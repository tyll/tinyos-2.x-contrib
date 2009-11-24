======================================================================
                     RESTful API for TinyOS
======================================================================


 A RESTful interface for TinyOS which allows the control of sensors
 and actuators over HTTP. Running the webserver application, the 
 sensor node can be addressed by using its IPv6 Address. 
 The implementation is based on blip, the 6LoWPAN stack included in 
 TinyOS 2.1.1. 


----------------------------------------------------------------------
 Dependencies
----------------------------------------------------------------------

 The application was tested with TinyOS 2.1 and the RF212 radio 
 transceiver. 


----------------------------------------------------------------------
 Authors
----------------------------------------------------------------------

 Lars Schor, ETH Zurich, lschor@ee.ethz.ch
 Philipp Sommer, ETH Zurich, sommer@tik.ee.ethz.ch


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

 [1] blip, http://docs.tinyos.net/index.php/BLIP_Tutorial
 [2] L. Schor, P. Sommer, and R. Wattenhofer. Towards a 
  Zero-Configuration Wireless Sensor Network Architecture for Smart 
  Buildings. In Proc. First ACM Workshop On Embedded Sensing Systems 
  For Energy-Efficiency In Buildings (BuildSys), Berkeley, CA, USA, 
  Nov. 2009. 

