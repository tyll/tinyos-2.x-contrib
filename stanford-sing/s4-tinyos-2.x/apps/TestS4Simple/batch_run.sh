make micaz sim

i="440"
date

g++ -g -o a.exe driver-test.cpp  simbuild/micaz/sim.o  simbuild/micaz/tossim.o simbuild/micaz/c-support.o  -I$TOSDIR/lib/tossim

./a.exe > output.txt 




date
exit

