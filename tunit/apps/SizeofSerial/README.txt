TUnit uses the serial stack.  We use this application to make a few required
calls to the serial stack (which means those functions shouldn't be optimized
away) to see approximately how big the serial stack is compared to the entire
TUnit library.

    compiled SizeofSerialC to build/telosb/main.exe
            5338 bytes in ROM
             211 bytes in RAM
             
    compiled TestTunitC to build/telosb/main.exe
            6798 bytes in ROM
             463 bytes in RAM
             
             
    sizeof(tunit - serial stack) =
            1460 bytes in ROM
             252 bytes in RAM
             
