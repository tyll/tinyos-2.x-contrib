#all:
#	gcc -Wall -O0 -mcpu=arm7tdmi-s -mapcs -mthumb-interwork -o flash.o flash.c -nostartfiles -nodefaultlibs -nostdlib -Wl,-e,main
#	objcopy -Obinary -j.text flash.o flash.bin
#	objdump --disassemble-all -bbinary -marm7tdmi flash.bin > flash.asm
#

TOOL_PREFIX=arm-elf-

all:
	$(TOOL_PREFIX)gcc -W -Wall -O3 -mcpu=arm7tdmi -mapcs -mthumb-interwork -c -o flash.o flash.c
	$(TOOL_PREFIX)as --warn -mcpu=arm7tdmi -mapcs-32 -EL -mthumb-interwork -o crt0.o crt0.s
	$(TOOL_PREFIX)ld -O3 --gc-sections crt0.o flash.o -o flash
	$(TOOL_PREFIX)objcopy -O binary flash flash.bin
	$(TOOL_PREFIX)objdump --disassemble-all -b binary -m arm7tdmi flash.bin > flash.asm

clean:
	rm -f flash.o flash.bin flash.asm
