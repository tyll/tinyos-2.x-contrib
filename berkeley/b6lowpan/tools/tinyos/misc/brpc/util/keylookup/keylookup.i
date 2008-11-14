
program KeyLookup {
   command lookup(uint8_t [] key);
   event lookupDone(uint8_t [] value);

   command insert(uint8_t [] key, uint8_t [] value);
   event insertDone(uint8_t [] key);
} = 12135;

