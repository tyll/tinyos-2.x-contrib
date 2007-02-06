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
 * @author David Moss
 * @author David Gay
 */

#include "Storage.h"

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
    DIRECT_ID = unique(UQ_BLOCK_STORAGE) + uniqueCount(UQ_CONFIG_STORAGE),
    RESOURCE_ID = unique(UQ_AT45DB),
  };
    
  components DirectStorageP,
      new At45dbVolumeSettingsP() as SettingsP, 
      At45dbStorageManagerC as StorageC, 
      At45dbC,
      WireDirectStorageC;

  DirectStorage = DirectStorageP.DirectStorage[DIRECT_ID];
  DirectModify = DirectStorageP.DirectModify[DIRECT_ID];
  DirectStorageSettings = SettingsP.VolumeSettings;
  DirectModifySettings = SettingsP.VolumeSettings;

  DirectStorageP.At45dbVolume[DIRECT_ID] -> StorageC.At45dbVolume[volume_id];  
  DirectStorageP.Resource[DIRECT_ID] -> At45dbC.Resource[RESOURCE_ID];
  DirectStorageP.VolumeSettings -> SettingsP.VolumeSettings;
  
  SettingsP.At45dbVolume -> StorageC.At45dbVolume[volume_id];
  
}
