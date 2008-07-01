/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * @author Kamin Whitehouse
 * @author Michael Okola (TinyOS 2.x porting)
 */

//includes Rpc;

module UnitTestC {

  //items below that are marked with /** **/ are illegal @rpc commands
  //and should provide compile time errors if uncommented
  provides{

    interface TestInterface1;
    command void testCommand1();
    command error_t testCommand3(uint8_t something);
    command error_t* testCommand4(uint8_t something, uint16_t* data);
    event void testEvent1();
    event error_t testEvent3(uint8_t something);
    event error_t* testEvent4(uint8_t something, uint16_t* data);
  }
  uses{
    interface Leds;
    interface SplitControl;
    interface TestInterface2;

  }
}
implementation {

  uint8_t test;
  uint8_t* testPtr;
  uint8_t testArray[10];

  command void testCommand1(){
    call Leds.set(1);
  }
  command error_t testCommand3(uint8_t something){
    call Leds.set(3);
    return SUCCESS;
  }
  command error_t* testCommand4(uint8_t something, uint16_t* data){
    call Leds.set(4);
    return (error_t*)data;
  }
  event void testEvent1(){
    call Leds.set(1);
  }
  event error_t testEvent3(uint8_t something){
    call Leds.set(3);
    return SUCCESS;
  }
  event error_t* testEvent4(uint8_t something, uint16_t* data){
    call Leds.set(4);
    return (error_t*)data;
  }
  command void TestInterface1.testCommand1(){
    call Leds.set(1);
  }
  command error_t TestInterface1.testCommand3(uint8_t something){
    call Leds.set(3);
    return SUCCESS;
  }
  command error_t* TestInterface1.testCommand4(uint8_t something, uint16_t* data){
    call Leds.set(4);
    return (error_t*)data;
  }
  event void TestInterface2.testEvent1(){
    call Leds.set(1);
  }
  event error_t TestInterface2.testEvent3(uint8_t something){
    call Leds.set(3);
    return SUCCESS;
  }
  event error_t* TestInterface2.testEvent4(uint8_t something, uint16_t* data){
    call Leds.set(4);
    return (error_t*)data;
  }

  event void SplitControl.startDone(error_t error){
    test = 123;
    testPtr= &test;
    testArray[0] = 1;
    testArray[1] = 2;
    testArray[2] = 3;
    testArray[3] = 4;
    testArray[4] = 5;
    testArray[5] = 6;
    testArray[6] = 7;
    testArray[7] = 8;
    testArray[8] = 9;
    testArray[9] = 10;
  }

  event void SplitControl.stopDone(error_t error){
  }

}
