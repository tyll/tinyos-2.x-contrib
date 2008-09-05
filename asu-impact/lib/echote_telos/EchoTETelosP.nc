/*
 * Copyright (c) 2008, Arizona Board of Regents
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright notice, 
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *   this list of conditions and the following disclaimer in the documentation 
 *   and/or other materials provided with the distribution.
 * - Neither the name of Arizona State University nor the names of its 
 *   contributors may be used to endorse or promote products derived from this 
 *   software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 */

/** 
 * HAL-level interface to a Decagon ECH2O-TE soil probe from the Telos 
 * platform. Provides a Read interface with physical values for the probe's 
 * dielectric (moisture), temperature, and conductivity sensors. Uses a 
 * GeneralIO pin to activate the probe and a UART receive pin to read the 
 * data. Manages UART resource arbitration.
 *
 * Read Interface
 * --------------
 * The #readDone event error level either is SUCCESS, or one of the 
 * #echote_error enum values. These error values uniquely identify the 
 * location in the code where the error occurred.
 *
 * Implementation
 * --------------
 * 1. Client requests a read, and in turn the module requests use of the UART 
 *    resource.
 * 2. When resource use is granted, the module first starts a timeout timer to 
 *    handle an incomplete response from the probe. Then the module triggers 
 *    the configured GeneralIO pin to power the probe and generate readings. 
 * 3. The module collects UART data from the probe via the interrupt-driven, 
 *    async UartStream.receivedByte event. Uses the byte-mode UartStream 
 *    interface since the received byte count may vary. Data is in the form 
 *    of three ASCII values separated by a space and terminated with a CR.
 * 4. Module releases the UART, interprets the data as physical values, and 
 *    signals the #readDone event to the client. May be triggered by the 
 *    expected final CR character, too much data from the probe overflowing
 *    the read buffer, or by timeout.
 *
 * Probe Data Format
 * -----------------
 * The data from the probe is ASCII characters in the form:
 *
 * [J]DDD[D]SE[E[E]]STTTC
 *
 * J  junk byte that is an artifact of our hardware interface; it is not 
 *    in the probe spec. We discard this value when SKIP_FIRST_BYTE == 1.
 * D  dielectric reading; length 3/4
 * E  electical conductivity reading in mS/cm; length 1/2/3
 * T  temperature reading as 10*T + 400, where T is in Celsius; length 3
 * S  space (0x20) 
 * C  carriage return (0x0d)
 */
#include "EchoTETelos.h"

