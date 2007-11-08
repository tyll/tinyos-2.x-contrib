
/**
 * Erase, Write, Read, Erase the entire flash.
 * This tests the ability to use SPI and/or DMA, the physical integrity of
 * the flash chip, and the majority of the DirectStorage interface.
 *
 * @author David Moss
 */


#include "StorageVolumes.h"
 
configuration TestDirectStorageC {
}

implementation {
  /** Do not modify the order of these tests */
  components new TestCaseC() as TestErase1C,
      new TestCaseC() as TestWriteC,
      new TestCaseC() as TestReadC,
      new TestCaseC() as TestErase2C;
      
  components TestDirectStorageP,
      new DirectStorageC(VOLUME_TEST),
      new StateC(),
      LedsC;
      
  TestDirectStorageP.DirectStorage -> DirectStorageC;
  TestDirectStorageP.VolumeSettings -> DirectStorageC.DirectStorageSettings;
  TestDirectStorageP.State -> StateC;
  TestDirectStorageP.Leds -> LedsC;
  
  TestDirectStorageP.SetUp -> TestErase1C.SetUp;
  
  TestDirectStorageP.TestErase1 -> TestErase1C;
  TestDirectStorageP.TestWrite -> TestWriteC;
  TestDirectStorageP.TestRead -> TestReadC;
  TestDirectStorageP.TestErase2 -> TestErase2C;
  
}

