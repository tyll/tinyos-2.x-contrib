/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
#ifndef __NXTMOTE_HARDWARE_H__
#define __NXTMOTE_HARDWARE_H__

#include "AT91SAM7S256.h"

#include "AT91SAM7S256_extra.h"
#include "lib_AT91SAM7S256.h"
#include "lib_extra_AT91SAM7S256.h"

#define   OSC                           48054850L

//PIT Timer
#define   MS_1_TIME         ((OSC/16)/1000)

typedef   unsigned char                 UCHAR;  //uint8_t
typedef   unsigned short                USHORT; //uint16_t
typedef   unsigned char                 UBYTE;  //uint8_t
typedef   signed char                   SBYTE;  //int8_t
typedef   unsigned short int            UWORD;  //uint16_t
typedef   signed short int              SWORD;  //int16_t
typedef   unsigned long                 ULONG;  //uint32_t
typedef   signed long                   SLONG;  //int32_t

typedef   ULONG*                        PULONG;
typedef   USHORT*                       PUSHORT;
typedef   UCHAR*                        PUCHAR;
typedef   char*                         PSZ;

/*
typedef signed char int8_t;
typedef unsigned char uint8_t;

typedef short int16_t;
typedef unsigned short uint16_t;

typedef int int32_t;
typedef unsigned int uint32_t;

typedef long long int64_t;
typedef unsigned long long uint64_t;

typedef int32_t intptr_t;
typedef uint32_t uintptr_t;
*/

extern void AT91F_Spurious_handler(void);
extern void AT91F_Default_IRQ_handler(void);
extern void AT91F_Default_FIQ_handler(void);

inline void __nesc_enable_interrupt() {
  uint32_t statusReg = 0;

  asm volatile (
	       "mrs %0,CPSR\n\t"
	       "bic %0,%1,#0xc0\n\t"
	       "msr CPSR_c, %1"
	       : "=r" (statusReg)
	       : "0" (statusReg)
	       );
  return;
}

inline void __nesc_disable_interrupt() {
/*
  uint32_t statusReg = 0;

  asm volatile (
		"mrs %0,CPSR\n\t"
		"orr %0,%1,#0xc0\n\t"
		"msr CPSR_c,%1\n\t"
		: "=r" (statusReg)
		: "0" (statusReg)
		);
*/
  return;
}

typedef uint32_t __nesc_atomic_t;
//TODO: enable
inline __nesc_atomic_t __nesc_atomic_start(void) @spontaneous() {
  uint32_t result = 0;
/*
  uint32_t temp = 0;

  asm volatile (
		"mrs %0,CPSR\n\t"
		"orr %1,%2,%4\n\t"
		"msr CPSR_cf,%3"
		: "=r" (result) , "=r" (temp)
		: "0" (result) , "1" (temp) , "i" (ARM_CPSR_INT_MASK)
		);
*/
  return result;
}

inline void __nesc_atomic_end(__nesc_atomic_t oldState) @spontaneous() {
  //uint32_t  statusReg = 0;

  oldState &= ARM_CPSR_INT_MASK;
/*
  asm volatile (
		"mrs %0,CPSR\n\t"
		"bic %0, %1, %2\n\t"
		"orr %0, %1, %3\n\t"
		"msr CPSR_c, %1"
		: "=r" (statusReg)
		: "0" (statusReg),"i" (ARM_CPSR_INT_MASK), "r" (oldState)
		);
*/
  return;
}
inline void __nesc_atomic_sleep() {
  //__nesc_enable_interrupt();
}

// Add offset to channel id (first channel id is zero) to get timer peripheral id
#define TIMER_PID(chnl_id) chnl_id + AT91C_ID_TC0

// With MCK at 48054857 Hz and a timer incrementing at MCK/2
// 1 ms is approx. 24028 ticks
#define TICKSONEMSCLK2 (24028)
//#define TICKTOMSCLK2(ticks)

