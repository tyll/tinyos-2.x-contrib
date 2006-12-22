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
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Direct Storage Configuration
 * @author David Moss
 * @author Jonathan Hui
 */
#include "Stm25p.h"

generic configuration DirectStorageC(volume_id_t volume_id) {
  provides {
    interface DirectStorage;
    interface DirectModify;
    interface VolumeSettings as DirectStorageSettings;
    interface VolumeSettings as DirectModifySettings;
  }
}

implementation {

  enum {
    DIRECT_ID = unique( "Stm25p.Direct" ),
    VOLUME_ID = unique( "Stm25p.Volume" ),
  };

  components Stm25pDirectP,
      Stm25pSectorC,
      Stm25pVolumeSettingsP,
      new Stm25pBinderP(volume_id);
      
  DirectStorage = Stm25pDirectP.DirectStorage[DIRECT_ID];
  DirectModify = Stm25pDirectP.DirectModify[DIRECT_ID];
  DirectStorageSettings = Stm25pVolumeSettingsP.VolumeSettings[DIRECT_ID];
  DirectModifySettings = Stm25pVolumeSettingsP.VolumeSettings[DIRECT_ID];
  
  Stm25pDirectP.ClientResource[DIRECT_ID] -> Stm25pSectorC.ClientResource[VOLUME_ID];
  Stm25pDirectP.Sector[DIRECT_ID] -> Stm25pSectorC.Sector[VOLUME_ID];
  Stm25pDirectP.VolumeSettings -> Stm25pVolumeSettingsP.VolumeSettings[DIRECT_ID];
  
  Stm25pVolumeSettingsP.Sector[DIRECT_ID] -> Stm25pSectorC.Sector[VOLUME_ID];
  
  Stm25pBinderP.Volume -> Stm25pSectorC.Volume[VOLUME_ID];

}
