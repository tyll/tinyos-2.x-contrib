@/*********************************************************************
@Copyright:      (c) Intel Corporation, 2002, 2003
@ 
@INTEL MAKES NO WARRANTY OF ANY KIND REGARDING THE CODE.  THIS CODE IS
@LICENSED ON AN "AS IS" BASIS AND INTEL WILL NOT PROVIDE ANY SUPPORT,
@ASSISTANCE, INSTALLATION, TRAINING OR OTHER SERVICES.  INTEL DOES NOT
@PROVIDE ANY UPDATES ENHANCEMENTS OR EXTENSIONS.  INTEL SPECIFICALLY
@DISCLAIMS ANY WARRANTY OF MERCHANTABILITY, NONINFRINGEMENT, FITNESS
@FOR ANY PARTICULAR PURPOSE, OR ANY OTHER WARRANTY.  INTEL DISCLAIMS
@ALL LIABILITY, INCLUDING LIABILITY FOR INFRINGMENT OF ANY PROPRIETARY
@RIGHTS, RELATING TO USE OF THE CODE.  NO LICENSE, EXPRESS OR IMPLIED,
@BY ESTOPPEL OR OTHERWISE, TO ANY INTELLECTUAL PROPERTY RIGHTS IS
@GRANTED HEREIN.
@*********************************************************************/@
@  File:     mmu_table.s
@
@  Uses Section descriptor within the First-level dscriptor format
@
@  For Bulverde
@
@      3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 
@      1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
@
@      --- Virtual Offset ---- 0 0 0 0 0 0 0 X -AP 0 -Domain 0 C B 1 0     <---- 1MB page descriptor
@
@
@
@    X     C     B
@    0     0     0       IO Cycle, stall until complete
@    0     0     1       Write merging, but uncached
@    0     1     0       Buffering, cache Write-Through mode, read allocate
@    0     1     1       Regular Caching, Writi-Through mode, read allocate
@
@    1     0     0       Unpredictable
@    1     0     1       Buffer Writes, but don't coalesce
@    1     1     0       Mini D-Cache, (cache policy is determined by MD field of Auxillary Control Reg)
@    1     1     1       Same as X=0 with Read & Write Allocate
@
@
        

@set WT to 1 to enable the WT through table, set to 0 to use the WB table
.equ WT,1	

@set SRAM_CACHEABLE to 1 to enable either WT or WB caching to internal SRAM
.equ SRAM_CACHEABLE,1

@disable caching for upper 31M of FLASH so that we can write to it without mucking with page table
.equ NO_UPPER_FLASH_CACHE, 1
		
.if WT
        @.ALIGN        0x4000
	.align	14
@.Write Through Table
.global MMUTable	
MMUTable:	

        .word        0x0000000A		@ ROM  (x=0,c=1,b=1 => Write-Through)
.if NO_UPPER_FLASH_CACHE
	.word        0x00100002
        .word        0x00200002
        .word        0x00300002
        .word        0x00400002
        .word        0x00500002
        .word        0x00600002
        .word        0x00700002
        .word        0x00800002
        .word        0x00900002
        .word        0x00A00002
        .word        0x00B00002
        .word        0x00C00002
        .word        0x00D00002
        .word        0x00E00002
        .word        0x00F00002
        .word        0x01000002
        .word        0x01100002
        .word        0x01200002
        .word        0x01300002
        .word        0x01400002
        .word        0x01500002
        .word        0x01600002
        .word        0x01700002
        .word        0x01800002
        .word        0x01900002
        .word        0x01A00002
        .word        0x01B00002
        .word        0x01C00002
        .word        0x01D00002
        .word        0x01E00002
        .word        0x01F00002		@ 32 MByte
.else
	.word        0x0010000A
        .word        0x0020000A
        .word        0x0030000A
        .word        0x0040000A
        .word        0x0050000A
        .word        0x0060000A
        .word        0x0070000A
        .word        0x0080000A
        .word        0x0090000A
        .word        0x00A0000A
        .word        0x00B0000A
        .word        0x00C0000A
        .word        0x00D0000A
        .word        0x00E0000A
        .word        0x00F0000A
        .word        0x0100000A
        .word        0x0110000A
        .word        0x0120000A
        .word        0x0130000A
        .word        0x0140000A
        .word        0x0150000A
        .word        0x0160000A
        .word        0x0170000A
        .word        0x0180000A
        .word        0x0190000A
        .word        0x01A0000A
        .word        0x01B0000A
        .word        0x01C0000A
        .word        0x01D0000A
        .word        0x01E0000A
        .word        0x01F0000A		@ 32 MByte
