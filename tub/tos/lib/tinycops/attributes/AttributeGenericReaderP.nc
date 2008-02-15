/* 
 * Copyright (c) 2006, Technische Universitaet Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitaet Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */

generic module AttributeGenericReaderP()
{
  provides {
    interface AttributeValue;
    interface AttributeMatching;
  } uses {
    interface Read<uint16_t>;
  }  
}
implementation
{
  typedef nx_uint16_t sensor_data_t; 
  sensor_data_t *dest = 0;
  
  enum {
    // as defined in attributes.xml
    PS_OPR_EQUALS = 0,
    PS_OPR_SMALLER = 1,
    PS_OPR_SMALLER_EQUAL = 2,
    PS_OPR_GREATER = 3,
    PS_OPR_GREATER_EQUAL = 4,
    PS_OPR_ANY = 5,
  };

  command uint8_t AttributeValue.valueSize()
  {
    return sizeof(sensor_data_t);
  }  

  command error_t AttributeValue.getValue(void *value, uint8_t maxSize)
  {
    error_t result = EBUSY;
    if (!value)
      return FAIL;
    if (maxSize < sizeof(sensor_data_t))
      return ESIZE;
    if (!dest){
      dest = value;
      result = call Read.read();
      if (result != SUCCESS)
        dest = 0;
    }
    return result;
  }

  event void Read.readDone(error_t result, uint16_t  val)
  {
    void *olddest = dest;
    *dest = val;
    dest = 0;
    signal AttributeValue.getDone(olddest, sizeof(sensor_data_t), result);
  }
  
  command bool AttributeMatching.isMatching(const avpair_t *avpair, const constraint_t *constraint)
  {
    uint16_t value1 = *((sensor_data_t*) avpair->value);
    uint16_t value2 = *((sensor_data_t*) constraint->value);
    bool matching = FALSE;
    switch (constraint->operationID)
    {
      case PS_OPR_EQUALS: matching = (value1 == value2); break;
      case PS_OPR_SMALLER: matching = (value1 < value2); break;
      case PS_OPR_SMALLER_EQUAL: matching = (value1 <= value2); break;
      case PS_OPR_GREATER: matching = (value1 > value2); break;
      case PS_OPR_GREATER_EQUAL: matching = (value1 >= value2); break;
      case PS_OPR_ANY: matching = TRUE; break;
    }
    return matching;
  }
}