// priorities which are used in HplAt91InterruptM
const uint8_t TOSH_IRP_TABLE[] = {
  0xFF, // AT91C_ID_FIQ         ID  0, Advanced Interrupt Controller (FIQ)
  AT91C_AIC_PRIOR_HIGHEST, // AT91C_ID_SYS         ID  1, System Peripheral
  0xFF, // AT91C_ID_PIOA        ID  2, Parallel IO Controller
  0xFF, // AT91C_ID_3_Reserved  ID  3, Reserved
  0xFF, // AT91C_ID_ADC         ID  4, Analog-to-Digital Converter
  0xFF, // AT91C_ID_SPI         ID  5, Serial Peripheral Interface
  0xFF, // AT91C_ID_US0         ID  6, USART 0
  0xFF, // AT91C_ID_US1         ID  7, USART 1
  0xFF, // AT91C_ID_SSC         ID  8, Serial Synchronous Controller
  AT91C_AIC_PRIOR_HIGHEST, // AT91C_ID_TWI         ID  9, Two-Wire Interface
  0xFF, // AT91C_ID_PWMC        ID 10, PWM Controller
  0xFF, // AT91C_ID_UDP         ID 11, USB Device Port
  0x04, // AT91C_ID_TC0         ID 12, Timer Counter 0
  0xFF, // AT91C_ID_TC1         ID 13, Timer Counter 1
  0xFF, // AT91C_ID_TC2         ID 14, Timer Counter 2
  0xFF, // AT91C_ID_15_Reserved ID 15, Reserved
  0xFF, // AT91C_ID_16_Reserved ID 16, Reserved
  0xFF, // AT91C_ID_17_Reserved ID 17, Reserved
  0xFF, // AT91C_ID_18_Reserved ID 18, Reserved
  0xFF, // AT91C_ID_19_Reserved ID 19, Reserved
  0xFF, // AT91C_ID_20_Reserved ID 20, Reserved
  0xFF, // AT91C_ID_21_Reserved ID 21, Reserved
  0xFF, // AT91C_ID_22_Reserved ID 22, Reserved
  0xFF, // AT91C_ID_23_Reserved ID 23, Reserved
  0xFF, // AT91C_ID_24_Reserved ID 24, Reserved
  0xFF, // AT91C_ID_25_Reserved ID 25, Reserved
  0xFF, // AT91C_ID_26_Reserved ID 26, Reserved
  0xFF, // AT91C_ID_27_Reserved ID 27, Reserved
  0xFF, // AT91C_ID_28_Reserved ID 28, Reserved
  0xFF, // AT91C_ID_29_Reserved ID 29, Reserved
  0xFF, // AT91C_ID_IRQ0        ID 30, Advanced Interrupt Controller (IRQ0)
  0xFF, // AT91C_ID_IRQ1        ID 31, Advanced Interrupt Controller (IRQ1)
  0xFF, // AT91C_ALL_INT        ID 0xC0007FF7 ALL VALID INTERRUPTS
};

// priorities which are used in HplAt91InterruptM
// TRUE:  AT91C_AIC_SRCTYPE_INT_HIGH_LEVEL
// FALSE: AT91C_AIC_SRCTYPE_INT_EDGE_TRIGGERED
const uint8_t TOSH_IRQLEVEL_TABLE[] = {
  0xFF, // AT91C_ID_FIQ         ID  0, Advanced Interrupt Controller (FIQ)
  TRUE, // AT91C_ID_SYS         ID  1, System Peripheral
  0xFF, // AT91C_ID_PIOA        ID  2, Parallel IO Controller
  0xFF, // AT91C_ID_3_Reserved  ID  3, Reserved
  0xFF, // AT91C_ID_ADC         ID  4, Analog-to-Digital Converter
  0xFF, // AT91C_ID_SPI         ID  5, Serial Peripheral Interface
  0xFF, // AT91C_ID_US0         ID  6, USART 0
  0xFF, // AT91C_ID_US1         ID  7, USART 1
  0xFF, // AT91C_ID_SSC         ID  8, Serial Synchronous Controller
  FALSE, // AT91C_ID_TWI         ID  9, Two-Wire Interface
  0xFF, // AT91C_ID_PWMC        ID 10, PWM Controller
  0xFF, // AT91C_ID_UDP         ID 11, USB Device Port
  FALSE, // AT91C_ID_TC0         ID 12, Timer Counter 0
  FALSE, // AT91C_ID_TC1         ID 13, Timer Counter 1
  FALSE, // AT91C_ID_TC2         ID 14, Timer Counter 2
  0xFF, // AT91C_ID_15_Reserved ID 15, Reserved
  0xFF, // AT91C_ID_16_Reserved ID 16, Reserved
  0xFF, // AT91C_ID_17_Reserved ID 17, Reserved
  0xFF, // AT91C_ID_18_Reserved ID 18, Reserved
  0xFF, // AT91C_ID_19_Reserved ID 19, Reserved
  0xFF, // AT91C_ID_20_Reserved ID 20, Reserved
  0xFF, // AT91C_ID_21_Reserved ID 21, Reserved
  0xFF, // AT91C_ID_22_Reserved ID 22, Reserved
  0xFF, // AT91C_ID_23_Reserved ID 23, Reserved
  0xFF, // AT91C_ID_24_Reserved ID 24, Reserved
  0xFF, // AT91C_ID_25_Reserved ID 25, Reserved
  0xFF, // AT91C_ID_26_Reserved ID 26, Reserved
  0xFF, // AT91C_ID_27_Reserved ID 27, Reserved
  0xFF, // AT91C_ID_28_Reserved ID 28, Reserved
  0xFF, // AT91C_ID_29_Reserved ID 29, Reserved
  0xFF, // AT91C_ID_IRQ0        ID 30, Advanced Interrupt Controller (IRQ0)
  0xFF, // AT91C_ID_IRQ1        ID 31, Advanced Interrupt Controller (IRQ1)
  0xFF, // AT91C_ALL_INT        ID 0xC0007FF7 ALL VALID INTERRUPTS
};