.endif
	@.ALIGN 0x100				@(0x4100=0x4000+0x040*4)
	.align	8

        .word        0x0400000A		@ Flash  (x=0,c=1,b=1 => Write-Through)
        .word        0x0410000A
        .word        0x0420000A
        .word        0x0430000A
        .word        0x0440000A
        .word        0x0450000A
        .word        0x0460000A
        .word        0x0470000A
        .word        0x0480000A
        .word        0x0490000A
        .word        0x04A0000A
        .word        0x04B0000A
        .word        0x04C0000A
        .word        0x04D0000A
        .word        0x04E0000A
        .word        0x04F0000A
        .word        0x0500000A
        .word        0x0510000A
        .word        0x0520000A
        .word        0x0530000A
        .word        0x0540000A
        .word        0x0550000A
        .word        0x0560000A
        .word        0x0570000A
        .word        0x0580000A
        .word        0x0590000A
        .word        0x05A0000A
        .word        0x05B0000A
        .word        0x05C0000A
        .word        0x05D0000A
        .word        0x05E0000A
        .word        0x05F0000A		@ 32 MByte

	@.ALIGN		0x100				@(0x4200=0x4000+0x080*4)
	.align	8

        .word        0x08000002		@ Mainstone Board Regs  (x=0,c=0,b=0 => I/O space)

	@.ALIGN		0x80				@(0x4280=0x4000+0x0A0*4)
	.align	7

        .word        0x0A00000A		@ nCS2 - 2M SRAM  (x=0,c=1,b=1 => Write-Through)
		.word        0x0A10000A		@ 

	@.ALIGN		0x80				@(0x4300=0x4000+0x0C0*4)
	.align	7

        .word        0x0   			@ (nCS3  (x=0,c=0,b=0 => I/O space)

	@.ALIGN		0x100				@(0x4400=0x4000+0x100*4)
	.align	8

        .word        0x10000002		@ nCS4 - 100BASE2 Ethernet  (x=0,c=0,b=0 => I/O space)
        .word        0x10100002
        .word        0x10200002
        .word        0x10300002

	@.ALIGN		0x100				@(0x4500=0x4000+0x140*4)
	.align	8

        .word        0x14000002		@ nCS5 - Expansion Connector  (x=0,c=0,b=0 => I/O space)
        .word        0x14100002
        .word        0x14200002
        .word        0x14300002


	@.ALIGN		0x400				@(0x4800=0x4000+0x200*4)
	.align	10

        .word        0x20000002		@ PCMCIA/CF Slot 0  (x=0,c=0,b=0 => I/O space)
        .word        0x20100002
        .word        0x20200002
        .word        0x20300002		@ REALLY SHOULD BE 256 MB!!!!!!

	@.ALIGN		0x400				@(0x4C00=0x4000+0x300*4)
	.align	10

        .word        0x30000002		@ PCMCIA/CF Slot 1  (x=0,c=0,b=0 => I/O space)
        .word        0x30100002
        .word        0x30200002
        .word        0x30300002		@ REALLY SHOULD BE 256 MB!!!!!!

	@.ALIGN		0x400				@(0x5000=0x4000+0x400*4)
	.align	10

        .word        0x40000002		@ Internal Registers (periphs) (x=0,c=0,b=0 => I/O space)
        .word        0x40100002
        .word        0x40200002
        .word        0x40300002
        .word        0x40400002
        .word        0x40500002
        .word        0x40600002
        .word        0x40700002
        .word        0x40800002
        .word        0x40900002
        .word        0x40A00002
        .word        0x40B00002
        .word        0x40C00002
        .word        0x40D00002
        .word        0x40E00002
        .word        0x40F00002
        .word        0x41000002
        .word        0x41100002
        .word        0x41200002
        .word        0x41300002
        .word        0x41400002
        .word        0x41500002
        .word        0x41600002
        .word        0x41700002
        .word        0x41800002
        .word        0x41900002
        .word        0x41A00002
        .word        0x41B00002
        .word        0x41C00002
        .word        0x41D00002
        .word        0x41E00002
        .word        0x41F00002		@ 32 MByte
        .word        0x42000002	
        .word        0x42100002
        .word        0x42200002
        .word        0x42300002
        .word        0x42400002
        .word        0x42500002
        .word        0x42600002
        .word        0x42700002
        .word        0x42800002
        .word        0x42900002
        .word        0x42A00002
        .word        0x42B00002
        .word        0x42C00002
        .word        0x42D00002
        .word        0x42E00002
        .word        0x42F00002
        .word        0x43000002
        .word        0x43100002
        .word        0x43200002
        .word        0x43300002
        .word        0x43400002
        .word        0x43500002
        .word        0x43600002
        .word        0x43700002
        .word        0x43800002
        .word        0x43900002
        .word        0x43A00002
        .word        0x43B00002
        .word        0x43C00002
        .word        0x43D00002
        .word        0x43E00002
        .word        0x43F00002		@ 32 MByte
        
        
 
        .word        0x44000002		@ Internal Registers (LCD)  (x=0,c=0,b=0 => I/O space)
        .word        0x44100002
        .word        0x44200002
        .word        0x44300002
        .word        0x44400002
        .word        0x44500002
        .word        0x44600002
        .word        0x44700002
        .word        0x44800002
        .word        0x44900002
        .word        0x44A00002
        .word        0x44B00002
        .word        0x44C00002
        .word        0x44D00002
        .word        0x44E00002
        .word        0x44F00002
        .word        0x45000002
        .word        0x45100002
        .word        0x45200002
        .word        0x45300002
        .word        0x45400002
        .word        0x45500002
        .word        0x45600002
        .word        0x45700002
        .word        0x45800002
        .word        0x45900002
        .word        0x45A00002
        .word        0x45B00002
        .word        0x45C00002
        .word        0x45D00002
        .word        0x45E00002
        .word        0x45F00002		@ 32 MByte
        .word        0x46000002	
        .word        0x46100002
        .word        0x46200002
        .word        0x46300002
        .word        0x46400002
        .word        0x46500002
        .word        0x46600002
        .word        0x46700002
        .word        0x46800002
        .word        0x46900002
        .word        0x46A00002
        .word        0x46B00002
        .word        0x46C00002
        .word        0x46D00002
        .word        0x46E00002
        .word        0x46F00002
        .word        0x47000002
        .word        0x47100002
        .word        0x47200002
        .word        0x47300002
        .word        0x47400002
        .word        0x47500002
        .word        0x47600002
        .word        0x47700002
        .word        0x47800002
        .word        0x47900002
        .word        0x47A00002
        .word        0x47B00002
        .word        0x47C00002
        .word        0x47D00002
        .word        0x47E00002
        .word        0x47F00002		@ 32 MByte

       
 
        .word        0x48000002		@ Internal Registers (mem ctrl)  (x=0,c=0,b=0 => I/O space)
        .word        0x48100002
        .word        0x48200002
        .word        0x48300002
        .word        0x48400002
        .word        0x48500002
        .word        0x48600002
        .word        0x48700002
        .word        0x48800002
        .word        0x48900002
        .word        0x48A00002
        .word        0x48B00002
        .word        0x48C00002
        .word        0x48D00002
        .word        0x48E00002
        .word        0x48F00002
        .word        0x49000002
        .word        0x49100002
        .word        0x49200002
        .word        0x49300002
        .word        0x49400002
        .word        0x49500002
        .word        0x49600002
        .word        0x49700002
        .word        0x49800002
        .word        0x49900002
        .word        0x49A00002
        .word        0x49B00002
        .word        0x49C00002
        .word        0x49D00002
        .word        0x49E00002
        .word        0x49F00002		@ 32 MByte
        .word        0x4A000002	
        .word        0x4A100002
        .word        0x4A200002
        .word        0x4A300002
        .word        0x4A400002
        .word        0x4A500002
        .word        0x4A600002
        .word        0x4A700002
        .word        0x4A800002
        .word        0x4A900002
        .word        0x4AA00002
        .word        0x4AB00002
        .word        0x4AC00002
        .word        0x4AD00002
        .word        0x4AE00002
        .word        0x4AF00002
        .word        0x4B000002
        .word        0x4B100002
        .word        0x4B200002
        .word        0x4B300002
        .word        0x4B400002
        .word        0x4B500002
        .word        0x4B600002
        .word        0x4B700002
        .word        0x4B800002
        .word        0x4B900002
        .word        0x4BA00002
        .word        0x4BB00002
        .word        0x4BC00002
        .word        0x4BD00002
        .word        0x4BE00002
        .word        0x4BF00002	
       	.word		   0x4C000002			@ 33 MByte

@// end at  ( 0x5300 = 0x4000 + 0x4C0 *4 )

	@.ALIGN		0x200			@// this should get us to 0x5400
	.align	9
	.word        0x50000002			@ cif registers at 0x5000
	@.ALIGN		0x200			@ (0x5600=0x4000+0x580*4)
	.align	9
								@// this should get us to 0x5600

	.word		0x58000002		@ internal SRAM control registers

	@.ALIGN		0x100			@ (0x5700=0x4000+0x5C0*4)
	.align	8
								@// this should get us to 0x5700

.if SRAM_CACHEABLE
	.word		   0x5C00000A 		@ 256K internal SRAM (x=0, C=1, b=0 => Write-Through)
.else
	.word		   0x5C000002 		@ 256K internal SRAM (x=0, C=1, b=0 => Write-Through)
.endif

	@.ALIGN		0x1000			@// this should get us to 0x6000
	.align	12

	.word 0x0						@insert a word so the next align goes to 0x6800
        
 	@.ALIGN		0x800				@(0x6800=0x4000+0xA00*4)
	.align	11

        .word        0xA000000A		@ SDRAM bank 0  (x=0,c=1,b=0 => Write-Through) 
        .word        0xA010000A		
        .word        0xA020000A
        .word        0xA030000A
        .word        0xA040000A
        .word        0xA050000A
        .word        0xA060000A
        .word        0xA070000A
        .word        0xA080000A
        .word        0xA090000A
        .word        0xA0A0000A
        .word        0xA0B0000A
        .word        0xA0C0000A
        .word        0xA0D0000A
        .word        0xA0E0000A
        .word        0xA0F0000A
        .word        0xA100000A
        .word        0xA110000A
        .word        0xA120000A
        .word        0xA130000A
        .word        0xA140000A
        .word        0xA150000A
        .word        0xA160000A
        .word        0xA170000A
        .word        0xA180000A
        .word        0xA190000A
        .word        0xA1A0000A
        .word        0xA1B0000A
        .word        0xA1C0000A
        .word        0xA1D0000A
        .word        0xA1E0000A
        .word        0xA1F0000A		@ 32 MByte
        .word        0xA200000A	
        .word        0xA210000A
        .word        0xA220000A
        .word        0xA230000A
        .word        0xA240000A
        .word        0xA250000A
        .word        0xA260000A
        .word        0xA270000A
        .word        0xA280000A
        .word        0xA290000A
        .word        0xA2A0000A
        .word        0xA2B0000A
        .word        0xA2C0000A
        .word        0xA2D0000A
        .word        0xA2E0000A
        .word        0xA2F0000A
        .word        0xA300000A
        .word        0xA310000A
        .word        0xA320000A
        .word        0xA330000A
        .word        0xA340000A
        .word        0xA350000A
        .word        0xA360000A
        .word        0xA370000A
        .word        0xA380000A
        .word        0xA390000A
        .word        0xA3A0000A
        .word        0xA3B0000A
        .word        0xA3C0000A
        .word        0xA3D0000A
        .word        0xA3E0000A
        .word        0xA3F0000A		@ 32 MByte
MMUTable_end:
	nop
.else
@ write-back table
        @.ALIGN        0x4000
	.align	14
.global MMUTable
MMUTable:	

        .word        0x0000000E		@ ROM  (x=0,c=1,b=1 => Write-Back)
.if NO_UPPER_FLASH_CACHE
	.word        0x00100002
        .word        0x00200002
        .word        0x00300002
        .word        0x00400002
        .word        0x00500002
        .word        0x00600002
        .word        0x00700002
        .word        0x00800002
        .word        0x00900002
        .word        0x00A00002
        .word        0x00B00002
        .word        0x00C00002
        .word        0x00D00002
        .word        0x00E00002
        .word        0x00F00002
        .word        0x01000002
        .word        0x01100002
        .word        0x01200002
        .word        0x01300002
        .word        0x01400002
        .word        0x01500002
        .word        0x01600002
        .word        0x01700002
        .word        0x01800002
        .word        0x01900002
        .word        0x01A00002
        .word        0x01B00002
        .word        0x01C00002
        .word        0x01D00002
        .word        0x01E00002
        .word        0x01F00002		@ 32 MByte
.else
        .word        0x0010000E
        .word        0x0020000E
        .word        0x0030000E
        .word        0x0040000E
        .word        0x0050000E
        .word        0x0060000E
        .word        0x0070000E
        .word        0x0080000E
        .word        0x0090000E
        .word        0x00A0000E
        .word        0x00B0000E
        .word        0x00C0000E
        .word        0x00D0000E
        .word        0x00E0000E
        .word        0x00F0000E
        .word        0x0100000E
        .word        0x0110000E
        .word        0x0120000E
        .word        0x0130000E
        .word        0x0140000E
        .word        0x0150000E
        .word        0x0160000E
        .word        0x0170000E
        .word        0x0180000E
        .word        0x0190000E
        .word        0x01A0000E
        .word        0x01B0000E
        .word        0x01C0000E
        .word        0x01D0000E
        .word        0x01E0000E
        .word        0x01F0000E		@ 32 MByte
.endif
	@.ALIGN 0x100				@(0x4100=0x4000+0x040*4)
	.align	8

        .word        0x0400000E		@ Flash  (x=0,c=1,b=1 => Write-Back)
        .word        0x0410000E
        .word        0x0420000E
        .word        0x0430000E
        .word        0x0440000E
        .word        0x0450000E
        .word        0x0460000E
        .word        0x0470000E
        .word        0x0480000E
        .word        0x0490000E
        .word        0x04A0000E
        .word        0x04B0000E
        .word        0x04C0000E
        .word        0x04D0000E
        .word        0x04E0000E
        .word        0x04F0000E
        .word        0x0500000E
        .word        0x0510000E
        .word        0x0520000E
        .word        0x0530000E
        .word        0x0540000E
        .word        0x0550000E
        .word        0x0560000E
        .word        0x0570000E
        .word        0x0580000E
        .word        0x0590000E
        .word        0x05A0000E
        .word        0x05B0000E
        .word        0x05C0000E
        .word        0x05D0000E
        .word        0x05E0000E
        .word        0x05F0000E		@ 32 MByte

	@.ALIGN		0x100				@(0x4200=0x4000+0x080*4)
	.align	8

        .word        0x08000002		@ Mainstone Board Regs  (x=0,c=0,b=0 => I/O space)

	@.ALIGN		0x80				@(0x4280=0x4000+0x0A0*4)
	.align	7

        .word        0x0A00000E		@ nCS2 - 2M SRAM  (x=0,c=1,b=1 => Write-Back)
		.word        0x0A10000E		@ 

	@.ALIGN		0x80				@(0x4300=0x4000+0x0C0*4)
	.align	7

        .word        0x0   			@ (nCS3  (x=0,c=0,b=0 => I/O space)

	@.ALIGN		0x100				@(0x4400=0x4000+0x100*4)
	.align	8

        .word        0x10000002		@ nCS4 - 100BASE2 Ethernet  (x=0,c=0,b=0 => I/O space)
        .word        0x10100002
        .word        0x10200002
        .word        0x10300002

	@.ALIGN		0x100				@(0x4500=0x4000+0x140*4)
	.align	8

        .word        0x14000002		@ nCS5 - Expansion Connector  (x=0,c=0,b=0 => I/O space)
        .word        0x14100002
        .word        0x14200002
        .word        0x14300002


	@.ALIGN		0x400				@(0x4800=0x4000+0x200*4)
	.align	10

        .word        0x20000002		@ PCMCIA/CF Slot 0  (x=0,c=0,b=0 => I/O space)
        .word        0x20100002
        .word        0x20200002
        .word        0x20300002		@ REALLY SHOULD BE 256 MB!!!!!!

	@.ALIGN		0x400				@(0x4C00=0x4000+0x300*4)
	.align	10

        .word        0x30000002		@ PCMCIA/CF Slot 1  (x=0,c=0,b=0 => I/O space)
        .word        0x30100002
        .word        0x30200002
        .word        0x30300002		@ REALLY SHOULD BE 256 MB!!!!!!

	@.ALIGN		0x400				@(0x5000=0x4000+0x400*4)
	.align	10

        .word        0x40000002		@ Internal Registers (periphs) (x=0,c=0,b=0 => I/O space)
        .word        0x40100002
        .word        0x40200002
        .word        0x40300002
        .word        0x40400002
        .word        0x40500002
        .word        0x40600002
        .word        0x40700002
        .word        0x40800002
        .word        0x40900002
        .word        0x40A00002
        .word        0x40B00002
        .word        0x40C00002
        .word        0x40D00002
        .word        0x40E00002
        .word        0x40F00002
        .word        0x41000002
        .word        0x41100002
        .word        0x41200002
        .word        0x41300002
        .word        0x41400002
        .word        0x41500002
        .word        0x41600002
        .word        0x41700002
        .word        0x41800002
        .word        0x41900002
        .word        0x41A00002
        .word        0x41B00002
        .word        0x41C00002
        .word        0x41D00002
        .word        0x41E00002
        .word        0x41F00002		@ 32 MByte
        .word        0x42000002	
        .word        0x42100002
        .word        0x42200002
        .word        0x42300002
        .word        0x42400002
        .word        0x42500002
        .word        0x42600002
        .word        0x42700002
        .word        0x42800002
        .word        0x42900002
        .word        0x42A00002
        .word        0x42B00002
        .word        0x42C00002
        .word        0x42D00002
        .word        0x42E00002
        .word        0x42F00002
        .word        0x43000002
        .word        0x43100002
        .word        0x43200002
        .word        0x43300002
        .word        0x43400002
        .word        0x43500002
        .word        0x43600002
        .word        0x43700002
        .word        0x43800002
        .word        0x43900002
        .word        0x43A00002
        .word        0x43B00002
        .word        0x43C00002
        .word        0x43D00002
        .word        0x43E00002
        .word        0x43F00002		@ 32 MByte
        
        
 
        .word        0x44000002		@ Internal Registers (LCD)  (x=0,c=0,b=0 => I/O space)
        .word        0x44100002
        .word        0x44200002
        .word        0x44300002
        .word        0x44400002
        .word        0x44500002
        .word        0x44600002
        .word        0x44700002
        .word        0x44800002
        .word        0x44900002
        .word        0x44A00002
        .word        0x44B00002
        .word        0x44C00002
        .word        0x44D00002
        .word        0x44E00002
        .word        0x44F00002
        .word        0x45000002
        .word        0x45100002
        .word        0x45200002
        .word        0x45300002
        .word        0x45400002
        .word        0x45500002
        .word        0x45600002
        .word        0x45700002
        .word        0x45800002
        .word        0x45900002
        .word        0x45A00002
        .word        0x45B00002
        .word        0x45C00002
        .word        0x45D00002
        .word        0x45E00002
        .word        0x45F00002		@ 32 MByte
        .word        0x46000002	
        .word        0x46100002
        .word        0x46200002
        .word        0x46300002
        .word        0x46400002
        .word        0x46500002
        .word        0x46600002
        .word        0x46700002
        .word        0x46800002
        .word        0x46900002
        .word        0x46A00002
        .word        0x46B00002
        .word        0x46C00002
        .word        0x46D00002
        .word        0x46E00002
        .word        0x46F00002
        .word        0x47000002
        .word        0x47100002
        .word        0x47200002
        .word        0x47300002
        .word        0x47400002
        .word        0x47500002
        .word        0x47600002
        .word        0x47700002
        .word        0x47800002
        .word        0x47900002
        .word        0x47A00002
        .word        0x47B00002
        .word        0x47C00002
        .word        0x47D00002
        .word        0x47E00002
        .word        0x47F00002		@ 32 MByte

       
 
        .word        0x48000002		@ Internal Registers (mem ctrl)  (x=0,c=0,b=0 => I/O space)
        .word        0x48100002
        .word        0x48200002
        .word        0x48300002
        .word        0x48400002
        .word        0x48500002
        .word        0x48600002
        .word        0x48700002
        .word        0x48800002
        .word        0x48900002
        .word        0x48A00002
        .word        0x48B00002
        .word        0x48C00002
        .word        0x48D00002
        .word        0x48E00002
        .word        0x48F00002
        .word        0x49000002
        .word        0x49100002
        .word        0x49200002
        .word        0x49300002
        .word        0x49400002
        .word        0x49500002
        .word        0x49600002
        .word        0x49700002
        .word        0x49800002
        .word        0x49900002
        .word        0x49A00002
        .word        0x49B00002
        .word        0x49C00002
        .word        0x49D00002
        .word        0x49E00002
        .word        0x49F00002		@ 32 MByte
        .word        0x4A000002	
        .word        0x4A100002
        .word        0x4A200002
        .word        0x4A300002
        .word        0x4A400002
        .word        0x4A500002
        .word        0x4A600002
        .word        0x4A700002
        .word        0x4A800002
        .word        0x4A900002
        .word        0x4AA00002
        .word        0x4AB00002
        .word        0x4AC00002
        .word        0x4AD00002
        .word        0x4AE00002
        .word        0x4AF00002
        .word        0x4B000002
        .word        0x4B100002
        .word        0x4B200002
        .word        0x4B300002
        .word        0x4B400002
        .word        0x4B500002
        .word        0x4B600002
        .word        0x4B700002
        .word        0x4B800002
        .word        0x4B900002
        .word        0x4BA00002
        .word        0x4BB00002
        .word        0x4BC00002
        .word        0x4BD00002
        .word        0x4BE00002
        .word        0x4BF00002	
       	.word		   0x4C000002			@ 33 MByte

@// end at  ( 0x5300 = 0x4000 + 0x4C0 *4 )

	@.ALIGN		0x200			@// this should get us to 0x5400
	.align	9
	.word        0x50000002			@ cif registers at 0x5000
	@.ALIGN		0x200			@ (0x5600=0x4000+0x580*4)
	.align	9
								@// this should get us to 0x5600

		.word		   0x58000002	@ internal SRAM control registers

	@.ALIGN		0x100			@ (0x5700=0x4000+0x5C0*4)
	.align	8
								@// this should get us to 0x5700
.if SRAM_CACHEABLE
	.word		   0x5C00000E 		@ 256K internal SRAM (x=0, C=1, b=0 => Write-Back)
.else
	.word		   0x5C000002 		@ 256K internal SRAM (x=0, C=1, b=0 => Write-Back)
.endif

	@.ALIGN		0x1000			@// this should get us to 0x6000
	.align	12

	.word 0x0						@insert a word so the next align goes to 0x6800
        
 	@.ALIGN		0x800				@(0x6800=0x4000+0xA00*4)
	.align	11

        .word        0xA000000A		@ SDRAM bank 0  1M Write-Through for LCD Frame Buffer
        .word        0xA010000E		@ SDRAM bank 0  (x=0,c=1,b=0 => Write-Back)
        .word        0xA020000E
        .word        0xA030000E
        .word        0xA040000E
        .word        0xA050000E
        .word        0xA060000E
        .word        0xA070000E
        .word        0xA080000E
        .word        0xA090000E
        .word        0xA0A0000E
        .word        0xA0B0000E
        .word        0xA0C0000E
        .word        0xA0D0000E
        .word        0xA0E0000E
        .word        0xA0F0000E
        .word        0xA100000E
        .word        0xA110000E
        .word        0xA120000E
        .word        0xA130000E
        .word        0xA140000E
        .word        0xA150000E
        .word        0xA160000E
        .word        0xA170000E
        .word        0xA180000E
        .word        0xA190000E
        .word        0xA1A0000E
        .word        0xA1B0000E
        .word        0xA1C0000E
        .word        0xA1D0000E
        .word        0xA1E0000E
        .word        0xA1F0000E		@ 32 MByte
        .word        0xA200000E	
        .word        0xA210000E
        .word        0xA220000E
        .word        0xA230000E
        .word        0xA240000E
        .word        0xA250000E
        .word        0xA260000E
        .word        0xA270000E
        .word        0xA280000E
        .word        0xA290000E
        .word        0xA2A0000E
        .word        0xA2B0000E
        .word        0xA2C0000E
        .word        0xA2D0000E
        .word        0xA2E0000E
        .word        0xA2F0000E
        .word        0xA300000E
        .word        0xA310000E
        .word        0xA320000E
        .word        0xA330000E
        .word        0xA340000E
        .word        0xA350000E
        .word        0xA360000E
        .word        0xA370000E
        .word        0xA380000E
        .word        0xA390000E
        .word        0xA3A0000E
        .word        0xA3B0000E
        .word        0xA3C0000E
        .word        0xA3D0000E
        .word        0xA3E0000E
        .word        0xA3F0000E		@ 32 MByte
MMUTable_end:
	nop
.endif
        .END
