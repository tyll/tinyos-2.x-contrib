/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * @author David Moss
 */
 
#ifndef TESTCASE_H
#define TESTCASE_H

#ifndef UQ_ASSERTION
#define UQ_ASSERTION "TUnit.Assertion"
#endif

#ifndef UQ_TESTCASE
#define UQ_TESTCASE "TUnit.Test"
#endif

/***************** TUnit Private Internal Assertions ****************/
static void assertEqualsFailed(char *failMsg, uint32_t expected, uint32_t actual, uint8_t assertionId);
static void assertNotEqualsFailed(char *failMsg, uint32_t actual, uint8_t assertionId);
static void assertResultIsBelowFailed(char *failMsg, uint32_t upperbound, uint32_t actual, uint8_t assertionId);
static void assertResultIsAboveFailed(char *failMsg, uint32_t lowerbound, uint32_t actual, uint8_t assertionId);
static void assertTunitSuccess(uint8_t assertionId);
static void assertTunitFail(char *failMsg, uint8_t assertionId);

/***************** TUnit Private Internal Functions ****************/
static void setTUnitTestName(char *name);
#define setTestName(x) setTUnitTestName(x);

/***************** Public Assertion Definitions ***************/
/**
 * Test was a success
 */
#define assertSuccess()\
  assertTunitSuccess(unique(UQ_ASSERTION));
  
/**
 * Test was a failure
 */
#define assertFail(msg)\
  assertTunitFail(msg, unique(UQ_ASSERTION));

/**
 * Assert expected == actual
 */
#define assertEquals(msg, expected, actual)\
  if ((expected) != (actual)) {\
    assertEqualsFailed(msg, ((uint32_t) expected), ((uint32_t) actual), unique(UQ_ASSERTION));\
  } else {\
    assertSuccess();\
  }

/**
 * Assert expected != actual
 */
#define assertNotEquals(msg, expected, actual)\
  if ((expected) == (actual)) {\
    assertNotEqualsFailed(msg, ((uint32_t) actual), unique(UQ_ASSERTION));\
  } else {\
    assertSuccess();\
  }

/**
 * Assert upperbound > actual
 */
#define assertResultIsBelow(msg, upperbound, actual)\
  if ((upperbound) <= (actual)) {\
    assertResultIsBelowFailed(msg, ((uint32_t) upperbound), ((uint32_t) actual), unique(UQ_ASSERTION));\
  } else {\
    assertSuccess();\
  } 

/**
 * Assert lowerbound < actual
 */
#define assertResultIsAbove(msg, lowerbound, actual)\
  if ((lowerbound) >= (actual)) {\
    assertResultIsAboveFailed(msg, ((uint32_t) lowerbound), ((uint32_t) actual), unique(UQ_ASSERTION));\
  } else {\
    assertSuccess();\
  } 
  
/**
 * Assert array1 === array2
 */
#define assertCompares(msg, array1, array2, size)\
  assertEquals(msg, 0, memcmp((array1), (array2), size))

/**
 * Assert condition == TRUE
 */
#define assertTrue(message, condition)\
  if(!(condition)) {\
    assertFail(message);\
  } else {\
    assertSuccess();\
  }

/**
 * Assert condition == FALSE
 */
#define assertFalse(message, condition)\
  if((condition)) {\
    assertFail(message);\
  } else {\
    assertSuccess();\
  }

/**
 * Assert pointer == NULL
 */
#define assertNull(pointer)\
  if((pointer) != NULL) {\
    assertFail(#pointer " was not null.");\
  } else {\
    assertSuccess();\
  }

/**
 * Assert pointer != NULL
 */
#define assertNotNull(pointer)\
  if((pointer) == NULL) {\
    assertFail(#pointer " was null");\
  } else {\
    assertSuccess();\
  }

#endif

