Test out the onewire bus code. 

This checks for DS1825's on startup, then continuously iterates over all DS1825's detected and reads from them. The results are output via serial printf.

TODO: check this with multiple types, even if they are dummy
