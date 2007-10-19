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
 * Interface for the SPI resource for an entire chip.  The chip accesses
 * the platform SPI resource one time, but can have multiple clients 
 * using the SPI bus on top.  When all of the clients are released, the
 * chip will normally try to release itself from the platforms SPI bus.
 * In some cases, this isn't desirable - so even though upper components
 * aren't actively using the SPI bus, they can tell the chip to hold onto
 * it so they can have immediate access when they need. 
 *
 * Any component that aborts a release MUST attempt the release at a later
 * time if they don't acquire and release the SPI bus naturally after the
 * abort.
 * 
 * @author David Moss
 */
interface ChipSpiResource {
  
  /**
   * The SPI bus is about to be automatically released.  Modules that aren't
   * using the SPI bus but still want the SPI bus to stick around must call
   * abortRelease() within the event.
   */
  async event void releasing();

  
  /**
   * Abort the release of the SPI bus.  This must be called only with the
   * releasing() event
   */
  async command void abortRelease();
  
  /**
   * Release the SPI bus if there are no objections
   * @return SUCCESS if the SPI bus is released from the chip.
   *      FAIL if the SPI bus is already in use.
   *      EBUSY if some component aborted the release.
   */
  async command error_t attemptRelease();
  
}
