/* $Id$ */
/*
 * Copyright (c) 2006 Stanford University.
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
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *  A general Stack component, having a bounded size.
 *
 *  Derived from StackC, work of:
 *  @author Philip Levis
 *  @author Geoffrey Mainland
 * -------------------------
 *  @author Scott Moeller
 *  @date   $Date$
 */

   
generic module StackC(typedef stack_t, uint8_t STACK_SIZE) {
  provides interface Stack<stack_t>;
}

implementation {

  stack_t ONE_NOK stack[STACK_SIZE];
  uint8_t top = 0;
  uint8_t bottom = 0;
  uint8_t size = 0;
  
  command bool Stack.empty() {
    return size == 0;
  }

  command uint8_t Stack.size() {
    return size;
  }

  command uint8_t Stack.maxSize() {
    return STACK_SIZE;
  }

  command stack_t Stack.top() {
    return stack[top];
  }

  command stack_t Stack.popTop() {
    stack_t t = call Stack.top();
    dbg("StackC", "%s: size is %hhu\n", __FUNCTION__, size);

    if( call Stack.empty() ) 
      return t; 

    if ( size > 1 ) {
      if ( top == 0 )
        top = STACK_SIZE - 1;
      else
        top--;
    }

    size--;
    return t;
  }

  command stack_t Stack.bottom() {
    return stack[bottom];
  }

  command stack_t Stack.popBottom() {
    stack_t t = call Stack.bottom();
    dbg("StackC", "%s: size is %hhu\n", __FUNCTION__, size);

    if( call Stack.empty() ) 
      return t; 

    if ( size > 1 ) {
      if ( bottom == (STACK_SIZE - 1) )
        bottom = 0;
      else
        bottom++;
    }

    size--;
    return t;
  }

  command error_t Stack.pushTop(stack_t newVal) {
    dbg("StackC", "%s: size is %hhu\n", __FUNCTION__, size);

    if( size == STACK_SIZE )
      return FAIL;

    if( size > 0 ) 
    {
      if (top == STACK_SIZE - 1)
        top = 0;
      else
        top++;
    }

    stack[top] = newVal;
    size++;
    return SUCCESS;
  }

  command error_t Stack.pushBottom(stack_t newVal) {
    dbg("StackC", "%s: size is %hhu\n", __FUNCTION__, size);

    if( size == STACK_SIZE )
      return FAIL;

    if( size > 0 ) 
    {
      if (bottom == 0)
        bottom = STACK_SIZE - 1;
      else
        bottom--;
    }

    stack[bottom] = newVal;
    size++;
    return SUCCESS;
  }
  
  command stack_t Stack.element(uint8_t idx) {
    idx += bottom;
    idx %= STACK_SIZE;
    return stack[idx];
  } 

}