module EchoTETelosP {
    provides {
        interface Read<soil_reading_t>;
        interface Msp430UartConfigure as UartResourceConfigure;
    }
    uses {
        interface UartStream;
        interface Resource      as UartResource;
        interface GeneralIO     as TriggerPin;
        interface Timer<TMilli> as TimeoutTimer;
        //uses interface LedsFlasher;
    }
}
implementation {
   
//
// Constants
//

/** Relevant ASCII values when scanning the raw reading. */
enum {
    ASCII_CR = 0xd,
    ASCII_SP = 0x20,
    ASCII_0  = 0x30
};

/** Maximum number of digits in a raw data element like dielectric or EC. */
enum {
    MAX_DATUM_DIGITS = 4
};

/** Length of buffer to store soil sensor reading. */
enum {
    UART_BUF_MAXLEN = 15
};

/** Skips over the initial junk byte described in the probe data format. */
enum {
    SKIP_FIRST_BYTE = 1
};

/** 
 * Configuration for the MSP430 UART appropriate for the probe. Uses external
 * crystal clock source to mitigate temperature effects. Requres receive only; 
 * no transmit. 
 */
static const msp430_uart_union_config_t uart_config = { 
  {
    ubr:    UBR_32KHZ_1200, 
    umctl:  UMCTL_32KHZ_1200, 
    mm:     0, 
    listen: 0, 
    clen:   1, 
    spb:    0, 
    pev:    0, 
    pena:   0, 
    urxse:  0, 
    ssel:   0x01, 
    ckpl:   0, 
    urxwie: 0, 
    urxeie: 1, 
    urxe:   1, 
    utxe:   0
  } 
};

//
// Variables
//

/** Buffer for raw sensor data. */
uint8_t uartBuf[UART_BUF_MAXLEN];

/** Count of bytes read into #uartBuf during a reading. */
uint8_t uartBufCount;

/** 
 * Module state indicating it has finished receiving data and is preparing to 
 * send the #readDone event. Used to ensure all actions have completed for the 
 * current read before begining a new read. Therefore this value must be set 
 * FALSE when finalization is complete. This value may be set from async 
 * context; so atomic protection is required. 
 */
bool isFinalizing = FALSE;

// 
// Declarations
//

int8_t    asciiToDigit(uint8_t asciiChar);
uint16_t  digitsToUint16(int8_t *digits, uint8_t buflen);
void      closeIO();
task void recycleResourceTask();
task void failureOverflowTask();
task void completionTask();
void      signalDoneError(error_t error, soil_reading_t*);

//
// Read and Msp430UartConfigure interfaces
//

command error_t Read.read() {
    return call UartResource.request();
}

async command msp430_uart_union_config_t* UartResourceConfigure.getConfig() {
    // Cast to avoid compiler warning for const attribute.
    return (msp430_uart_union_config_t*) &uart_config;
}

//
// Timer event handlers
//

/** 
 * Closes down the read, avoiding conflict with possible completion by the
 * normal UartStream.receivedByte event.
 */
event void TimeoutTimer.fired() {
    bool mustFinalize;
    atomic {
        mustFinalize = !isFinalizing;
        isFinalizing = TRUE;
    }

    if (mustFinalize) {    
        closeIO();
        signalDoneError(SOILERR_TIMEOUT, NULL);
        atomic
        isFinalizing = FALSE;
    }
}

//
// UART functions
//

/**
 * UART is available. Sets sensor excitation line high to generate a reading.
 */
event void UartResource.granted() {
    bool finalizing;
    atomic
    finalizing = isFinalizing;
    
    // Defer new read until any current read has finished completely. In
    // practice this path is unlikely. Read requests will not be scheduled so
    // often because the probe must rest a few seconds between readings.
    if (finalizing) {
        post recycleResourceTask();
        
    } else {
        atomic {
        memset(&uartBuf, 0, UART_BUF_MAXLEN);
        uartBufCount = 0;
        }
        
        call UartStream.enableReceiveInterrupt();
        call TimeoutTimer.startOneShot(ECHOTE_TIMEOUT);
        call TriggerPin.set();
    }
}

/** 
 * UART stream interface for per-byte collection. Collects bytes until done,
 * and then signals #readDone event. Disregards first byte because we expect 
 * it is junk -- a spurious reception from the sensor.
 */
async event void UartStream.receivedByte(uint8_t byte) {
    bool mustFinalize = FALSE;

    // It's possible that the first, junk byte is a CR. By adding it to 
    // #uartBuf, in effect we ignore it.
    atomic
    if (byte != ASCII_CR || (uartBufCount == 0 && SKIP_FIRST_BYTE)) {
        uartBuf[uartBufCount++] = byte;
        // Buffer full and no CR implies overflow.
        if (uartBufCount == UART_BUF_MAXLEN) {
            mustFinalize = !isFinalizing;
            isFinalizing = TRUE;
        }
    } else {
        mustFinalize = !isFinalizing;
        isFinalizing = TRUE;
    }
        
    // Followup actions moved outside of atomic protection.
    if (mustFinalize) {
        if (byte != ASCII_CR) {
            post failureOverflowTask();
        } else {
            post completionTask();
        }
        closeIO();
    }
}

/** Release and reacquire the UART. */
task void recycleResourceTask() {
    error_t result;
    
    call UartResource.release();
    result = call UartResource.request();
    if (result != SUCCESS) {
        signalDoneError(result, NULL);
    }
}

/** Multi-byte portion of interface; unused. */
async event void UartStream.receiveDone( uint8_t* buf, uint16_t len, 
                                        error_t error ) {
}

/** Multi-byte portion of interface; unused. */
async event void UartStream.sendDone( uint8_t* buf, uint16_t len, 
                                     error_t error ) {
}

//
// Functions to interpret received data and signal #readDone event.
//

/** 
 * Stops the timeout timer, reads the raw ASCII data from the sensor, 
 * converts it to ints for the outgoing interface, and signals the #readDone 
 * event.
 *
 * Assumes #isFinalizing has been set TRUE.
 */
task void completionTask() {
    enum {
        READ_DIELECTRIC,
        READ_EC,
        READ_TEMP
    };
    soil_reading_t reading;
    uint8_t state = READ_DIELECTRIC;
    int8_t  digit, int_buf[MAX_DATUM_DIGITS];
    uint8_t i, uartLen, intBufLen = 0;

    call TimeoutTimer.stop();
    atomic
    uartLen = uartBufCount;
    
    // See module comments for a description of the probe data format. 
    // Start at second char to skip over junk byte.
    for (i = SKIP_FIRST_BYTE ? 1 : 0; i < uartLen; i++) {
        uint8_t uartBufChar;
        atomic
        uartBufChar = uartBuf[i];
        
        if (uartBufChar == ASCII_SP) {
            if (intBufLen == 0) {
                signalDoneError(SOILERR_TRUNCATED, &reading);
                goto end;
            } else if (state == READ_DIELECTRIC) {
                reading.dielectric = digitsToUint16(int_buf, intBufLen);
                state  = READ_EC;
                intBufLen = 0;
            } else if (state == READ_EC) {
                reading.ec = digitsToUint16(int_buf, intBufLen);
                state  = READ_TEMP;
                intBufLen = 0;
            }
        } else {
            if (intBufLen == MAX_DATUM_DIGITS) {
                signalDoneError(SOILERR_OVERFLOW2, &reading);
                goto end;
            } else {
                digit = asciiToDigit(uartBufChar);
                if (digit == -1) {
                    signalDoneError(SOILERR_NOT_DIGIT, &reading);
                    goto end;
                } else {
                    int_buf[intBufLen++] = digit;
                }
            }
        }
    }
    if (state == READ_TEMP) {
        if (intBufLen == 0) {
            signalDoneError(SOILERR_TRUNCATED2, &reading);
        } else {
            reading.temp = digitsToUint16(int_buf, intBufLen);
            signal Read.readDone(SUCCESS, reading);
        }
    } else { 
        signalDoneError(SOILERR_TRUNCATED3, &reading);
    }
    
    end:
    atomic
    isFinalizing = FALSE;
}

/** 
 * Simply wraps the #readDone signal in a deferred task for use from an async 
 * function. 
 */
task void failureOverflowTask() {
    call TimeoutTimer.stop();
    signalDoneError(SOILERR_OVERFLOW, NULL);
    atomic
    isFinalizing = FALSE;
}

/** If the given ASCII char is a digit, return it; otherwise return -1. */
int8_t asciiToDigit(uint8_t asciiChar) {
    int16_t val = asciiChar - ASCII_0;
    if (val < 0 || val > 9) {
        val = -1;
    }
    return val;
}

/** Converts the given array of digits into a 2-byte unsigned int. */
uint16_t digitsToUint16(int8_t *digits, uint8_t buflen) {
    uint16_t val = 0;
    int8_t i;
    
    for (i = 0; i < buflen; i++) {
        // Multiply by 10 and add next digit.
        val = (val<<3) + (val<<1) + digits[i];
    }
    return val;
}

/** Utility function to avoid code duplication. */
void signalDoneError(error_t error, soil_reading_t *reading) {
    if (reading != NULL) {
        memset(reading, 0, sizeof(soil_reading_t));
    }
    signal Read.readDone(error, *reading);
}

//
// Miscellaneous functions
//

/** Closes I/O access after all data received, a timeout, or an error. */
void closeIO() {
    call TriggerPin.clr();
    call UartStream.disableReceiveInterrupt();
    call UartResource.release();
}

}
