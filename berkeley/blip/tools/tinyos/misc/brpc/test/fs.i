
program Filesystem {  
  command open(uint8_t [] filename);
  event   openDone(uint32_t fh);

  command read(uint32_t fh, uint32_t off, uint16_t len);
  event   readDone(uint32_t fh, uint8_t [] data);


  command write(uint32_t fh, uint32_t off, uint8_t [] data);
  event   writeDone(uint32_t fh, uint16_t error);
} = 12135;


