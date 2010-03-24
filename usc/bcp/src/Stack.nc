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
 *  Interface to a Stack list (top / bottom accessibility) 
 *  that contains items of a specific type. 
 *  The stack has a maximum size.
 *
 *  @author Philip Levis
 *  @author Kyle Jamieson
 *  @author Scott Moeller
 *  @date   $Date$
 */

   
interface Stack<t> {

  /**
   * Returns if the stack is empty.
   *
   * @return Whether the stack is empty.
   */
  command bool empty();

  /**
   * The number of elements currently in the stack.
   * Always less than or equal to maxSize().
   *
   * @return The number of elements in the stack.
   */
  command uint8_t size();

  /**
   * The maximum number of elements the stack can hold.
   *
   * @return The maximum stack size.
   */
  command uint8_t maxSize();

  /**
   * Get the top of the stack without removing it. If the stack
   * is empty, the return value is undefined.
   *
   * @return 't ONE' The top of the stack.
   */
  command t top();
  
  /**
   * Pop the top of the stack. If the stack is empty, the return
   * value is undefined.
   *
   * @return 't ONE' The top of the stack.
   */
  command t popTop();

  /**
   * Get the bottom of the stack without removing it. If the stack
   * is empty, the return value is undefined.
   *
   * @return 't ONE' The bottom of the stack.
   */
  command t bottom();
  
  /**
   * Pop the bottom of the stack. If the stack is empty, the return
   * value is undefined.
   *
   * @return 't ONE' The bottom of the stack.
   */
  command t popBottom();

  /**
   * Push an element to the top of the stack.
   *
   * @param 't ONE newVal' - the element to push
   * @return SUCCESS if the element was pushed successfully, FAIL
   *                 if it was not pushed
   */
  command error_t pushTop(t newVal);

  /**
   * Push an element to the bottom of the stack.
   *
   * @param 't ONE newVal' - the element to push
   * @return SUCCESS if the element was pushed successfully, FAIL
   *                 if it was not pushed
   */
  command error_t pushBottom(t newVal);

  /**
   * Return the nth element of the stack without altering it, 
   * where 0 is the bottom of the stack and (size - 1) is the top. 
   * If the element requested is larger than the current stack size,
   * the return value is undefined.
   *
   * @param index - the index of the element to return
   * @return 't ONE' the requested element in the stack.
   */
  command t element(uint8_t idx);
}
