/*
 * Copyright (c) 2007, Intel Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of the Intel Corporation nor the names of its contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
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
 *
 * Author: Adrian Burns
 *         July, 2010
 */


#ifndef BLUETOOTH_MASTER_TEST_H
#define BLUETOOTH_MASTER_TEST_H


enum {
  SHIMMER_REV1 = 0
};

enum {
  PROPRIETARY_DATA_TYPE = 0xFF,
  STRING_DATA_TYPE = 0xFE
};

enum {
  SAMPLING_1000HZ = 1,
  SAMPLING_500HZ = 2,
  SAMPLING_250HZ = 4,
  SAMPLING_200HZ = 5,
  SAMPLING_166HZ = 6,
  SAMPLING_125HZ = 8,
  SAMPLING_100HZ = 10,
  SAMPLING_50HZ = 20,
  SAMPLING_10HZ = 100,
  SAMPLING_0HZ_OFF = 255
};

enum {
  FRAMING_SIZE     = 0x4,
  FRAMING_CE_COMP  = 0x20,
  FRAMING_CE_CE    = 0x5D,
  FRAMING_CE       = 0x7D,
  FRAMING_BOF      = 0xC0,
  FRAMING_EOF      = 0xC1,
  FRAMING_BOF_CE   = 0xE0,
  FRAMING_EOF_CE   = 0xE1,
};

#endif // BLUETOOTH_MASTER_TEST_H