// Lookup table for some peripheral ids
AT91_REG PID_ADR_TABLE[] = {
  0x00000000,     // AT91C_ID_FIQ         ID  0, Advanced Interrupt Controller (FIQ)
  AT91C_BASE_PITC,     // AT91C_ID_SYS         ID  1, System Peripheral
  0x00000000,     // AT91C_ID_PIOA        ID  2, Parallel IO Controller
  0x00000000,     // AT91C_ID_3_Reserved  ID  3, Reserved
  0x00000000,     // AT91C_ID_ADC         ID  4, Analog-to-Digital Converter
  0x00000000,     // AT91C_ID_SPI         ID  5, Serial Peripheral Interface
  0x00000000,     // AT91C_ID_US0         ID  6, USART 0
  0x00000000,     // AT91C_ID_US1         ID  7, USART 1
  0x00000000,     // AT91C_ID_SSC         ID  8, Serial Synchronous Controller
  0x00000000,     // AT91C_ID_TWI         ID  9, Two-Wire Interface
  0x00000000,     // AT91C_ID_PWMC        ID 10, PWM Controller
  0x00000000,     // AT91C_ID_UDP         ID 11, USB Device Port
  AT91C_BASE_TC0, // AT91C_ID_TC0         ID 12, Timer Counter 0
  AT91C_BASE_TC1, // AT91C_ID_TC1         ID 13, Timer Counter 1
  AT91C_BASE_TC2, // AT91C_ID_TC2         ID 14, Timer Counter 2
  0x00000000,     // AT91C_ID_15_Reserved ID 15, Reserved
  0x00000000,     // AT91C_ID_16_Reserved ID 16, Reserved
  0x00000000,     // AT91C_ID_17_Reserved ID 17, Reserved
  0x00000000,     // AT91C_ID_18_Reserved ID 18, Reserved
  0x00000000,     // AT91C_ID_19_Reserved ID 19, Reserved
  0x00000000,     // AT91C_ID_20_Reserved ID 20, Reserved
  0x00000000,     // AT91C_ID_21_Reserved ID 21, Reserved
  0x00000000,     // AT91C_ID_22_Reserved ID 22, Reserved
  0x00000000,     // AT91C_ID_23_Reserved ID 23, Reserved
  0x00000000,     // AT91C_ID_24_Reserved ID 24, Reserved
  0x00000000,     // AT91C_ID_25_Reserved ID 25, Reserved
  0x00000000,     // AT91C_ID_26_Reserved ID 26, Reserved
  0x00000000,     // AT91C_ID_27_Reserved ID 27, Reserved
  0x00000000,     // AT91C_ID_28_Reserved ID 28, Reserved
  0x00000000,     // AT91C_ID_29_Reserved ID 29, Reserved
  0x00000000,     // AT91C_ID_IRQ0        ID 30, Advanced Interrupt Controller (IRQ0)
  0x00000000,     // AT91C_ID_IRQ1        ID 31, Advanced Interrupt Controller (IRQ1)
  0x00000000,     // AT91C_ALL_INT        ID 0xC0007FF7 ALL VALID INTERRUPTS
};

