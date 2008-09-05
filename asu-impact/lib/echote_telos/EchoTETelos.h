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
#ifndef ECHOTE_TELOS_H
#define ECHOTE_TELOS_H


/** Expanded error conditions for the Read interface. */
enum {
   SOILERR_OVERFLOW = ELAST+1,
   SOILERR_OVERFLOW2,
   SOILERR_TRUNCATED,
   SOILERR_TRUNCATED2,
   SOILERR_TRUNCATED3,
   SOILERR_NOT_DIGIT,
   SOILERR_TIMEOUT
} echote_error;

/** 
 * Amount of time to wait for a reading to complete, in milliseconds. 
 * According to ECH2O-TE docs, the reading should complete in about 50 ms.
 */
enum {
    ECHOTE_TIMEOUT = 500
};

/** Data from a soil sensor reading. */
typedef nx_struct {
    /** 
     * Dielectric output. Use calibration equation to derive volumetric
     * water content (VWC).
     */
    nx_uint16_t dielectric;
    /** 
     * Temperature in Celsius multiplied by 10 offset by 400: T*10 + 400.
     */
    nx_uint16_t temp;
    /**
     * Electrical conductivity value. Divide by 100 for units of dS/m.
     */
    nx_uint16_t ec;
} soil_reading_t;

#endif

