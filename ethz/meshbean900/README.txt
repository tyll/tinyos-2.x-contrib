======================================================================
      TinyOS Support for the Meshnetics MeshBean and MeshBean900
======================================================================


 The MeshBean/MeshBean900 development boards from Meshnetics[1] are
 based on the ZigBit/ZigBit900 modules. Both the ZigBit and the
 ZigBit900 module contains an Atmel ATMega1281 microcontroller and an
 Atmel radio transceiver. The radio chip of the ZigBit module (AT86RF230)
 is operating in the 2.4 GHz band while the ZigBit900 module (AT86RF212)
 is operating in the 900 MHz band. The MeshBean development boards
 feature a number of peripheral devices such as temperature and light
 sensors, a serial identifier chip, an UART-to-USB converter and an
 extension connector for additional devices. 


----------------------------------------------------------------------
 File Structure
----------------------------------------------------------------------

 To use the MeshBean/MeshBean900 together with TinyOS 2.x, you need to
 add the following directories and files to the TinyOS installation path:

 support
 |-make
    |-meshbean.target         make target for the MeshBean platform
    |-meshbean900.target      make target for the MeshBean900 platform

    |-avr
      |-jtagicemkII.extra     AVR JTAGICE mkII programmer support

 tos
 |-platforms
    |-meshbean                platform-specific implementation (LED, 
                              UART, user buttons) for the MeshBean
                              platform
      |-chips

        |-atm128 
          |-i2c               Atmel Atmega128 I2C master controller
        
        |-atm1281             
          |-pins              Atmel Atmega1281 I/O pins
        
        |-ds2411              platform-specific DS2411 serial id chip
                              implementation
        
        |-lm73                LM73 temperature sensor (I2C)
        
        |-rf212               platform-specific implementation for the
                              Atmel AT86RF212 radio chip
        
        |-tsl2550             TSL2550 dual channel light sensor (I2C)          
 
|-platforms
    |-meshbean900             platform-specific implementation for the
                              MeshBean900 platform, the Meshbean900
                              platform inherits from the Meshbean platform



----------------------------------------------------------------------
 Software Dependencies
----------------------------------------------------------------------

 The latest TinyOS 2.x from the CVS repository is required.


----------------------------------------------------------------------
 Installing on the MeshBean/MeshBean900 
----------------------------------------------------------------------

 An application for the MeshBean platform can be compiled using the
 "meshbean" make target in TinyOS: 

 $ make meshbean

 For the MeshBean900 platform use the "meshbean900" target:

 $ make meshbean900


 There exist different ways to install the binary image on the Meshbean/
 Meshbean900 module:

  (1) Using the BitCloud bootloader from Meshnetics which is pre-installed
      on the MeshBean/MeshBean900 board. Follow the steps in the BitCloud
      documentation to install a binary image in the SREC format on the node. 

      NOTE: The BitCloud bootloader is only available for Windows. However,
            there exist also a Linux version from a third-party [3].

  (2) Using a JTAG programmer to download the binary image in the SREC format.
      WARNING: This will overwrite any existing BitCloud bootloader on the
      MeshBean/MeshBean900 module!!!


----------------------------------------------------------------------
 Authors
----------------------------------------------------------------------

 Philipp Sommer, ETH Zurich, sommer@tik.ee.ethz.ch
 Roland Flury, ETH Zurich, rflury@tik.ee.ethz.ch
 Thomas Fahrni, ETH Zurich, tfahrni@ee.ethz.ch
 Richard Huber, ETH Zurich, rihuber@ee.ethz.ch
 Lars Schor, ETH Zurich, lschor@ee.ethz.ch


----------------------------------------------------------------------
 License
----------------------------------------------------------------------

 Copyright (c) 2009, Distributed Computing Group (DCG), ETH Zurich.
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
 3. Neither the name of the copyright holders nor the names of
     contributors may be used to endorse or promote products derived
     from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
 OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 THE POSSIBILITY OF SUCH DAMAGE.


----------------------------------------------------------------------
 References
----------------------------------------------------------------------

 [1] Meshnetics, http://www.meshnetics.com/
 [2] TinyOS CVS, http://sourceforge.net/cvs/?group_id=28656
 [3] Meshnetics serial programmer for Linux, 
     http://pervasive.researchstudio.at/portal/projects/meshprog