/* Bluetooth Start */

/* Error codes from then Loader */
enum
{
  SUCCESS_             = 0x0000, // Name collision with SUCCESS from TinyError.h
  INPROGRESS          = 0x0001,
  REQPIN              = 0x0002,
  NOMOREHANDLES       = 0x8100,
  NOSPACE             = 0x8200,
  NOMOREFILES         = 0x8300,
  EOFEXSPECTED        = 0x8400,
  ENDOFFILE           = 0x8500,
  NOTLINEARFILE       = 0x8600,
  FILENOTFOUND        = 0x8700,
  HANDLEALREADYCLOSED = 0x8800,
  NOLINEARSPACE       = 0x8900,
  UNDEFINEDERROR      = 0x8A00,
  FILEISBUSY          = 0x8B00,
  NOWRITEBUFFERS      = 0x8C00,
  APPENDNOTPOSSIBLE   = 0x8D00,
  FILEISFULL          = 0x8E00,
  FILEEXISTS          = 0x8F00,
  MODULENOTFOUND      = 0x9000,
  OUTOFBOUNDERY       = 0x9100,
  ILLEGALFILENAME     = 0x9200,
  ILLEGALHANDLE       = 0x9300,
  BTBUSY              = 0x9400,
  BTCONNECTFAIL       = 0x9500,
  BTTIMEOUT           = 0x9600,
  FILETX_TIMEOUT      = 0x9700,
  FILETX_DSTEXISTS    = 0x9800,
  FILETX_SRCMISSING   = 0x9900,
  FILETX_STREAMERROR  = 0x9A00,
  FILETX_CLOSEERROR   = 0x9B00,
  BTWAIT              = 0x9C00 // if cCommReq is busy
};

/* Loader */
enum
{
  OPENREAD        = 0x80,
  OPENWRITE       = 0x81,
  READ            = 0x82,
  WRITE           = 0x83,
  CLOSE           = 0x84,
  DELETE          = 0x85,
  FINDFIRST       = 0x86,
  FINDNEXT        = 0x87,
  VERSIONS        = 0x88,
  OPENWRITELINEAR = 0x89,
  OPENREADLINEAR  = 0x8A,
  OPENWRITEDATA   = 0x8B,
  OPENAPPENDDATA  = 0x8C,
  FINDFIRSTMODULE = 0x90,
  FINDNEXTMODULE  = 0x91,
  CLOSEMODHANDLE  = 0x92,
  IOMAPREAD       = 0x94,
  IOMAPWRITE      = 0x95,
  BOOTCMD         = 0x97,     /* external command only */
  SETBRICKNAME    = 0x98,
  BTGETADR        = 0x9A,
  DEVICEINFO      = 0x9B,
  DELETEUSERFLASH = 0xA0,
  POLLCMDLEN      = 0xA1,
  POLLCMD         = 0xA2,
  RENAMEFILE      = 0xA3,
  BTFACTORYRESET  = 0xA4

};

/* UI */

// Constants related to BlueToothState
enum
{
  BT_STATE_VISIBLE            = 0x01,         // RW - BT visible
  BT_STATE_CONNECTED          = 0x02,         // RW - BT connected to something
  BT_STATE_OFF                = 0x04,         // RW - BT power off
  BT_ERROR_ATTENTION          = 0x08,         // W  - BT error attention
  BT_CONNECT_REQUEST          = 0x40,         // RW - BT get connect accept in progress
  BT_PIN_REQUEST              = 0x80          // RW - BT get pin code
};

// Loader
//Mask out handle byte of Loader status word for error code checks
#define LOADER_ERR(StatusWord) ((StatusWord & 0xFF00))

//Byte value of error half of Loader status word
#define LOADER_ERR_BYTE(StatusWord) ((UBYTE)((StatusWord & 0xFF00) >> 8))

//Value of handle inside Loader status word
#define LOADER_HANDLE(StatusWord) ((UBYTE)(StatusWord))

