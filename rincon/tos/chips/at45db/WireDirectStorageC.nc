
/**
 * We do this because this configuration will not get instantiated
 * more than once, so the At45dbC will be wired ot DirectStorageP
 * exactly one time. 
 * @author David Moss
 */
 
configuration WireDirectStorageC {
}

implementation {
  components DirectStorageP,
      At45dbC;
      
  DirectStorageP.At45db -> At45dbC;
  
}

