/* Copyright (c) 2010 Johns Hopkins University.
*  All rights reserved.
*
*  Permission to use, copy, modify, and distribute this software and its
*  documentation for any purpose, without fee, and without written
*  agreement is hereby granted, provided that the above copyright
*  notice, the (updated) modification history and the author appear in
*  all copies of this source code.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*/
/*
 * Wiring for standard one-wire discovery and identification protocol.
 * If the MAX_ONEWIRE_DEVICES compile flag is set to 1, then the generic multi-device mapper will be replaced by the specialized single-device mapper (which takes up less ROM/RAM).
 * 
 * @author Doug Carlson <carlson@cs.jhu.edu>
 * @modified 6/16/10
 */
configuration OneWireDeviceMapperC {
  provides {
    interface OneWireDeviceMapper;
  }
  uses {
    interface Resource;
    interface OneWireMaster;
  }
} implementation {
  #if MAX_ONEWIRE_DEVICES == 1
    #warning "using single-onewire device setup"
    components SingleOneWireDeviceMapperP as Mapper;
  #else
    components OneWireDeviceMapperP as Mapper;
  #endif

  components OneWireCrcC;

  OneWireDeviceMapper = Mapper;
  
  Mapper.OneWireMaster = OneWireMaster;
  Mapper.Resource = Resource;
  Mapper.OneWireCrc -> OneWireCrcC;
}