//Pointer to lower byte of Loader status word
#define LOADER_HANDLE_P(StatusWord) ((UBYTE*)(&StatusWord))

// More loader

//Communications specific errors
#define ERR_COMM_CHAN_NOT_READY -32 //0xE0 Specified channel/connection not configured or busy
#define ERR_COMM_CHAN_INVALID   -33 //0xDF Specified channel/connection is not valid
#define ERR_COMM_BUFFER_FULL    -34 //0xDE No room in comm buffer
#define ERR_COMM_BUS_ERR        -35 //0xDD Something went wrong on the communications bus

//Version numbers are two bytes, MAJOR.MINOR (big-endian)
//For example, version 1.5 would be 0x0105
//If these switch to little-endian, be sure to update
//definition and usages of VM_OLDEST_COMPATIBLE_VERSION, too!
#define   FIRMWAREVERSION               0x0104 //1.04
#define   PROTOCOLVERSION               0x017C //1.124

// RC

//Direct command protocol opcodes
//!!! These MUST be mutually exclusive with c_comm's protocol opcodes.
// Since all of c_comm's protocol opcodes are above 0x80, we're safe for now.
enum
{
  RC_START_PROGRAM,
  RC_STOP_PROGRAM,
  RC_PLAY_SOUND_FILE,
  RC_PLAY_TONE,
  RC_SET_OUT_STATE,
  RC_SET_IN_MODE,
  RC_GET_OUT_STATE,
  RC_GET_IN_VALS,
  RC_RESET_IN_VAL,
  RC_MESSAGE_WRITE,
  RC_RESET_POSITION,
  RC_GET_BATT_LVL,
  RC_STOP_SOUND,
  RC_KEEP_ALIVE,
  RC_LS_GET_STATUS,
  RC_LS_WRITE,
  RC_LS_READ,
  RC_GET_CURR_PROGRAM,
  RC_GET_BUTTON_STATE,
  RC_MESSAGE_READ,
  NUM_RC_OPCODES
};

// IOCtrl
enum
{
  POWERDOWN = 0x5A00,
  BOOT      = 0xA55A
};

// UI
// Constants related to Flags
enum
{
  UI_UPDATE                   = 0x01,         // W  - Make changes take effect
  UI_DISABLE_LEFT_RIGHT_ENTER = 0x02,         // RW - Disable left, right and enter button
  UI_DISABLE_EXIT             = 0x04,         // RW - Disable exit button
  UI_REDRAW_STATUS            = 0x08,         // W  - Redraw entire status line
  UI_RESET_SLEEP_TIMER        = 0x10,         // W  - Reset sleep timeout timer
  UI_EXECUTE_LMS_FILE         = 0x20,         // W  - Execute LMS file in "LMSfilename" (Try It)
  UI_BUSY                     = 0x40,         // R  - UI busy running or datalogging (popup disabled)
  UI_ENABLE_STATUS_UPDATE     = 0x80          // W  - Enable status line to be updated
};

// Dispplay
// Constants related to Flags
enum
{
  DISPLAY_ON                = 0x01,     // W  - Display on
  DISPLAY_REFRESH           = 0x02,     // W  - Enable refresh
  DISPLAY_POPUP             = 0x08,     // W  - Use popup display memory
  DISPLAY_REFRESH_DISABLED  = 0x40,     // R  - Refresh disabled
  DISPLAY_BUSY              = 0x80      // R  - Refresh in progress
};

