module DummyOWTypeP {
  provides interface OneWireDeviceType;
}
implementation {
  uint8_t matchId[8]={0xef,0x00,0x00,0x00,
                      0x06,0xb1,0xc3,0x3b};

  command bool OneWireDeviceType.isOfType(onewire_t id){
    uint8_t i;
//    printf("OK lets check %llx (against %llx): ", id.id, *((uint64_t*)matchId));
//    for (i=0; i < 8; i++) {
//      printf("%x ",id.data[i]);
//    }
//    printf(" vs. ");
//    for (i=0; i < 8; i++) {
//      printf("%x ",matchId[7-i]);
//    }
//
//    printf("\n\r");
    for (i=0; i < 8; i++) {
//      printf("%x ?= %x: %x\n\r", id.data[i], matchId[7-i], id.data[i] == matchId[7-i]);
      if (id.data[i] != matchId[7-i]) {
//        printf("returning false\n\r");
        return FALSE;
      }
    }
//    printf("returning true\n\r");
    return TRUE;
  }
}
