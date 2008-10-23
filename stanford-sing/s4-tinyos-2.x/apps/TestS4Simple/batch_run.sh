make micaz sim

i="440"
date

g++ -g -o a.exe driver-test.cpp  build/micaz/sim.o  build/micaz/tossim.o build/micaz/c-support.o  -I$TOSDIR/lib/tossim

./a.exe > output.txt 




date
exit