/* interface between comm and BC4           */
enum
{
  MSG_BEGIN_INQUIRY,
  MSG_CANCEL_INQUIRY,
  MSG_CONNECT,
  MSG_OPEN_PORT,
  MSG_LOOKUP_NAME,
  MSG_ADD_DEVICE,
  MSG_REMOVE_DEVICE,
  MSG_DUMP_LIST,
  MSG_CLOSE_CONNECTION,
  MSG_ACCEPT_CONNECTION,
  MSG_PIN_CODE,
  MSG_OPEN_STREAM,
  MSG_START_HEART,
  MSG_HEARTBEAT,
  MSG_INQUIRY_RUNNING,
  MSG_INQUIRY_RESULT,
  MSG_INQUIRY_STOPPED,
  MSG_LOOKUP_NAME_RESULT,
  MSG_LOOKUP_NAME_FAILURE,
  MSG_CONNECT_RESULT,
  MSG_RESET_INDICATION,
  MSG_REQUEST_PIN_CODE,
  MSG_REQUEST_CONNECTION,
  MSG_LIST_RESULT,
  MSG_LIST_ITEM,
  MSG_LIST_DUMP_STOPPED,
  MSG_CLOSE_CONNECTION_RESULT,
  MSG_PORT_OPEN_RESULT,
  MSG_SET_DISCOVERABLE,
  MSG_CLOSE_PORT,
  MSG_CLOSE_PORT_RESULT,
  MSG_PIN_CODE_ACK,
  MSG_DISCOVERABLE_ACK,
  MSG_SET_FRIENDLY_NAME,
  MSG_SET_FRIENDLY_NAME_ACK,
  MSG_GET_LINK_QUALITY,
  MSG_LINK_QUALITY_RESULT,
  MSG_SET_FACTORY_SETTINGS,
  MSG_SET_FACTORY_SETTINGS_ACK,
  MSG_GET_LOCAL_ADDR,
  MSG_GET_LOCAL_ADDR_RESULT,
  MSG_GET_FRIENDLY_NAME,
  MSG_GET_DISCOVERABLE,
  MSG_GET_PORT_OPEN,
  MSG_GET_FRIENDLY_NAME_RESULT,
  MSG_GET_DISCOVERABLE_RESULT,
  MSG_GET_PORT_OPEN_RESULT,
  MSG_GET_VERSION,
  MSG_GET_VERSION_RESULT,
  MSG_GET_BRICK_STATUSBYTE_RESULT,
  MSG_SET_BRICK_STATUSBYTE_RESULT,
  MSG_GET_BRICK_STATUSBYTE,
  MSG_SET_BRICK_STATUSBYTE
};

#define   SIZE_OF_BT_NAME               16
#define   SIZE_OF_BRICK_NAME            8
#define   SIZE_OF_CLASS_OF_DEVICE       4
#define   SIZE_OF_BT_PINCODE            16
#define   SIZE_OF_BDADDR                7

#define   FILENAME_LENGTH         19    // zero termination not included
#define   FILEHEADER_LENGTH       8     // all simple file headers

/* Bluetooth End */

//Clock selection constants
//enum {
//  TC_CLKS         = 0x7,
//  TC_CLKS_MCK2    = 0x0,
//  TC_CLKS_MCK8    = 0x1,
//  TC_CLKS_MCK32   = 0x2,
//  TC_CLKS_MCK128  = 0x3,
//  TC_CLKS_MCK1024 = 0x4
//};

// GPIO pins
// See AT91SAM7S256 LEGO MINDSTORMS HW sheet 1
// and J7, J8, J9, and J6 on sheet 3
#define DIGIA0 (23) // Port 1 pin 5 (yellow)
#define DIGIA1 (18) // Port 1 pin 6 (blue)

#define DIGIB0 (28) // Port 2 pin 5
#define DIGIB1 (19) // Port 2 pin 6

#define DIGIC0 (29) // Port 3 pin 5
#define DIGIC1 (20) // Port 3 pin 6

#define DIGID0 (30) // Port 4 pin 5
#define DIGID1 (2)  // Port 4 pin 6
// See HW appendix page 1. Pin5 on port 1 is PA18 that is DIGIA1
#define LEDVAL_ (1 << DIGIA0)
// Little function to toggle a pin
// Usage: write {toggle(0);}
//   in your code to turn off the led
#define togglepin(toggle)\
            {/* GPIO register addresses */\
							/* Register use */\
							*AT91C_PIOA_PER = LEDVAL_;\
							*AT91C_PIOA_OER = LEDVAL_;\
							if(toggle == 0)\
							  *AT91C_PIOA_CODR = LEDVAL_;  /* port 1 pin 5 at 0.0 v (enable this line OR the next)*/\
							else\
							  *AT91C_PIOA_SODR = LEDVAL_;  /* port 1 pin 5 (blue) at 3.25-3.27 v (GND is on pin 2 (black)) */\
							while(1); /* stop here */\
						}

#include "nxt.h"

#endif //__NXTMOTE_HARDWARE_H__
