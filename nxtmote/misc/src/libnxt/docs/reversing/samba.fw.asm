
samba.fw:     file format binary

Disassembly of section .data:

00000000 <.data>:
	/*
	 * Interrupt vector
	 */
       0:	ea000013 	b	0x54  /* Reset */
       4:	eafffffe 	b	0x4   /* Illegal instruction */
       8:	ea000054 	b	0x160 /* SWI */
       c:	eafffffe 	b	0xc   /* Prefetch Abort */
      10:	eafffffe 	b	0x10  /* Data Abort */
      14:	eafffffe 	b	0x14  /* (Reserved) */
      18:	eafffffe 	b	0x18  /* IRQ */
      1c:	e599820c 	ldr	r8, [r9, #524] 	/* FIQ */
      20:	e3a0d004 	mov	sp, #4	; 0x4
      24:	e58bd128 	str	sp, [fp, #296]
      28:	e59ad04c 	ldr	sp, [sl, #76]
      2c:	e59cd004 	ldr	sp, [ip, #4]
      30:	e21dd001 	ands	sp, sp, #1	; 0x1
      34:	125ef004 	subnes	pc, lr, #4	; 0x4
      38:	e59ad03c 	ldr	sp, [sl, #60]
      3c:	e21ddf80 	ands	sp, sp, #512	; 0x200
      40:	01cc80b0 	streqh	r8, [ip]
      44:	11cc80b2 	strneh	r8, [ip, #2]
      48:	13a0d001 	movne	sp, #1	; 0x1
      4c:	158cd004 	strne	sp, [ip, #4]
      50:	e25ef004 	subs	pc, lr, #4	; 0x4

	/*
	 * Reset bootstrap
	 */

	/* Switch to FIQ mode and initialize banked registers */
      54:	e10f0000 	mrs	r0, CPSR
      58:	e321f0d1 	msr	CPSR_c, #209	; 0xd1
      5c:	e28f200c 	add	r2, pc, #12	; 0xc
      60:	e8921e00 	ldmia	r2, {r9, sl, fp, ip}
      64:	e3c00040 	bic	r0, r0, #64	; 0x40
      68:	e121f000 	msr	CPSR_c, r0
      6c:	ea000003 	b	0x80
      70:	fffcc000 	swinv	0x00fcc000
      74:	fffff400 	swinv	0x00fff400
      78:	fffff000 	swinv	0x00fff000
      7c:	00200f44 	eoreq	r0, r0, r4, asr #30

	/* Initialize stack */
      80:	e59fd0f4 	ldr	sp, [pc, #244]	; 0x17c

	/* Initialize flash controller */
      84:	e3e010ff 	mvn	r1, #255 /* Memory controller base */
      88:	e59f00f0 	ldr	r0, [pc, #240]	; 0x180
      8c:	e5810060 	str	r0, [r1, #96]

	/* Try to use an external oscillator */
      90:	e59f10ec 	ldr	r1, [pc, #236]	; 0x184
      94:	e3a00002 	mov	r0, #2	; 0x2
      98:	e5810020 	str	r0, [r1, #32] /* Set oscillator bypass */
      9c:	e3a0002d 	mov	r0, #45	; 0x2d
      a0:	e2500001 	subs	r0, r0, #1	; 0x1
      a4:	8afffffd 	bhi	0xa0 /* Wait for input to stabilize */

	/* Test Main Clock Ready */
      a8:	e3a04b40 	mov	r4, #65536	; 0x10000
      ac:	e5913024 	ldr	r3, [r1, #36]
      b0:	e0043003 	and	r3, r4, r3
      b4:	e3530b40 	cmp	r3, #65536	; 0x10000
      b8:	0a000006 	beq	0xd8 /* External oscillator configured */

	/* Start Main Oscillator */
      bc:	e59f00c4 	ldr	r0, [pc, #196]	; 0x188
      c0:	e5810020 	str	r0, [r1, #32]
      c4:	e3a04001 	mov	r4, #1	; 0x1
      c8:	e5913068 	ldr	r3, [r1, #104]
      cc:	e0043003 	and	r3, r4, r3
      d0:	e3530001 	cmp	r3, #1	; 0x1
      d4:	1afffffb 	bne	0xc8 /* Wait for Main Oscillator
						stabilized */

	/* Set Main Clock to use Main Oscillator */
      d8:	e3a00001 	mov	r0, #1	; 0x1
      dc:	e5810030 	str	r0, [r1, #48] /* Main clock, no divisor */
      e0:	e3a04008 	mov	r4, #8	; 0x8
      e4:	e5913068 	ldr	r3, [r1, #104]
      e8:	e0043003 	and	r3, r4, r3
      ec:	e3530008 	cmp	r3, #8	; 0x8
      f0:	1afffffb 	bne	0xe4 /* Wait for Master Clock ready */

	/* Copy OS core to ram */
      f4:	e3a00000 	mov	r0, #0	; 0x0
      f8:	e3a01d50 	mov	r1, #5120	; 0x1400
      fc:	e3a02980 	mov	r2, #2097152	; 0x200000
     100:	e490a004 	ldr	sl, [r0], #4
     104:	e482a004 	str	sl, [r2], #4
     108:	e1500001 	cmp	r0, r1
     10c:	3afffffb 	bcc	0x100

	/* Copy more stuff to RAM */
     110:	e28f202c 	add	r2, pc, #44	; 0x2c
     114:	e892001b 	ldmia	r2, {r0, r1, r3, r4}
     118:	e1500001 	cmp	r0, r1
     11c:	0a000003 	beq	0x130
     120:	e1510003 	cmp	r1, r3
     124:	34902004 	ldrcc	r2, [r0], #4
     128:	34812004 	strcc	r2, [r1], #4
     12c:	3afffffb 	bcc	0x120
     130:	e3a02000 	mov	r2, #0	; 0x0
     134:	e1530004 	cmp	r3, r4
     138:	34832004 	strcc	r2, [r3], #4
     13c:	3afffffc 	bcc	0x134
     140:	ea000003 	b	0x154
     144:	00200f2c 	eoreq	/* */
     148:	00200f2c 	eoreq	/* */
     14c:	00200f3c 	eoreq	/* */
     150:	00200f84 	eoreq	/* */

	/* Call the Boot0 additional bootstrap */
     154:	e59f0030 	ldr	r0, [pc, #48]	; 0x18c
     158:	e1a0e00f 	mov	lr, pc
     15c:	e12fff10 	bx	r0

	/* Call into Main, the OS bootup sequence. */
     160:	e59f0028 	ldr	r0, [pc, #40]	; 0x190
     164:	e1a0e00f 	mov	lr, pc
     168:	e12fff10 	bx	r0

	/* Crash if Main returns. */
     16c:	eafffffe 	b	0x16c

	/* Branch to something else, dunno what yet. */
     170:	e59fe01c 	ldr	lr, [pc, #28]	; 0x194
     174:	e12fff10 	bx	r0
     178:	eafffffe 	b	0x178
     17c:	00202000 	/* Stack pointer address */
     180:	00340100 	/* Initial flash controller mode */
     184:	fffffc00 	/* Power Mgmt Controller base*/
     188:	00004001 	/* Oscillator configuration */
     18c:	0020038d	/* Address of Boot0 */
     190:	00200c9b 	/* Address of Main  */
     194:	00200160 	/* Address of ???   */
     198:	b4104998 	ldrlt	r4, [r0], #-2456
     19c:	60882001 	addvs	r2, r8, r1
     1a0:	22004897 	andcs	r4, r0, #9895936	; 0x970000
     1a4:	20016082 	andcs	r6, r1, r2, lsl #1
     1a8:	42430280 	submi	r0, r3, #8	; 0x8
     1ac:	48956158 	ldmmiia	r5, {r3, r4, r6, r8, sp, lr}
     1b0:	62812104 	addvs	r2, r1, #1	; 0x1
     1b4:	68446804 	stmvsda	r4, {r2, fp, sp, lr}^
     1b8:	009c6302 	addeqs	r6, ip, r2, lsl #6
     1bc:	4a9160a2 	bmi	0xfe45844c
     1c0:	60513240 	subvss	r3, r1, r0, asr #4
     1c4:	4a906241 	bmi	0xfe418ad0
     1c8:	605001c8 	subvss	r0, r0, r8, asr #3
     1cc:	bc106159 	ldflts	f6, [r0], {89}
     1d0:	b4f04770 	ldrltbt	r4, [r0], #1904
     1d4:	6843488d 	stmvsda	r3, {r0, r2, r3, r7, fp, lr}^
     1d8:	2504488b 	strcs	r4, [r4, #-2187]
     1dc:	3c401c04 	mcrrcc	12, 0, r1, r0, cr4
     1e0:	2b002201 	blcs	0x89ec
     1e4:	d11d498a 	tstle	sp, sl, lsl #19
     1e8:	610b424b 	tstvs	fp, fp, asr #4
     1ec:	0c034e84 	stceq	14, cr4, [r3], {132}
     1f0:	4b8260b3 	blmi	0xfe0984c4
     1f4:	1c0b605a 	stcne	0, cr6, [fp], {90}
     1f8:	0253611d 	subeqs	r6, r3, #1073741831	; 0x40000007
     1fc:	60236163 	eorvs	r6, r3, r3, ror #2
     200:	6306424e 	tstvs	r6, #-536870908	; 0xe0000004
     204:	4f836066 	swimi	0x00836066
     208:	60fe1306 	rscvss	r1, lr, r6, lsl #6
     20c:	008f2620 	addeq	r2, pc, r0, lsr #12
     210:	4e7c60be 	mrcmi	0, 3, r6, cr12, cr14, {5}
     214:	60353640 	eorvss	r3, r5, r0, asr #12
     218:	62354e7a 	eorvss	r4, r5, #1952	; 0x7a0
     21c:	600368c6 	andvs	r6, r3, r6, asr #17
     220:	605a4b7a 	subvss	r4, sl, sl, ror fp
     224:	685e4b79 	ldmvsda	lr, {r0, r3, r4, r5, r6, r8, r9, fp, lr}^
     228:	37084f78 	smlsdxcc	r8, r8, pc, r4
     22c:	d1692e01 	cmnle	r9, r1, lsl #28
     230:	1c3c6878 	ldcne	8, cr6, [ip], #-480
     234:	d0642800 	rsble	r2, r4, r0, lsl #16
     238:	1c3d8860 	ldcne	8, cr8, [sp], #-384
     23c:	1b40882d 	blne	0x10222f8
     240:	4d730400 	cfldrdmi	mvd0, [r3]
     244:	27ad0c00 	strcs	r0, [sp, r0, lsl #24]!
     248:	354000ff 	strccb	r0, [r0, #-255]
     24c:	801842b8 	ldrhih	r4, [r8], -r8
     250:	d2464e71 	suble	r4, r6, #1808	; 0x710
     254:	d2012888 	andle	r2, r1, #8912896	; 0x880000
     258:	e0234870 	eor	r4, r3, r0, ror r8
     25c:	3a881c02 	bcc	0xfe20726c
     260:	d2012a48 	andle	r2, r1, #294912	; 0x48000
     264:	e01d486e 	ands	r4, sp, lr, ror #16
     268:	3ad01c02 	bcc	0xff407278
     26c:	d2012ad0 	andle	r2, r1, #851968	; 0xd0000
     270:	e017486c 	ands	r4, r7, ip, ror #16
     274:	3aff1c02 	bcc	0xfffc7284
     278:	2a883aa1 	bcs	0xfe20ed04
     27c:	486ad201 	stmmida	sl!, {r0, r9, ip, lr, pc}^
     280:	2245e010 	subcs	lr, r5, #16	; 0x10
     284:	27ff00d2 	undefined
     288:	1a8237e9 	bne	0xfe08e234
     28c:	d20142ba 	andle	r4, r1, #-1610612725	; 0xa000000b
     290:	e0074866 	and	r4, r7, r6, ror #16
     294:	01122241 	tsteq	r2, r1, asr #4
     298:	22ff1a80 	rsccss	r1, pc, #524288	; 0x80000
     29c:	42903259 	addmis	r3, r0, #-1879048187	; 0x90000005
     2a0:	4863d201 	stmmida	r3!, {r0, r9, ip, lr, pc}^
     2a4:	200062c8 	andcs	r6, r0, r8, asr #5
     2a8:	07526aaa 	ldreqb	r6, [r2, -sl, lsr #21]
     2ac:	1c02d403 	cfstrsne	mvf13, [r2], {3}
     2b0:	42b23001 	adcmis	r3, r2, #1	; 0x1
     2b4:	2009d3f8 	strcsd	sp, [r9], -r8
     2b8:	20006308 	andcs	r6, r0, r8, lsl #6
     2bc:	07126aaa 	ldreq	r6, [r2, -sl, lsr #21]
     2c0:	1c02d403 	cfstrsne	mvf13, [r2], {3}
     2c4:	42b23001 	adcmis	r3, r2, #1	; 0x1
     2c8:	200bd3f8 	strcsd	sp, [fp], -r8
     2cc:	20006308 	andcs	r6, r0, r8, lsl #6
     2d0:	07096aa9 	streq	r6, [r9, -r9, lsr #21]
     2d4:	1c01d403 	cfstrsne	mvf13, [r1], {3}
     2d8:	42b13001 	adcmis	r3, r1, #1	; 0x1
     2dc:	2002d3f8 	strcsd	sp, [r2], -r8
     2e0:	630ae00c 	tstvs	sl, #12	; 0xc
     2e4:	6aaa2000 	bvs	0xfea882ec
     2e8:	d4030712 	strle	r0, [r3], #-1810
     2ec:	30011c02 	andcc	r1, r1, r2, lsl #24
     2f0:	d3f842b2 	mvnles	r4, #536870923	; 0x2000000b
     2f4:	0200203f 	andeq	r2, r0, #63	; 0x3f
     2f8:	200362c8 	andcs	r6, r3, r8, asr #5
     2fc:	20006058 	andcs	r6, r0, r8, asr r0
     300:	e0406060 	sub	r6, r0, r0, rrx
     304:	6859e7ff 	ldmvsda	r9, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, sp, lr, pc}^
     308:	d10a2902 	tstle	sl, r2, lsl #18
     30c:	28006878 	stmcsda	r0, {r3, r4, r5, r6, fp, sp, lr}
     310:	8878d039 	ldmhida	r8!, {r0, r3, r4, r5, ip, lr, pc}^
     314:	1a408839 	bne	0x1022400
     318:	20008018 	andcs	r8, r0, r8, lsl r0
     31c:	20036078 	andcs	r6, r3, r8, ror r0
     320:	6859e02c 	ldmvsda	r9, {r2, r3, r5, sp, lr, pc}^
     324:	d1102903 	tstle	r0, r3, lsl #18
     328:	63010249 	tstvs	r1, #-1879048188	; 0x90000004
     32c:	48396061 	ldmmida	r9!, {r0, r5, r6, sp, lr}
     330:	600121ac 	andvs	r2, r1, ip, lsr #3
     334:	31408819 	cmpcc	r0, r9, lsl r8
     338:	620109c9 	andvs	r0, r1, #3293184	; 0x324000
     33c:	01892123 	orreq	r2, r9, r3, lsr #2
     340:	21506041 	cmpcs	r0, r1, asr #32
     344:	605d6001 	subvss	r6, sp, r1
     348:	6858e01d 	ldmvsda	r8, {r0, r2, r3, r4, sp, lr, pc}^
     34c:	d11a2804 	tstle	sl, r4, lsl #16
     350:	69484930 	stmvsdb	r8, {r4, r5, r8, fp, lr}^
     354:	0f400600 	swieq	0x00400600
     358:	6988d004 	stmvsib	r8, {r2, ip, lr, pc}
     35c:	300120ff 	strccd	r2, [r1], -pc
     360:	e00f6008 	and	r6, pc, r8
     364:	07c06948 	streqb	r6, [r0, r8, asr #18]
     368:	6988d50d 	stmvsib	r8, {r0, r2, r3, r8, sl, ip, lr, pc}
     36c:	d1072823 	tstle	r7, r3, lsr #16
     370:	07806948 	streq	r6, [r0, r8, asr #18]
     374:	203ed5fc 	ldrcssh	sp, [lr], -ip
     378:	200561c8 	andcs	r6, r5, r8, asr #3
     37c:	e0026058 	and	r6, r2, r8, asr r0
     380:	d0002880 	andle	r2, r0, r0, lsl #17
     384:	6858605a 	ldmvsda	r8, {r1, r3, r4, r6, sp, lr}^
     388:	4770bcf0 	undefined
     38c:	4829b510 	stmmida	r9!, {r4, r8, sl, ip, sp, pc}
     390:	2400491f 	strcs	r4, [r0], #-2335
     394:	4a1e62c8 	bmi	0x798ebc
     398:	32404b1f 	subcc	r4, r0, #31744	; 0x7c00
     39c:	07406a90 	undefined
     3a0:	1c20d403 	cfstrsne	mvf13, [r0], #-12
     3a4:	42983401 	addmis	r3, r8, #16777216	; 0x1000000
     3a8:	2001d3f8 	strcsd	sp, [r1], -r8
     3ac:	03c04a22 	biceq	r4, r0, #139264	; 0x22000
     3b0:	4a216050 	bmi	0x8584f8
     3b4:	3a404821 	bcc	0x1012440
     3b8:	48166090 	ldmmida	r6, {r4, r7, sp, lr}
     3bc:	68003040 	stmvsda	r0, {r6, ip, sp}
     3c0:	42904a1f 	addmis	r4, r0, #126976	; 0x1f000
     3c4:	2080d009 	addcs	sp, r0, r9
     3c8:	01006008 	tsteq	r0, r8
     3cc:	490e6108 	stmmidb	lr, {r3, r8, sp, lr}
     3d0:	39400140 	stmccdb	r0, {r6, r8}^
     3d4:	61086008 	tstvs	r8, r8
     3d8:	490c6348 	stmmidb	ip, {r3, r6, r8, r9, sp, lr}
     3dc:	31082000 	tstcc	r8, r0
     3e0:	80488008 	subhi	r8, r8, r8
     3e4:	48176048 	ldmmida	r7, {r3, r6, sp, lr}
     3e8:	f92bf000 	stmnvdb	fp!, {ip, sp, lr, pc}
     3ec:	48174916 	ldmmida	r7, {r1, r2, r4, r8, fp, lr}
     3f0:	fb2bf000 	blx	0xafc3fa
     3f4:	bc08bc10 	stclt	12, cr11, [r8], {16}
     3f8:	00004718 	andeq	r4, r0, r8, lsl r7
     3fc:	fffcc000 	swinv	0x00fcc000
     400:	fffcc200 	swinv	0x00fcc200
     404:	fffff100 	swinv	0x00fff100
     408:	fffff440 	swinv	0x00fff440
     40c:	00200f3c 	eoreq	r0, r0, ip, lsr pc
     410:	fffffc00 	swinv	0x00fffc00
     414:	fffff200 	swinv	0x00fff200
     418:	000f4240 	andeq	r4, pc, r0, asr #4
     41c:	004f3f01 	subeq	r3, pc, r1, lsl #30
     420:	00273f01 	eoreq	r3, r7, r1, lsl #30
     424:	001a3f01 	andeqs	r3, sl, r1, lsl #30
     428:	001abf01 	andeqs	fp, sl, r1, lsl #30
     42c:	00093f01 	andeq	r3, r9, r1, lsl #30
     430:	0009bf01 	andeq	fp, r9, r1, lsl #30
     434:	10483f0e 	subne	r3, r8, lr, lsl #30
     438:	fffffd40 	swinv	0x00fffd40
     43c:	a5000401 	strge	r0, [r0, #-1025]
     440:	27080340 	strcs	r0, [r8, -r0, asr #6]
     444:	00200f64 	eoreq	r0, r0, r4, ror #30
     448:	fffb0000 	swinv	0x00fb0000
     44c:	00200f6c 	eoreq	r0, r0, ip, ror #30
     450:	40480200 	submi	r0, r8, r0, lsl #4
     454:	21004ab3 	strcsh	r4, [r0, -r3]
     458:	d5020403 	strle	r0, [r2, #-1027]
     45c:	40500040 	submis	r0, r0, r0, asr #32
     460:	0040e000 	subeq	lr, r0, r0
     464:	04093101 	streq	r3, [r9], #-257
     468:	0c000400 	cfstrseq	mvf0, [r0], {0}
     46c:	29080c09 	stmcsdb	r8, {r0, r3, sl, fp}
     470:	4770d3f2 	undefined
     474:	694a49ac 	stmvsdb	sl, {r2, r3, r5, r7, r8, fp, lr}^
     478:	d5fc0792 	ldrleb	r0, [ip, #1938]!
     47c:	477061c8 	ldrmib	r6, [r0, -r8, asr #3]!
     480:	49a948aa 	stmmiib	r9!, {r1, r3, r5, r7, fp, lr}
     484:	3801e000 	stmccda	r1, {sp, lr, pc}
     488:	07d2694a 	ldreqb	r6, [r2, sl, asr #18]
     48c:	2800d402 	stmcsda	r0, {r1, sl, ip, lr, pc}
     490:	e005d1f9 	strd	sp, [r5], -r9
     494:	d0032800 	andle	r2, r3, r0, lsl #16
     498:	06006988 	streq	r6, [r0], -r8, lsl #19
     49c:	47700e00 	ldrmib	r0, [r0, -r0, lsl #28]!
     4a0:	200149a3 	andcs	r4, r1, r3, lsr #19
     4a4:	20ff7048 	rsccss	r7, pc, r8, asr #32
     4a8:	b5f34770 	ldrltb	r4, [r3, #1904]!
     4ac:	26001c0f 	strcs	r1, [r0], -pc, lsl #24
     4b0:	e01e2400 	ands	r2, lr, r0, lsl #8
     4b4:	ffe4f7ff 	swinv	0x00e4f7ff
     4b8:	1c054a9d 	stcne	10, cr4, [r5], {157}
     4bc:	28007850 	stmcsda	r0, {r4, r6, fp, ip, sp, lr}
     4c0:	2001d003 	andcs	sp, r1, r3
     4c4:	bc08bcfc 	stclt	12, cr11, [r8], {252}
     4c8:	1c314718 	ldcne	7, cr4, [r1], #-96
     4cc:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
     4d0:	4a97ffbf 	bmi	0xfe6003d4
     4d4:	78111c06 	ldmvcda	r1, {r1, r2, sl, fp, ip}
     4d8:	43086850 	tstmi	r8, #5242880	; 0x500000
     4dc:	9800d008 	stmlsda	r0, {r3, ip, lr, pc}
     4e0:	30017005 	andcc	r7, r1, r5
     4e4:	2f809000 	swics	0x00809000
     4e8:	6850d102 	ldmvsda	r0, {r1, r8, ip, lr, pc}^
     4ec:	60503801 	subvss	r3, r0, r1, lsl #16
     4f0:	42bc3401 	adcmis	r3, ip, #16777216	; 0x1000000
     4f4:	1c30d3de 	ldcne	3, cr13, [r0], #-888
     4f8:	b5f8e7e4 	ldrltb	lr, [r8, #2020]!
     4fc:	20001c06 	andcs	r1, r0, r6, lsl #24
     500:	1c0c4f8b 	stcne	15, cr4, [ip], {139}
     504:	70782900 	rsbvcs	r2, r8, r0, lsl #18
     508:	2101d102 	tstcs	r1, r2, lsl #2
     50c:	e0017039 	and	r7, r1, r9, lsr r0
     510:	7038607c 	eorvcs	r6, r8, ip, ror r0
     514:	d0030661 	andle	r0, r3, r1, ror #12
     518:	31801c21 	orrcc	r1, r0, r1, lsr #24
     51c:	01e409cc 	mvneq	r0, ip, asr #19
     520:	f7ff2500 	ldrnvb	r2, [pc, r0, lsl #10]!
     524:	4f82ffad 	swimi	0x0082ffad
     528:	29007879 	stmcsdb	r0, {r0, r3, r4, r5, r6, fp, ip, sp, lr}
     52c:	2000d00b 	andcs	sp, r0, fp
     530:	f7ff7078 	undefined
     534:	7879ffa5 	ldmvcda	r9!, {r0, r2, r5, r7, r8, r9, sl, fp, ip, sp, lr, pc}^
     538:	d0042900 	andle	r2, r4, r0, lsl #18
     53c:	70782000 	rsbvcs	r2, r8, r0
     540:	bc08bcf8 	stclt	12, cr11, [r8], {248}
     544:	28154718 	ldmcsda	r5, {r3, r4, r8, r9, sl, lr}
     548:	2843d005 	stmcsda	r3, {r0, r2, ip, lr, pc}^
     54c:	2871d003 	ldmcsda	r1!, {r0, r1, ip, lr, pc}^
     550:	2d00d0f6 	stccs	0, cr13, [r0, #-984]
     554:	2700d0e5 	strcs	sp, [r0, -r5, ror #1]
     558:	1c292501 	cfstr32ne	mvfx2, [r9], #-4
     55c:	f0001c30 	andnv	r1, r0, r0, lsr ip
     560:	4973f878 	ldmmidb	r3!, {r3, r4, r5, r6, fp, ip, sp, lr, pc}^
     564:	78490600 	stmvcda	r9, {r9, sl}^
     568:	29000e00 	stmcsdb	r0, {r9, sl, fp}
     56c:	4970d003 	ldmmidb	r0!, {r0, r1, ip, lr, pc}^
     570:	70482000 	subvc	r2, r8, r0
     574:	2804e7e4 	stmcsda	r4, {r2, r5, r6, r7, r8, r9, sl, sp, lr, pc}
     578:	2806d003 	stmcsda	r6, {r0, r1, ip, lr, pc}
     57c:	2815d00b 	ldmcsda	r5, {r0, r1, r3, ip, lr, pc}
     580:	2700d001 	strcs	sp, [r0, -r1]
     584:	2c0043ff 	stccs	3, cr4, [r0], {255}
     588:	2004d10b 	andcs	sp, r4, fp, lsl #2
     58c:	ff72f7ff 	swinv	0x0072f7ff
     590:	ff76f7ff 	swinv	0x0076f7ff
     594:	3501e007 	strcc	lr, [r1, #-7]
     598:	0e2d062d 	cfmadda32eq	mvax1, mvax0, mvfx13, mvfx13
     59c:	36803c80 	strcc	r3, [r0], r0, lsl #25
     5a0:	2f00e7f1 	swics	0x0000e7f1
     5a4:	4962d0d9 	stmmidb	r2!, {r0, r3, r4, r6, r7, ip, lr, pc}^
     5a8:	70082000 	andvc	r2, r8, r0
     5ac:	b5f8e7c8 	ldrltb	lr, [r8, #1992]!
     5b0:	485e1c06 	ldmmida	lr, {r1, r2, sl, fp, ip}^
     5b4:	90004a5e 	andls	r4, r0, lr, asr sl
     5b8:	27642000 	strcsb	r2, [r4, -r0]!
     5bc:	24002501 	strcs	r2, [r0], #-1281
     5c0:	70502900 	subvcs	r2, r0, r0, lsl #18
     5c4:	2001d101 	andcs	sp, r1, r1, lsl #2
     5c8:	4a59e002 	bmi	0x16785d8
     5cc:	60512000 	subvss	r2, r1, r0
     5d0:	20437010 	subcs	r7, r3, r0, lsl r0
     5d4:	ff4ef7ff 	swinv	0x004ef7ff
     5d8:	98004a53 	stmlsda	r0, {r0, r1, r4, r6, r9, fp, lr}
     5dc:	3801e000 	stmccda	r1, {sp, lr, pc}
     5e0:	07c96951 	undefined
     5e4:	2800d402 	stmcsda	r0, {r1, sl, ip, lr, pc}
     5e8:	e001d1f9 	strd	sp, [r1], -r9
     5ec:	d1042800 	tstle	r4, r0, lsl #16
     5f0:	d1ee3f01 	mvnle	r3, r1, lsl #30
     5f4:	bc08bcf8 	stclt	12, cr11, [r8], {248}
     5f8:	4f4d4718 	swimi	0x004d4718
     5fc:	ff40f7ff 	swinv	0x0040f7ff
     600:	29007879 	stmcsdb	r0, {r0, r3, r4, r5, r6, fp, ip, sp, lr}
     604:	2801d112 	stmcsda	r1, {r1, r4, r8, ip, lr, pc}
     608:	2804d009 	stmcsda	r4, {r0, r3, ip, lr, pc}
     60c:	2006d104 	andcs	sp, r6, r4, lsl #2
     610:	ff30f7ff 	swinv	0x0030f7ff
     614:	d0f12c00 	rscles	r2, r1, r0, lsl #24
     618:	70382000 	eorvcs	r2, r8, r0
     61c:	1c29e7ea 	stcne	7, cr14, [r9], #-936
     620:	f0001c30 	andnv	r1, r0, r0, lsr ip
     624:	7879f848 	ldmvcda	r9!, {r3, r6, fp, ip, sp, lr, pc}^
     628:	d0022900 	andle	r2, r2, r0, lsl #18
     62c:	70782000 	rsbvcs	r2, r8, r0
     630:	2800e7e0 	stmcsda	r0, {r5, r6, r7, r8, r9, sl, sp, lr, pc}
     634:	3501d1f0 	strcc	sp, [r1, #-496]
     638:	0e2d062d 	cfmadda32eq	mvax1, mvax0, mvfx13, mvfx13
     63c:	34803680 	strcc	r3, [r0], #1664
     640:	493ce7dc 	ldmmidb	ip!, {r2, r3, r4, r6, r7, r8, r9, sl, sp, lr, pc}
     644:	60014a3a 	andvs	r4, r1, sl, lsr sl
     648:	6041493b 	subvs	r4, r1, fp, lsr r9
     64c:	70512100 	subvcs	r2, r1, r0, lsl #2
     650:	b5f04770 	ldrltb	r4, [r0, #1904]!
     654:	1c0c1c07 	stcne	12, cr1, [ip], {7}
     658:	20012600 	andcs	r2, r1, r0, lsl #12
     65c:	ff0af7ff 	swinv	0x000af7ff
     660:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
     664:	43e0ff07 	mvnmi	pc, #28	; 0x1c
     668:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
     66c:	ff02f7ff 	swinv	0x0002f7ff
     670:	492f2500 	stmmidb	pc!, {r8, sl, sp}
     674:	6848780a 	stmvsda	r8, {r1, r3, fp, ip, sp, lr}^
     678:	d0044302 	andle	r4, r4, r2, lsl #6
     67c:	3701783c 	smladxcc	r1, ip, r8, r7
     680:	60483801 	subvs	r3, r8, r1, lsl #16
     684:	2400e000 	strcs	lr, [r0]
     688:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
     68c:	1c31fef3 	ldcne	14, cr15, [r1], #-972
     690:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
     694:	1c06fedd 	stcne	14, cr15, [r6], {221}
     698:	2d803501 	cfstr32cs	mvfx3, [r0, #4]
     69c:	0a30dbe9 	beq	0xc37648
     6a0:	fee8f7ff 	mcr2	7, 7, pc, cr8, cr15, {7}
     6a4:	0e000630 	cfmadd32eq	mvax1, mvfx0, mvfx0, mvfx0
     6a8:	fee4f7ff 	mcr2	7, 7, pc, cr4, cr15, {7}
     6ac:	fee8f7ff 	mcr2	7, 7, pc, cr8, cr15, {7}
     6b0:	bc08bcf0 	stclt	12, cr11, [r8], {240}
     6b4:	b5f84718 	ldrltb	r4, [r8, #1816]!
     6b8:	1c0c1c05 	stcne	12, cr1, [ip], {5}
     6bc:	46682102 	strmibt	r2, [r8], -r2, lsl #2
     6c0:	fef3f7ff 	mrc2	7, 7, pc, cr3, cr15, {7}
     6c4:	1c282180 	stfnes	f2, [r8], #-512
     6c8:	feeff7ff 	mcr2	7, 7, pc, cr15, cr15, {7}
     6cc:	1c064918 	stcne	9, cr4, [r6], {24}
     6d0:	25007848 	strcs	r7, [r0, #-2120]
     6d4:	280043ed 	stmcsda	r0, {r0, r2, r3, r5, r6, r7, r8, r9, lr}
     6d8:	f7ffd10b 	ldrnvb	sp, [pc, fp, lsl #2]!
     6dc:	0207fed1 	andeq	pc, r7, #3344	; 0xd10
     6e0:	fecef7ff 	mcr2	7, 6, pc, cr14, cr15, {7}
     6e4:	19c04912 	stmneib	r0, {r1, r4, r8, fp, lr}^
     6e8:	04007849 	streq	r7, [r0], #-2121
     6ec:	29010c00 	stmcsdb	r1, {sl, fp}
     6f0:	1c28d103 	stfned	f5, [r8], #-12
     6f4:	bc08bcf8 	stclt	12, cr11, [r8], {248}
     6f8:	42b04718 	adcmis	r4, r0, #6291456	; 0x600000
     6fc:	ab00d109 	blge	0x34b28
     700:	42a07818 	adcmi	r7, r0, #1572864	; 0x180000
     704:	7858d105 	ldmvcda	r8, {r0, r2, r8, ip, lr, pc}^
     708:	060943e1 	streq	r4, [r9], -r1, ror #7
     70c:	42880e09 	addmi	r0, r8, #144	; 0x90
     710:	2018d003 	andcss	sp, r8, r3
     714:	feaef7ff 	mcr2	7, 5, pc, cr14, cr15, {7}
     718:	2006e7eb 	andcs	lr, r6, fp, ror #15
     71c:	feaaf7ff 	mcr2	7, 5, pc, cr10, cr15, {7}
     720:	e7e72000 	strb	r2, [r7, r0]!
     724:	00001021 	andeq	r1, r0, r1, lsr #32
     728:	fffff200 	swinv	0x00fff200
     72c:	00186a00 	andeqs	r6, r8, r0, lsl #20
     730:	00200f4c 	eoreq	r0, r0, ip, asr #30
     734:	002004fb 	streqd	r0, [r0], -fp
     738:	002005af 	eoreq	r0, r0, pc, lsr #11
     73c:	22206b01 	eorcs	r6, r0, #1024	; 0x400
     740:	63014311 	tstvs	r1, #1140850688	; 0x44000000
     744:	07096b01 	streq	r6, [r9, -r1, lsl #22]
     748:	6b01d5fc 	blvs	0x75f40
     74c:	43912228 	orrmis	r2, r1, #-2147483646	; 0x80000002
     750:	6b016301 	blvs	0x5935c
     754:	d1fc4011 	mvnles	r4, r1, lsl r0
     758:	6b014770 	blvs	0x52520
     75c:	43112210 	tstmi	r1, #1	; 0x1
     760:	6b016301 	blvs	0x5936c
     764:	d5fc07c9 	ldrleb	r0, [ip, #1993]!
     768:	08496b01 	stmeqda	r9, {r0, r8, r9, fp, sp, lr}^
     76c:	63010049 	tstvs	r1, #73	; 0x49
     770:	07c96b01 	streqb	r6, [r9, r1, lsl #22]
     774:	4770d4fc 	undefined
     778:	2508b470 	strcs	fp, [r8, #-1136]
     77c:	1c2c2610 	stcne	6, cr2, [ip], #-64
     780:	d2002a08 	andle	r2, r0, #32768	; 0x8000
     784:	1b121c14 	blne	0x4877dc
     788:	780be002 	stmvcda	fp, {r1, sp, lr, pc}
     78c:	65033101 	strvs	r3, [r3, #-257]
     790:	d2fa3c01 	rscles	r3, sl, #256	; 0x100
     794:	07db6b03 	ldreqb	r6, [fp, r3, lsl #22]
     798:	6b03d506 	blvs	0xf5bb8
     79c:	005b085b 	subeqs	r0, fp, fp, asr r8
     7a0:	6b036303 	blvs	0xd93b4
     7a4:	d4fc07db 	ldrlebt	r0, [ip], #2011
     7a8:	43336b03 	teqmi	r3, #3072	; 0xc00
     7ac:	6b036303 	blvs	0xd93c0
     7b0:	d505079c 	strle	r0, [r5, #-1948]
     7b4:	22026b01 	andcs	r6, r2, #1024	; 0x400
     7b8:	63014391 	tstvs	r1, #1140850690	; 0x44000002
     7bc:	4770bc70 	undefined
     7c0:	d5f407db 	ldrleb	r0, [r4, #2011]!
     7c4:	d1da2a00 	bicles	r2, sl, r0, lsl #20
     7c8:	07c96b01 	streqb	r6, [r9, r1, lsl #22]
     7cc:	6b01d5f6 	blvs	0x75fac
     7d0:	00490849 	subeq	r0, r9, r9, asr #16
     7d4:	6b016301 	blvs	0x593e0
     7d8:	d4fc07c9 	ldrlebt	r0, [ip], #1993
     7dc:	b5f8e7ee 	ldrltb	lr, [r8, #2030]!
     7e0:	6b216804 	blvs	0x85a7f8
     7e4:	d56f0749 	strleb	r0, [pc, #-1865]!	; 0xa3
     7e8:	060a6d21 	streq	r6, [sl], -r1, lsr #26
     7ec:	0e126d21 	cdpeq	13, 1, cr6, cr2, cr1, {1}
     7f0:	0e1b060b 	cfmsub32eq	mvax0, mvfx0, mvfx11, mvfx11
     7f4:	469c6d21 	ldrmi	r6, [ip], r1, lsr #26
     7f8:	6d230609 	stcvs	6, cr0, [r3, #-36]!
     7fc:	021b0e09 	andeqs	r0, fp, #144	; 0x90
     800:	040d4319 	streq	r4, [sp], #-793
     804:	0c2d6d21 	stceq	13, cr6, [sp], #-132
     808:	6d230609 	stcvs	6, cr0, [r3, #-36]!
     80c:	021b0e09 	andeqs	r0, fp, #144	; 0x90
     810:	040e4319 	streq	r4, [lr], #-793
     814:	0c366d21 	ldceq	13, cr6, [r6], #-132
     818:	6d230609 	stcvs	6, cr0, [r3, #-36]!
     81c:	021b0e09 	andeqs	r0, fp, #144	; 0x90
     820:	04094319 	streq	r4, [r9], #-793
     824:	06130c09 	ldreq	r0, [r3], -r9, lsl #24
     828:	6b23d506 	blvs	0x8f5c48
     82c:	433b2780 	teqmi	fp, #33554432	; 0x2000000
     830:	6b236323 	blvs	0x8d94c4
     834:	d5fc061b 	ldrleb	r0, [ip, #1563]!
     838:	27046b23 	strcs	r6, [r4, -r3, lsr #22]
     83c:	632343bb 	teqvs	r3, #-335544318	; 0xec000002
     840:	075b6b23 	ldreqb	r6, [fp, -r3, lsr #22]
     844:	4663d4fc 	undefined
     848:	431a021b 	tstmi	sl, #-1342177279	; 0xb0000001
     84c:	27004bc1 	strcs	r4, [r0, -r1, asr #23]
     850:	d06a429a 	strleb	r4, [sl], #-42
     854:	23ffdc23 	mvncss	sp, #8960	; 0x2300
     858:	429a3302 	addmis	r3, sl, #134217728	; 0x8000000
     85c:	dc12d040 	ldcle	0, cr13, [r2], {64}
     860:	d0632a80 	rsble	r2, r3, r0, lsl #21
     864:	d0612a81 	rsble	r2, r1, r1, lsl #21
     868:	d1712a82 	cmnle	r1, r2, lsl #21
     86c:	801fab00 	andhis	sl, pc, r0, lsl #22
     870:	07306861 	ldreq	r6, [r0, -r1, ror #16]!
     874:	07890f00 	streq	r0, [r9, r0, lsl #30]
     878:	2803d56b 	stmcsda	r3, {r0, r1, r3, r5, r6, r8, sl, ip, lr, pc}
     87c:	0080d869 	addeq	sp, r0, r9, ror #16
     880:	6b001900 	blvs	0x6c88
     884:	23ffe07b 	mvncss	lr, #123	; 0x7b
     888:	429a3303 	addmis	r3, sl, #201326592	; 0xc000000
     88c:	2303d06d 	tstcs	r3, #109	; 0x6d
     890:	429a021b 	addmis	r0, sl, #-1342177279	; 0xb0000001
     894:	3301d05c 	tstcc	r1, #92	; 0x5c
     898:	d021429a 	mlale	r1, sl, r2, r4
     89c:	2309e058 	tstcs	r9, #88	; 0x58
     8a0:	2602021b 	undefined
     8a4:	d042429a 	umaalle	r4, r2, sl, r2
     8a8:	2305dc0f 	tstcs	r5, #3840	; 0xf00
     8ac:	429a021b 	addmis	r0, sl, #-1342177279	; 0xb0000001
     8b0:	230dd02c 	tstcs	sp, #44	; 0x2c
     8b4:	429a01db 	addmis	r0, sl, #-1073741770	; 0xc0000036
     8b8:	2311d013 	tstcs	r1, #19	; 0x13
     8bc:	429a01db 	addmis	r0, sl, #-1073741770	; 0xc0000036
     8c0:	2201d146 	andcs	sp, r1, #-2147483631	; 0x80000011
     8c4:	e0991d01 	adds	r1, r9, r1, lsl #26
     8c8:	4ba3e02c 	blmi	0xfe8f8980
     8cc:	d06a429a 	strleb	r4, [sl], #-42
     8d0:	429a4ba2 	addmis	r4, sl, #165888	; 0x28800
     8d4:	4ba1d068 	blmi	0xfe874a7c
     8d8:	429a3380 	addmis	r3, sl, #2	; 0x2
     8dc:	7145d138 	cmpvc	r5, r8, lsr r1
     8e0:	1c28e083 	stcne	0, cr14, [r8], #-524
     8e4:	380138ff 	stmccda	r1, {r0, r1, r2, r3, r4, r5, r6, r7, fp, ip, sp}
     8e8:	2212d105 	andcss	sp, r2, #1073741825	; 0x40000001
     8ec:	d8002912 	stmleda	r0, {r1, r4, r8, fp, sp}
     8f0:	499b1c0a 	ldmmiib	fp, {r1, r3, sl, fp, ip}
     8f4:	2001e082 	andcs	lr, r1, r2, lsl #1
     8f8:	42850240 	addmi	r0, r5, #4	; 0x4
     8fc:	2243d128 	subcs	sp, r3, #10	; 0xa
     900:	d8002943 	stmleda	r0, {r0, r1, r6, r8, fp, sp}
     904:	49961c0a 	ldmmiib	r6, {r1, r3, sl, fp, ip}
     908:	e0773112 	rsbs	r3, r7, r2, lsl r1
     90c:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
     910:	20ffff24 	rsccss	pc, pc, r4, lsr #30
     914:	43283001 	teqmi	r8, #1	; 0x1
     918:	200160a0 	andcs	r6, r1, r0, lsr #1
     91c:	d1002d00 	tstle	r0, r0, lsl #26
     920:	60602000 	rsbvs	r2, r0, r0
     924:	bc08bcf8 	stclt	12, cr11, [r8], {248}
     928:	e0304718 	eors	r4, r0, r8, lsl r7
     92c:	7105e01e 	tstvc	r5, lr, lsl r0
     930:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
     934:	2d00ff12 	stccs	15, cr15, [r0, #-72]
     938:	2601d100 	strcs	sp, [r1], -r0, lsl #2
     93c:	20416066 	subcs	r6, r1, r6, rrx
     940:	2d000240 	sfmcs	f0, 4, [r0, #-256]
     944:	2000d100 	andcs	sp, r0, r0, lsl #2
     948:	20436360 	subcs	r6, r3, r0, ror #6
     94c:	e0010240 	and	r0, r1, r0, asr #4
     950:	e00ee058 	and	lr, lr, r8, asr r0
     954:	d1002d00 	tstle	r0, r0, lsl #26
     958:	63a02000 	movvs	r2, #0	; 0x0
     95c:	02002085 	andeq	r2, r0, #133	; 0x85
     960:	d1002d00 	tstle	r0, r0, lsl #26
     964:	63e02000 	mvnvs	r2, #0	; 0x0
     968:	e01ee7dc 	ldrsb	lr, [lr], -ip
     96c:	801fab00 	andhis	sl, pc, r0, lsl #22
     970:	6861e00a 	stmvsda	r1!, {r1, r3, sp, lr, pc}^
     974:	d54507c9 	strleb	r0, [r5, #-1993]
     978:	d1432800 	cmple	r3, r0, lsl #16
     97c:	04006b20 	streq	r6, [r0], #-2848
     980:	300117c0 	andcc	r1, r1, r0, asr #15
     984:	8018ab00 	andhis	sl, r8, r0, lsl #22
     988:	46692202 	strmibt	r2, [r9], -r2, lsl #4
     98c:	0730e036 	undefined
     990:	2d000f00 	stccs	15, cr0, [r0]
     994:	2800d136 	stmcsda	r0, {r1, r2, r4, r5, r8, ip, lr, pc}
     998:	2803d034 	stmcsda	r3, {r2, r4, r5, ip, lr, pc}
     99c:	0080d832 	addeq	sp, r0, r2, lsr r8
     9a0:	63071900 	tstvs	r7, #0	; 0x0
     9a4:	e01ae021 	ands	lr, sl, r1, lsr #32
     9a8:	0730e023 	ldreq	lr, [r0, -r3, lsr #32]!
     9ac:	2d000f00 	stccs	15, cr0, [r0]
     9b0:	2800d128 	stmcsda	r0, {r3, r5, r8, ip, lr, pc}
     9b4:	2803d026 	stmcsda	r3, {r1, r2, r5, ip, lr, pc}
     9b8:	2801d824 	stmcsda	r1, {r2, r5, fp, ip, lr, pc}
     9bc:	2041d103 	subcs	sp, r1, r3, lsl #2
     9c0:	63600240 	cmnvs	r0, #4	; 0x4
     9c4:	2802e011 	stmcsda	r2, {r0, r4, sp, lr, pc}
     9c8:	2043d103 	subcs	sp, r3, r3, lsl #2
     9cc:	63a00240 	movvs	r0, #4	; 0x4
     9d0:	2803e00b 	stmcsda	r3, {r0, r1, r3, sp, lr, pc}
     9d4:	2085d109 	addcs	sp, r5, r9, lsl #2
     9d8:	63e00200 	mvnvs	r0, #0	; 0x0
     9dc:	6b20e005 	blvs	0x8389f8
     9e0:	d5fc0780 	ldrleb	r0, [ip, #1920]!
     9e4:	43b06b20 	movmis	r6, #32768	; 0x8000
     9e8:	1c206320 	stcne	3, cr6, [r0], #-128
     9ec:	feb5f7ff 	mrc2	7, 5, pc, cr5, cr15, {7}
     9f0:	2208e798 	andcs	lr, r8, #39845888	; 0x2600000
     9f4:	d8002908 	stmleda	r0, {r3, r8, fp, sp}
     9f8:	495a1c0a 	ldmmidb	sl, {r1, r3, sl, fp, ip}^
     9fc:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
     a00:	e78ffebb 	undefined
     a04:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
     a08:	e78bfe99 	undefined
     a0c:	1c04b510 	cfstr32ne	mvfx11, [r4], {16}
     a10:	69c16800 	stmvsib	r1, {fp, sp, lr}^
     a14:	d50d04ca 	strle	r0, [sp, #-1226]
     a18:	03092101 	tsteq	r9, #1073741824	; 0x40000000
     a1c:	21006201 	tstcs	r0, r1, lsl #4
     a20:	628143c9 	addvs	r4, r1, #603979779	; 0x24000003
     a24:	62812100 	addvs	r2, r1, #0	; 0x0
     a28:	310121ff 	strccd	r2, [r1, -pc]
     a2c:	01c96081 	biceq	r6, r9, r1, lsl #1
     a30:	e0066301 	and	r6, r6, r1, lsl #6
     a34:	d50407c9 	strle	r0, [r4, #-1993]
     a38:	62012101 	andvs	r2, r1, #1073741824	; 0x40000000
     a3c:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
     a40:	7920fece 	stmvcdb	r0!, {r1, r2, r3, r6, r7, r9, sl, fp, ip, sp, lr, pc}
     a44:	bc08bc10 	stclt	12, cr11, [r8], {16}
     a48:	60014718 	andvs	r4, r1, r8, lsl r7
     a4c:	71012100 	tstvc	r1, r0, lsl #2
     a50:	21027141 	tstcs	r2, r1, asr #2
     a54:	49446081 	stmmidb	r4, {r0, r7, sp, lr}^
     a58:	494460c1 	stmmidb	r4, {r0, r6, r7, sp, lr}^
     a5c:	49446101 	stmmidb	r4, {r0, r8, sp, lr}^
     a60:	47706141 	ldrmib	r6, [r0, -r1, asr #2]!
     a64:	6804b5f7 	stmvsda	r4, {r0, r1, r2, r4, r5, r6, r7, r8, sl, ip, sp, pc}
     a68:	1c076885 	stcne	8, cr6, [r7], {133}
     a6c:	1c382600 	ldcne	6, cr2, [r8]
     a70:	ffccf7ff 	swinv	0x00ccf7ff
     a74:	d01d2800 	andles	r2, sp, r0, lsl #16
     a78:	40286b60 	eormi	r6, r8, r0, ror #22
     a7c:	6b60d018 	blvs	0x1834ae4
     a80:	0c009902 	stceq	9, cr9, [r0], {2}
     a84:	d2024288 	andle	r4, r2, #-2147483640	; 0x80000008
     a88:	0c006b60 	stceq	11, cr6, [r0], {96}
     a8c:	9802e006 	stmlsda	r2, {r1, r2, sp, lr, pc}
     a90:	6d62e004 	stcvsl	0, cr14, [r2, #-16]!
     a94:	9b011c31 	blls	0x47b60
     a98:	545a3601 	ldrplb	r3, [sl], #-1537
     a9c:	d2f83801 	rscles	r3, r8, #65536	; 0x10000
     aa0:	43a86b60 	movmi	r6, #98304	; 0x18000
     aa4:	2d026360 	stccs	3, cr6, [r2, #-384]
     aa8:	2540d101 	strcsb	sp, [r0, #-257]
     aac:	2502e000 	strcs	lr, [r2]
     ab0:	d0dc2e00 	sbcles	r2, ip, r0, lsl #28
     ab4:	60bd1c30 	adcvss	r1, sp, r0, lsr ip
     ab8:	bc08bcfe 	stclt	12, cr11, [r8], {254}
     abc:	b5f04718 	ldrltb	r4, [r0, #1816]!
     ac0:	21401c0e 	cmpcs	r0, lr, lsl #24
     ac4:	1c076804 	stcne	8, cr6, [r7], {4}
     ac8:	2a401c08 	bcs	0x1007af0
     acc:	1c10d200 	lfmne	f5, 1, [r0], {0}
     ad0:	e0021a15 	and	r1, r2, r5, lsl sl
     ad4:	36017832 	undefined
     ad8:	380165a2 	stmccda	r1, {r1, r5, r7, r8, sl, sp, lr}
     adc:	6ba2d2fa 	blvs	0xfe8b56cc
     ae0:	43022010 	tstmi	r2, #16	; 0x10
     ae4:	e01e63a2 	ands	r6, lr, r2, lsr #7
     ae8:	2d402040 	stccsl	0, cr2, [r0, #-256]
     aec:	1c28d200 	sfmne	f5, 1, [r8]
     af0:	e0021a2d 	and	r1, r2, sp, lsr #20
     af4:	36017831 	undefined
     af8:	380165a1 	stmccda	r1, {r0, r5, r7, r8, sl, sp, lr}
     afc:	e004d2fa 	strd	sp, [r4], -sl
     b00:	f7ff1c38 	undefined
     b04:	2800ff83 	stmcsda	r0, {r0, r1, r7, r8, r9, sl, fp, ip, sp, lr, pc}
     b08:	6ba0d01f 	blvs	0xfe834b8c
     b0c:	d5f707c0 	ldrleb	r0, [r7, #1984]!
     b10:	08406ba0 	stmeqda	r0, {r5, r7, r8, r9, fp, sp, lr}^
     b14:	63a00040 	movvs	r0, #64	; 0x40
     b18:	07c06ba0 	streqb	r6, [r0, r0, lsr #23]
     b1c:	6ba0d4fc 	blvs	0xfe835f14
     b20:	43082110 	tstmi	r8, #4	; 0x4
     b24:	2d0063a0 	stccs	3, cr6, [r0, #-640]
     b28:	e004d1de 	ldrd	sp, [r4], -lr
     b2c:	f7ff1c38 	undefined
     b30:	2800ff6d 	stmcsda	r0, {r0, r2, r3, r5, r6, r8, r9, sl, fp, ip, sp, lr, pc}
     b34:	6ba0d009 	blvs	0xfe834b60
     b38:	d5f707c0 	ldrleb	r0, [r7, #1984]!
     b3c:	08406ba0 	stmeqda	r0, {r5, r7, r8, r9, fp, sp, lr}^
     b40:	63a00040 	movvs	r0, #64	; 0x40
     b44:	07c06ba0 	streqb	r6, [r0, r0, lsr #23]
     b48:	1c28d4fc 	cfstrsne	mvf13, [r8], #-1008
     b4c:	bc08bcf0 	stclt	12, cr11, [r8], {240}
     b50:	00004718 	andeq	r4, r0, r8, lsl r7
     b54:	00000302 	andeq	r0, r0, r2, lsl #6
     b58:	00002021 	andeq	r2, r0, r1, lsr #32
     b5c:	000021a1 	andeq	r2, r0, r1, lsr #3
     b60:	00200ed0 	ldreqd	r0, [r0], -r0
     b64:	00200f2c 	eoreq	r0, r0, ip, lsr #30
     b68:	00200a0d 	eoreq	r0, r0, sp, lsl #20
     b6c:	00200abf 	streqh	r0, [r0], -pc
     b70:	00200a65 	eoreq	r0, r0, r5, ror #20
     b74:	4abfb5fe 	bmi	0xfefee374
     b78:	4abf7813 	bmi	0xfefdebcc
     b7c:	d0312b00 	eorles	r2, r1, r0, lsl #22
     b80:	d1012904 	tstle	r1, r4, lsl #18
     b84:	e0066803 	and	r6, r6, r3, lsl #16
     b88:	d1032902 	tstle	r3, r2, lsl #18
     b8c:	5ec02300 	cdppl	3, 12, cr2, cr0, cr0, {0}
     b90:	e0001c03 	and	r1, r0, r3, lsl #24
     b94:	ac007803 	stcge	8, cr7, [r0], {3}
     b98:	00483402 	subeq	r3, r8, r2, lsl #8
     b9c:	39011901 	stmccdb	r1, {r0, r8, fp, ip}
     ba0:	26302500 	ldrcst	r2, [r0], -r0, lsl #10
     ba4:	071ce00a 	ldreq	lr, [ip, -sl]
     ba8:	2c090f24 	stccs	15, cr0, [r9], {36}
     bac:	4334d801 	teqmi	r4, #65536	; 0x10000
     bb0:	3437e000 	ldrcct	lr, [r7]
     bb4:	3901700c 	stmccdb	r1, {r2, r3, ip, sp, lr}
     bb8:	3501111b 	strcc	r1, [r1, #-283]
     bbc:	d8f242a8 	ldmleia	r2!, {r3, r5, r7, r9, lr}^
     bc0:	701eab00 	andvcs	sl, lr, r0, lsl #22
     bc4:	70592178 	subvcs	r2, r9, r8, ror r1
     bc8:	44691c01 	strmibt	r1, [r9], #-3073
     bcc:	708b230a 	addvc	r2, fp, sl, lsl #6
     bd0:	70cb230d 	sbcvc	r2, fp, sp, lsl #6
     bd4:	46681d01 	strmibt	r1, [r8], -r1, lsl #26
     bd8:	f0006892 	mulnv	r0, r2, r8
     bdc:	bcfef96f 	ldcltl	9, cr15, [lr], #444
     be0:	4718bc08 	ldrmi	fp, [r8, -r8, lsl #24]
     be4:	f0006892 	mulnv	r0, r2, r8
     be8:	e7f8f969 	ldrb	pc, [r8, r9, ror #18]!
     bec:	1c04b510 	cfstr32ne	mvfx11, [r4], {16}
     bf0:	fc46f7ff 	mcrr2	7, 15, pc, r6, cr15
     bf4:	bc107020 	ldclt	0, cr7, [r0], {32}
     bf8:	2001bc08 	andcs	fp, r1, r8, lsl #24
     bfc:	b5704718 	ldrltb	r4, [r0, #-1816]!
     c00:	1c0e1c05 	stcne	12, cr1, [lr], {5}
     c04:	e0042400 	and	r2, r4, r0, lsl #8
     c08:	35017828 	strcc	r7, [r1, #-2088]
     c0c:	fc32f7ff 	ldc2	7, cr15, [r2], #-1020
     c10:	42b43401 	adcmis	r3, r4, #16777216	; 0x1000000
     c14:	bc70d3f8 	ldcltl	3, cr13, [r0], #-992
     c18:	4718bc08 	ldrmi	fp, [r8, -r8, lsl #24]
     c1c:	4c96b510 	cfldr32mi	mvfx11, [r6], {16}
     c20:	34181c0a 	ldrcc	r1, [r8], #-3082
     c24:	1c201c01 	stcne	12, cr1, [r0], #-4
     c28:	f0006923 	andnv	r6, r0, r3, lsr #18
     c2c:	bc10f948 	ldclt	9, cr15, [r0], {72}
     c30:	4718bc08 	ldrmi	fp, [r8, -r8, lsl #24]
     c34:	4c90b510 	cfldr32mi	mvfx11, [r0], {16}
     c38:	34181c0a 	ldrcc	r1, [r8], #-3082
     c3c:	1c201c01 	stcne	12, cr1, [r0], #-4
     c40:	f0006963 	andnv	r6, r0, r3, ror #18
     c44:	bc10f93c 	ldclt	9, cr15, [r0], {60}
     c48:	4718bc08 	ldrmi	fp, [r8, -r8, lsl #24]
     c4c:	1c06b5f8 	cfstr32ne	mvfx11, [r6], {248}
     c50:	27401c0c 	strcsb	r1, [r0, -ip, lsl #24]
     c54:	1c3de009 	ldcne	0, cr14, [sp], #-36
     c58:	d2002c40 	andle	r2, r0, #16384	; 0x4000
     c5c:	1c291c25 	stcne	12, cr1, [r9], #-148
     c60:	f7ff1c30 	undefined
     c64:	1b64ffdb 	blne	0x1940bd8
     c68:	2c001976 	stccs	9, cr1, [r0], {118}
     c6c:	bcf8d1f3 	ldfltp	f5, [r8], #972
     c70:	4718bc08 	ldrmi	fp, [r8, -r8, lsl #24]
     c74:	1c05b570 	cfstr32ne	mvfx11, [r5], {112}
     c78:	26401c0c 	strcsb	r1, [r0], -ip, lsl #24
     c7c:	1c31e008 	ldcne	0, cr14, [r1], #-32
     c80:	d2002c40 	andle	r2, r0, #16384	; 0x4000
     c84:	1c281c21 	stcne	12, cr1, [r8], #-132
     c88:	ffd4f7ff 	swinv	0x00d4f7ff
     c8c:	182d1a24 	stmneda	sp!, {r2, r5, r9, fp, ip}
     c90:	d1f42c00 	mvnles	r2, r0, lsl #24
     c94:	bc08bc70 	stclt	12, cr11, [r8], {112}
     c98:	b5f04718 	ldrltb	r4, [r0, #1816]!
     c9c:	4d764f76 	ldcmil	15, cr4, [r6, #-472]!
     ca0:	3718b093 	undefined
     ca4:	68f91c38 	ldmvsia	r9!, {r3, r4, r5, sl, fp, ip}^
     ca8:	f907f000 	stmnvdb	r7, {ip, sp, lr, pc}
     cac:	d0072800 	andle	r2, r7, r0, lsl #16
     cb0:	60284872 	eorvs	r4, r8, r2, ror r8
     cb4:	60684872 	rsbvs	r4, r8, r2, ror r8
     cb8:	60a84872 	adcvs	r4, r8, r2, ror r8
     cbc:	e00c4872 	and	r4, ip, r2, ror r8
     cc0:	fa87f7ff 	blx	0xfe1fecc4
     cc4:	d1ed2805 	mvnle	r2, r5, lsl #16
     cc8:	3110496b 	tstcc	r0, fp, ror #18
     ccc:	60286808 	eorvs	r6, r8, r8, lsl #16
     cd0:	60686848 	rsbvs	r6, r8, r8, asr #16
     cd4:	60a8486d 	adcvs	r4, r8, sp, ror #16
     cd8:	60e8486d 	rscvs	r4, r8, sp, ror #16
     cdc:	fa5cf7ff 	blx	0x173ece0
     ce0:	21404a65 	cmpcs	r0, r5, ror #20
     ce4:	68d2a801 	ldmvsia	r2, {r0, fp, sp, pc}^
     ce8:	f8e8f000 	stmnvia	r8!, {ip, sp, lr, pc}^
     cec:	af019011 	swige	0x00019011
     cf0:	e0ba2500 	adcs	r2, sl, r0, lsl #10
     cf4:	28ff7838 	ldmcsia	pc!, {r3, r4, r5, fp, ip, sp, lr}^
     cf8:	2823d066 	stmcsda	r3!, {r1, r2, r5, r6, ip, lr, pc}
     cfc:	485dd165 	ldmmida	sp, {r0, r2, r5, r6, r8, ip, lr, pc}^
     d00:	28007800 	stmcsda	r0, {fp, ip, sp, lr}
     d04:	4a5cd005 	bmi	0x1734d20
     d08:	a0622102 	rsbge	r2, r2, r2, lsl #2
     d0c:	f0006892 	mulnv	r0, r2, r8
     d10:	2c53f8d5 	mrrccs	8, 13, pc, r3, cr5
     d14:	4a58d106 	bmi	0x1635134
     d18:	68529912 	ldmvsda	r2, {r1, r4, r8, fp, ip, pc}^
     d1c:	f0001c30 	andnv	r1, r0, r0, lsr ip
     d20:	e072f8cd 	rsbs	pc, r2, sp, asr #17
     d24:	d1062c52 	tstle	r6, r2, asr ip
     d28:	99124a53 	ldmlsdb	r2, {r0, r1, r4, r6, r9, fp, lr}
     d2c:	1c306812 	ldcne	8, cr6, [r0], #-72
     d30:	f8c4f000 	stmnvia	r4, {ip, sp, lr, pc}^
     d34:	2c4fe069 	mcrrcs	0, 6, lr, pc, cr9
     d38:	9812d102 	ldmlsda	r2, {r1, r8, ip, lr, pc}
     d3c:	e0647030 	rsb	r7, r4, r0, lsr r0
     d40:	d1022c48 	tstle	r2, r8, asr #24
     d44:	80309812 	eorhis	r9, r0, r2, lsl r8
     d48:	2c57e05f 	mrrccs	0, 5, lr, r7, cr15
     d4c:	9812d102 	ldmlsda	r2, {r1, r8, ip, lr, pc}
     d50:	e05a6030 	subs	r6, sl, r0, lsr r0
     d54:	d1022c6f 	tstle	r2, pc, ror #24
     d58:	1c302101 	ldfnes	f2, [r0], #-4
     d5c:	2c68e00c 	stccsl	0, cr14, [r8], #-48
     d60:	2300d104 	tstcs	r0, #1	; 0x1
     d64:	21025ef0 	strcsd	r5, [r2, -r0]
     d68:	e0049012 	and	r9, r4, r2, lsl r0
     d6c:	d1062c77 	tstle	r6, r7, ror ip
     d70:	21046830 	tstcs	r4, r0, lsr r8
     d74:	a8129012 	ldmgeda	r2, {r1, r4, ip, pc}
     d78:	fefcf7ff 	mrc2	7, 7, pc, cr12, cr15, {7}
     d7c:	2c47e045 	mcrrcs	0, 4, lr, r7, cr5
     d80:	9812d103 	ldmlsda	r2, {r0, r1, r8, ip, lr, pc}
     d84:	f8a0f000 	stmnvia	r0!, {ip, sp, lr, pc}
     d88:	2c54e03f 	mrrccs	0, 3, lr, r4, cr15
     d8c:	4939d109 	ldmmidb	r9!, {r0, r3, r8, ip, lr, pc}
     d90:	70082001 	andvc	r2, r8, r1
     d94:	21024a38 	tstcs	r2, r8, lsr sl
     d98:	6892a03e 	ldmvsia	r2, {r1, r2, r3, r4, r5, sp, pc}
     d9c:	f88ef000 	stmnvia	lr, {ip, sp, lr, pc}
     da0:	2c4ee033 	mcrrcs	0, 3, lr, lr, cr3
     da4:	4933d103 	ldmmidb	r3!, {r0, r1, r8, ip, lr, pc}
     da8:	70082000 	andvc	r2, r8, r0
     dac:	2c56e02d 	mrrccs	0, 2, lr, r6, cr13
     db0:	4830d12b 	ldmmida	r0!, {r0, r1, r3, r5, r8, ip, lr, pc}
     db4:	68404c30 	stmvsda	r0, {r4, r5, sl, fp, lr}^
     db8:	210568a2 	smlatbcs	r5, r2, r8, r6
     dbc:	f87ef000 	ldmnvda	lr!, {ip, sp, lr, pc}^
     dc0:	1c292500 	cfstr32ne	mvfx2, [r9]
     dc4:	e002a034 	and	sl, r2, r4, lsr r0
     dc8:	e02ce04d 	eor	lr, ip, sp, asr #32
     dcc:	78023101 	stmvcda	r2, {r0, r8, ip, sp}
     dd0:	2a003001 	bcs	0xcddc
     dd4:	a030d1fa 	ldrgesh	sp, [r0], -sl
     dd8:	f00068a2 	andnv	r6, r0, r2, lsr #17
     ddc:	2101f86f 	tstcsp	r1, pc, ror #16
     de0:	68a2a030 	stmvsia	r2!, {r4, r5, sp, pc}
     de4:	f86af000 	stmnvda	sl!, {ip, sp, lr, pc}^
     de8:	e000a72f 	and	sl, r0, pc, lsr #14
     dec:	78383501 	ldmvcda	r8!, {r0, r8, sl, ip, sp}
     df0:	28003701 	stmcsda	r0, {r0, r8, r9, sl, ip, sp}
     df4:	1c29d1fa 	stfned	f5, [r9], #-1000
     df8:	68a2a02b 	stmvsia	r2!, {r0, r1, r3, r5, sp, pc}
     dfc:	f85ef000 	ldmnvda	lr, {ip, sp, lr, pc}^
     e00:	a0242102 	eorge	r2, r4, r2, lsl #2
     e04:	f00068a2 	andnv	r6, r0, r2, lsr #17
     e08:	2000f859 	andcs	pc, r0, r9, asr r8
     e0c:	48199012 	ldmmida	r9, {r1, r4, ip, pc}
     e10:	7800247a 	stmvcda	r0, {r1, r3, r4, r5, r6, sl, sp}
     e14:	d0262800 	eorle	r2, r6, r0, lsl #16
     e18:	21014a17 	tstcs	r1, r7, lsl sl
     e1c:	6892a025 	ldmvsia	r2, {r0, r2, r5, sp, pc}
     e20:	f84cf000 	stmnvda	ip, {ip, sp, lr, pc}^
     e24:	1c01e01f 	stcne	0, cr14, [r1], {31}
     e28:	29093930 	stmcsdb	r9, {r4, r5, r8, fp, ip, sp}
     e2c:	9812d803 	ldmlsda	r2, {r0, r1, fp, ip, lr, pc}
     e30:	43080100 	tstmi	r8, #0	; 0x0
     e34:	1c01e016 	stcne	0, cr14, [r1], {22}
     e38:	29053941 	stmcsdb	r5, {r0, r6, r8, fp, ip, sp}
     e3c:	9912d803 	ldmlsdb	r2, {r0, r1, fp, ip, lr, pc}
     e40:	38370109 	ldmccda	r7!, {r0, r3, r8}
     e44:	1c01e006 	stcne	0, cr14, [r1], {6}
     e48:	29053961 	stmcsdb	r5, {r0, r5, r6, r8, fp, ip, sp}
     e4c:	9912d804 	ldmlsdb	r2, {r2, fp, ip, lr, pc}
     e50:	38570109 	ldmccda	r7, {r0, r3, r8}^
     e54:	e0054308 	and	r4, r5, r8, lsl #6
     e58:	d101282c 	tstle	r1, ip, lsr #16
     e5c:	e0009e12 	and	r9, r0, r2, lsl lr
     e60:	20001c04 	andcs	r1, r0, r4, lsl #24
     e64:	37019012 	smladcc	r1, r2, r0, r9
     e68:	98113501 	ldmlsda	r1, {r0, r8, sl, ip, sp}
     e6c:	da004285 	ble	0x11888
     e70:	e735e740 	ldr	lr, [r5, -r0, asr #14]!
     e74:	00200f34 	eoreq	r0, r0, r4, lsr pc
     e78:	00200f54 	eoreq	r0, r0, r4, asr pc
     e7c:	00200c4d 	eoreq	r0, r0, sp, asr #24
     e80:	00200c75 	eoreq	r0, r0, r5, ror ip
     e84:	00200c1d 	eoreq	r0, r0, sp, lsl ip
     e88:	00200c35 	eoreq	r0, r0, r5, lsr ip
     e8c:	00200bff 	streqd	r0, [r0], -pc
     e90:	00200bed 	eoreq	r0, r0, sp, ror #23
     e94:	00000d0a 	andeq	r0, r0, sl, lsl #26
     e98:	20766f4e 	rsbcss	r6, r6, lr, asr #30
     e9c:	32203031 	eorcc	r3, r0, #49	; 0x31
     ea0:	00343030 	eoreqs	r3, r4, r0, lsr r0
     ea4:	00000020 	andeq	r0, r0, r0, lsr #32
     ea8:	343a3431 	ldrcct	r3, [sl], #-1073
     eac:	33333a39 	teqcc	r3, #233472	; 0x39000
     eb0:	00000000 	andeq	r0, r0, r0
     eb4:	0000003e 	andeq	r0, r0, lr, lsr r0
     eb8:	47084700 	strmi	r4, [r8, -r0, lsl #14]
     ebc:	47184710 	undefined
     ec0:	47284720 	strmi	r4, [r8, -r0, lsr #14]!
     ec4:	47384730 	undefined
     ec8:	46c04778 	undefined
     ecc:	eafffca7 	b	0x170
     ed0:	01100112 	tsteq	r0, r2, lsl r1
     ed4:	08000002 	stmeqda	r0, {r1}
     ed8:	612403eb 	smulwtvs	r4, fp, r3
     edc:	00000110 	andeq	r0, r0, r0, lsl r1
     ee0:	02090100 	andeq	r0, r9, #0	; 0x0
     ee4:	01020043 	tsteq	r2, r3, asr #32
     ee8:	0900c000 	stmeqdb	r0, {lr, pc}
     eec:	01000004 	tsteq	r0, r4
     ef0:	00000202 	andeq	r0, r0, r2, lsl #4
     ef4:	10002405 	andne	r2, r0, r5, lsl #8
     ef8:	02240401 	eoreq	r0, r4, #16777216	; 0x1000000
     efc:	06240500 	streqt	r0, [r4], -r0, lsl #10
     f00:	24050100 	strcs	r0, [r5], #-256
     f04:	07010001 	streq	r0, [r1, -r1]
     f08:	08038305 	stmeqda	r3, {r0, r2, r8, r9, pc}
     f0c:	0409ff00 	streq	pc, [r9], #-3840
     f10:	0a020001 	beq	0x80f1c
     f14:	07000000 	streq	r0, [r0, -r0]
     f18:	40020105 	andmi	r0, r2, r5, lsl #2
     f1c:	05070000 	streq	r0, [r7]
     f20:	00400282 	subeq	r0, r0, r2, lsl #5
     f24:	2e317600 	cfmsuba32cs	mvax0, mvax7, mvfx1, mvfx0
     f28:	00002034 	andeq	r2, r0, r4, lsr r0
     f2c:	0001c200 	andeq	ip, r1, r0, lsl #4
     f30:	00080000 	andeq	r0, r8, r0
     f34:	00000001 	andeq	r0, r0, r1
     f38:	00200f25 	eoreq	r0, r0, r5, lsr #30
     f3c:	ffffffff 	swinv	0x00ffffff
     f40:	ffffffff 	swinv	0x00ffffff
     f44:	ffffffff 	swinv	0x00ffffff
     f48:	ffffffff 	swinv	0x00ffffff
     f4c:	ffffffff 	swinv	0x00ffffff
     f50:	ffffffff 	swinv	0x00ffffff
     f54:	ffffffff 	swinv	0x00ffffff
     f58:	ffffffff 	swinv	0x00ffffff
     f5c:	ffffffff 	swinv	0x00ffffff
     f60:	ffffffff 	swinv	0x00ffffff
     f64:	ffffffff 	swinv	0x00ffffff
     f68:	ffffffff 	swinv	0x00ffffff
     f6c:	ffffffff 	swinv	0x00ffffff
     f70:	ffffffff 	swinv	0x00ffffff
     f74:	ffffffff 	swinv	0x00ffffff
     f78:	ffffffff 	swinv	0x00ffffff
     f7c:	ffffffff 	swinv	0x00ffffff
     f80:	ffffffff 	swinv	0x00ffffff
     f84:	ffffffff 	swinv	0x00ffffff
     f88:	ffffffff 	swinv	0x00ffffff
     f8c:	ffffffff 	swinv	0x00ffffff
     f90:	ffffffff 	swinv	0x00ffffff
     f94:	ffffffff 	swinv	0x00ffffff
     f98:	ffffffff 	swinv	0x00ffffff
     f9c:	ffffffff 	swinv	0x00ffffff
     fa0:	ffffffff 	swinv	0x00ffffff
     fa4:	ffffffff 	swinv	0x00ffffff
     fa8:	ffffffff 	swinv	0x00ffffff
     fac:	ffffffff 	swinv	0x00ffffff
     fb0:	ffffffff 	swinv	0x00ffffff
     fb4:	ffffffff 	swinv	0x00ffffff
     fb8:	ffffffff 	swinv	0x00ffffff
     fbc:	ffffffff 	swinv	0x00ffffff
     fc0:	ffffffff 	swinv	0x00ffffff
     fc4:	ffffffff 	swinv	0x00ffffff
     fc8:	ffffffff 	swinv	0x00ffffff
     fcc:	ffffffff 	swinv	0x00ffffff
     fd0:	ffffffff 	swinv	0x00ffffff
     fd4:	ffffffff 	swinv	0x00ffffff
     fd8:	ffffffff 	swinv	0x00ffffff
     fdc:	ffffffff 	swinv	0x00ffffff
     fe0:	ffffffff 	swinv	0x00ffffff
     fe4:	ffffffff 	swinv	0x00ffffff
     fe8:	ffffffff 	swinv	0x00ffffff
     fec:	ffffffff 	swinv	0x00ffffff
     ff0:	ffffffff 	swinv	0x00ffffff
     ff4:	ffffffff 	swinv	0x00ffffff
     ff8:	ffffffff 	swinv	0x00ffffff
     ffc:	ffffffff 	swinv	0x00ffffff
    1000:	ffffffff 	swinv	0x00ffffff
    1004:	ffffffff 	swinv	0x00ffffff
    1008:	ffffffff 	swinv	0x00ffffff
    100c:	ffffffff 	swinv	0x00ffffff
    1010:	ffffffff 	swinv	0x00ffffff
    1014:	ffffffff 	swinv	0x00ffffff
    1018:	ffffffff 	swinv	0x00ffffff
    101c:	ffffffff 	swinv	0x00ffffff
    1020:	ffffffff 	swinv	0x00ffffff
    1024:	ffffffff 	swinv	0x00ffffff
    1028:	ffffffff 	swinv	0x00ffffff
    102c:	ffffffff 	swinv	0x00ffffff
    1030:	ffffffff 	swinv	0x00ffffff
    1034:	ffffffff 	swinv	0x00ffffff
    1038:	ffffffff 	swinv	0x00ffffff
    103c:	ffffffff 	swinv	0x00ffffff
    1040:	ffffffff 	swinv	0x00ffffff
    1044:	ffffffff 	swinv	0x00ffffff
    1048:	ffffffff 	swinv	0x00ffffff
    104c:	ffffffff 	swinv	0x00ffffff
    1050:	ffffffff 	swinv	0x00ffffff
    1054:	ffffffff 	swinv	0x00ffffff
    1058:	ffffffff 	swinv	0x00ffffff
    105c:	ffffffff 	swinv	0x00ffffff
    1060:	ffffffff 	swinv	0x00ffffff
    1064:	ffffffff 	swinv	0x00ffffff
    1068:	ffffffff 	swinv	0x00ffffff
    106c:	ffffffff 	swinv	0x00ffffff
    1070:	ffffffff 	swinv	0x00ffffff
    1074:	ffffffff 	swinv	0x00ffffff
    1078:	ffffffff 	swinv	0x00ffffff
    107c:	ffffffff 	swinv	0x00ffffff
    1080:	ffffffff 	swinv	0x00ffffff
    1084:	ffffffff 	swinv	0x00ffffff
    1088:	ffffffff 	swinv	0x00ffffff
    108c:	ffffffff 	swinv	0x00ffffff
    1090:	ffffffff 	swinv	0x00ffffff
    1094:	ffffffff 	swinv	0x00ffffff
    1098:	ffffffff 	swinv	0x00ffffff
    109c:	ffffffff 	swinv	0x00ffffff
    10a0:	ffffffff 	swinv	0x00ffffff
    10a4:	ffffffff 	swinv	0x00ffffff
    10a8:	ffffffff 	swinv	0x00ffffff
    10ac:	ffffffff 	swinv	0x00ffffff
    10b0:	ffffffff 	swinv	0x00ffffff
    10b4:	ffffffff 	swinv	0x00ffffff
    10b8:	ffffffff 	swinv	0x00ffffff
    10bc:	ffffffff 	swinv	0x00ffffff
    10c0:	ffffffff 	swinv	0x00ffffff
    10c4:	ffffffff 	swinv	0x00ffffff
    10c8:	ffffffff 	swinv	0x00ffffff
    10cc:	ffffffff 	swinv	0x00ffffff
    10d0:	ffffffff 	swinv	0x00ffffff
    10d4:	ffffffff 	swinv	0x00ffffff
    10d8:	ffffffff 	swinv	0x00ffffff
    10dc:	ffffffff 	swinv	0x00ffffff
    10e0:	ffffffff 	swinv	0x00ffffff
    10e4:	ffffffff 	swinv	0x00ffffff
    10e8:	ffffffff 	swinv	0x00ffffff
    10ec:	ffffffff 	swinv	0x00ffffff
    10f0:	ffffffff 	swinv	0x00ffffff
    10f4:	ffffffff 	swinv	0x00ffffff
    10f8:	ffffffff 	swinv	0x00ffffff
    10fc:	ffffffff 	swinv	0x00ffffff
    1100:	ffffffff 	swinv	0x00ffffff
    1104:	ffffffff 	swinv	0x00ffffff
    1108:	ffffffff 	swinv	0x00ffffff
    110c:	ffffffff 	swinv	0x00ffffff
    1110:	ffffffff 	swinv	0x00ffffff
    1114:	ffffffff 	swinv	0x00ffffff
    1118:	ffffffff 	swinv	0x00ffffff
    111c:	ffffffff 	swinv	0x00ffffff
    1120:	ffffffff 	swinv	0x00ffffff
    1124:	ffffffff 	swinv	0x00ffffff
    1128:	ffffffff 	swinv	0x00ffffff
    112c:	ffffffff 	swinv	0x00ffffff
    1130:	ffffffff 	swinv	0x00ffffff
    1134:	ffffffff 	swinv	0x00ffffff
    1138:	ffffffff 	swinv	0x00ffffff
    113c:	ffffffff 	swinv	0x00ffffff
    1140:	ffffffff 	swinv	0x00ffffff
    1144:	ffffffff 	swinv	0x00ffffff
    1148:	ffffffff 	swinv	0x00ffffff
    114c:	ffffffff 	swinv	0x00ffffff
    1150:	ffffffff 	swinv	0x00ffffff
    1154:	ffffffff 	swinv	0x00ffffff
    1158:	ffffffff 	swinv	0x00ffffff
    115c:	ffffffff 	swinv	0x00ffffff
    1160:	ffffffff 	swinv	0x00ffffff
    1164:	ffffffff 	swinv	0x00ffffff
    1168:	ffffffff 	swinv	0x00ffffff
    116c:	ffffffff 	swinv	0x00ffffff
    1170:	ffffffff 	swinv	0x00ffffff
    1174:	ffffffff 	swinv	0x00ffffff
    1178:	ffffffff 	swinv	0x00ffffff
    117c:	ffffffff 	swinv	0x00ffffff
    1180:	ffffffff 	swinv	0x00ffffff
    1184:	ffffffff 	swinv	0x00ffffff
    1188:	ffffffff 	swinv	0x00ffffff
    118c:	ffffffff 	swinv	0x00ffffff
    1190:	ffffffff 	swinv	0x00ffffff
    1194:	ffffffff 	swinv	0x00ffffff
    1198:	ffffffff 	swinv	0x00ffffff
    119c:	ffffffff 	swinv	0x00ffffff
    11a0:	ffffffff 	swinv	0x00ffffff
    11a4:	ffffffff 	swinv	0x00ffffff
    11a8:	ffffffff 	swinv	0x00ffffff
    11ac:	ffffffff 	swinv	0x00ffffff
    11b0:	ffffffff 	swinv	0x00ffffff
    11b4:	ffffffff 	swinv	0x00ffffff
    11b8:	ffffffff 	swinv	0x00ffffff
    11bc:	ffffffff 	swinv	0x00ffffff
    11c0:	ffffffff 	swinv	0x00ffffff
    11c4:	ffffffff 	swinv	0x00ffffff
    11c8:	ffffffff 	swinv	0x00ffffff
    11cc:	ffffffff 	swinv	0x00ffffff
    11d0:	ffffffff 	swinv	0x00ffffff
    11d4:	ffffffff 	swinv	0x00ffffff
    11d8:	ffffffff 	swinv	0x00ffffff
    11dc:	ffffffff 	swinv	0x00ffffff
    11e0:	ffffffff 	swinv	0x00ffffff
    11e4:	ffffffff 	swinv	0x00ffffff
    11e8:	ffffffff 	swinv	0x00ffffff
    11ec:	ffffffff 	swinv	0x00ffffff
    11f0:	ffffffff 	swinv	0x00ffffff
    11f4:	ffffffff 	swinv	0x00ffffff
    11f8:	ffffffff 	swinv	0x00ffffff
    11fc:	ffffffff 	swinv	0x00ffffff
    1200:	22407c80 	subcs	r7, r0, #32768	; 0x8000
    1204:	748a4302 	strvc	r4, [sl], #770
    1208:	1809e123 	stmneda	r9, {r0, r1, r5, r8, sp, lr, pc}
    120c:	6a5269ba 	bvs	0x149b8fc
    1210:	7c801810 	stcvc	8, cr1, [r0], {16}
    1214:	e7f52220 	ldrb	r2, [r5, r0, lsr #4]!
    1218:	28019802 	stmcsda	r1, {r1, fp, ip, pc}
    121c:	4975d1f4 	ldmmidb	r5!, {r2, r4, r5, r6, r7, r8, ip, lr, pc}^
    1220:	6a896909 	bvs	0xfe25b64c
    1224:	1d096a49 	fstsne	s12, [r9, #-292]
    1228:	780b1c62 	stmvcda	fp, {r1, r5, r6, sl, fp, ip}
    122c:	784b7013 	stmvcda	fp, {r0, r1, r4, ip, sp, lr}^
    1230:	20037053 	andcs	r7, r3, r3, asr r0
    1234:	69f8e751 	ldmvsib	r8!, {r0, r4, r6, r8, r9, sl, sp, lr, pc}^
    1238:	21046a40 	tstcs	r4, r0, asr #20
    123c:	e10876c1 	smlabt	r8, r1, r6, r7
    1240:	6a406ab8 	bvs	0x101bd28
    1244:	6a496ab9 	bvs	0x125bd30
    1248:	22107e89 	andcss	r7, r0, #2192	; 0x890
    124c:	7682430a 	strvc	r4, [r2], sl, lsl #6
    1250:	28019802 	stmcsda	r1, {r1, fp, ip, pc}
    1254:	6ab8d1f3 	bvs	0xfee35a28
    1258:	30216a40 	eorcc	r6, r1, r0, asr #20
    125c:	49847800 	stmmiib	r4, {fp, ip, sp, lr}
    1260:	90004348 	andls	r4, r0, r8, asr #6
    1264:	1c624669 	stcnel	6, cr4, [r2], #-420
    1268:	1e402004 	cdpne	0, 4, cr2, cr0, cr4, {0}
    126c:	54135c0b 	ldrpl	r5, [r3], #-3083
    1270:	2005d1fb 	strcsd	sp, [r5], -fp
    1274:	9802e6b3 	stmlsda	r2, {r0, r1, r4, r5, r7, r9, sl, sp, lr, pc}
    1278:	d1e02801 	mvnle	r2, r1, lsl #16
    127c:	90007870 	andls	r7, r0, r0, ror r8
    1280:	d3022804 	tstle	r2, #262144	; 0x40000
    1284:	43ed253f 	mvnmi	r2, #264241152	; 0xfc00000
    1288:	9800e0e6 	stmlsda	r0, {r1, r2, r5, r6, r7, sp, lr, pc}
    128c:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    1290:	fb74f003 	blx	0x1d3d2a6
    1294:	98001c05 	stmlsda	r0, {r0, r2, sl, fp, ip}
    1298:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    129c:	fb96f003 	blx	0xfe5bd2b2
    12a0:	20027060 	andcs	r7, r2, r0, rrx
    12a4:	7870e69b 	ldmvcda	r0!, {r0, r1, r3, r4, r7, r9, sl, sp, lr, pc}^
    12a8:	46689000 	strmibt	r9, [r8], -r0
    12ac:	808178b1 	strhih	r7, [r1], r1
    12b0:	28049800 	stmcsda	r4, {fp, ip, pc}
    12b4:	253fd301 	ldrcs	sp, [pc, #-769]!	; 0xfbb
    12b8:	78f3e594 	ldmvcia	r3!, {r2, r4, r7, r8, sl, sp, lr, pc}^
    12bc:	1c321d36 	ldcne	13, cr1, [r2], #-216
    12c0:	88814668 	stmhiia	r1, {r3, r5, r6, r9, sl, lr}
    12c4:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    12c8:	06009800 	streq	r9, [r0], -r0, lsl #16
    12cc:	f0030e00 	andnv	r0, r3, r0, lsl #28
    12d0:	1c05fb9f 	stcne	11, cr15, [r5], {159}
    12d4:	9802e0bd 	stmlsda	r2, {r0, r2, r3, r4, r5, r7, sp, lr, pc}
    12d8:	d1fb2801 	mvnles	r2, r1, lsl #16
    12dc:	90007870 	andls	r7, r0, r0, ror r8
    12e0:	d2cf2804 	sbcle	r2, pc, #262144	; 0x40000
    12e4:	06009800 	streq	r9, [r0], -r0, lsl #16
    12e8:	f0030e00 	andnv	r0, r3, r0, lsl #28
    12ec:	1c05fb47 	stcne	11, cr15, [r5], {71}
    12f0:	06009800 	streq	r9, [r0], -r0, lsl #16
    12f4:	f0030e00 	andnv	r0, r3, r0, lsl #28
    12f8:	4669fb69 	strmibt	pc, [r9], -r9, ror #22
    12fc:	46688088 	strmibt	r8, [r8], -r8, lsl #1
    1300:	70608880 	rsbvc	r8, r0, r0, lsl #17
    1304:	2d002002 	stccs	0, cr2, [r0, #-8]
    1308:	8889db10 	stmhiia	r9, {r4, r8, r9, fp, ip, lr, pc}
    130c:	d00d2900 	andle	r2, sp, r0, lsl #18
    1310:	46681ca2 	strmibt	r1, [r8], -r2, lsr #25
    1314:	06098881 	streq	r8, [r9], -r1, lsl #17
    1318:	98000e09 	stmlsda	r0, {r0, r3, r9, sl, fp}
    131c:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    1320:	fbecf003 	blx	0xffb3d336
    1324:	46681c05 	strmibt	r1, [r8], -r5, lsl #24
    1328:	1c808880 	stcne	8, cr8, [r0], {128}
    132c:	22104669 	andcss	r4, r0, #110100480	; 0x6900000
    1330:	889b466b 	ldmhiia	fp, {r0, r1, r3, r5, r6, r9, sl, lr}
    1334:	808a1ad2 	ldrhid	r1, [sl], r2
    1338:	22008889 	andcs	r8, r0, #8978432	; 0x890000
    133c:	29001823 	stmcsdb	r0, {r0, r1, r5, fp, ip}
    1340:	1e49d002 	cdpne	0, 4, cr13, cr9, cr2, {0}
    1344:	d1fc545a 	mvnles	r5, sl, asr r4
    1348:	88894669 	stmhiia	r9, {r0, r3, r5, r6, r9, sl, lr}
    134c:	e6461840 	strb	r1, [r6], -r0, asr #16
    1350:	28019802 	stmcsda	r1, {r1, fp, ip, pc}
    1354:	29ffd114 	ldmcsib	pc!, {r2, r4, r8, ip, lr, pc}^
    1358:	2513d108 	ldrcs	sp, [r3, #-264]
    135c:	201443ed 	andcss	r4, r4, sp, ror #7
    1360:	1c622100 	stfnee	f2, [r2]
    1364:	54111e40 	ldrpl	r1, [r1], #-3648
    1368:	e005d1fc 	strd	sp, [r5], -ip
    136c:	49b12214 	ldmmiib	r1!, {r2, r4, r9, sp}
    1370:	1c603136 	stfnee	f3, [r0], #-216
    1374:	feeef013 	mcr2	0, 7, pc, cr14, cr3, {0}
    1378:	e6ae2015 	ssat	r2, #15, r5
    137c:	28019802 	stmcsda	r1, {r1, fp, ip, pc}
    1380:	4668d167 	strmibt	sp, [r8], -r7, ror #2
    1384:	80c17871 	sbchi	r7, r1, r1, ror r8
    1388:	706078b0 	strvch	r7, [r0], #-128
    138c:	4668a901 	strmibt	sl, [r8], -r1, lsl #18
    1390:	f00188c0 	andnv	r8, r1, r0, asr #17
    1394:	1c05f9c5 	stcne	9, cr15, [r5], {197}
    1398:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    139c:	270370a0 	strcs	r7, [r3, -r0, lsr #1]
    13a0:	db132d00 	blle	0x4cc7a8
    13a4:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    13a8:	d00f2800 	andle	r2, pc, r0, lsl #16
    13ac:	466878f3 	undefined
    13b0:	1ce18882 	stcnel	8, cr8, [r1], #520
    13b4:	f00188c0 	andnv	r8, r1, r0, asr #17
    13b8:	1c05f9e7 	stcne	9, cr15, [r5], {231}
    13bc:	46682800 	strmibt	r2, [r8], -r0, lsl #16
    13c0:	2100da02 	tstcs	r0, r2, lsl #20
    13c4:	e0018081 	and	r8, r1, r1, lsl #1
    13c8:	1cff8887 	ldcnel	8, cr8, [pc], #540
    13cc:	213b4668 	teqcs	fp, r8, ror #12
    13d0:	8892466a 	ldmhiia	r2, {r1, r3, r5, r6, r9, sl, lr}
    13d4:	80811a89 	addhi	r1, r1, r9, lsl #21
    13d8:	21008880 	smlabbcs	r0, r0, r8, r8
    13dc:	280019e2 	stmcsda	r0, {r1, r5, r6, r7, r8, fp, ip}
    13e0:	1e40d002 	cdpne	0, 4, cr13, cr0, cr2, {0}
    13e4:	d1fc5411 	mvnles	r5, r1, lsl r4
    13e8:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    13ec:	e5f61838 	ldrb	r1, [r6, #2104]!
    13f0:	e4f72541 	ldrbt	r2, [r7], #1345
    13f4:	0000015c 	andeq	r0, r0, ip, asr r1
    13f8:	28137830 	ldmcsda	r3, {r4, r5, fp, ip, sp, lr}
    13fc:	4668d129 	strmibt	sp, [r8], -r9, lsr #2
    1400:	80c178b1 	strhih	r7, [r1], #129
    1404:	808178f1 	strhid	r7, [r1], r1
    1408:	78701d31 	ldmvcda	r0!, {r0, r4, r5, r8, sl, fp, ip}^
    140c:	16000600 	strne	r0, [r0], -r0, lsl #12
    1410:	db1e2800 	blle	0x78b418
    1414:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    1418:	d01a2800 	andles	r2, sl, r0, lsl #16
    141c:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    1420:	d216283c 	andles	r2, r6, #3932160	; 0x3c0000
    1424:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    1428:	1e401808 	cdpne	8, 4, cr1, cr0, cr8, {0}
    142c:	28007800 	stmcsda	r0, {fp, ip, sp, lr}
    1430:	4668d10f 	strmibt	sp, [r8], -pc, lsl #2
    1434:	88c08882 	stmhiia	r0, {r1, r7, fp, pc}^
    1438:	f908f001 	stmnvdb	r8, {r0, ip, sp, lr, pc}
    143c:	20041c05 	andcs	r1, r4, r5, lsl #24
    1440:	428543c0 	addmi	r4, r5, #3	; 0x3
    1444:	9805d105 	stmlsda	r5, {r0, r2, r8, ip, lr, pc}
    1448:	78099905 	stmvcda	r9, {r0, r2, r8, fp, ip, pc}
    144c:	430a2201 	tstmi	sl, #268435456	; 0x10000000
    1450:	98027002 	stmlsda	r2, {r1, ip, sp, lr}
    1454:	d1042801 	tstle	r4, r1, lsl #16
    1458:	99039806 	stmlsdb	r3, {r1, r2, fp, ip, pc}
    145c:	70257001 	eorvc	r7, r5, r1
    1460:	9806e002 	stmlsda	r6, {r1, sp, lr, pc}
    1464:	70012100 	andvc	r2, r1, r0, lsl #2
    1468:	b0072000 	andlt	r2, r7, r0
    146c:	ff61f000 	swinv	0x0061f000
    1470:	0000ea60 	andeq	lr, r0, r0, ror #20
    1474:	496eb5f0 	stmmidb	lr!, {r4, r5, r6, r7, r8, sl, ip, sp, pc}^
    1478:	4c726108 	ldfmie	f6, [r2], #-32
    147c:	61204869 	teqvs	r0, r9, ror #16
    1480:	4a692100 	bmi	0x1a49888
    1484:	486a014e 	stmmida	sl!, {r1, r2, r3, r6, r8}^
    1488:	203c6903 	eorcss	r6, ip, r3, lsl #18
    148c:	699d4348 	ldmvsib	sp, {r3, r6, r8, r9, lr}
    1490:	19ad6a6d 	stmneib	sp!, {r0, r2, r3, r5, r6, r9, fp, sp, lr}
    1494:	50153512 	andpls	r3, r5, r2, lsl r5
    1498:	4348200f 	cmpmi	r8, #15	; 0xf
    149c:	1d150080 	ldcne	0, cr0, [r5, #-512]
    14a0:	6a7f699f 	bvs	0x1fdbb24
    14a4:	371319bf 	undefined
    14a8:	1c15502f 	ldcne	0, cr5, [r5], {47}
    14ac:	699f3508 	ldmvsib	pc, {r3, r8, sl, ip, sp}
    14b0:	19bf6a7f 	ldmneib	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    14b4:	502f3714 	eorpl	r3, pc, r4, lsl r7
    14b8:	350c1c15 	strcc	r1, [ip, #-3093]
    14bc:	6a7f699f 	bvs	0x1fdbb40
    14c0:	371519bf 	undefined
    14c4:	1c15502f 	ldcne	0, cr5, [r5], {47}
    14c8:	699f3510 	ldmvsib	pc, {r4, r8, sl, ip, sp}
    14cc:	19bf6a7f 	ldmneib	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    14d0:	1c15502f 	ldcne	0, cr5, [r5], {47}
    14d4:	699f3514 	ldmvsib	pc, {r2, r4, r8, sl, ip, sp}
    14d8:	19bf6a7f 	ldmneib	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    14dc:	502f370c 	eorpl	r3, pc, ip, lsl #14
    14e0:	35181c15 	ldrcc	r1, [r8, #-3093]
    14e4:	6a7f699f 	bvs	0x1fdbb68
    14e8:	371919bf 	undefined
    14ec:	1c15502f 	ldcne	0, cr5, [r5], {47}
    14f0:	699f351c 	ldmvsib	pc, {r2, r3, r4, r8, sl, ip, sp}
    14f4:	19bf6a7f 	ldmneib	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    14f8:	502f371c 	eorpl	r3, pc, ip, lsl r7
    14fc:	35201c15 	strcc	r1, [r0, #-3093]!
    1500:	6a7f699f 	bvs	0x1fdbb84
    1504:	371a19bf 	undefined
    1508:	1c15502f 	ldcne	0, cr5, [r5], {47}
    150c:	699f3524 	ldmvsib	pc, {r2, r5, r8, sl, ip, sp}
    1510:	19bf6a7f 	ldmneib	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    1514:	502f371b 	eorpl	r3, pc, fp, lsl r7
    1518:	35281c15 	strcc	r1, [r8, #-3093]!
    151c:	6a7f699f 	bvs	0x1fdbba0
    1520:	371619bf 	undefined
    1524:	1c15502f 	ldcne	0, cr5, [r5], {47}
    1528:	699f352c 	ldmvsib	pc, {r2, r3, r5, r8, sl, ip, sp}
    152c:	19bf6a7f 	ldmneib	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    1530:	502f3717 	eorpl	r3, pc, r7, lsl r7
    1534:	35301c15 	ldrcc	r1, [r0, #-3093]!
    1538:	6a7f699f 	bvs	0x1fdbbbc
    153c:	371819bf 	undefined
    1540:	1c15502f 	ldcne	0, cr5, [r5], {47}
    1544:	699f3534 	ldmvsib	pc, {r2, r4, r5, r8, sl, ip, sp}
    1548:	19bf6a7f 	ldmneib	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    154c:	502f1d3f 	eorpl	r1, pc, pc, lsr sp
    1550:	35381c15 	ldrcc	r1, [r8, #-3093]!
    1554:	6a7f699f 	bvs	0x1fdbbd8
    1558:	360819be 	undefined
    155c:	1c49502e 	mcrrne	0, 2, r5, r9, cr14
    1560:	d38f2903 	orrle	r2, pc, #49152	; 0xc000
    1564:	4a312100 	bmi	0xc4996c
    1568:	434e2614 	cmpmi	lr, #20971520	; 0x1400000
    156c:	43482018 	cmpmi	r8, #24	; 0x18
    1570:	6a6d685d 	bvs	0x1b5b6ec
    1574:	350819ad 	strcc	r1, [r8, #-2477]
    1578:	20065015 	andcs	r5, r6, r5, lsl r0
    157c:	00804348 	addeq	r4, r0, r8, asr #6
    1580:	685f1d15 	ldmvsda	pc, {r0, r2, r4, r8, sl, fp, ip}^
    1584:	19bf6a7f 	ldmneib	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    1588:	502f3709 	eorpl	r3, pc, r9, lsl #14
    158c:	35081c15 	strcc	r1, [r8, #-3093]
    1590:	6a7f685f 	bvs	0x1fdb714
    1594:	1cbf19bf 	ldcne	9, cr1, [pc], #764
    1598:	1c15502f 	ldcne	0, cr5, [r5], {47}
    159c:	685f350c 	ldmvsda	pc, {r2, r3, r8, sl, ip, sp}^
    15a0:	19bf6a7f 	ldmneib	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    15a4:	502f1d3f 	eorpl	r1, pc, pc, lsr sp
    15a8:	35101c15 	ldrcc	r1, [r0, #-3093]
    15ac:	6a7f685f 	bvs	0x1fdb730
    15b0:	1dbf19bf 	ldcne	9, cr1, [pc, #764]!
    15b4:	1c15502f 	ldcne	0, cr5, [r5], {47}
    15b8:	685f3514 	ldmvsda	pc, {r2, r4, r8, sl, ip, sp}^
    15bc:	19be6a7f 	ldmneib	lr!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    15c0:	502e3610 	eorpl	r3, lr, r0, lsl r6
    15c4:	29041c49 	stmcsdb	r4, {r0, r3, r6, sl, fp, ip}
    15c8:	f000d3ce 	andnv	sp, r0, lr, asr #7
    15cc:	f000fcd1 	ldrnvd	pc, [r0], -r1
    15d0:	4818fb53 	ldmmida	r8, {r0, r1, r4, r6, r8, r9, fp, ip, sp, lr, pc}
    15d4:	18414918 	stmneda	r1, {r3, r4, r8, fp, lr}^
    15d8:	800a2200 	andhi	r2, sl, r0, lsl #4
    15dc:	804a4a92 	umaalhi	r4, sl, r2, sl
    15e0:	710a2201 	tstvc	sl, r1, lsl #4
    15e4:	714a2200 	cmpvc	sl, r0, lsl #4
    15e8:	302280ca 	eorcc	r8, r2, sl, asr #1
    15ec:	77227002 	strvc	r7, [r2, -r2]!
    15f0:	200177a2 	andcs	r7, r1, r2, lsr #15
    15f4:	48117760 	ldmmida	r1, {r5, r6, r8, r9, sl, ip, sp, lr}
    15f8:	83208360 	teqhi	r0, #-2147483647	; 0x80000001
    15fc:	49102210 	ldmmidb	r0, {r4, r9, sp}
    1600:	f0131c20 	andnvs	r1, r3, r0, lsr #24
    1604:	2014fda7 	andcss	pc, r4, r7, lsr #27
    1608:	4a0e2100 	bmi	0x389a10
    160c:	1f003220 	swine	0x00003220
    1610:	d1fc5011 	mvnles	r5, r1, lsl r0
    1614:	fffcf012 	swinv	0x00fcf012
    1618:	f804f013 	stmnvda	r4, {r0, r1, r4, ip, sp, lr, pc}
    161c:	f7ff6160 	ldrnvb	r6, [pc, r0, ror #2]!
    1620:	46c0f9bf 	undefined
    1624:	00100d3d 	andeqs	r0, r0, sp, lsr sp
    1628:	000089a0 	andeq	r8, r0, r0, lsr #19
    162c:	00008940 	andeq	r8, r0, r0, asr #18
    1630:	0000015c 	andeq	r0, r0, ip, asr r1
    1634:	00008680 	andeq	r8, r0, r0, lsl #13
    1638:	000002b2 	streqh	r0, [r0], -r2
    163c:	0000ffff 	streqd	pc, [r0], -pc
    1640:	00118d48 	andeqs	r8, r1, r8, asr #26
    1644:	0000064c 	andeq	r0, r0, ip, asr #12
    1648:	2700b5f3 	undefined
    164c:	69004875 	stmvsdb	r0, {r0, r2, r4, r5, r6, fp, lr}
    1650:	20ad9000 	adccs	r9, sp, r0
    1654:	49750080 	ldmmidb	r5!, {r7}^
    1658:	4e74180d 	cdpmi	8, 7, cr1, cr4, cr13, {0}
    165c:	4c701d36 	ldcmil	13, cr1, [r0], #-216
    1660:	28007fb0 	stmcsda	r0, {r4, r5, r7, r8, r9, sl, fp, ip, sp, lr}
    1664:	1e40d007 	cdpne	0, 4, cr13, cr0, cr7, {0}
    1668:	d9672801 	stmledb	r7!, {r0, fp, sp}^
    166c:	d0231ec0 	eorle	r1, r3, r0, asr #29
    1670:	d0431e40 	suble	r1, r3, r0, asr #28
    1674:	7fa0e0ca 	swivc	0x00a0e0ca
    1678:	d1fb2801 	mvnles	r2, r1, lsl #16
    167c:	1c2077a7 	stcne	7, cr7, [r0], #-668
    1680:	f0003020 	andnv	r3, r0, r0, lsr #32
    1684:	2800f9eb 	stmcsda	r0, {r0, r1, r3, r5, r6, r7, r8, fp, ip, sp, lr, pc}
    1688:	2003da03 	andcs	sp, r3, r3, lsl #20
    168c:	20047720 	andcs	r7, r4, r0, lsr #14
    1690:	2001e0bb 	strcsh	lr, [r1], -fp
    1694:	200277b0 	strcsh	r7, [r2], -r0
    1698:	69607720 	stmvsdb	r0!, {r5, r8, r9, sl, ip, sp, lr}^
    169c:	f00060a8 	andnv	r6, r0, r8, lsr #1
    16a0:	4860fb43 	stmmida	r0!, {r0, r1, r6, r8, r9, fp, ip, sp, lr, pc}^
    16a4:	6a816900 	bvs	0xfe05baac
    16a8:	6a806a49 	bvs	0xfe01bfd4
    16ac:	7e806a40 	cdpvc	10, 8, cr6, cr0, cr0, {2}
    16b0:	43022206 	tstmi	r2, #1610612736	; 0x60000000
    16b4:	e0a9768a 	adc	r7, r9, sl, lsl #13
    16b8:	28047f20 	stmcsda	r4, {r5, r8, r9, sl, fp, ip, sp, lr}
    16bc:	f000d101 	andnv	sp, r0, r1, lsl #2
    16c0:	4858fb33 	ldmmida	r8, {r0, r1, r4, r5, r8, r9, fp, ip, sp, lr, pc}^
    16c4:	6a806900 	bvs	0xfe01bacc
    16c8:	7e816a40 	cdpvc	10, 8, cr6, cr1, cr0, {2}
    16cc:	400a22f9 	strmid	r2, [sl], -r9
    16d0:	f0007682 	andnv	r7, r0, r2, lsl #13
    16d4:	f7fffad1 	undefined
    16d8:	4852fa6d 	ldmmida	r2, {r0, r2, r3, r5, r6, r9, fp, ip, sp, lr, pc}^
    16dc:	69c16900 	stmvsib	r1, {r8, fp, sp, lr}^
    16e0:	22046a49 	andcs	r6, r4, #299008	; 0x49000
    16e4:	69c176ca 	stmvsib	r1, {r1, r3, r6, r7, r9, sl, ip, sp, lr}^
    16e8:	6a806a49 	bvs	0xfe01c014
    16ec:	30246a40 	eorcc	r6, r4, r0, asr #20
    16f0:	77487800 	strvcb	r7, [r8, -r0, lsl #16]
    16f4:	8028484c 	eorhi	r4, r8, ip, asr #16
    16f8:	e0862005 	add	r2, r6, r5
    16fc:	5e282000 	cdppl	0, 2, cr2, cr8, cr0, {0}
    1700:	42884949 	addmi	r4, r8, #1196032	; 0x124000
    1704:	78e8d110 	stmvcia	r8!, {r4, r8, ip, lr, pc}^
    1708:	d10d2801 	tstle	sp, r1, lsl #16
    170c:	20001c29 	andcs	r1, r0, r9, lsr #24
    1710:	2300b403 	tstcs	r0, #50331648	; 0x3000000
    1714:	21002200 	tstcs	r0, r0, lsl #4
    1718:	9f022008 	swils	0x00022008
    171c:	6a7f683f 	bvs	0x1fdb820
    1720:	f015683f 	andnvs	r6, r5, pc, lsr r8
    1724:	b002fd67 	andlt	pc, r2, r7, ror #26
    1728:	28057f20 	stmcsda	r5, {r5, r8, r9, sl, fp, ip, sp, lr}
    172c:	f000d16e 	andnv	sp, r0, lr, ror #2
    1730:	2000fafb 	strcsd	pc, [r0], -fp
    1734:	77b070e8 	ldrvc	r7, [r0, r8, ror #1]!
    1738:	e0677720 	rsb	r7, r7, r0, lsr #14
    173c:	28017fe0 	stmcsda	r1, {r5, r6, r7, r8, r9, sl, fp, ip, sp, lr}
    1740:	9800d006 	stmlsda	r0, {r1, r2, ip, lr, pc}
    1744:	6a406880 	bvs	0x101b94c
    1748:	78003020 	stmvcda	r0, {r5, ip, sp}
    174c:	d50c07c0 	strle	r0, [ip, #-1984]
    1750:	980077e7 	stmlsda	r0, {r0, r1, r2, r5, r6, r7, r8, r9, sl, ip, sp, lr}
    1754:	6a406880 	bvs	0x101b95c
    1758:	1c022120 	stfnes	f2, [r2], {32}
    175c:	78123220 	ldmvcda	r2, {r5, r9, ip, sp}
    1760:	401323fe 	ldrmish	r2, [r3], -lr
    1764:	20045443 	andcs	r5, r4, r3, asr #8
    1768:	7968e7e5 	stmvcdb	r8!, {r0, r2, r5, r6, r7, r8, r9, sl, sp, lr, pc}^
    176c:	d0082800 	andle	r2, r8, r0, lsl #16
    1770:	fef4f000 	cdp2	0, 15, cr15, cr4, cr0, {0}
    1774:	e004716f 	and	r7, r4, pc, ror #2
    1778:	ff54f012 	swinv	0x0054f012
    177c:	42816961 	addmi	r6, r1, #1589248	; 0x184000
    1780:	482ad144 	stmmida	sl!, {r2, r6, r8, ip, lr, pc}
    1784:	78053030 	stmvcda	r5, {r4, r5, ip, sp}
    1788:	f0001c28 	andnv	r1, r0, r8, lsr #24
    178c:	2800fbe9 	stmcsda	r0, {r0, r3, r5, r6, r7, r8, r9, fp, ip, sp, lr, pc}
    1790:	4668d022 	strmibt	sp, [r8], -r2, lsr #32
    1794:	25007105 	strcs	r7, [r0, #-261]
    1798:	79004668 	stmvcdb	r0, {r3, r5, r6, r9, sl, lr}
    179c:	fc98f001 	ldc2	0, cr15, [r8], {1}
    17a0:	28001c07 	stmcsda	r0, {r0, r1, r2, sl, fp, ip}
    17a4:	2f01db18 	swics	0x0001db18
    17a8:	2f02d01c 	swics	0x0002d01c
    17ac:	2f04d01a 	swics	0x0004d01a
    17b0:	2f05d018 	swics	0x0005d018
    17b4:	1c6dd00c 	stcnel	0, cr13, [sp], #-48
    17b8:	28017fb0 	stmcsda	r1, {r4, r5, r7, r8, r9, sl, fp, ip, sp, lr}
    17bc:	4668d108 	strmibt	sp, [r8], -r8, lsl #2
    17c0:	21147900 	tstcs	r4, r0, lsl #18
    17c4:	68314348 	ldmvsda	r1!, {r3, r6, r8, r9, lr}
    17c8:	7a401808 	bvc	0x10077f0
    17cc:	d3e34285 	mvnle	r4, #1342177288	; 0x50000008
    17d0:	30304816 	eorccs	r4, r0, r6, lsl r8
    17d4:	fb4ef000 	blx	0x13bd7de
    17d8:	da032f00 	ble	0xcd3e0
    17dc:	77b02004 	ldrvc	r2, [r0, r4]!
    17e0:	e7a92003 	str	r2, [r9, r3]!
    17e4:	d0112f04 	andles	r2, r1, r4, lsl #30
    17e8:	30304810 	eorccs	r4, r0, r0, lsl r8
    17ec:	f0007800 	andnv	r7, r0, r0, lsl #16
    17f0:	2800fbb7 	stmcsda	r0, {r0, r1, r2, r4, r5, r7, r8, r9, fp, ip, sp, lr, pc}
    17f4:	2f05d001 	swics	0x0005d001
    17f8:	2004d103 	andcs	sp, r4, r3, lsl #2
    17fc:	200177b0 	strcsh	r7, [r1], -r0
    1800:	7fb0e79a 	swivc	0x00b0e79a
    1804:	d0b72801 	adcles	r2, r7, r1, lsl #16
    1808:	77b02003 	ldrvc	r2, [r0, r3]!
    180c:	ff0af012 	swinv	0x000af012
    1810:	42816961 	addmi	r6, r1, #1589248	; 0x184000
    1814:	f012d0fa 	ldrnvsh	sp, [r2], -sl
    1818:	6160ff05 	msrvs	SPSR_, r5, lsl #30
    181c:	0000e326 	andeq	lr, r0, r6, lsr #6
    1820:	0000064c 	andeq	r0, r0, ip, asr #12
    1824:	0000015c 	andeq	r0, r0, ip, asr r1
    1828:	ffff9400 	swinv	0x00ff9400
    182c:	00008680 	andeq	r8, r0, r0, lsl #13
    1830:	f012b500 	andnvs	fp, r2, r0, lsl #10
    1834:	bc01ff17 	stclt	15, cr15, [r1], {23}
    1838:	00004700 	andeq	r4, r0, r0, lsl #14
    183c:	1c04b5f7 	cfstr32ne	mvfx11, [r4], {247}
    1840:	330e1c03 	tstcc	lr, #768	; 0x300
    1844:	785e781d 	ldmvcda	lr, {r0, r2, r3, r4, fp, ip, sp, lr}^
    1848:	49532210 	ldmmidb	r3, {r4, r9, sp}^
    184c:	fc68f013 	stc2l	0, cr15, [r8], #-76
    1850:	d1032800 	tstle	r3, r0, lsl #16
    1854:	d3012e04 	tstle	r1, #64	; 0x40
    1858:	d3022d02 	tstle	r2, #128	; 0x80
    185c:	43c02003 	bicmi	r2, r0, #3	; 0x3
    1860:	497de094 	ldmmidb	sp!, {r2, r4, r7, sp, lr, pc}^
    1864:	83888a20 	orrhi	r8, r8, #131072	; 0x20000
    1868:	83c88a60 	bichi	r8, r8, #393216	; 0x60000
    186c:	84088aa0 	strhi	r8, [r8], #-2720
    1870:	8ae29802 	bhi	0xff8a7880
    1874:	98028082 	stmlsda	r2, {r1, r7, pc}
    1878:	80c28b22 	sbchi	r8, r2, r2, lsr #22
    187c:	8b629802 	blhi	0x18a788c
    1880:	8ba08102 	blhi	0xfe821c90
    1884:	8be08488 	blhi	0xff822aac
    1888:	8c2284c8 	cfstrshi	mvf8, [r2], #-800
    188c:	20028c63 	andcs	r8, r2, r3, ror #24
    1890:	2b0043c0 	blcs	0x12798
    1894:	2bffd07a 	blcs	0xffff5a84
    1898:	768bd278 	undefined
    189c:	830b8ca3 	tsthi	fp, #41728	; 0xa300
    18a0:	d0732b00 	rsbles	r2, r3, r0, lsl #22
    18a4:	25269b02 	strcs	r9, [r6, #-2818]!
    18a8:	8b8b801d 	blhi	0xfe2e1924
    18ac:	3526009d 	strcc	r0, [r6, #-157]!
    18b0:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    18b4:	4e36006b 	cdpmi	0, 3, cr0, cr6, cr11, {3}
    18b8:	1b9b402e 	blne	0xfe6d1978
    18bc:	806b9d02 	rsbhi	r9, fp, r2, lsl #26
    18c0:	88ad9d02 	stmhiia	sp!, {r1, r8, sl, fp, ip, pc}
    18c4:	042d195d 	streqt	r1, [sp], #-2397
    18c8:	006b0c2d 	rsbeq	r0, fp, sp, lsr #24
    18cc:	402e4e30 	eormi	r4, lr, r0, lsr lr
    18d0:	9b021b9d 	blls	0x8874c
    18d4:	042d815d 	streqt	r8, [sp], #-349
    18d8:	19630c2d 	stmnedb	r3!, {r0, r2, r3, r5, sl, fp}^
    18dc:	7e8f466e 	cdpvc	6, 8, cr4, cr15, cr14, {3}
    18e0:	78367037 	ldmvcda	r6!, {r0, r1, r2, r4, r5, ip, sp, lr}
    18e4:	19ad00b6 	stmneib	sp!, {r1, r2, r4, r5, r7}
    18e8:	e0032600 	and	r2, r3, r0, lsl #12
    18ec:	19ed785f 	stmneib	sp!, {r0, r1, r2, r3, r4, r6, fp, ip, sp, lr}^
    18f0:	1c761d1b 	ldcnel	13, cr1, [r6], #-108
    18f4:	783f466f 	ldmvcda	pc!, {r0, r1, r2, r3, r5, r6, r9, sl, lr}
    18f8:	d3f742be 	mvnles	r4, #-536870901	; 0xe000000b
    18fc:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    1900:	4e23006b 	cdpmi	0, 2, cr0, cr3, cr11, {3}
    1904:	1b9b402e 	blne	0xfe6d19c4
    1908:	81ab9d02 	movhi	r9, r2, lsl #26
    190c:	0c1b041b 	cfldrseq	mvf0, [fp], {27}
    1910:	8b0e9d01 	blhi	0x3a8d1c
    1914:	1bad0076 	blne	0xfeb41af4
    1918:	d13742ab 	teqle	r7, fp, lsr #5
    191c:	33301c0b 	teqcc	r0, #2816	; 0xb00
    1920:	701d25ff 	ldrvcsh	r2, [sp], -pc
    1924:	9b02705d 	blls	0x9daa0
    1928:	18e3899b 	stmneia	r3!, {r0, r1, r3, r4, r7, r8, fp, pc}^
    192c:	694b600b 	stmvsdb	fp, {r0, r1, r3, sp, lr}^
    1930:	18eb690d 	stmneia	fp!, {r0, r2, r3, r8, fp, sp, lr}^
    1934:	694b604b 	stmvsdb	fp, {r0, r1, r3, r6, sp, lr}^
    1938:	26147e8d 	ldrcs	r7, [r4], -sp, lsl #29
    193c:	195b4375 	ldmnedb	fp, {r0, r2, r4, r5, r6, r8, r9, lr}^
    1940:	9b02614b 	blls	0x99e74
    1944:	18e3881b 	stmneia	r3!, {r0, r1, r3, r4, fp, pc}^
    1948:	694b608b 	stmvsdb	fp, {r0, r1, r3, r7, sp, lr}^
    194c:	25031c1c 	strcs	r1, [r3, #-3100]
    1950:	d004422b 	andle	r4, r4, fp, lsr #4
    1954:	079b1d24 	ldreq	r1, [fp, r4, lsr #26]
    1958:	1ae30f9b 	bne	0xff8c57cc
    195c:	694b614b 	stmvsdb	fp, {r0, r1, r3, r6, r8, sp, lr}^
    1960:	18e5690c 	stmneia	r5!, {r2, r3, r8, fp, sp, lr}^
    1964:	4b0d60cd 	blmi	0x359ca0
    1968:	831d1aed 	tsthi	sp, #970752	; 0xed000
    196c:	8bce694d 	blhi	0xff39bea8
    1970:	614d19ad 	smlaltbvs	r1, sp, sp, r9
    1974:	18aa68cd 	stmneia	sl!, {r0, r2, r3, r6, r7, fp, sp, lr}
    1978:	1ad262ca 	bne	0xff49a4a8
    197c:	0c02835a 	stceq	3, cr8, [r2], {90}
    1980:	6949850a 	stmvsdb	r9, {r1, r3, r8, sl, pc}^
    1984:	42914a03 	addmis	r4, r1, #12288	; 0x3000
    1988:	2000d200 	andcs	sp, r0, r0, lsl #4
    198c:	fc28f000 	stc2	0, cr15, [r8]
    1990:	0000fffe 	streqd	pc, [r0], -lr
    1994:	00008001 	andeq	r8, r0, r1
    1998:	00118d48 	andeqs	r8, r1, r8, asr #26
    199c:	0000064c 	andeq	r0, r0, ip, asr #12
    19a0:	1c17b5f3 	cfldr32ne	mvfx11, [r7], {243}
    19a4:	1c102400 	cfldrsne	mvf2, [r0], {0}
    19a8:	ff54f000 	swinv	0x0054f000
    19ac:	28081c05 	stmcsda	r8, {r0, r2, sl, fp, ip}
    19b0:	1c38d11b 	ldfned	f5, [r8], #-108
    19b4:	f9c4f001 	stmnvib	r4, {r0, ip, sp, lr, pc}^
    19b8:	1c7f1c05 	ldcnel	12, cr1, [pc], #-20
    19bc:	e0052600 	and	r2, r5, r0, lsl #12
    19c0:	0c000438 	cfstrseq	mvf0, [r0], {56}
    19c4:	fff8f000 	swinv	0x00f8f000
    19c8:	1c761c07 	ldcnel	12, cr1, [r6], #-28
    19cc:	0c360436 	cfldrseq	mvf0, [r6], #-216
    19d0:	d20842ae 	andle	r4, r8, #-536870902	; 0xe000000a
    19d4:	0c12043a 	cfldrseq	mvf0, [r2], {58}
    19d8:	98009901 	stmlsda	r0, {r0, r8, fp, ip, pc}
    19dc:	ffe0f7ff 	swinv	0x00e0f7ff
    19e0:	28001c04 	stmcsda	r0, {r2, sl, fp, ip}
    19e4:	1c20daec 	stcne	10, cr13, [r0], #-944
    19e8:	00bee322 	adceqs	lr, lr, r2, lsr #6
    19ec:	d1082d07 	tstle	r8, r7, lsl #26
    19f0:	49192002 	ldmmidb	r9, {r1, sp}
    19f4:	19896889 	stmneib	r9, {r0, r3, r7, fp, sp, lr}
    19f8:	49175e08 	ldmmidb	r7, {r3, r9, sl, fp, ip, lr}
    19fc:	180f68c9 	stmneda	pc, {r0, r3, r6, r7, fp, sp, lr}
    1a00:	2200e005 	andcs	lr, r0, #5	; 0x5
    1a04:	1c382100 	ldfnes	f2, [r8]
    1a08:	ff2af000 	swinv	0x002af000
    1a0c:	48121c07 	ldmmida	r2, {r0, r1, r2, sl, fp, ip}
    1a10:	19806880 	stmneib	r0, {r7, fp, sp, lr}
    1a14:	28007840 	stmcsda	r0, {r6, fp, ip, sp, lr}
    1a18:	1c28d009 	stcne	0, cr13, [r8], #-36
    1a1c:	ff7ef000 	swinv	0x007ef000
    1a20:	28002100 	stmcsda	r0, {r8, sp}
    1a24:	1e40d0df 	mcrne	0, 2, sp, cr0, cr15, {6}
    1a28:	d1fc5439 	mvnles	r5, r9, lsr r4
    1a2c:	1c28e7db 	stcne	7, cr14, [r8], #-876
    1a30:	ff74f000 	swinv	0x0074f000
    1a34:	98011c02 	stmlsda	r1, {r1, sl, fp, ip}
    1a38:	99008800 	stmlsdb	r0, {fp, pc}
    1a3c:	1c381809 	ldcne	8, cr1, [r8], #-36
    1a40:	faaaf013 	blx	0xfeabda94
    1a44:	88069801 	stmhida	r6, {r0, fp, ip, pc}
    1a48:	f0001c28 	andnv	r1, r0, r8, lsr #24
    1a4c:	1830ff67 	ldmneda	r0!, {r0, r1, r2, r5, r6, r8, r9, sl, fp, ip, sp, lr, pc}
    1a50:	80089901 	andhi	r9, r8, r1, lsl #18
    1a54:	0000e7c7 	andeq	lr, r0, r7, asr #15
    1a58:	00008680 	andeq	r8, r0, r0, lsl #13
    1a5c:	b08cb5f0 	strltd	fp, [ip], r0
    1a60:	ab021c06 	blge	0x88a80
    1a64:	1c01aa05 	stcne	10, cr10, [r1], {5}
    1a68:	4cad208a 	stcmi	0, cr2, [sp], #552
    1a6c:	69246924 	stmvsdb	r4!, {r2, r5, r8, fp, sp, lr}
    1a70:	68246a64 	stmvsda	r4!, {r2, r5, r6, r9, fp, sp, lr}
    1a74:	fbc4f015 	blx	0xff13dad2
    1a78:	98051c07 	stmlsda	r5, {r0, r1, r2, sl, fp, ip}
    1a7c:	24029000 	strcs	r9, [r2]
    1a80:	20ff43e4 	rsccss	r4, pc, r4, ror #7
    1a84:	42070200 	andmi	r0, r7, #0	; 0x0
    1a88:	9800d105 	stmlsda	r0, {r0, r2, r8, ip, lr, pc}
    1a8c:	d0022800 	andle	r2, r2, r0, lsl #16
    1a90:	28009802 	stmcsda	r0, {r1, fp, ip, pc}
    1a94:	1c20d101 	stfned	f5, [r0], #-4
    1a98:	f000e0ec 	andnv	lr, r0, ip, ror #1
    1a9c:	f000f8ed 	andnv	pc, r0, sp, ror #17
    1aa0:	4da0fa67 	stcmi	10, cr15, [r0, #412]!
    1aa4:	30301c28 	eorccs	r1, r0, r8, lsr #24
    1aa8:	71479003 	cmpvc	r7, r3
    1aac:	1c312214 	lfmne	f2, 4, [r1], #-80
    1ab0:	30361c28 	eorccs	r1, r6, r8, lsr #24
    1ab4:	fb4ef013 	blx	0x13bdb0a
    1ab8:	9902aa06 	stmlsdb	r2, {r1, r2, r9, fp, sp, pc}
    1abc:	f7ff9800 	ldrnvb	r9, [pc, r0, lsl #16]!
    1ac0:	2800febd 	stmcsda	r0, {r0, r2, r3, r4, r5, r7, r9, sl, fp, ip, sp, lr, pc}
    1ac4:	6828dbe8 	stmvsda	r8!, {r3, r5, r6, r7, r8, r9, fp, ip, lr, pc}
    1ac8:	42889900 	addmi	r9, r8, #0	; 0x0
    1acc:	9902d3e3 	stmlsdb	r2, {r0, r1, r5, r6, r7, r8, r9, ip, lr, pc}
    1ad0:	18519a00 	ldmneda	r1, {r9, fp, ip, pc}^
    1ad4:	d2de4288 	sbcles	r4, lr, #-2147483640	; 0x80000008
    1ad8:	68696928 	stmvsda	r9!, {r3, r5, r8, fp, sp, lr}^
    1adc:	d3da4281 	bicles	r4, sl, #268435464	; 0x10000008
    1ae0:	1882696a 	stmneia	r2, {r1, r3, r5, r6, r8, fp, sp, lr}
    1ae4:	d2d64291 	sbcles	r4, r6, #268435465	; 0x10000009
    1ae8:	428168e9 	addmi	r6, r1, #15269888	; 0xe90000
    1aec:	4291d3d3 	addmis	sp, r1, #1275068419	; 0x4c000003
    1af0:	8be8d2d1 	blhi	0xffa3663c
    1af4:	d0ce2800 	sbcle	r2, lr, r0, lsl #16
    1af8:	8940a806 	stmhidb	r0, {r1, r2, fp, sp, pc}^
    1afc:	180e9900 	stmneda	lr, {r8, fp, ip, pc}
    1b00:	e02a2700 	eor	r2, sl, r0, lsl #14
    1b04:	00b91c38 	adceqs	r1, r9, r8, lsr ip
    1b08:	22141871 	andcss	r1, r4, #7405568	; 0x710000
    1b0c:	686a4350 	stmvsda	sl!, {r4, r6, r8, r9, lr}^
    1b10:	780b1812 	stmvcda	fp, {r1, r4, fp, ip}
    1b14:	686a7193 	stmvsda	sl!, {r0, r1, r4, r7, r8, ip, sp, lr}^
    1b18:	784b1812 	stmvcda	fp, {r1, r4, fp, ip}^
    1b1c:	686a7413 	stmvsda	sl!, {r0, r1, r4, sl, ip, sp, lr}^
    1b20:	52118849 	andpls	r8, r1, #4784128	; 0x490000
    1b24:	18096869 	stmneda	r9, {r0, r3, r5, r6, fp, sp, lr}
    1b28:	808a2200 	addhi	r2, sl, r0, lsl #4
    1b2c:	18096869 	stmneda	r9, {r0, r3, r5, r6, fp, sp, lr}
    1b30:	724a2214 	subvc	r2, sl, #1073741825	; 0x40000001
    1b34:	18096869 	stmneda	r9, {r0, r3, r5, r6, fp, sp, lr}
    1b38:	720a22ff 	andvc	r2, sl, #-268435441	; 0xf000000f
    1b3c:	18096869 	stmneda	r9, {r0, r3, r5, r6, fp, sp, lr}
    1b40:	71ca798a 	bicvc	r7, sl, sl, lsl #19
    1b44:	18086869 	stmneda	r8, {r0, r3, r5, r6, fp, sp, lr}
    1b48:	280079c0 	stmcsda	r0, {r6, r7, r8, fp, ip, sp, lr}
    1b4c:	0639d104 	ldreqt	sp, [r9], -r4, lsl #2
    1b50:	98030e09 	stmlsda	r3, {r0, r3, r9, sl, fp}
    1b54:	f948f000 	stmnvdb	r8, {ip, sp, lr, pc}^
    1b58:	7ea81c7f 	mcrvc	12, 5, r1, cr8, cr15, {3}
    1b5c:	0c3f043f 	cfldrseq	mvf0, [pc], #-252
    1b60:	d3cf4287 	bicle	r4, pc, #1879048200	; 0x70000008
    1b64:	18300080 	ldmneda	r0!, {r7}
    1b68:	e0032600 	and	r2, r3, r0, lsl #12
    1b6c:	1e498b29 	cdpne	11, 4, cr8, cr9, cr9, {1}
    1b70:	1c768051 	ldcnel	0, cr8, [r6], #-324
    1b74:	04367ea9 	ldreqt	r7, [r6], #-3753
    1b78:	428e0c36 	addmi	r0, lr, #13824	; 0x3600
    1b7c:	1c31d217 	lfmne	f5, 1, [r1], #-92
    1b80:	43722214 	cmnmi	r2, #1073741825	; 0x40000001
    1b84:	189b686b 	ldmneia	fp, {r0, r1, r3, r5, r6, fp, sp, lr}
    1b88:	2f007c1f 	swics	0x00007c1f
    1b8c:	60d8d005 	sbcvss	sp, r8, r5
    1b90:	189b686b 	ldmneia	fp, {r0, r1, r3, r5, r6, fp, sp, lr}
    1b94:	18c07c1b 	stmneia	r0, {r0, r1, r3, r4, sl, fp, ip, sp, lr}^
    1b98:	2700e001 	strcs	lr, [r0, -r1]
    1b9c:	686b60df 	stmvsda	fp!, {r0, r1, r2, r3, r4, r6, r7, sp, lr}^
    1ba0:	7eab189a 	mcrvc	8, 5, r1, cr11, cr10, {4}
    1ba4:	42991e5b 	addmis	r1, r9, #1456	; 0x5b0
    1ba8:	8a91dae0 	bhi	0xfe478730
    1bac:	9803e7df 	stmlsda	r3, {r0, r1, r2, r3, r4, r6, r7, r8, r9, sl, sp, lr, pc}
    1bb0:	28ff7800 	ldmcsia	pc!, {fp, ip, sp, lr}^
    1bb4:	1c20d101 	stfned	f5, [r0], #-4
    1bb8:	4668e05c 	undefined
    1bbc:	80812100 	addhi	r2, r1, r0, lsl #2
    1bc0:	1c322600 	ldcne	6, cr2, [r2]
    1bc4:	a806a901 	stmgeda	r6, {r0, r8, fp, sp, pc}
    1bc8:	9b008840 	blls	0x23cd0
    1bcc:	f7ff1818 	undefined
    1bd0:	1c07fee7 	stcne	14, cr15, [r7], {231}
    1bd4:	db4d2800 	blle	0x134bbdc
    1bd8:	f0001c30 	andnv	r1, r0, r0, lsr ip
    1bdc:	1c06feed 	stcne	14, cr15, [r6], {237}
    1be0:	42860c20 	addmi	r0, r6, #8192	; 0x2000
    1be4:	a806d1ed 	stmgeda	r6, {r0, r2, r3, r5, r6, r7, r8, ip, lr, pc}
    1be8:	466988c0 	strmibt	r8, [r9], -r0, asr #17
    1bec:	42818889 	addmi	r8, r1, #8978432	; 0x890000
    1bf0:	a906d13d 	stmgedb	r6, {r0, r2, r3, r4, r5, r8, ip, lr, pc}
    1bf4:	4669890a 	strmibt	r8, [r9], -sl, lsl #18
    1bf8:	18898889 	stmneia	r9, {r0, r3, r7, fp, pc}
    1bfc:	889bab06 	ldmhiia	fp, {r1, r2, r8, r9, fp, sp, pc}
    1c00:	d1344299 	ldrleb	r4, [r4, -r9]!
    1c04:	8849a906 	stmhida	r9, {r1, r2, r8, fp, sp, pc}^
    1c08:	18599b00 	ldmneda	r9, {r8, r9, fp, ip, pc}^
    1c0c:	8c281809 	stchi	8, cr1, [r8], #-36
    1c10:	181868eb 	ldmneda	r8, {r0, r1, r3, r5, r6, r7, fp, sp, lr}
    1c14:	f9c0f013 	stmnvib	r0, {r0, r1, r4, ip, sp, lr, pc}^
    1c18:	88016ae8 	stmhida	r1, {r3, r5, r6, r7, r9, fp, sp, lr}
    1c1c:	185168ea 	ldmneda	r1, {r1, r3, r5, r6, r7, fp, sp, lr}^
    1c20:	d1c84288 	bicle	r4, r8, r8, lsl #5
    1c24:	20cd2600 	sbccs	r2, sp, r0, lsl #12
    1c28:	18280040 	stmneda	r8!, {r6}
    1c2c:	200e9004 	andcs	r9, lr, r4
    1c30:	90004370 	andls	r4, r0, r0, ror r3
    1c34:	22009904 	andcs	r9, r0, #65536	; 0x10000
    1c38:	9800520a 	stmlsda	r0, {r1, r3, r9, ip, lr}
    1c3c:	1c899904 	stcne	9, cr9, [r9], {4}
    1c40:	2000520a 	andcs	r5, r0, sl, lsl #4
    1c44:	21cf0042 	biccs	r0, pc, r2, asr #32
    1c48:	9b000049 	blls	0x1d74
    1c4c:	185b18eb 	ldmneda	fp, {r0, r1, r3, r5, r6, r7, fp, ip}^
    1c50:	52990c21 	addpls	r0, r9, #8448	; 0x2100
    1c54:	04001c40 	streq	r1, [r0], #-3136
    1c58:	28050c00 	stmcsda	r5, {sl, fp}
    1c5c:	1c76d3f2 	ldcnel	3, cr13, [r6], #-968
    1c60:	0c360436 	cfldrseq	mvf0, [r6], #-216
    1c64:	d3e22e14 	mvnle	r2, #320	; 0x140
    1c68:	fc46f000 	mcrr2	0, 0, pc, r6, cr0
    1c6c:	d0002801 	andle	r2, r0, r1, lsl #16
    1c70:	1c38e711 	ldcne	7, cr14, [r8], #-68
    1c74:	e35cb00c 	cmp	ip, #12	; 0xc
    1c78:	2000b5f1 	strcsd	fp, [r0], -r1
    1c7c:	60084929 	andvs	r4, r8, r9, lsr #18
    1c80:	60488308 	subvs	r8, r8, r8, lsl #6
    1c84:	61c87688 	bicvs	r7, r8, r8, lsl #13
    1c88:	60c86088 	sbcvs	r6, r8, r8, lsl #1
    1c8c:	4a238408 	bmi	0x8e2cb4
    1c90:	84ca848a 	strhib	r8, [sl], #1162
    1c94:	62c8850a 	sbcvs	r8, r8, #41943040	; 0x2800000
    1c98:	34301c0c 	ldrcct	r1, [r0], #-3084
    1c9c:	702525ff 	strvcd	r2, [r5], -pc
    1ca0:	80607065 	rsbhi	r7, r0, r5, rrx
    1ca4:	4e1e7125 	mufmiep	f7, f6, f5
    1ca8:	28ff7960 	ldmcsia	pc!, {r5, r6, r8, fp, ip, sp, lr}^
    1cac:	2300d011 	tstcs	r0, #17	; 0x11
    1cb0:	31352200 	teqcc	r5, r0, lsl #4
    1cb4:	69372084 	ldmvsdb	r7!, {r2, r7, sp}
    1cb8:	6a7f693f 	bvs	0x1fdc1bc
    1cbc:	f015683f 	andnvs	r6, r5, pc, lsr r8
    1cc0:	7165fa99 	strvcb	pc, [r5, #-169]!
    1cc4:	21002014 	tstcs	r0, r4, lsl r0
    1cc8:	32364a16 	eorccs	r4, r6, #90112	; 0x16000
    1ccc:	52111e80 	andpls	r1, r1, #2048	; 0x800
    1cd0:	2500d1fc 	strcs	sp, [r0, #-508]
    1cd4:	70054668 	andvc	r4, r5, r8, ror #12
    1cd8:	43682015 	cmnmi	r8, #21	; 0x15
    1cdc:	311a1c21 	tstcc	sl, r1, lsr #24
    1ce0:	28005c08 	stmcsda	r0, {r3, sl, fp, ip, lr}
    1ce4:	2300d009 	tstcs	r0, #9	; 0x9
    1ce8:	46692200 	strmibt	r2, [r9], -r0, lsl #4
    1cec:	69372084 	ldmvsdb	r7!, {r2, r7, sp}
    1cf0:	6a7f693f 	bvs	0x1fdc1f4
    1cf4:	f015683f 	andnvs	r6, r5, pc, lsr r8
    1cf8:	1c6dfa7d 	stcnel	10, cr15, [sp], #-500
    1cfc:	0e2d062d 	cfmadda32eq	mvax1, mvax0, mvfx13, mvfx13
    1d00:	d3e72d10 	mvnle	r2, #1024	; 0x400
    1d04:	004020a8 	subeq	r2, r0, r8, lsr #1
    1d08:	4a062100 	bmi	0x18a110
    1d0c:	1e80324a 	cdpne	2, 8, cr3, cr0, cr10, {2}
    1d10:	d1fc5211 	mvnles	r5, r1, lsl r2
    1d14:	bc01bcf8 	stclt	12, cr11, [r1], {248}
    1d18:	00004700 	andeq	r4, r0, r0, lsl #14
    1d1c:	0000ffff 	streqd	pc, [r0], -pc
    1d20:	0000015c 	andeq	r0, r0, ip, asr r1
    1d24:	00008680 	andeq	r8, r0, r0, lsl #13
    1d28:	2100b510 	tstcs	r0, r0, lsl r5
    1d2c:	6900482d 	stmvsdb	r0, {r0, r2, r3, r5, fp, lr}
    1d30:	00ca2400 	sbceq	r2, sl, r0, lsl #8
    1d34:	6a5b6883 	bvs	0x16dbf48
    1d38:	711c189b 	ldrvcb	r1, [ip, -fp]
    1d3c:	6a5b6883 	bvs	0x16dbf50
    1d40:	709c189b 	umullvcs	r1, ip, fp, r8
    1d44:	6a5b6883 	bvs	0x16dbf58
    1d48:	70d4189a 	smullvcs	r1, r4, sl, r8
    1d4c:	06091c49 	streq	r1, [r9], -r9, asr #24
    1d50:	29040e09 	stmcsdb	r4, {r0, r3, r9, sl, fp}
    1d54:	2100d3ed 	smlattcs	r0, sp, r3, sp
    1d58:	434a2214 	cmpmi	sl, #1073741825	; 0x40000001
    1d5c:	6a5b6843 	bvs	0x16dbe70
    1d60:	721c189b 	andvcs	r1, ip, #10158080	; 0x9b0000
    1d64:	6a5b6843 	bvs	0x16dbe78
    1d68:	725c189b 	subvcs	r1, ip, #10158080	; 0x9b0000
    1d6c:	6a5b6843 	bvs	0x16dbe80
    1d70:	805c189b 	ldrhib	r1, [ip], #-139
    1d74:	6a5b6843 	bvs	0x16dbe88
    1d78:	809c189b 	umullhis	r1, ip, fp, r8
    1d7c:	6a5b6843 	bvs	0x16dbe90
    1d80:	80dc189b 	smullhis	r1, ip, fp, r8
    1d84:	6a5b6843 	bvs	0x16dbe98
    1d88:	2301189a 	tstcs	r1, #10092544	; 0x9a0000
    1d8c:	1c497413 	cfstrdne	mvd7, [r9], {19}
    1d90:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    1d94:	d3df2904 	bicles	r2, pc, #65536	; 0x10000
    1d98:	014a2100 	cmpeq	sl, r0, lsl #2
    1d9c:	6a5b6983 	bvs	0x16dc3b0
    1da0:	74dc189b 	ldrvcb	r1, [ip], #2203
    1da4:	6a5b6983 	bvs	0x16dc3b8
    1da8:	769c189b 	undefined
    1dac:	6a5b6983 	bvs	0x16dc3c0
    1db0:	765c189b 	undefined
    1db4:	6a5b6983 	bvs	0x16dc3c8
    1db8:	751c189b 	ldrvc	r1, [ip, #-2203]
    1dbc:	6a5b6983 	bvs	0x16dc3d0
    1dc0:	60dc189b 	smullvss	r1, ip, fp, r8
    1dc4:	6a5b6983 	bvs	0x16dc3d8
    1dc8:	771c189b 	undefined
    1dcc:	6a5b6983 	bvs	0x16dc3e0
    1dd0:	236f189a 	cmncs	pc, #10092544	; 0x9a0000
    1dd4:	1c497493 	cfstrdne	mvd7, [r9], {147}
    1dd8:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    1ddc:	d3dc2903 	bicles	r2, ip, #49152	; 0xc000
    1de0:	0000e016 	andeq	lr, r0, r6, lsl r0
    1de4:	0000015c 	andeq	r0, r0, ip, asr r1
    1de8:	4a90b510 	bmi	0xfe42f230
    1dec:	23146852 	tstcs	r4, #5373952	; 0x520000
    1df0:	18d3434b 	ldmneia	r3, {r0, r1, r3, r6, r8, r9, lr}^
    1df4:	721c24ff 	andvcs	r2, ip, #-16777216	; 0xff000000
    1df8:	2bff7803 	blcs	0xfffdfe0c
    1dfc:	7001d101 	andvc	sp, r1, r1, lsl #2
    1e00:	7843e004 	stmvcda	r3, {r2, sp, lr, pc}^
    1e04:	43632414 	cmnmi	r3, #335544320	; 0x14000000
    1e08:	721118d2 	andvcs	r1, r1, #13762560	; 0xd20000
    1e0c:	46c07041 	strmib	r7, [r0], r1, asr #32
    1e10:	bc01bc10 	stclt	12, cr11, [r1], {16}
    1e14:	00004700 	andeq	r4, r0, r0, lsl #14
    1e18:	7802b5f3 	stmvcda	r2, {r0, r1, r4, r5, r6, r7, r8, sl, ip, sp, pc}
    1e1c:	685b4b83 	ldmvsda	fp, {r0, r1, r7, r8, r9, fp, lr}^
    1e20:	23149300 	tstcs	r4, #0	; 0x0
    1e24:	9c00434b 	stcls	3, cr4, [r0], {75}
    1e28:	23ff18e4 	mvncss	r1, #14942208	; 0xe40000
    1e2c:	d107428a 	smlabble	r7, sl, r2, r4
    1e30:	70017a21 	andvc	r7, r1, r1, lsr #20
    1e34:	78017223 	stmvcda	r1, {r0, r1, r5, r9, ip, sp, lr}
    1e38:	d11629ff 	ldrlesh	r2, [r6, -pc]
    1e3c:	e0147043 	ands	r7, r4, r3, asr #32
    1e40:	43552514 	cmpmi	r5, #83886080	; 0x5000000
    1e44:	19759e00 	ldmnedb	r5!, {r9, sl, fp, ip, pc}^
    1e48:	7a2f466e 	bvc	0xbd3808
    1e4c:	7a2e7137 	bvc	0xb9e330
    1e50:	d106428e 	smlabble	r6, lr, r2, r4
    1e54:	722e7a26 	eorvc	r7, lr, #155648	; 0x26000
    1e58:	78457223 	stmvcda	r5, {r0, r1, r5, r9, ip, sp, lr}^
    1e5c:	d10042a9 	smlatble	r0, r9, r2, r4
    1e60:	466a7042 	strmibt	r7, [sl], -r2, asr #32
    1e64:	2aff7912 	bcs	0xfffe02b4
    1e68:	46c0d1ea 	strmib	sp, [r0], sl, ror #3
    1e6c:	bc01bcfc 	stclt	12, cr11, [r1], {252}
    1e70:	00004700 	andeq	r4, r0, r0, lsl #14
    1e74:	7801b510 	stmvcda	r1, {r4, r8, sl, ip, sp, pc}
    1e78:	42917842 	addmis	r7, r1, #4325376	; 0x420000
    1e7c:	4a6bd00e 	bmi	0x1af5ebc
    1e80:	23146852 	tstcs	r4, #5373952	; 0x520000
    1e84:	18d3434b 	ldmneia	r3, {r0, r1, r3, r6, r8, r9, lr}^
    1e88:	70047a1c 	andvc	r7, r4, ip, lsl sl
    1e8c:	721c24ff 	andvcs	r2, ip, #-16777216	; 0xff000000
    1e90:	24147843 	ldrcs	r7, [r4], #-2115
    1e94:	18d24363 	ldmneia	r2, {r0, r1, r5, r6, r8, r9, lr}^
    1e98:	70417211 	subvc	r7, r1, r1, lsl r2
    1e9c:	0000e7b8 	streqh	lr, [r0], -r8
    1ea0:	1c04b530 	cfstr32ne	mvfx11, [r4], {48}
    1ea4:	20001c0d 	andcs	r1, r0, sp, lsl #24
    1ea8:	29ff7821 	ldmcsib	pc!, {r0, r5, fp, ip, sp, lr}^
    1eac:	7025d101 	eorvc	sp, r5, r1, lsl #2
    1eb0:	1c29e00a 	stcne	0, cr14, [r9], #-40
    1eb4:	303048a9 	eorccs	r4, r0, r9, lsr #17
    1eb8:	ffaef7ff 	swinv	0x00aef7ff
    1ebc:	1c641c29 	stcnel	12, cr1, [r4], #-164
    1ec0:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
    1ec4:	2002ff91 	mulcs	r2, r1, pc
    1ec8:	faa3f7fe 	blx	0xfe8ffec8
    1ecc:	1c04b510 	cfstr32ne	mvfx11, [r4], {16}
    1ed0:	70017841 	andvc	r7, r1, r1, asr #16
    1ed4:	d00729ff 	strled	r2, [r7], -pc
    1ed8:	f7ff1c40 	ldrnvb	r1, [pc, r0, asr #24]!
    1edc:	7821ff9d 	stmvcda	r1!, {r0, r2, r3, r4, r7, r8, r9, sl, fp, ip, sp, lr, pc}
    1ee0:	3030489e 	mlaccs	r0, lr, r8, r4
    1ee4:	ff80f7ff 	swinv	0x0080f7ff
    1ee8:	f82cf003 	stmnvda	ip!, {r0, r1, ip, sp, lr, pc}
    1eec:	1c04b5f0 	cfstr32ne	mvfx11, [r4], {240}
    1ef0:	20001c15 	andcs	r1, r0, r5, lsl ip
    1ef4:	428143c0 	addmi	r4, r1, #3	; 0x3
    1ef8:	4285d101 	addmi	sp, r5, #1073741824	; 0x40000000
    1efc:	1c0ed01b 	stcne	0, cr13, [lr], {27}
    1f00:	4896e015 	ldmmiia	r6, {r0, r2, r4, sp, lr, pc}
    1f04:	21146842 	tstcs	r4, r2, asr #16
    1f08:	18514361 	ldmneda	r1, {r0, r5, r6, r8, r9, lr}^
    1f0c:	5d8968c9 	stcpl	8, cr6, [r9, #804]
    1f10:	434b2314 	cmpmi	fp, #1342177280	; 0x50000000
    1f14:	79d718d2 	ldmvcib	r7, {r1, r4, r6, r7, fp, ip}^
    1f18:	71d71e7f 	bicvcs	r1, r7, pc, ror lr
    1f1c:	18d26842 	ldmneia	r2, {r1, r6, fp, sp, lr}^
    1f20:	2a0079d2 	bcs	0x20670
    1f24:	3030d102 	eorccs	sp, r0, r2, lsl #2
    1f28:	ff5ef7ff 	swinv	0x005ef7ff
    1f2c:	04361c76 	ldreqt	r1, [r6], #-3190
    1f30:	42b51436 	adcmis	r1, r5, #905969664	; 0x36000000
    1f34:	e1fbdae5 	mvns	sp, r5, ror #21
    1f38:	2214b510 	andcss	fp, r4, #67108864	; 0x4000000
    1f3c:	4887434a 	stmmiia	r7, {r1, r3, r6, r8, r9, lr}
    1f40:	189b6843 	ldmneia	fp, {r0, r1, r6, fp, sp, lr}
    1f44:	1e6479dc 	mcrne	9, 3, r7, cr4, cr12, {6}
    1f48:	684371dc 	stmvsda	r3, {r2, r3, r4, r6, r7, r8, ip, sp, lr}^
    1f4c:	79d2189a 	ldmvcib	r2, {r1, r3, r4, r7, fp, ip}^
    1f50:	d1022a00 	tstle	r2, r0, lsl #20
    1f54:	f7ff3030 	undefined
    1f58:	f002ff47 	andnv	pc, r2, r7, asr #30
    1f5c:	0000fff3 	streqd	pc, [r0], -r3
    1f60:	487e1c01 	ldmmida	lr!, {r0, sl, fp, ip}^
    1f64:	42917e82 	addmis	r7, r1, #2080	; 0x820
    1f68:	0fc04180 	swieq	0x00c04180
    1f6c:	00004770 	andeq	r4, r0, r0, ror r7
    1f70:	487ab530 	ldmmida	sl!, {r4, r5, r8, sl, ip, sp, pc}^
    1f74:	31344909 	teqcc	r4, r9, lsl #18
    1f78:	21006101 	tstcs	r0, r1, lsl #2
    1f7c:	4d062200 	sfmmi	f2, 4, [r6]
    1f80:	69040093 	stmvsdb	r4, {r0, r1, r4, r7}
    1f84:	1c5250e5 	mrrcne	0, 14, r5, r2, cr5
    1f88:	019b2380 	orreqs	r2, fp, r0, lsl #7
    1f8c:	d3f7429a 	mvnles	r4, #-1610612727	; 0xa0000009
    1f90:	f7fe6141 	ldrnvb	r6, [lr, r1, asr #2]!
    1f94:	46c0fe33 	undefined
    1f98:	deadbeef 	cdple	14, 10, cr11, cr13, cr15, {7}
    1f9c:	0000064c 	andeq	r0, r0, ip, asr #12
    1fa0:	1c04b5f3 	cfstr32ne	mvfx11, [r4], {243}
    1fa4:	f0001c15 	andnv	r1, r0, r5, lsl ip
    1fa8:	210afed5 	ldrcsd	pc, [sl, -r5]
    1fac:	91004341 	tstls	r0, r1, asr #6
    1fb0:	6af24e1e 	bvs	0xffc95830
    1fb4:	888f1851 	stmhiia	pc, {r0, r4, r6, fp, ip}
    1fb8:	f0001c29 	andnv	r1, r0, r9, lsr #24
    1fbc:	2800f83d 	stmcsda	r0, {r0, r2, r3, r4, r5, fp, ip, sp, lr, pc}
    1fc0:	e035da00 	eors	sp, r5, r0, lsl #20
    1fc4:	1c644669 	stcnel	6, cr4, [r4], #-420
    1fc8:	42bd808c 	adcmis	r8, sp, #140	; 0x8c
    1fcc:	1c2cd215 	sfmne	f5, 1, [ip], #-84
    1fd0:	0c240424 	cfstrseq	mvf0, [r4], #-144
    1fd4:	d2f442bc 	rscles	r4, r4, #-1073741813	; 0xc000000b
    1fd8:	6af19800 	bvs	0xffc67fe0
    1fdc:	88011808 	stmhida	r1, {r3, fp, ip}
    1fe0:	43608840 	cmnmi	r0, #4194304	; 0x400000
    1fe4:	04091809 	streq	r1, [r9], #-2057
    1fe8:	46680c09 	strmibt	r0, [r8], -r9, lsl #24
    1fec:	f0008880 	andnv	r8, r0, r0, lsl #17
    1ff0:	2800f8fb 	stmcsda	r0, {r0, r1, r3, r4, r5, r6, r7, fp, ip, sp, lr, pc}
    1ff4:	1c64dbe5 	stcnel	11, cr13, [r4], #-916
    1ff8:	42afe7ea 	adcmi	lr, pc, #61341696	; 0x3a80000
    1ffc:	1c3cd2e1 	lfmne	f5, 1, [ip], #-900
    2000:	0c240424 	cfstrseq	mvf0, [r4], #-144
    2004:	d2dc42ac 	sbcles	r4, ip, #-1073741814	; 0xc000000a
    2008:	6af19800 	bvs	0xffc68010
    200c:	88011808 	stmhida	r1, {r3, fp, ip}
    2010:	43608840 	cmnmi	r0, #4194304	; 0x400000
    2014:	04091809 	streq	r1, [r9], #-2057
    2018:	46680c09 	strmibt	r0, [r8], -r9, lsl #24
    201c:	f0008880 	andnv	r8, r0, r0, lsl #17
    2020:	2800f89f 	stmcsda	r0, {r0, r1, r2, r3, r4, r7, fp, ip, sp, lr, pc}
    2024:	1c64dbcd 	stcnel	11, cr13, [r4], #-820
    2028:	0000e7ea 	andeq	lr, r0, sl, ror #15
    202c:	00008680 	andeq	r8, r0, r0, lsl #13
    2030:	bc02bcfc 	stclt	12, cr11, [r2], {252}
    2034:	00004708 	andeq	r4, r0, r8, lsl #14
    2038:	b081b5f1 	strltd	fp, [r1], r1
    203c:	46681c0c 	strmibt	r1, [r8], -ip, lsl #24
    2040:	200a8885 	andcs	r8, sl, r5, lsl #17
    2044:	4e454345 	cdpmi	3, 4, cr4, cr5, cr5, {2}
    2048:	19416af0 	stmnedb	r1, {r4, r5, r6, r7, r9, fp, sp, lr}^
    204c:	42a2888a 	adcmi	r8, r2, #9043968	; 0x8a0000
    2050:	2000d101 	andcs	sp, r0, r1, lsl #2
    2054:	4294e07e 	addmis	lr, r4, #126	; 0x7e
    2058:	808cd201 	addhi	sp, ip, r1, lsl #4
    205c:	466ae7f9 	undefined
    2060:	4363884b 	cmnmi	r3, #4915200	; 0x4b0000
    2064:	8bf28013 	blhi	0xffca20b8
    2068:	880f4bb4 	stmhida	pc, {r2, r4, r5, r7, r8, r9, fp, lr}
    206c:	d011429f 	mulles	r1, pc, r2
    2070:	429f890f 	addmis	r8, pc, #245760	; 0x3c000
    2074:	890bd006 	stmhidb	fp, {r1, r2, ip, lr, pc}
    2078:	437b270a 	cmnmi	fp, #2621440	; 0x280000
    207c:	880b5ac0 	stmhida	fp, {r6, r7, r9, fp, ip, lr}
    2080:	e0011ac0 	and	r1, r1, r0, asr #21
    2084:	1a108808 	bne	0x4240ac
    2088:	881b466b 	ldmhida	fp, {r0, r1, r3, r5, r6, r9, sl, lr}
    208c:	0c000400 	cfstrseq	mvf0, [r0], {0}
    2090:	d2e24298 	rscle	r4, r2, #-2147483639	; 0x80000009
    2094:	1c036970 	stcne	9, cr6, [r3], {112}
    2098:	42382703 	eormis	r2, r8, #786432	; 0xc0000
    209c:	1d1bd004 	ldcne	0, cr13, [fp, #-16]
    20a0:	0f800780 	swieq	0x00800780
    20a4:	61701a18 	cmnvs	r0, r8, lsl sl
    20a8:	0f801050 	swieq	0x00801050
    20ac:	1c181883 	ldcne	8, cr1, [r8], {131}
    20b0:	1a1043b8 	bne	0x412f98
    20b4:	4828d003 	stmmida	r8!, {r0, r1, ip, lr, pc}
    20b8:	1d004018 	stcne	0, cr4, [r0, #-96]
    20bc:	697083f0 	ldmvsdb	r0!, {r4, r5, r6, r7, r8, r9, pc}^
    20c0:	8812466a 	ldmhida	r2, {r1, r3, r5, r6, r9, sl, lr}
    20c4:	23801882 	orrcs	r1, r0, #8519680	; 0x820000
    20c8:	429a021b 	addmis	r0, sl, #-1342177279	; 0xb0000001
    20cc:	2004d302 	andcs	sp, r4, r2, lsl #6
    20d0:	e03f43c0 	eors	r4, pc, r0, asr #7
    20d4:	181f6933 	ldmneda	pc, {r0, r1, r4, r5, r8, fp, sp, lr}
    20d8:	8bf06172 	blhi	0xffc1a6a8
    20dc:	8812466a 	ldmhida	r2, {r1, r3, r5, r6, r9, sl, lr}
    20e0:	83f01880 	mvnhis	r1, #8388608	; 0x800000
    20e4:	8888884a 	stmhiia	r8, {r1, r3, r6, fp, pc}
    20e8:	04124342 	ldreq	r4, [r2], #-834
    20ec:	88080c12 	stmhida	r8, {r1, r4, sl, fp}
    20f0:	180968f1 	stmneda	r9, {r0, r4, r5, r6, r7, fp, sp, lr}
    20f4:	f0121c38 	andnvs	r1, r2, r8, lsr ip
    20f8:	4668ff4f 	strmibt	pc, [r8], -pc, asr #30
    20fc:	210a8880 	smlabbcs	sl, r0, r8, r8
    2100:	49164348 	ldmmidb	r6, {r3, r6, r8, r9, lr}
    2104:	18086ac9 	stmneda	r8, {r0, r3, r6, r7, r9, fp, sp, lr}
    2108:	46688842 	strmibt	r8, [r8], -r2, asr #16
    210c:	210a8880 	smlabbcs	sl, r0, r8, r8
    2110:	49124348 	ldmmidb	r2, {r3, r6, r8, r9, lr}
    2114:	18086ac9 	stmneda	r8, {r0, r3, r6, r7, r9, fp, sp, lr}
    2118:	43428880 	cmpmi	r2, #8388608	; 0x800000
    211c:	0c120412 	cfldrseq	mvf0, [r2], {18}
    2120:	466920ff 	undefined
    2124:	230a8889 	tstcs	sl, #8978432	; 0x890000
    2128:	4b0c4359 	blmi	0x312e94
    212c:	5a596adb 	bpl	0x165cca0
    2130:	68db4b0a 	ldmvsia	fp, {r1, r3, r8, r9, fp, lr}^
    2134:	2a001859 	bcs	0x82a0
    2138:	1e52d002 	cdpne	0, 5, cr13, cr2, cr2, {0}
    213c:	d1fc5488 	mvnles	r5, r8, lsl #9
    2140:	19406af0 	stmnedb	r0, {r4, r5, r6, r7, r9, fp, sp, lr}^
    2144:	1a7968f1 	bne	0x1e5c510
    2148:	80848001 	addhi	r8, r4, r1
    214c:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    2150:	f99cf000 	ldmnvib	ip, {ip, sp, lr, pc}
    2154:	0000e76c 	andeq	lr, r0, ip, ror #14
    2158:	0000fffc 	streqd	pc, [r0], -ip
    215c:	00008680 	andeq	r8, r0, r0, lsl #13
    2160:	b081b5f3 	strltd	fp, [r1], r3
    2164:	24012700 	strcs	r2, [r1], #-1792
    2168:	e00d2500 	and	r2, sp, r0, lsl #10
    216c:	0c360436 	cfldrseq	mvf0, [r6], #-216
    2170:	68c04871 	stmvsia	r0, {r0, r4, r5, r6, fp, lr}^
    2174:	88094669 	stmhida	r9, {r0, r3, r5, r6, r9, sl, lr}
    2178:	1c6d5381 	stcnel	3, cr5, [sp], #-516
    217c:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    2180:	0c240424 	cfstrseq	mvf0, [r4], #-144
    2184:	d22942a5 	eorle	r4, r9, #1342177290	; 0x5000000a
    2188:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    218c:	04301946 	ldreqt	r1, [r0], #-2374
    2190:	f0000c00 	andnv	r0, r0, r0, lsl #24
    2194:	2808fb5f 	stmcsda	r8, {r0, r1, r2, r3, r4, r6, r8, r9, fp, ip, sp, lr, pc}
    2198:	4668d105 	strmibt	sp, [r8], -r5, lsl #2
    219c:	f0008880 	andnv	r8, r0, r0, lsl #17
    21a0:	1824fdcf 	stmneda	r4!, {r0, r1, r2, r3, r6, r7, r8, sl, fp, ip, sp, lr, pc}
    21a4:	2807e7e9 	stmcsda	r7, {r0, r3, r5, r6, r7, r8, r9, sl, sp, lr, pc}
    21a8:	0430d1e7 	ldreqt	sp, [r0], #-487
    21ac:	f0000c00 	andnv	r0, r0, r0, lsl #24
    21b0:	2102f92f 	tstcsp	r2, pc, lsr #18
    21b4:	8892466a 	ldmhiia	r2, {r1, r3, r5, r6, r9, sl, lr}
    21b8:	00921952 	addeqs	r1, r2, r2, asr r9
    21bc:	689b4b5e 	ldmvsia	fp, {r1, r2, r3, r4, r6, r8, r9, fp, lr}
    21c0:	5e51189a 	mrcpl	8, 2, r1, cr1, cr10, {4}
    21c4:	8912466a 	ldmhidb	r2, {r1, r3, r5, r6, r9, sl, lr}
    21c8:	0432188e 	ldreqt	r1, [r2], #-2190
    21cc:	1c010c12 	stcne	12, cr0, [r1], {18}
    21d0:	f0004668 	andnv	r4, r0, r8, ror #12
    21d4:	1c07f859 	stcne	8, cr15, [r7], {89}
    21d8:	dac72800 	ble	0xff1cc1e0
    21dc:	46c01c38 	undefined
    21e0:	bc02bcfe 	stclt	12, cr11, [r2], {254}
    21e4:	00004708 	andeq	r4, r0, r8, lsl #14
    21e8:	b082b5f2 	strltd	fp, [r2], r2
    21ec:	26001c07 	strcs	r1, [r0], -r7, lsl #24
    21f0:	fb30f000 	blx	0xc3e1fa
    21f4:	1c79466a 	ldcnel	6, cr4, [r9], #-424
    21f8:	25008011 	strcs	r8, [r0, #-17]
    21fc:	d12a2807 	teqle	sl, r7, lsl #16
    2200:	89014668 	stmhidb	r1, {r3, r5, r6, r9, sl, lr}
    2204:	f0001c38 	andnv	r1, r0, r8, lsr ip
    2208:	1c07fda5 	stcne	13, cr15, [r7], {165}
    220c:	4378200a 	cmnmi	r8, #10	; 0xa
    2210:	49499001 	stmmidb	r9, {r0, ip, pc}^
    2214:	18086ac9 	stmneda	r8, {r0, r3, r6, r7, r9, fp, sp, lr}
    2218:	e0008884 	and	r8, r0, r4, lsl #17
    221c:	042d1c6d 	streqt	r1, [sp], #-3181
    2220:	42a50c2d 	adcmi	r0, r5, #11520	; 0x2d00
    2224:	9801d212 	stmlsda	r1, {r1, r4, r9, ip, lr, pc}
    2228:	6ac94943 	bvs	0xff25473c
    222c:	88011808 	stmhida	r1, {r3, fp, ip}
    2230:	43688840 	cmnmi	r8, #4194304	; 0x400000
    2234:	04091809 	streq	r1, [r9], #-2057
    2238:	46680c09 	strmibt	r0, [r8], -r9, lsl #24
    223c:	f7ff8800 	ldrnvb	r8, [pc, r0, lsl #16]!
    2240:	1c06ffd3 	stcne	15, cr15, [r6], {211}
    2244:	dae92800 	ble	0xffa4c24c
    2248:	e7c91c30 	undefined
    224c:	f0001c38 	andnv	r1, r0, r8, lsr ip
    2250:	1c06f84b 	stcne	8, cr15, [r6], {75}
    2254:	2808e7f8 	stmcsda	r8, {r3, r4, r5, r6, r7, r8, r9, sl, sp, lr, pc}
    2258:	1c38d1f6 	ldfned	f5, [r8], #-984
    225c:	fd70f000 	ldc2l	0, cr15, [r0]
    2260:	46681c04 	strmibt	r1, [r8], -r4, lsl #24
    2264:	042d8807 	streqt	r8, [sp], #-2055
    2268:	42a50c2d 	adcmi	r0, r5, #11520	; 0x2d00
    226c:	4668d2ec 	strmibt	sp, [r8], -ip, ror #5
    2270:	19788901 	ldmnedb	r8!, {r0, r8, fp, pc}^
    2274:	0c000400 	cfstrseq	mvf0, [r0], {0}
    2278:	ffb6f7ff 	swinv	0x00b6f7ff
    227c:	28001c06 	stmcsda	r0, {r1, r2, sl, fp, ip}
    2280:	1c6ddbe2 	stcnel	11, cr13, [sp], #-904
    2284:	0000e7ef 	andeq	lr, r0, pc, ror #15
    2288:	1c04b5f2 	cfstr32ne	mvfx11, [r4], {242}
    228c:	4e2b1c15 	mcrmi	12, 1, r1, cr11, cr5, {0}
    2290:	8d384f29 	ldchi	15, cr4, [r8, #-164]!
    2294:	d10542b0 	strleh	r4, [r5, -r0]
    2298:	f0002005 	andnv	r2, r0, r5
    229c:	2800f851 	stmcsda	r0, {r0, r4, r6, fp, ip, sp, lr, pc}
    22a0:	e0b1da00 	adcs	sp, r1, r0, lsl #20
    22a4:	80208d38 	eorhi	r8, r0, r8, lsr sp
    22a8:	4341210a 	cmpmi	r1, #-2147483646	; 0x80000002
    22ac:	18516afa 	ldmneda	r1, {r1, r3, r4, r5, r6, r7, r9, fp, sp, lr}^
    22b0:	85398909 	ldrhi	r8, [r9, #-2313]!
    22b4:	f90ef000 	stmnvdb	lr, {ip, sp, lr, pc}
    22b8:	88226af9 	stmhida	r2!, {r0, r3, r4, r5, r6, r7, r9, fp, sp, lr}
    22bc:	435a230a 	cmpmi	sl, #671088640	; 0x28000000
    22c0:	8822528e 	stmhida	r2!, {r1, r2, r3, r7, r9, ip, lr}
    22c4:	188a435a 	stmneia	sl, {r1, r3, r4, r6, r8, r9, lr}
    22c8:	881b466b 	ldmhida	fp, {r0, r1, r3, r5, r6, r9, sl, lr}
    22cc:	88228053 	stmhida	r2!, {r0, r1, r4, r6, pc}
    22d0:	435a230a 	cmpmi	sl, #671088640	; 0x28000000
    22d4:	2300188a 	tstcs	r0, #9043968	; 0x8a0000
    22d8:	88228093 	stmhida	r2!, {r0, r1, r4, r7, pc}
    22dc:	435a230a 	cmpmi	sl, #671088640	; 0x28000000
    22e0:	80cd1889 	sbchi	r1, sp, r9, lsl #17
    22e4:	0000e7dd 	ldreqd	lr, [r0], -sp
    22e8:	4913b5f0 	ldmmidb	r3, {r4, r5, r6, r7, r8, sl, ip, sp, pc}
    22ec:	230a6aca 	tstcs	sl, #827392	; 0xca000
    22f0:	18d34343 	ldmneia	r3, {r0, r1, r6, r8, r9, lr}^
    22f4:	809c2400 	addhis	r2, ip, r0, lsl #8
    22f8:	4c10805c 	ldcmi	0, cr8, [r0], {92}
    22fc:	80dc801c 	sbchis	r8, ip, ip, lsl r0
    2300:	42a88c8d 	adcmi	r8, r8, #36096	; 0x8d00
    2304:	891ad103 	ldmhidb	sl, {r0, r1, r8, ip, lr, pc}
    2308:	e00e848a 	and	r8, lr, sl, lsl #9
    230c:	42a58935 	adcmi	r8, r5, #868352	; 0xd4000
    2310:	260ad00b 	strcs	sp, [sl], -fp
    2314:	1996436e 	ldmneib	r6, {r1, r2, r3, r5, r6, r8, r9, lr}
    2318:	42878937 	addmi	r8, r7, #901120	; 0xdc000
    231c:	891ad1f6 	ldmhidb	sl, {r1, r2, r4, r5, r6, r7, r8, ip, lr, pc}
    2320:	8cca8132 	stfhip	f0, [sl], {50}
    2324:	d1004290 	strleb	r4, [r0, -r0]
    2328:	8d0a84cd 	cfstrshi	mvf8, [sl, #-820]
    232c:	8508811a 	strhi	r8, [r8, #-282]
    2330:	bcf02000 	ldcltl	0, cr2, [r0]
    2334:	4708bc02 	strmi	fp, [r8, -r2, lsl #24]
    2338:	00008680 	andeq	r8, r0, r0, lsl #13
    233c:	0000ffff 	streqd	pc, [r0], -pc
    2340:	4cbeb5f1 	cfldr32mi	mvfx11, [lr], #964
    2344:	466a6ae1 	strmibt	r6, [sl], -r1, ror #21
    2348:	8013888b 	andhis	r8, r3, fp, lsl #17
    234c:	18158812 	ldmneda	r5, {r1, r4, fp, pc}
    2350:	436a884a 	cmnmi	sl, #4849664	; 0x4a0000
    2354:	1c036960 	stcne	9, cr6, [r3], {96}
    2358:	42302603 	eormis	r2, r0, #3145728	; 0x300000
    235c:	1d1bd004 	ldcne	0, cr13, [fp, #-16]
    2360:	0f800780 	swieq	0x00800780
    2364:	61601a18 	cmnvs	r0, r8, lsl sl
    2368:	10588be3 	subnes	r8, r8, r3, ror #23
    236c:	18c60f80 	stmneia	r6, {r7, r8, r9, sl, fp}^
    2370:	27031c30 	smladxcs	r3, r0, ip, r1
    2374:	1a1843b8 	bne	0x61325c
    2378:	48b2d003 	ldmmiia	r2!, {r0, r1, ip, lr, pc}
    237c:	1d004030 	stcne	0, cr4, [r0, #-192]
    2380:	696383e0 	stmvsdb	r3!, {r5, r6, r7, r8, r9, pc}^
    2384:	0c120412 	cfldrseq	mvf0, [r2], {18}
    2388:	26801898 	pkhbtcs	r1, r0, r8, LSL #17
    238c:	42b00236 	adcmis	r0, r0, #1610612739	; 0x60000003
    2390:	2004d302 	andcs	sp, r4, r2, lsl #6
    2394:	e03743c0 	eors	r4, r7, r0, asr #7
    2398:	18f66926 	ldmneia	r6!, {r1, r2, r5, r8, fp, sp, lr}^
    239c:	8be06160 	blhi	0xff81a924
    23a0:	83e01880 	mvnhi	r1, #8388608	; 0x800000
    23a4:	8888884a 	stmhiia	r8, {r1, r3, r6, fp, pc}
    23a8:	04124342 	ldreq	r4, [r2], #-834
    23ac:	1c300c12 	ldcne	12, cr0, [r0], #-72
    23b0:	fdf2f012 	ldc2l	0, cr15, [r2, #72]!
    23b4:	48a262e6 	stmmiia	r2!, {r1, r2, r5, r6, r7, r9, sp, lr}
    23b8:	83411a31 	cmphi	r1, #200704	; 0x31000
    23bc:	68e16ae0 	stmvsia	r1!, {r5, r6, r7, r9, fp, sp, lr}^
    23c0:	80011a71 	andhi	r1, r1, r1, ror sl
    23c4:	80856ae0 	addhi	r6, r5, r0, ror #21
    23c8:	1829489f 	stmneda	r9!, {r0, r1, r2, r3, r4, r7, fp, lr}
    23cc:	e0122500 	ands	r2, r2, r0, lsl #10
    23d0:	434a220a 	cmpmi	sl, #-1610612736	; 0xa0000000
    23d4:	52986ae3 	addpls	r6, r8, #929792	; 0xe3000
    23d8:	189b6ae3 	ldmneia	fp, {r0, r1, r5, r6, r7, r9, fp, sp, lr}
    23dc:	6ae3805d 	bvs	0xff8e2558
    23e0:	809d189b 	umullhis	r1, sp, fp, r8
    23e4:	189b6ae3 	ldmneia	fp, {r0, r1, r5, r6, r7, r9, fp, sp, lr}
    23e8:	6ae380d8 	bvs	0xff8e2750
    23ec:	8d23189a 	stchi	8, cr1, [r3, #-616]!
    23f0:	85218113 	strhi	r8, [r1, #-275]!
    23f4:	466a1809 	strmibt	r1, [sl], -r9, lsl #16
    23f8:	04098812 	streq	r8, [r9], #-2066
    23fc:	42910c09 	addmis	r0, r1, #2304	; 0x900
    2400:	2000d2e6 	andcs	sp, r0, r6, ror #5
    2404:	f842f000 	stmnvda	r2, {ip, sp, lr, pc}^
    2408:	bc02bcf8 	stclt	12, cr11, [r2], {248}
    240c:	00004708 	andeq	r4, r0, r8, lsl #14
    2410:	2401b5f1 	strcs	fp, [r1], #-1521
    2414:	26002500 	strcs	r2, [r0], -r0, lsl #10
    2418:	1c404669 	mcrrne	6, 6, r4, r0, cr9
    241c:	27008048 	strcs	r8, [r0, -r8, asr #32]
    2420:	46694668 	strmibt	r4, [r9], -r8, ror #12
    2424:	19c98849 	stmneib	r9, {r0, r3, r6, fp, pc}^
    2428:	88008001 	stmhida	r0, {r0, pc}
    242c:	fa12f000 	blx	0x4be434
    2430:	d1052808 	tstle	r5, r8, lsl #16
    2434:	88004668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}
    2438:	fc82f000 	stc2	0, cr15, [r2], {0}
    243c:	e0101824 	ands	r1, r0, r4, lsr #16
    2440:	fa6cf000 	blx	0x1b3e448
    2444:	042d1c02 	streqt	r1, [sp], #-3074
    2448:	1c280c2d 	stcne	12, cr0, [r8], #-180
    244c:	f0151c11 	andnvs	r1, r5, r1, lsl ip
    2450:	2800fa5d 	stmcsda	r0, {r0, r2, r3, r4, r6, r9, fp, ip, sp, lr, pc}
    2454:	18a9d001 	stmneia	r9!, {r0, ip, lr, pc}
    2458:	18ad1a0d 	stmneia	sp!, {r0, r2, r3, r9, fp, ip}
    245c:	d2004296 	andle	r4, r0, #1610612745	; 0x60000009
    2460:	1c7f1c16 	ldcnel	12, cr1, [pc], #-88
    2464:	0c3f043f 	cfldrseq	mvf0, [pc], #-252
    2468:	0c240424 	cfstrseq	mvf0, [r4], #-144
    246c:	d3d742a7 	bicles	r4, r7, #1879048202	; 0x7000000a
    2470:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    2474:	1c311c28 	ldcne	12, cr1, [r1], #-160
    2478:	fa48f015 	blx	0x123e4d4
    247c:	d0012800 	andle	r2, r1, r0, lsl #16
    2480:	1a0d19a9 	bne	0x348b2c
    2484:	0c000428 	cfstrseq	mvf0, [r0], {40}
    2488:	0000e7be 	streqh	lr, [r0], -lr
    248c:	4919b5f0 	ldmmidb	r9, {r4, r5, r6, r7, r8, sl, ip, sp, pc}
    2490:	42908cca 	addmis	r8, r0, #51712	; 0xca00
    2494:	e74bd100 	strb	sp, [fp, -r0, lsl #2]
    2498:	240a6acb 	strcs	r6, [sl], #-2763
    249c:	191c4344 	ldmnedb	ip, {r2, r6, r8, r9, lr}
    24a0:	4d698c8e 	stcmil	12, cr8, [r9, #-568]!
    24a4:	d10342b0 	strleh	r4, [r3, -r0]
    24a8:	848e8926 	strhi	r8, [lr], #2342
    24ac:	8936e00a 	ldmhidb	r6!, {r1, r3, sp, lr, pc}
    24b0:	d00742ae 	andle	r4, r7, lr, lsr #5
    24b4:	437e270a 	cmnmi	lr, #2621440	; 0x280000
    24b8:	8937199e 	ldmhidb	r7!, {r1, r2, r3, r4, r7, r8, fp, ip}
    24bc:	d1f64287 	mvnles	r4, r7, lsl #5
    24c0:	81378927 	teqhi	r7, r7, lsr #18
    24c4:	240a8125 	strcs	r8, [sl], #-293
    24c8:	189a4362 	ldmneia	sl, {r1, r5, r6, r8, r9, lr}
    24cc:	84c88110 	strhib	r8, [r8], #272
    24d0:	0000e7e1 	andeq	lr, r0, r1, ror #15
    24d4:	4907b410 	stmmidb	r7, {r4, sl, ip, sp, pc}
    24d8:	8ccb6aca 	fstmiashi	fp, {s13-s214}
    24dc:	4363240a 	cmnmi	r3, #167772160	; 0xa000000
    24e0:	811818d3 	ldrhisb	r1, [r8, -r3]
    24e4:	436084c8 	cmnmi	r0, #-939524096	; 0xc8000000
    24e8:	49571810 	ldmmidb	r7, {r4, fp, ip}^
    24ec:	20008101 	andcs	r8, r0, r1, lsl #2
    24f0:	4770bc10 	undefined
    24f4:	00008680 	andeq	r8, r0, r0, lsl #13
    24f8:	2400b570 	strcs	fp, [r0], #-1392
    24fc:	484f2200 	stmmida	pc, {r9, sp}^
    2500:	49518c83 	ldmmidb	r1, {r0, r1, r7, sl, fp, pc}^
    2504:	1c52e001 	mrrcne	0, 0, lr, r2, cr1
    2508:	6ac5892b 	bvs	0xff1649bc
    250c:	d011428b 	andles	r4, r1, fp, lsl #5
    2510:	435e260a 	cmpmi	lr, #10485760	; 0xa00000
    2514:	882e19ad 	stmhida	lr!, {r0, r2, r3, r5, r7, r8, fp, ip}
    2518:	d004428e 	andle	r4, r4, lr, lsl #5
    251c:	d20142a6 	andle	r4, r1, #1610612746	; 0x6000000a
    2520:	e0182000 	ands	r2, r8, r0
    2524:	892e1c34 	stmhidb	lr!, {r2, r4, r5, sl, fp, ip}
    2528:	d1ec428e 	mvnle	r4, lr, lsl #5
    252c:	42b38cc6 	adcmis	r8, r3, #50688	; 0xc600
    2530:	e7f5d0e9 	ldrb	sp, [r5, r9, ror #1]!
    2534:	e0048d03 	and	r8, r4, r3, lsl #26
    2538:	200a1c52 	andcs	r1, sl, r2, asr ip
    253c:	18e84343 	stmneia	r8!, {r0, r1, r6, r8, r9, lr}^
    2540:	428b8903 	addmi	r8, fp, #49152	; 0xc000
    2544:	88a8d1f8 	stmhiia	r8!, {r3, r4, r5, r6, r7, r8, ip, lr, pc}
    2548:	0c120412 	cfldrseq	mvf0, [r2], {18}
    254c:	d0014282 	andle	r4, r1, r2, lsl #5
    2550:	e0002000 	and	r2, r0, r0
    2554:	f0022001 	andnv	r2, r2, r1
    2558:	0000fbaf 	andeq	pc, r0, pc, lsr #23
    255c:	4c37b5f1 	cfldr32mi	mvfx11, [r7], #-964
    2560:	8ca68c25 	stchi	12, cr8, [r6], #148
    2564:	8800e020 	stmhida	r0, {r5, sp, lr, pc}
    2568:	88494669 	stmhida	r9, {r0, r3, r5, r6, r9, sl, lr}^
    256c:	0c090409 	cfstrseq	mvf0, [r9], {9}
    2570:	040022ff 	streq	r2, [r0], #-767
    2574:	4b310c00 	blmi	0xc4557c
    2578:	181868db 	ldmneda	r8, {r0, r1, r3, r4, r6, r7, fp, sp, lr}
    257c:	d0022900 	andle	r2, r2, r0, lsl #18
    2580:	54421e49 	strplb	r1, [r2], #-3657
    2584:	2e00d1fc 	mcrcs	1, 0, sp, cr0, cr12, {7}
    2588:	68e0d106 	stmvsia	r0!, {r1, r2, r8, ip, lr, pc}^
    258c:	62e01940 	rscvs	r1, r0, #1048576	; 0x100000
    2590:	6ae1482b 	bvs	0xff854644
    2594:	83411a09 	cmphi	r1, #36864	; 0x9000
    2598:	53c56ae0 	bicpl	r6, r5, #917504	; 0xe0000
    259c:	88404668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}^
    25a0:	6ae0182d 	bvs	0xff80865c
    25a4:	890619c0 	stmhidb	r6, {r6, r7, r8, fp, ip}
    25a8:	42864827 	addmi	r4, r6, #2555904	; 0x270000
    25ac:	042dd03a 	streqt	sp, [sp], #-58
    25b0:	10680c2d 	rsbne	r0, r8, sp, lsr #24
    25b4:	19420f80 	stmnedb	r2, {r7, r8, r9, sl, fp}^
    25b8:	23031c10 	tstcs	r3, #4096	; 0x1000
    25bc:	1a284398 	bne	0xa13424
    25c0:	4d20d002 	stcmi	0, cr13, [r0, #-8]!
    25c4:	1d2d4015 	stcne	0, cr4, [sp, #-84]!
    25c8:	4377270a 	cmnmi	r7, #2621440	; 0x280000
    25cc:	19c06ae0 	stmneib	r0, {r5, r6, r7, r9, fp, sp, lr}^
    25d0:	88024669 	stmhida	r2, {r0, r3, r5, r6, r9, sl, lr}
    25d4:	8809800a 	stmhida	r9, {r1, r3, pc}
    25d8:	42914a1b 	addmis	r4, r1, #110592	; 0x1b000
    25dc:	4669d0e1 	strmibt	sp, [r9], -r1, ror #1
    25e0:	88808842 	stmhiia	r0, {r1, r6, fp, pc}
    25e4:	804a4342 	subhi	r4, sl, r2, asr #6
    25e8:	88004668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}
    25ec:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    25f0:	d0d342a8 	sbcles	r4, r3, r8, lsr #5
    25f4:	884a68e0 	stmhida	sl, {r5, r6, r7, fp, sp, lr}^
    25f8:	18418809 	stmneda	r1, {r0, r3, fp, pc}^
    25fc:	f0121940 	andnvs	r1, r2, r0, asr #18
    2600:	4668fccb 	strmibt	pc, [r8], -fp, asr #25
    2604:	46698800 	strmibt	r8, [r9], -r0, lsl #16
    2608:	18698849 	stmneda	r9!, {r0, r3, r6, fp, pc}^
    260c:	46684288 	strmibt	r4, [r8], -r8, lsl #5
    2610:	8840daa9 	stmhida	r0, {r0, r3, r5, r7, r9, fp, ip, lr, pc}^
    2614:	46691828 	strmibt	r1, [r9], -r8, lsr #16
    2618:	1a098849 	bne	0x264744
    261c:	8812466a 	ldmhida	r2, {r1, r3, r5, r6, r9, sl, lr}
    2620:	e7a31889 	str	r1, [r3, r9, lsl #17]!
    2624:	1b418be0 	blne	0x10655ac
    2628:	04096962 	streq	r6, [r9], #-2402
    262c:	1a520c09 	bne	0x1485658
    2630:	1a406162 	bne	0x101abc0
    2634:	200083e0 	andcs	r8, r0, r0, ror #7
    2638:	0000e6e6 	andeq	lr, r0, r6, ror #13
    263c:	00008680 	andeq	r8, r0, r0, lsl #13
    2640:	0000064c 	andeq	r0, r0, ip, asr #12
    2644:	0000fffc 	streqd	pc, [r0], -ip
    2648:	0000ffff 	streqd	pc, [r0], -pc
    264c:	9900b5f6 	stmlsdb	r0, {r1, r2, r4, r5, r6, r7, r8, sl, ip, sp, pc}
    2650:	d1022900 	tstle	r2, r0, lsl #18
    2654:	43c02000 	bicmi	r2, r0, #0	; 0x0
    2658:	2814e061 	ldmcsda	r4, {r0, r5, r6, sp, lr, pc}
    265c:	2011d301 	andcss	sp, r1, r1, lsl #6
    2660:	4a96e7f9 	bmi	0xfe5bc64c
    2664:	312c1c11 	teqcc	ip, r1, lsl ip
    2668:	2bff7a4b 	blcs	0xfffe0f9c
    266c:	2013d102 	andcss	sp, r3, r2, lsl #2
    2670:	e05443c0 	subs	r4, r4, r0, asr #7
    2674:	889b466b 	ldmhiia	fp, {r0, r1, r3, r5, r6, r9, sl, lr}
    2678:	d3012b3c 	tstle	r1, #61440	; 0xf000
    267c:	e7ea2012 	undefined
    2680:	4358230e 	cmpmi	r8, #939524096	; 0x38000000
    2684:	20cd1814 	sbccs	r1, sp, r4, lsl r8
    2688:	18250040 	stmneda	r5!, {r6}
    268c:	007626cf 	rsbeqs	r2, r6, pc, asr #13
    2690:	00408868 	subeq	r8, r0, r8, ror #16
    2694:	5b801820 	blpl	0xfe00871c
    2698:	d0242800 	eorle	r2, r4, r0, lsl #16
    269c:	00408868 	subeq	r8, r0, r8, ror #16
    26a0:	5b801820 	blpl	0xfe008728
    26a4:	88896809 	stmhiia	r9, {r0, r3, fp, sp, lr}
    26a8:	d21c4288 	andles	r4, ip, #-2147483640	; 0x80000008
    26ac:	1c408828 	mcrrne	8, 2, r8, r0, cr8
    26b0:	f0152105 	andnvs	r2, r5, r5, lsl #2
    26b4:	8028f92b 	eorhi	pc, r8, fp, lsr #18
    26b8:	88814668 	stmhiia	r1, {r3, r5, r6, r9, sl, lr}
    26bc:	00408868 	subeq	r8, r0, r8, ror #16
    26c0:	5b801820 	blpl	0xfe008748
    26c4:	fcb8f7ff 	ldc2	7, cr15, [r8], #1020
    26c8:	28001c07 	stmcsda	r0, {r0, r1, r2, sl, fp, ip}
    26cc:	da158868 	ble	0x564874
    26d0:	18200040 	stmneda	r0!, {r6}
    26d4:	f7ff5b80 	ldrnvb	r5, [pc, r0, lsl #23]!
    26d8:	8868fe07 	stmhida	r8!, {r0, r1, r2, r9, sl, fp, ip, sp, lr, pc}^
    26dc:	18200040 	stmneda	r0!, {r6}
    26e0:	53814957 	orrpl	r4, r1, #1425408	; 0x15c000
    26e4:	4a56e01a 	bmi	0x15ba754
    26e8:	88682101 	stmhida	r8!, {r0, r8, sp}^
    26ec:	18200040 	stmneda	r0!, {r6}
    26f0:	f7ff1980 	ldrnvb	r1, [pc, r0, lsl #19]!
    26f4:	2800fdc9 	stmcsda	r0, {r0, r3, r6, r7, r8, sl, fp, ip, sp, lr, pc}
    26f8:	e010dade 	ldrsb	sp, [r0], -lr
    26fc:	18200040 	stmneda	r0!, {r6}
    2700:	f0005b80 	andnv	r5, r0, r0, lsl #23
    2704:	4669f951 	undefined
    2708:	9900888a 	stmlsdb	r0, {r1, r3, r7, fp, pc}
    270c:	fc44f012 	mcrr2	0, 1, pc, r4, cr2
    2710:	1c408868 	mcrrne	8, 6, r8, r0, cr8
    2714:	f0152105 	andnvs	r2, r5, r5, lsl #2
    2718:	8068f8f9 	strhid	pc, [r8], #-137
    271c:	e4871c38 	str	r1, [r7], #3128
    2720:	2900b510 	stmcsdb	r0, {r4, r8, sl, ip, sp, pc}
    2724:	2000d102 	andcs	sp, r0, r2, lsl #2
    2728:	e02b43c0 	eor	r4, fp, r0, asr #7
    272c:	1c1a4b63 	ldcne	11, cr4, [sl], {99}
    2730:	7a54322c 	bvc	0x150efe8
    2734:	d1032cff 	strled	r2, [r3, -pc]
    2738:	80082000 	andhi	r2, r8, r0
    273c:	e7f32013 	undefined
    2740:	d3042814 	tstle	r4, #1310720	; 0x140000
    2744:	80082000 	andhi	r2, r8, r0
    2748:	43c02011 	bicmi	r2, r0, #17	; 0x11
    274c:	240ee01a 	strcs	lr, [lr], #-26
    2750:	18184360 	ldmneda	r8, {r5, r6, r8, r9, lr}
    2754:	005b23cf 	subeqs	r2, fp, pc, asr #7
    2758:	006424cd 	rsbeq	r2, r4, sp, asr #9
    275c:	00645b04 	rsbeq	r5, r4, r4, lsl #22
    2760:	5ac01900 	bpl	0xff008b68
    2764:	d00a2800 	andle	r2, sl, r0, lsl #16
    2768:	88936812 	ldmhiia	r3, {r1, r4, fp, sp, lr}
    276c:	d2064298 	andle	r4, r6, #-2147483639	; 0x80000009
    2770:	4358230a 	cmpmi	r8, #671088640	; 0x28000000
    2774:	88801810 	stmhiia	r0, {r4, fp, ip}
    2778:	20008008 	andcs	r8, r0, r8
    277c:	2000e002 	andcs	lr, r0, r2
    2780:	20408008 	subcs	r8, r0, r8
    2784:	fbdff002 	blx	0xff7fe796
    2788:	b083b5f2 	strltd	fp, [r3], r2
    278c:	25001c1c 	strcs	r1, [r0, #-3100]
    2790:	29009903 	stmcsdb	r0, {r0, r1, r8, fp, ip, pc}
    2794:	2000d102 	andcs	sp, r0, r2, lsl #2
    2798:	e04f43c0 	sub	r4, pc, r0, asr #7
    279c:	1c194b47 	ldcne	11, cr4, [r9], {71}
    27a0:	7a4e312c 	bvc	0x138ec58
    27a4:	d1012eff 	strled	r2, [r1, -pc]
    27a8:	e7f52013 	undefined
    27ac:	d3022814 	tstle	r2, #1310720	; 0x140000
    27b0:	43c02011 	bicmi	r2, r0, #17	; 0x11
    27b4:	260ee042 	strcs	lr, [lr], -r2, asr #32
    27b8:	18184370 	ldmneda	r8, {r4, r5, r6, r8, r9, lr}
    27bc:	20cd9001 	sbccs	r9, sp, r1
    27c0:	9b010040 	blls	0x428c8
    27c4:	90001818 	andls	r1, r0, r8, lsl r8
    27c8:	007626cf 	rsbeqs	r2, r6, pc, asr #13
    27cc:	00408800 	subeq	r8, r0, r0, lsl #16
    27d0:	18189b01 	ldmneda	r8, {r0, r8, r9, fp, ip, pc}
    27d4:	2f005b87 	swics	0x00005b87
    27d8:	6808d02f 	stmvsda	r8, {r0, r1, r2, r3, r5, ip, lr, pc}
    27dc:	428f8881 	addmi	r8, pc, #8454144	; 0x810000
    27e0:	210ad22b 	tstcs	sl, fp, lsr #4
    27e4:	18404379 	stmneda	r0, {r0, r3, r4, r5, r6, r8, r9, lr}^
    27e8:	88809002 	stmhiia	r0, {r1, ip, pc}
    27ec:	d2014282 	andle	r4, r1, #536870920	; 0x20000008
    27f0:	e7d12012 	undefined
    27f4:	f0001c38 	andnv	r1, r0, r8, lsr ip
    27f8:	9902f8d7 	stmlsdb	r2, {r0, r1, r2, r4, r6, r7, fp, ip, sp, lr, pc}
    27fc:	1c01888a 	stcne	8, cr8, [r1], {138}
    2800:	f0129803 	andnvs	r9, r2, r3, lsl #16
    2804:	2c00fbc9 	stccs	11, cr15, [r0], {201}
    2808:	1c38d005 	ldcne	0, cr13, [r8], #-20
    280c:	fd6cf7ff 	stc2l	7, cr15, [ip, #-1020]!
    2810:	28001c05 	stmcsda	r0, {r0, r2, sl, fp, ip}
    2814:	1c28da01 	stcne	10, cr13, [r8], #-4
    2818:	9800e010 	stmlsda	r0, {r4, sp, lr, pc}
    281c:	00408800 	subeq	r8, r0, r0, lsl #16
    2820:	18089901 	stmneda	r8, {r0, r8, fp, ip, pc}
    2824:	53814906 	orrpl	r4, r1, #98304	; 0x18000
    2828:	98009a00 	stmlsda	r0, {r9, fp, ip, pc}
    282c:	1c408800 	mcrrne	8, 0, r8, r0, cr0
    2830:	f0152105 	andnvs	r2, r5, r5, lsl #2
    2834:	8010f86b 	andhis	pc, r0, fp, ror #16
    2838:	2040e7ed 	subcs	lr, r0, sp, ror #15
    283c:	e578b004 	ldrb	fp, [r8, #-4]!
    2840:	0000ffff 	streqd	pc, [r0], -pc
    2844:	481d1c01 	ldmmida	sp, {r0, sl, fp, ip}
    2848:	42918b82 	addmis	r8, r1, #133120	; 0x20800
    284c:	0fc04180 	swieq	0x00c04180
    2850:	00004770 	andeq	r4, r0, r0, ror r7
    2854:	49190080 	ldmmidb	r9, {r7}
    2858:	5c086889 	stcpl	8, cr6, [r8], {137}
    285c:	00004770 	andeq	r4, r0, r0, ror r7
    2860:	1c05b530 	cfstr32ne	mvfx11, [r5], {48}
    2864:	20001c14 	andcs	r1, r0, r4, lsl ip
    2868:	01d22280 	biceqs	r2, r2, r0, lsl #5
    286c:	d2094295 	andle	r4, r9, #1342177289	; 0x50000009
    2870:	f0001c28 	andnv	r1, r0, r8, lsr #24
    2874:	2c00f869 	stccs	8, cr15, [r0], {105}
    2878:	00a9d01e 	adceq	sp, r9, lr, lsl r0
    287c:	68924a0f 	ldmvsia	r2, {r0, r1, r2, r3, r9, fp, lr}
    2880:	e0185c51 	ands	r5, r8, r1, asr ip
    2884:	020921c0 	andeq	r2, r9, #48	; 0x30
    2888:	d015420d 	andles	r4, r5, sp, lsl #4
    288c:	06c00a68 	streqb	r0, [r0], r8, ror #20
    2890:	05ed0ec0 	streqb	r0, [sp, #3776]!
    2894:	28020ded 	stmcsda	r2, {r0, r2, r3, r5, r6, r7, r8, sl, fp}
    2898:	2d2dd201 	sfmcs	f5, 1, [sp, #-4]!
    289c:	2000d301 	andcs	sp, r0, r1, lsl #6
    28a0:	0081e00a 	addeq	lr, r1, sl
    28a4:	00a84a06 	adceq	r4, r8, r6, lsl #20
    28a8:	689b1853 	ldmvsia	fp, {r0, r1, r4, r6, fp, ip}
    28ac:	2c005818 	stccs	8, cr5, [r0], {24}
    28b0:	5851d002 	ldmplda	r1, {r1, ip, lr, pc}^
    28b4:	70215d49 	eorvc	r5, r1, r9, asr #26
    28b8:	fdabf7fd 	stc2	7, cr15, [fp, #1012]!
    28bc:	00008680 	andeq	r8, r0, r0, lsl #13
    28c0:	00000270 	andeq	r0, r0, r0, ror r2
    28c4:	d00d2800 	andle	r2, sp, r0, lsl #16
    28c8:	29011e49 	stmcsdb	r1, {r0, r3, r6, r9, sl, fp, ip}
    28cc:	1e89d909 	cdpne	9, 8, cr13, cr9, cr9, {0}
    28d0:	d9042901 	stmledb	r4, {r0, r8, fp, sp}
    28d4:	29011e89 	stmcsdb	r1, {r0, r3, r7, r9, sl, fp, ip}
    28d8:	6002d804 	andvs	sp, r2, r4, lsl #16
    28dc:	8002e002 	andhi	lr, r2, r2
    28e0:	7002e000 	andvc	lr, r2, r0
    28e4:	4770b000 	ldrmib	fp, [r0, -r0]!
    28e8:	d0142800 	andles	r2, r4, r0, lsl #16
    28ec:	29051e49 	stmcsdb	r5, {r0, r3, r6, r9, sl, fp, ip}
    28f0:	a201d811 	andge	sp, r1, #1114112	; 0x110000
    28f4:	44975c52 	ldrmi	r5, [r7], #3154
    28f8:	0c081612 	stceq	6, cr1, [r8], {18}
    28fc:	68000404 	stmvsda	r0, {r2, sl}
    2900:	8800e00a 	stmhida	r0, {r1, r3, sp, lr, pc}
    2904:	2100e008 	tstcs	r0, r8
    2908:	e0055e40 	and	r5, r5, r0, asr #28
    290c:	e0037800 	and	r7, r3, r0, lsl #16
    2910:	56402100 	strplb	r2, [r0], -r0, lsl #2
    2914:	2000e000 	andcs	lr, r0, r0
    2918:	4770b000 	ldrmib	fp, [r0, -r0]!
    291c:	28011e40 	stmcsda	r1, {r6, r9, sl, fp, ip}
    2920:	1e80d90d 	cdpne	9, 8, cr13, cr0, cr13, {0}
    2924:	d9082801 	stmledb	r8, {r0, fp, sp}
    2928:	28011e80 	stmcsda	r1, {r7, r9, sl, fp, ip}
    292c:	1e80d903 	cdpne	9, 8, cr13, cr0, cr3, {0}
    2930:	1e80d003 	cdpne	0, 8, cr13, cr0, cr3, {0}
    2934:	2004d105 	andcs	sp, r4, r5, lsl #2
    2938:	2002e004 	andcs	lr, r2, r4
    293c:	2001e002 	andcs	lr, r1, r2
    2940:	2000e000 	andcs	lr, r0, r0
    2944:	4770b000 	ldrmib	fp, [r0, -r0]!
    2948:	1c04b530 	cfstr32ne	mvfx11, [r4], {48}
    294c:	e0001c0d 	and	r1, r0, sp, lsl #24
    2950:	04201c64 	streqt	r1, [r0], #-3172
    2954:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    2958:	2807ff7d 	stmcsda	r7, {r0, r2, r3, r4, r5, r6, r8, r9, sl, fp, ip, sp, lr, pc}
    295c:	1c29d115 	stfned	f5, [r9], #-84
    2960:	0c000420 	cfstrseq	mvf0, [r0], {32}
    2964:	fa02f000 	blx	0xbe96c
    2968:	d1012800 	tstle	r1, r0, lsl #16
    296c:	e0192000 	ands	r2, r9, r0
    2970:	04201c29 	streqt	r1, [r0], #-3113
    2974:	f0000c00 	andnv	r0, r0, r0, lsl #24
    2978:	49b1f9ed 	ldmmiib	r1!, {r0, r2, r3, r5, r6, r7, r8, fp, ip, sp, lr, pc}
    297c:	4350220a 	cmpmi	r0, #-1610612736	; 0xa0000000
    2980:	5a106aca 	bpl	0x41d4b0
    2984:	180868c9 	stmneda	r8, {r0, r3, r6, r7, fp, sp, lr}
    2988:	2808e00c 	stmcsda	r8, {r2, r3, sp, lr, pc}
    298c:	49acd0e0 	stmmiib	ip!, {r5, r6, r7, ip, lr, pc}
    2990:	04242002 	streqt	r2, [r4], #-2
    2994:	00a20c24 	adceq	r0, r2, r4, lsr #24
    2998:	189a688b 	ldmneia	sl, {r0, r1, r3, r7, fp, sp, lr}
    299c:	68c95e10 	stmvsia	r9, {r4, r9, sl, fp, ip, lr}^
    29a0:	19401808 	stmnedb	r0, {r3, fp, ip}^
    29a4:	fd35f7fd 	ldc2	7, cr15, [r5, #-1012]!
    29a8:	220a49a5 	andcs	r4, sl, #2703360	; 0x294000
    29ac:	6aca4350 	bvs	0xff2936f4
    29b0:	68c95a10 	stmvsia	r9, {r4, r9, fp, ip, lr}^
    29b4:	47701808 	ldrmib	r1, [r0, -r8, lsl #16]!
    29b8:	1c04b570 	cfstr32ne	mvfx11, [r4], {112}
    29bc:	1c2ce000 	stcne	0, cr14, [ip]
    29c0:	04281c65 	streqt	r1, [r8], #-3173
    29c4:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    29c8:	2800ff3d 	stmcsda	r0, {r0, r2, r3, r4, r5, r8, r9, sl, fp, ip, sp, lr, pc}
    29cc:	480fd101 	stmmida	pc, {r0, r8, ip, lr, pc}
    29d0:	0420e01a 	streqt	lr, [r0], #-26
    29d4:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    29d8:	2807ff3d 	stmcsda	r7, {r0, r2, r3, r4, r5, r8, r9, sl, fp, ip, sp, lr, pc}
    29dc:	2808d0ef 	stmcsda	r8, {r0, r1, r2, r3, r5, r6, r7, ip, lr, pc}
    29e0:	0420d110 	streqt	sp, [r0], #-272
    29e4:	f0000c00 	andnv	r0, r0, r0, lsl #24
    29e8:	1c04f9ab 	stcne	9, cr15, [r4], {171}
    29ec:	e0052600 	and	r2, r5, r0, lsl #12
    29f0:	0c000428 	cfstrseq	mvf0, [r0], {40}
    29f4:	ffe0f7ff 	swinv	0x00e0f7ff
    29f8:	1c761c05 	ldcnel	12, cr1, [r6], #-20
    29fc:	0c360436 	cfldrseq	mvf0, [r6], #-216
    2a00:	d3f542a6 	mvnles	r4, #1610612746	; 0x6000000a
    2a04:	0c000428 	cfstrseq	mvf0, [r0], {40}
    2a08:	f956f002 	ldmnvdb	r6, {r1, ip, sp, lr, pc}^
    2a0c:	0000ffff 	streqd	pc, [r0], -pc
    2a10:	1c04b5f1 	cfstr32ne	mvfx11, [r4], {241}
    2a14:	f7ff1c0e 	ldrnvb	r1, [pc, lr, lsl #24]!
    2a18:	1c05ff1d 	stcne	15, cr15, [r5], {29}
    2a1c:	f7ff1c30 	undefined
    2a20:	4285ff19 	addmi	pc, r5, #100	; 0x64
    2a24:	2000d001 	andcs	sp, r0, r1
    2a28:	4669e033 	undefined
    2a2c:	80081c60 	andhi	r1, r8, r0, ror #24
    2a30:	2d081c77 	stccs	12, cr1, [r8, #-476]
    2a34:	1c20d122 	stfned	f5, [r0], #-136
    2a38:	f982f000 	stmnvib	r2, {ip, sp, lr, pc}
    2a3c:	1c301c05 	ldcne	12, cr1, [r0], #-20
    2a40:	f97ef000 	ldmnvdb	lr!, {ip, sp, lr, pc}^
    2a44:	d1ee4285 	mvnle	r4, r5, lsl #5
    2a48:	88044668 	stmhida	r4, {r3, r5, r6, r9, sl, lr}
    2a4c:	27001c3e 	smladxcs	r0, lr, ip, r1
    2a50:	0c3f043f 	cfldrseq	mvf0, [pc], #-252
    2a54:	d21b42af 	andles	r4, fp, #-268435446	; 0xf000000a
    2a58:	0c090431 	cfstrseq	mvf0, [r9], {49}
    2a5c:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
    2a60:	2800ffd7 	stmcsda	r0, {r0, r1, r2, r4, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
    2a64:	1c20d0df 	stcne	0, cr13, [r0], #-892
    2a68:	ffa6f7ff 	swinv	0x00a6f7ff
    2a6c:	04301c04 	ldreqt	r1, [r0], #-3076
    2a70:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    2a74:	1c06ffa1 	stcne	15, cr15, [r6], {161}
    2a78:	e7e91c7f 	undefined
    2a7c:	d1072d07 	tstle	r7, r7, lsl #26
    2a80:	0c090439 	cfstrseq	mvf0, [r9], {57}
    2a84:	88004668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}
    2a88:	ffc2f7ff 	swinv	0x00c2f7ff
    2a8c:	d0ca2800 	sbcle	r2, sl, r0, lsl #16
    2a90:	e4b92001 	ldrt	r2, [r9], #1
    2a94:	1c05b5f3 	cfstr32ne	mvfx11, [r5], {243}
    2a98:	24002600 	strcs	r2, [r0], #-1536
    2a9c:	fedaf7ff 	mrc2	7, 6, pc, cr10, cr15, {7}
    2aa0:	1c69466a 	stcnel	6, cr4, [r9], #-424
    2aa4:	28078011 	stmcsda	r7, {r0, r4, pc}
    2aa8:	4668d12d 	strmibt	sp, [r8], -sp, lsr #2
    2aac:	1c288881 	stcne	8, cr8, [r8], #-516
    2ab0:	f950f000 	ldmnvdb	r0, {ip, sp, lr, pc}^
    2ab4:	46681c07 	strmibt	r1, [r8], -r7, lsl #24
    2ab8:	1c288805 	stcne	8, cr8, [r8], #-20
    2abc:	fecaf7ff 	mcr2	7, 6, pc, cr10, cr15, {7}
    2ac0:	d00a2807 	andle	r2, sl, r7, lsl #16
    2ac4:	d0082808 	andle	r2, r8, r8, lsl #16
    2ac8:	4347200a 	cmpmi	r7, #10	; 0xa
    2acc:	6ac0481d 	bvs	0xff014b48
    2ad0:	884419c0 	stmhida	r4, {r6, r7, r8, fp, ip}^
    2ad4:	43448880 	cmpmi	r4, #8388608	; 0x800000
    2ad8:	200ae030 	andcs	lr, sl, r0, lsr r0
    2adc:	48194347 	ldmmida	r9, {r0, r1, r2, r6, r8, r9, lr}
    2ae0:	19c06ac0 	stmneib	r0, {r6, r7, r9, fp, sp, lr}^
    2ae4:	04368881 	ldreqt	r8, [r6], #-2177
    2ae8:	428e0c36 	addmi	r0, lr, #13824	; 0x3600
    2aec:	8801d226 	stmhida	r1, {r1, r2, r5, r9, ip, lr, pc}
    2af0:	43708840 	cmnmi	r0, #4194304	; 0x400000
    2af4:	04091809 	streq	r1, [r9], #-2057
    2af8:	1c280c09 	stcne	12, cr0, [r8], #-36
    2afc:	ffcaf7ff 	swinv	0x00caf7ff
    2b00:	1c761824 	ldcnel	8, cr1, [r6], #-144
    2b04:	2808e7eb 	stmcsda	r8, {r0, r1, r3, r5, r6, r7, r8, r9, sl, sp, lr, pc}
    2b08:	1c28d115 	stfned	f5, [r8], #-84
    2b0c:	f918f000 	ldmnvdb	r8, {ip, sp, lr, pc}
    2b10:	46681c07 	strmibt	r1, [r8], -r7, lsl #24
    2b14:	04368805 	ldreqt	r8, [r6], #-2053
    2b18:	42be0c36 	adcmis	r0, lr, #13824	; 0x3600
    2b1c:	4668d20e 	strmibt	sp, [r8], -lr, lsl #4
    2b20:	1c288881 	stcne	8, cr8, [r8], #-516
    2b24:	ffb6f7ff 	swinv	0x00b6f7ff
    2b28:	1c281824 	stcne	8, cr1, [r8], #-144
    2b2c:	ff44f7ff 	swinv	0x0044f7ff
    2b30:	1c761c05 	ldcnel	12, cr1, [r6], #-20
    2b34:	f7ffe7ef 	ldrnvb	lr, [pc, pc, ror #15]!
    2b38:	1c04fef1 	stcne	14, cr15, [r4], {241}
    2b3c:	0c000420 	cfstrseq	mvf0, [r0], {32}
    2b40:	fa76f7ff 	blx	0x1dc0b44
    2b44:	00008680 	andeq	r8, r0, r0, lsl #13
    2b48:	b083b5f9 	strltd	fp, [r3], r9
    2b4c:	1c161c0c 	ldcne	12, cr1, [r6], {12}
    2b50:	f7ff1c10 	undefined
    2b54:	1c07fe7f 	stcne	14, cr15, [r7], {127}
    2b58:	1c704669 	ldcnel	6, cr4, [r0], #-420
    2b5c:	2f078088 	swics	0x00078088
    2b60:	4668d13a 	undefined
    2b64:	1c308a01 	ldcne	10, cr8, [r0], #-4
    2b68:	f8f4f000 	ldmnvia	r4!, {ip, sp, lr, pc}^
    2b6c:	4348210a 	cmpmi	r8, #-2147483646	; 0x80000002
    2b70:	49339002 	ldmmidb	r3!, {r1, ip, pc}
    2b74:	18086ac9 	stmneda	r8, {r0, r3, r6, r7, r9, fp, sp, lr}
    2b78:	88859000 	stmhiia	r5, {ip, pc}
    2b7c:	88864668 	stmhiia	r6, {r3, r5, r6, r9, sl, lr}
    2b80:	f7ff1c30 	undefined
    2b84:	1c07fe67 	stcne	14, cr15, [r7], {103}
    2b88:	d00f2807 	andle	r2, pc, r7, lsl #16
    2b8c:	d00d2f08 	andle	r2, sp, r8, lsl #30
    2b90:	88459800 	stmhida	r5, {fp, ip, pc}^
    2b94:	88809800 	stmhiia	r0, {fp, ip, pc}
    2b98:	042d4345 	streqt	r4, [sp], #-837
    2b9c:	1c2a0c2d 	stcne	12, cr0, [sl], #-180
    2ba0:	88009800 	stmhida	r0, {fp, ip, pc}
    2ba4:	68c94926 	stmvsia	r9, {r1, r2, r5, r8, fp, lr}^
    2ba8:	e03c1809 	eors	r1, ip, r9, lsl #16
    2bac:	043f2700 	ldreqt	r2, [pc], #1792	; 0x2bb4
    2bb0:	42af0c3f 	adcmi	r0, pc, #16128	; 0x3f00
    2bb4:	9802d23f 	stmlsda	r2, {r0, r1, r2, r3, r4, r5, r9, ip, lr, pc}
    2bb8:	6ac94921 	bvs	0xff255044
    2bbc:	88011808 	stmhida	r1, {r3, fp, ip}
    2bc0:	43788840 	cmnmi	r8, #4194304	; 0x400000
    2bc4:	041b180b 	ldreq	r1, [fp], #-2059
    2bc8:	1c320c1b 	ldcne	12, cr0, [r2], #-108
    2bcc:	98031c21 	stmlsda	r3, {r0, r5, sl, fp, ip}
    2bd0:	ffbaf7ff 	swinv	0x00baf7ff
    2bd4:	e7ea1c7f 	undefined
    2bd8:	d1172f08 	tstle	r7, r8, lsl #30
    2bdc:	f0001c30 	andnv	r1, r0, r0, lsr ip
    2be0:	1c05f8af 	stcne	8, cr15, [r5], {175}
    2be4:	88864668 	stmhiia	r6, {r3, r5, r6, r9, sl, lr}
    2be8:	043f2700 	ldreqt	r2, [pc], #1792	; 0x2bf0
    2bec:	42af0c3f 	adcmi	r0, pc, #16128	; 0x3f00
    2bf0:	4668d221 	strmibt	sp, [r8], -r1, lsr #4
    2bf4:	1c328a03 	ldcne	10, cr8, [r2], #-12
    2bf8:	98031c21 	stmlsda	r3, {r0, r5, sl, fp, ip}
    2bfc:	ffa4f7ff 	swinv	0x00a4f7ff
    2c00:	f7ff1c30 	undefined
    2c04:	1c06fed9 	stcne	14, cr15, [r6], {217}
    2c08:	e7ee1c7f 	undefined
    2c0c:	46682200 	strmibt	r2, [r8], -r0, lsl #4
    2c10:	1c308a01 	ldcne	10, cr8, [r0], #-4
    2c14:	fe24f7ff 	mcr2	7, 1, pc, cr4, cr15, {7}
    2c18:	1c381c06 	ldcne	12, cr1, [r8], #-24
    2c1c:	fe7ef7ff 	mrc2	7, 3, pc, cr14, cr15, {7}
    2c20:	1c021c05 	stcne	12, cr1, [r2], {5}
    2c24:	88201c31 	stmhida	r0!, {r0, r4, r5, sl, fp, ip}
    2c28:	18189b03 	ldmneda	r8, {r0, r1, r8, r9, fp, ip, pc}
    2c2c:	f9b4f012 	ldmnvib	r4!, {r1, r4, ip, sp, lr, pc}
    2c30:	19408820 	stmnedb	r0, {r5, fp, pc}^
    2c34:	20008020 	andcs	r8, r0, r0, lsr #32
    2c38:	f7ffb005 	ldrnvb	fp, [pc, r5]!
    2c3c:	0000fb7a 	andeq	pc, r0, sl, ror fp
    2c40:	00008680 	andeq	r8, r0, r0, lsl #13
    2c44:	b083b5f9 	strltd	fp, [r3], r9
    2c48:	1c161c0c 	ldcne	12, cr1, [r6], {12}
    2c4c:	f7ff1c10 	undefined
    2c50:	1c07fe01 	stcne	14, cr15, [r7], {1}
    2c54:	1c704669 	ldcnel	6, cr4, [r0], #-420
    2c58:	2f078088 	swics	0x00078088
    2c5c:	4668d13d 	undefined
    2c60:	1c308a01 	ldcne	10, cr8, [r0], #-4
    2c64:	f876f000 	ldmnvda	r6!, {ip, sp, lr, pc}^
    2c68:	4348210a 	cmpmi	r8, #-2147483646	; 0x80000002
    2c6c:	494e9002 	stmmidb	lr, {r1, ip, pc}^
    2c70:	18086ac9 	stmneda	r8, {r0, r3, r6, r7, r9, fp, sp, lr}
    2c74:	88859000 	stmhiia	r5, {ip, pc}
    2c78:	88864668 	stmhiia	r6, {r3, r5, r6, r9, sl, lr}
    2c7c:	f7ff1c30 	undefined
    2c80:	1c07fde9 	stcne	13, cr15, [r7], {233}
    2c84:	d0122807 	andles	r2, r2, r7, lsl #16
    2c88:	d0102f08 	andles	r2, r0, r8, lsl #30
    2c8c:	88459800 	stmhida	r5, {fp, ip, pc}^
    2c90:	88809800 	stmhiia	r0, {fp, ip, pc}
    2c94:	042d4345 	streqt	r4, [sp], #-837
    2c98:	1c2a0c2d 	stcne	12, cr0, [sl], #-180
    2c9c:	99038820 	stmlsdb	r3, {r5, fp, pc}
    2ca0:	98001809 	stmlsda	r0, {r0, r3, fp, ip}
    2ca4:	4b408800 	blmi	0x1024cac
    2ca8:	181868db 	ldmneda	r8, {r0, r1, r3, r4, r6, r7, fp, sp, lr}
    2cac:	2700e03f 	smladxcs	r0, pc, r0, lr
    2cb0:	0c3f043f 	cfldrseq	mvf0, [pc], #-252
    2cb4:	d23f42af 	eorles	r4, pc, #-268435446	; 0xf000000a
    2cb8:	493b9802 	ldmmidb	fp!, {r1, fp, ip, pc}
    2cbc:	18086ac9 	stmneda	r8, {r0, r3, r6, r7, r9, fp, sp, lr}
    2cc0:	88408801 	stmhida	r0, {r0, fp, pc}^
    2cc4:	180b4378 	stmneda	fp, {r3, r4, r5, r6, r8, r9, lr}
    2cc8:	0c1b041b 	cfldrseq	mvf0, [fp], {27}
    2ccc:	1c211c32 	stcne	12, cr1, [r1], #-200
    2cd0:	f7ff9803 	ldrnvb	r9, [pc, r3, lsl #16]!
    2cd4:	1c7fffb7 	ldcnel	15, cr15, [pc], #-732
    2cd8:	2f08e7ea 	swics	0x0008e7ea
    2cdc:	1c30d117 	ldfned	f5, [r0], #-92
    2ce0:	f82ef000 	stmnvda	lr!, {ip, sp, lr, pc}
    2ce4:	46681c05 	strmibt	r1, [r8], -r5, lsl #24
    2ce8:	27008886 	strcs	r8, [r0, -r6, lsl #17]
    2cec:	0c3f043f 	cfldrseq	mvf0, [pc], #-252
    2cf0:	d22142af 	eorle	r4, r1, #-268435446	; 0xf000000a
    2cf4:	8a034668 	bhi	0xd469c
    2cf8:	1c211c32 	stcne	12, cr1, [r1], #-200
    2cfc:	f7ff9803 	ldrnvb	r9, [pc, r3, lsl #16]!
    2d00:	1c30ffa1 	ldcne	15, cr15, [r0], #-644
    2d04:	fe58f7ff 	mrc2	7, 2, pc, cr8, cr15, {7}
    2d08:	1c7f1c06 	ldcnel	12, cr1, [pc], #-24
    2d0c:	2200e7ee 	andcs	lr, r0, #62390272	; 0x3b80000
    2d10:	8a014668 	bhi	0x546b8
    2d14:	f7ff1c30 	undefined
    2d18:	1c06fda3 	stcne	13, cr15, [r6], {163}
    2d1c:	f7ff1c38 	undefined
    2d20:	1c05fdfd 	stcne	13, cr15, [r5], {253}
    2d24:	88201c02 	stmhida	r0!, {r1, sl, fp, ip}
    2d28:	18099903 	stmneda	r9, {r0, r1, r8, fp, ip, pc}
    2d2c:	f0121c30 	andnvs	r1, r2, r0, lsr ip
    2d30:	8820f933 	stmhida	r0!, {r0, r1, r4, r5, r8, fp, ip, sp, lr, pc}
    2d34:	80201940 	eorhi	r1, r0, r0, asr #18
    2d38:	b0052000 	andlt	r2, r5, r0
    2d3c:	faf9f7ff 	blx	0xffe80d40
    2d40:	00802102 	addeq	r2, r0, r2, lsl #2
    2d44:	68924a18 	ldmvsia	r2, {r3, r4, r9, fp, lr}
    2d48:	5e401810 	mcrpl	8, 2, r1, cr0, cr0, {0}
    2d4c:	0c000400 	cfstrseq	mvf0, [r0], {0}
    2d50:	00004770 	andeq	r4, r0, r0, ror r7
    2d54:	4a14b410 	bmi	0x52fd9c
    2d58:	00802302 	addeq	r2, r0, r2, lsl #6
    2d5c:	18206894 	stmneda	r0!, {r2, r4, r7, fp, sp, lr}
    2d60:	68d25ec0 	ldmvsia	r2, {r6, r7, r9, sl, fp, ip, lr}^
    2d64:	5a401810 	bpl	0x1008dac
    2d68:	4770bc10 	undefined
    2d6c:	f7ffb500 	ldrnvb	fp, [pc, r0, lsl #10]!
    2d70:	210afff1 	strcsd	pc, [sl, -r1]
    2d74:	490c4348 	stmmidb	ip, {r3, r6, r8, r9, lr}
    2d78:	18086ac9 	stmneda	r8, {r0, r3, r6, r7, r9, fp, sp, lr}
    2d7c:	bc028880 	stclt	8, cr8, [r2], {128}
    2d80:	00004708 	andeq	r4, r0, r8, lsl #14
    2d84:	28ff4908 	ldmcsia	pc!, {r3, r8, fp, lr}^
    2d88:	8b08d101 	blhi	0x237194
    2d8c:	2214e009 	andcss	lr, r4, #9	; 0x9
    2d90:	68494350 	stmvsda	r9, {r4, r6, r8, r9, lr}^
    2d94:	88411808 	stmhida	r1, {r3, fp, ip}^
    2d98:	1a088800 	bne	0x224da0
    2d9c:	04001c40 	streq	r1, [r0], #-3136
    2da0:	b0000c00 	andlt	r0, r0, r0, lsl #24
    2da4:	00004770 	andeq	r4, r0, r0, ror r7
    2da8:	00008680 	andeq	r8, r0, r0, lsl #13
    2dac:	1c04b570 	cfstr32ne	mvfx11, [r4], {112}
    2db0:	46681c0d 	strmibt	r1, [r8], -sp, lsl #24
    2db4:	20007c06 	andcs	r7, r0, r6, lsl #24
    2db8:	d0032b02 	andle	r2, r3, r2, lsl #22
    2dbc:	d0012b04 	andle	r2, r1, r4, lsl #22
    2dc0:	d1222b06 	teqle	r2, r6, lsl #22
    2dc4:	d0032e02 	andle	r2, r3, r2, lsl #28
    2dc8:	d0012e04 	andle	r2, r1, r4, lsl #28
    2dcc:	d11c2e06 	tstle	ip, r6, lsl #28
    2dd0:	d1022c00 	tstle	r2, r0, lsl #24
    2dd4:	db164295 	blle	0x593830
    2dd8:	2c01e01b 	stccs	0, cr14, [r1], {27}
    2ddc:	42aad101 	adcmi	sp, sl, #1073741824	; 0x40000000
    2de0:	2c02e7f9 	stccs	7, cr14, [r2], {249}
    2de4:	42aad102 	adcmi	sp, sl, #-2147483648	; 0x80000000
    2de8:	e012da0d 	ands	sp, r2, sp, lsl #20
    2dec:	d1012c03 	tstle	r1, r3, lsl #24
    2df0:	e7f94295 	undefined
    2df4:	d1022c04 	tstle	r2, r4, lsl #24
    2df8:	d0044295 	mulle	r4, r5, r2
    2dfc:	2c05e009 	stccs	0, cr14, [r5], {9}
    2e00:	4295d107 	addmis	sp, r5, #-1073741823	; 0xc0000001
    2e04:	2001d005 	andcs	sp, r1, r5
    2e08:	2c00e003 	stccs	0, cr14, [r0], {3}
    2e0c:	4295d103 	addmis	sp, r5, #-1073741824	; 0xc0000000
    2e10:	f001d3f9 	strnvd	sp, [r1], -r9
    2e14:	2c01ff51 	stccs	15, cr15, [r1], {81}
    2e18:	42aad102 	adcmi	sp, sl, #-2147483648	; 0x80000000
    2e1c:	e7f8d3f3 	undefined
    2e20:	d1022c02 	tstle	r2, r2, lsl #24
    2e24:	d2ee42aa 	rscle	r4, lr, #-1610612726	; 0xa000000a
    2e28:	2c03e7f3 	stccs	7, cr14, [r3], {243}
    2e2c:	4295d101 	addmis	sp, r5, #1073741824	; 0x40000000
    2e30:	2c04e7f9 	stccs	7, cr14, [r4], {249}
    2e34:	4295d102 	addmis	sp, r5, #-2147483648	; 0x80000000
    2e38:	e7ead0e5 	strb	sp, [sl, r5, ror #1]!
    2e3c:	d1e82c05 	mvnle	r2, r5, lsl #24
    2e40:	d0e64295 	smlalle	r4, r6, r5, r2
    2e44:	0000e7df 	ldreqd	lr, [r0], -pc
    2e48:	1c04b5f1 	cfstr32ne	mvfx11, [r4], {241}
    2e4c:	1c161c0d 	ldcne	12, cr1, [r6], {13}
    2e50:	46691c18 	undefined
    2e54:	466a8b09 	strmibt	r8, [sl], -r9, lsl #22
    2e58:	27008b92 	undefined
    2e5c:	701f466b 	andvcs	r4, pc, fp, ror #12
    2e60:	1c33b407 	cfldrsne	mvf11, [r3], #-28
    2e64:	1c29aa03 	stcne	10, cr10, [r9], #-12
    2e68:	f0001c20 	andnv	r1, r0, r0, lsr #24
    2e6c:	a903f80f 	stmgedb	r3, {r0, r1, r2, r3, fp, ip, sp, lr, pc}
    2e70:	b0037809 	andlt	r7, r3, r9, lsl #16
    2e74:	d1072900 	tstle	r7, r0, lsl #18
    2e78:	d0032c04 	andle	r2, r3, r4, lsl #24
    2e7c:	d0012c03 	andle	r2, r1, r3, lsl #24
    2e80:	d1002c02 	tstle	r0, r2, lsl #24
    2e84:	702f2701 	eorvc	r2, pc, r1, lsl #14
    2e88:	fabef7ff 	blx	0xfefc0e8c
    2e8c:	b085b5f3 	strltd	fp, [r5], r3
    2e90:	1c1d1c14 	ldcne	12, cr1, [sp], {20}
    2e94:	8e864668 	cdphi	6, 8, cr4, cr6, cr8, {3}
    2e98:	71012100 	tstvc	r1, r0, lsl #2
    2e9c:	f7ff1c18 	undefined
    2ea0:	4669fcd9 	undefined
    2ea4:	1c307008 	ldcne	0, cr7, [r0], #-32
    2ea8:	fcd4f7ff 	ldc2l	7, cr15, [r4], {255}
    2eac:	70484669 	subvc	r4, r8, r9, ror #12
    2eb0:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    2eb4:	d0032807 	andle	r2, r3, r7, lsl #16
    2eb8:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    2ebc:	d10d2808 	tstle	sp, r8, lsl #16
    2ec0:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    2ec4:	42887849 	addmi	r7, r8, #4784128	; 0x490000
    2ec8:	2000d004 	andcs	sp, r0, r4
    2ecc:	b00743c0 	andlt	r4, r7, r0, asr #7
    2ed0:	fa2ff7ff 	blx	0xc00ed4
    2ed4:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    2ed8:	d03c2807 	eorles	r2, ip, r7, lsl #16
    2edc:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    2ee0:	d0642808 	rsble	r2, r4, r8, lsl #16
    2ee4:	4668466a 	strmibt	r4, [r8], -sl, ror #12
    2ee8:	1c288e01 	stcne	14, cr8, [r8], #-4
    2eec:	fcb8f7ff 	ldc2	7, cr15, [r8], #1020
    2ef0:	aa001c05 	bge	0x9f0c
    2ef4:	46681c52 	undefined
    2ef8:	1c308f01 	ldcne	15, cr8, [r0], #-4
    2efc:	fcb0f7ff 	ldc2	7, cr15, [r0], #1020
    2f00:	46681c06 	strmibt	r1, [r8], -r6, lsl #24
    2f04:	1c287801 	stcne	8, cr7, [r8], #-4
    2f08:	fceef7ff 	stc2l	7, cr15, [lr], #1020
    2f0c:	46681c05 	strmibt	r1, [r8], -r5, lsl #24
    2f10:	1c307841 	ldcne	8, cr7, [r0], #-260
    2f14:	fce8f7ff 	stc2l	7, cr15, [r8], #1020
    2f18:	46681c06 	strmibt	r1, [r8], -r6, lsl #24
    2f1c:	b4017840 	strlt	r7, [r1], #-2112
    2f20:	7803a801 	stmvcda	r3, {r0, fp, sp, pc}
    2f24:	1c291c32 	stcne	12, cr1, [r9], #-200
    2f28:	f7ff2005 	ldrnvb	r2, [pc, r5]!
    2f2c:	7020ff3f 	eorvc	pc, r0, pc, lsr pc
    2f30:	b0017820 	andlt	r7, r1, r0, lsr #16
    2f34:	d00c2800 	andle	r2, ip, r0, lsl #16
    2f38:	78404668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}^
    2f3c:	a801b401 	stmgeda	r1, {r0, sl, ip, sp, pc}
    2f40:	1c327803 	ldcne	8, cr7, [r2], #-12
    2f44:	7d001c29 	stcvc	12, cr1, [r0, #-164]
    2f48:	ff30f7ff 	swinv	0x0030f7ff
    2f4c:	70089907 	andvc	r9, r8, r7, lsl #18
    2f50:	2000b001 	andcs	fp, r0, r1
    2f54:	4668e7bb 	undefined
    2f58:	1c288e01 	stcne	14, cr8, [r8], #-4
    2f5c:	ff06f7ff 	swinv	0x0006f7ff
    2f60:	80484669 	subhi	r4, r8, r9, ror #12
    2f64:	8e014668 	cfmadd32hi	mvax3, mvfx4, mvfx1, mvfx8
    2f68:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    2f6c:	4669fef3 	undefined
    2f70:	485680c8 	ldmmida	r6, {r3, r6, r7, pc}^
    2f74:	90036ac0 	andls	r6, r3, r0, asr #21
    2f78:	88c94668 	stmhiia	r9, {r3, r5, r6, r9, sl, lr}^
    2f7c:	4351220a 	cmpmi	r1, #-1610612736	; 0xa0000000
    2f80:	5a519a03 	bpl	0x1469794
    2f84:	8f018601 	swihi	0x00018601
    2f88:	f7ff1c30 	undefined
    2f8c:	1c07feef 	stcne	14, cr15, [r7], {239}
    2f90:	8f014668 	swihi	0x00014668
    2f94:	f7ff1c30 	undefined
    2f98:	4669fedd 	undefined
    2f9c:	46688108 	strmibt	r8, [r8], -r8, lsl #2
    2fa0:	220a8909 	andcs	r8, sl, #147456	; 0x24000
    2fa4:	9a034351 	bls	0xd3cf0
    2fa8:	87015a51 	smlsdhi	r1, r1, sl, r5
    2fac:	1c28e008 	stcne	0, cr14, [r8], #-32
    2fb0:	fec6f7ff 	mcr2	7, 6, pc, cr6, cr15, {7}
    2fb4:	80484669 	subhi	r4, r8, r9, ror #12
    2fb8:	f7ff1c30 	undefined
    2fbc:	1c07fec1 	stcne	14, cr15, [r7], {193}
    2fc0:	88404668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}^
    2fc4:	d01342b8 	ldrleh	r4, [r3], -r8
    2fc8:	7d004668 	stcvc	6, cr4, [r0, #-416]
    2fcc:	d0032804 	andle	r2, r3, r4, lsl #16
    2fd0:	7d004668 	stcvc	6, cr4, [r0, #-416]
    2fd4:	d10b2805 	tstle	fp, r5, lsl #16
    2fd8:	70202001 	eorvc	r2, r0, r1
    2fdc:	7d004668 	stcvc	6, cr4, [r0, #-416]
    2fe0:	d1012805 	tstle	r1, r5, lsl #16
    2fe4:	e0002001 	and	r2, r0, r1
    2fe8:	99062000 	stmlsdb	r6, {sp}
    2fec:	e7b07008 	ldr	r7, [r0, r8]!
    2ff0:	46694668 	strmibt	r4, [r9], -r8, ror #12
    2ff4:	42b98849 	adcmis	r8, r9, #4784128	; 0x490000
    2ff8:	1c39d900 	ldcne	9, cr13, [r9]
    2ffc:	1c6d8201 	sfmne	f0, 3, [sp], #-4
    3000:	21001c76 	tstcs	r0, r6, ror ip
    3004:	4668e011 	undefined
    3008:	28087800 	stmcsda	r8, {fp, ip, sp, lr}
    300c:	0428d109 	streqt	sp, [r8], #-265
    3010:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    3014:	1c05fcd1 	stcne	12, cr15, [r5], {209}
    3018:	0c000430 	cfstrseq	mvf0, [r0], {48}
    301c:	fcccf7ff 	stc2l	7, cr15, [ip], {255}
    3020:	46681c06 	strmibt	r1, [r8], -r6, lsl #24
    3024:	89494669 	stmhidb	r9, {r0, r3, r5, r6, r9, sl, lr}^
    3028:	81411c49 	cmphi	r1, r9, asr #24
    302c:	46698940 	strmibt	r8, [r9], -r0, asr #18
    3030:	42888a09 	addmi	r8, r8, #36864	; 0x9000
    3034:	d2364668 	eorles	r4, r6, #109051904	; 0x6800000
    3038:	8e008f02 	cdphi	15, 0, cr8, cr0, cr2, {0}
    303c:	0c090431 	cfstrseq	mvf0, [r9], {49}
    3040:	042bb407 	streqt	fp, [fp], #-1031
    3044:	1c220c1b 	stcne	12, cr0, [r2], #-108
    3048:	a8039909 	stmgeda	r3, {r0, r3, r8, fp, ip, pc}
    304c:	f7ff7d00 	ldrnvb	r7, [pc, r0, lsl #26]!
    3050:	a903ff1d 	stmgedb	r3, {r0, r2, r3, r4, r8, r9, sl, fp, ip, sp, lr, pc}
    3054:	78207108 	stmvcda	r0!, {r3, r8, ip, sp, lr}
    3058:	2800b003 	stmcsda	r0, {r0, r1, ip, sp, pc}
    305c:	2004d103 	andcs	sp, r4, r3, lsl #2
    3060:	28005608 	stmcsda	r0, {r3, r9, sl, ip, lr}
    3064:	4669da03 	strmibt	sp, [r9], -r3, lsl #20
    3068:	56082004 	strpl	r2, [r8], -r4
    306c:	4668e72f 	strmibt	lr, [r8], -pc, lsr #14
    3070:	28077800 	stmcsda	r7, {fp, ip, sp, lr}
    3074:	4815d1c7 	ldmmida	r5, {r0, r1, r2, r6, r7, r8, ip, lr, pc}
    3078:	466b6ac0 	strmibt	r6, [fp], -r0, asr #21
    307c:	46948e0a 	ldrmi	r8, [r4], sl, lsl #28
    3080:	210a88ca 	smlabtcs	sl, sl, r8, r8
    3084:	1881434a 	stmneia	r1, {r1, r3, r6, r8, r9, lr}
    3088:	44618849 	strmibt	r8, [r1], #-2121
    308c:	46698619 	undefined
    3090:	468c8f09 	strmi	r8, [ip], r9, lsl #30
    3094:	890a4669 	stmhidb	sl, {r0, r3, r5, r6, r9, sl, lr}
    3098:	434a210a 	cmpmi	sl, #-2147483646	; 0x80000002
    309c:	88401880 	stmhida	r0, {r7, fp, ip}^
    30a0:	87184460 	ldrhi	r4, [r8, -r0, ror #8]
    30a4:	8840e7bd 	stmhida	r0, {r0, r2, r3, r4, r5, r7, r8, r9, sl, sp, lr, pc}^
    30a8:	d0dc42b8 	ldrleh	r4, [ip], #40
    30ac:	70202001 	eorvc	r2, r0, r1
    30b0:	b4012003 	strlt	r2, [r1], #-3
    30b4:	1c3a2303 	ldcne	3, cr2, [sl], #-12
    30b8:	8841a801 	stmhida	r1, {r0, fp, sp, pc}^
    30bc:	f7ff7d00 	ldrnvb	r7, [pc, r0, lsl #26]!
    30c0:	9907fe75 	stmlsdb	r7, {r0, r2, r4, r5, r6, r9, sl, fp, ip, sp, lr, pc}
    30c4:	b0017008 	andlt	r7, r1, r8
    30c8:	0000e7cd 	andeq	lr, r0, sp, asr #15
    30cc:	00008680 	andeq	r8, r0, r0, lsl #13
    30d0:	b081b5f1 	strltd	fp, [r1], r1
    30d4:	79004668 	stmvcdb	r0, {r3, r5, r6, r9, sl, lr}
    30d8:	ff42f7fe 	swinv	0x0042f7fe
    30dc:	d1022800 	tstle	r2, r0, lsl #16
    30e0:	43c02000 	bicmi	r2, r0, #0	; 0x0
    30e4:	4668e083 	strmibt	lr, [r8], -r3, lsl #1
    30e8:	21147900 	tstcs	r4, r0, lsl #18
    30ec:	49924348 	ldmmiib	r2, {r3, r6, r8, r9, lr}
    30f0:	180c6849 	stmneda	ip, {r0, r3, r6, fp, sp, lr}
    30f4:	004888a1 	subeq	r8, r8, r1, lsr #17
    30f8:	00528822 	subeqs	r8, r2, r2, lsr #16
    30fc:	681b4b8e 	ldmvsda	fp, {r1, r2, r3, r7, r8, r9, fp, lr}
    3100:	1815189a 	ldmneda	r5, {r1, r3, r4, r7, fp, ip}
    3104:	5e282000 	cdppl	0, 2, cr2, cr8, cr0, {0}
    3108:	0f060400 	swieq	0x00060400
    310c:	d41907f0 	ldrle	r0, [r9], #-2032
    3110:	882a4888 	stmhida	sl!, {r3, r7, fp, lr}
    3114:	011b2380 	tsteq	fp, r0, lsl #7
    3118:	121a4013 	andnes	r4, sl, #19	; 0x13
    311c:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    3120:	d1092a08 	tstle	r9, r8, lsl #20
    3124:	5eaa2200 	cdppl	2, 10, cr2, cr10, cr0, {0}
    3128:	00db23e0 	sbceqs	r2, fp, r0, ror #7
    312c:	121a4013 	andnes	r4, sl, #19	; 0x13
    3130:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    3134:	e0035c82 	and	r5, r3, r2, lsl #25
    3138:	5eaa2200 	cdppl	2, 10, cr2, cr10, cr0, {0}
    313c:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    3140:	db012a36 	blle	0x4da20
    3144:	e7cc2001 	strb	r2, [ip, r1]
    3148:	19922200 	ldmneib	r2, {r9, sp}
    314c:	1e521052 	mrcne	0, 2, r1, cr2, cr2, {2}
    3150:	2780882b 	strcs	r8, [r0, fp, lsr #16]
    3154:	401f013f 	andmis	r0, pc, pc, lsr r1
    3158:	061b123b 	undefined
    315c:	2b080e1b 	blcs	0x2069d0
    3160:	1c52d100 	ldfnep	f5, [r2], {0}
    3164:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    3168:	d3002a05 	tstle	r0, #20480	; 0x5000
    316c:	2e0e2204 	cdpcs	2, 0, cr2, cr14, cr4, {0}
    3170:	2302d101 	tstcs	r2, #1073741824	; 0x40000000
    3174:	4b705eee 	blmi	0x1c1ad34
    3178:	496f8659 	stmmidb	pc!, {r0, r3, r4, r6, r9, sl, pc}^
    317c:	466b3134 	undefined
    3180:	700b791b 	andvc	r7, fp, fp, lsl r9
    3184:	18400091 	stmneda	r0, {r0, r4, r7}^
    3188:	1c289000 	stcne	0, cr9, [r8]
    318c:	68499900 	stmvsda	r9, {r8, fp, ip, pc}^
    3190:	ff9cf011 	swinv	0x009cf011
    3194:	20041c07 	andcs	r1, r4, r7, lsl #24
    3198:	428743c0 	addmi	r4, r7, #3	; 0x3
    319c:	f7ffd107 	ldrnvb	sp, [pc, r7, lsl #2]!
    31a0:	1c28f9dd 	stcne	9, cr15, [r8], #-884
    31a4:	68499900 	stmvsda	r9, {r8, fp, ip, pc}^
    31a8:	ff90f011 	swinv	0x0090f011
    31ac:	2f001c07 	swics	0x00001c07
    31b0:	2f01db1c 	swics	0x0001db1c
    31b4:	2000d104 	andcs	sp, r0, r4, lsl #2
    31b8:	79a080a0 	stmvcib	r0!, {r5, r7, pc}
    31bc:	e00c71e0 	and	r7, ip, r0, ror #3
    31c0:	d1022f03 	tstle	r2, r3, lsl #30
    31c4:	8e40485c 	mcrhi	8, 2, r4, cr0, cr12, {2}
    31c8:	0636e006 	ldreqt	lr, [r6], -r6
    31cc:	88a00e36 	stmhiia	r0!, {r1, r2, r4, r5, r9, sl, fp}
    31d0:	19892100 	stmneib	r9, {r8, sp}
    31d4:	18401049 	stmneda	r0, {r0, r3, r6, ip}^
    31d8:	466880a0 	strmibt	r8, [r8], -r0, lsr #1
    31dc:	f7ff7900 	ldrnvb	r7, [pc, r0, lsl #18]!
    31e0:	88a1fdd1 	stmhiia	r1!, {r0, r4, r6, r7, r8, sl, fp, ip, sp, lr, pc}
    31e4:	d2014288 	andle	r4, r1, #-2147483640	; 0x80000008
    31e8:	43ff2701 	mvnmis	r2, #262144	; 0x40000
    31ec:	f7fe1c38 	undefined
    31f0:	0000ff1f 	andeq	pc, r0, pc, lsl pc
    31f4:	2400b5f1 	strcs	fp, [r0], #-1521
    31f8:	00c921e0 	sbceq	r2, r9, r0, ror #3
    31fc:	23804a4d 	orrcs	r4, r0, #315392	; 0x4d000
    3200:	8805011b 	stmhida	r5, {r0, r1, r3, r4, r8}
    3204:	122d401d 	eorne	r4, sp, #29	; 0x1d
    3208:	0e2d062d 	cfmadda32eq	mvax1, mvax0, mvfx13, mvfx13
    320c:	d10b2d08 	tstle	fp, r8, lsl #26
    3210:	5ec32300 	cdppl	3, 12, cr2, cr3, cr0, {0}
    3214:	12094019 	andne	r4, r9, #25	; 0x19
    3218:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    321c:	22005c51 	andcs	r5, r0, #20736	; 0x5100
    3220:	06365e86 	ldreqt	r5, [r6], -r6, lsl #29
    3224:	e0121636 	ands	r1, r2, r6, lsr r6
    3228:	402b8805 	eormi	r8, fp, r5, lsl #16
    322c:	061b121b 	undefined
    3230:	2b080e1b 	blcs	0x206aa4
    3234:	2300d107 	tstcs	r0, #-1073741823	; 0xc0000001
    3238:	40195ec3 	andmis	r5, r9, r3, asr #29
    323c:	06091209 	streq	r1, [r9], -r9, lsl #4
    3240:	5c510e09 	mrrcpl	14, 0, r0, r1, cr9
    3244:	2100e001 	tstcs	r0, r1
    3248:	22025e41 	andcs	r5, r2, #1040	; 0x410
    324c:	4f3a5e86 	swimi	0x003a5e86
    3250:	78bd3732 	ldmvcia	sp!, {r1, r4, r5, r8, r9, sl, ip, sp}
    3254:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    3258:	d00c2925 	andle	r2, ip, r5, lsr #18
    325c:	d04e2929 	suble	r2, lr, r9, lsr #18
    3260:	d031292b 	eorles	r2, r1, fp, lsr #18
    3264:	d00b292c 	andle	r2, fp, ip, lsr #18
    3268:	d013292d 	andles	r2, r3, sp, lsr #18
    326c:	d01a292f 	andles	r2, sl, pc, lsr #18
    3270:	d0342935 	eorles	r2, r4, r5, lsr r9
    3274:	8838e058 	ldmhida	r8!, {r3, r4, r6, sp, lr, pc}
    3278:	80381980 	eorhis	r1, r8, r0, lsl #19
    327c:	e0552403 	subs	r2, r5, r3, lsl #8
    3280:	04302100 	ldreqt	r2, [r0], #-256
    3284:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    3288:	1c29fb5f 	stcne	11, cr15, [r9], #-380
    328c:	fe08f7fe 	mcr2	7, 0, pc, cr8, cr14, {7}
    3290:	e04b1c04 	sub	r1, fp, r4, lsl #24
    3294:	04302100 	ldreqt	r2, [r0], #-256
    3298:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    329c:	1c29fb55 	stcne	11, cr15, [r9], #-340
    32a0:	fe14f7fe 	mrc2	7, 0, pc, cr4, cr14, {7}
    32a4:	1c29e7f4 	stcne	7, cr14, [r9], #-976
    32a8:	30304823 	eorccs	r4, r0, r3, lsr #16
    32ac:	fdb4f7fe 	ldc2	7, cr15, [r4, #1016]!
    32b0:	04302100 	ldreqt	r2, [r0], #-256
    32b4:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    32b8:	7801fb47 	stmvcda	r1, {r0, r1, r2, r6, r8, r9, fp, ip, sp, lr, pc}
    32bc:	3030481e 	eorccs	r4, r0, lr, lsl r8
    32c0:	fd92f7fe 	ldc2	7, cr15, [r2, #1016]
    32c4:	e0312401 	eors	r2, r1, r1, lsl #8
    32c8:	481b1c29 	ldmmida	fp, {r0, r3, r5, sl, fp, ip}
    32cc:	f7fe3030 	undefined
    32d0:	0631fda3 	ldreqt	pc, [r1], -r3, lsr #27
    32d4:	78b80e09 	ldmvcia	r8!, {r0, r3, r9, sl, fp}
    32d8:	fe2ef7fe 	mcr2	7, 1, pc, cr14, cr14, {7}
    32dc:	466ae7f2 	undefined
    32e0:	04302100 	ldreqt	r2, [r0], #-256
    32e4:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    32e8:	1c06fabb 	stcne	10, cr15, [r6], {187}
    32ec:	f99af011 	ldmnvib	sl, {r0, r4, ip, sp, lr, pc}
    32f0:	46681c02 	strmibt	r1, [r8], -r2, lsl #24
    32f4:	1c307801 	ldcne	8, cr7, [r0], #-4
    32f8:	fae4f7ff 	blx	0xff9412fc
    32fc:	480fe016 	stmmida	pc, {r1, r2, r4, sp, lr, pc}
    3300:	0c360436 	cfldrseq	mvf0, [r6], #-216
    3304:	d1014286 	smlabble	r1, r6, r2, r4
    3308:	e00f2405 	and	r2, pc, r5, lsl #8
    330c:	2100466a 	tstcs	r0, sl, ror #12
    3310:	f7ff1c30 	undefined
    3314:	1c06faa5 	stcne	10, cr15, [r6], {165}
    3318:	78014668 	stmvcda	r1, {r3, r5, r6, r9, sl, lr}
    331c:	f7ff1c30 	undefined
    3320:	2800fae3 	stmcsda	r0, {r0, r1, r5, r6, r7, r9, fp, ip, sp, lr, pc}
    3324:	e7efd002 	strb	sp, [pc, r2]!
    3328:	43e42401 	mvnmi	r2, #16777216	; 0x1000000
    332c:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
    3330:	0000f86b 	andeq	pc, r0, fp, ror #16
    3334:	00000100 	andeq	r0, r0, r0, lsl #2
    3338:	00008680 	andeq	r8, r0, r0, lsl #13
    333c:	0000ffff 	streqd	pc, [r0], -pc
    3340:	1c06b5ff 	cfstr32ne	mvfx11, [r6], {255}
    3344:	20802400 	addcs	r2, r0, r0, lsl #8
    3348:	88310100 	ldmhida	r1!, {r8}
    334c:	12094001 	andne	r4, r9, #1	; 0x1
    3350:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    3354:	d1122908 	tstle	r2, r8, lsl #18
    3358:	5e302000 	cdppl	0, 3, cr2, cr0, cr0, {0}
    335c:	00c921e0 	sbceq	r2, r9, r0, ror #3
    3360:	12084001 	andne	r4, r8, #1	; 0x1
    3364:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    3368:	5c0949cf 	stcpl	9, cr4, [r9], {207}
    336c:	5e302000 	cdppl	0, 3, cr2, cr0, cr0, {0}
    3370:	16000600 	strne	r0, [r0], -r0, lsl #12
    3374:	5eb22202 	cdppl	2, 11, cr2, cr2, cr2, {0}
    3378:	20021887 	andcs	r1, r2, r7, lsl #17
    337c:	8831e016 	ldmhida	r1!, {r1, r2, r4, sp, lr, pc}
    3380:	12004008 	andne	r4, r0, #8	; 0x8
    3384:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    3388:	d10a2808 	tstle	sl, r8, lsl #16
    338c:	5e302000 	cdppl	0, 3, cr2, cr0, cr0, {0}
    3390:	00c921e0 	sbceq	r2, r9, r0, ror #3
    3394:	12084001 	andne	r4, r8, #1	; 0x1
    3398:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    339c:	5c0949c2 	stcpl	9, cr4, [r9], {194}
    33a0:	2000e001 	andcs	lr, r0, r1
    33a4:	20025e31 	andcs	r5, r2, r1, lsr lr
    33a8:	20045e37 	andcs	r5, r4, r7, lsr lr
    33ac:	06095e35 	undefined
    33b0:	29020e09 	stmcsdb	r2, {r0, r3, r9, sl, fp}
    33b4:	2909d003 	stmcsdb	r9, {r0, r1, ip, lr, pc}
    33b8:	2912d001 	ldmcsdb	r2, {r0, ip, lr, pc}
    33bc:	2000d10d 	andcs	sp, r0, sp, lsl #2
    33c0:	042bb401 	streqt	fp, [fp], #-1025
    33c4:	22000c1b 	andcs	r0, r0, #6912	; 0x1b00
    33c8:	0c090439 	cfstrseq	mvf0, [r9], {57}
    33cc:	f0005e30 	andnv	r5, r0, r0, lsr lr
    33d0:	b001f9f5 	strltd	pc, [r1], -r5
    33d4:	f7feb004 	ldrnvb	fp, [lr, r4]!
    33d8:	4668ffac 	strmibt	pc, [r8], -ip, lsr #31
    33dc:	32344ab3 	eorccs	r4, r4, #733184	; 0xb3000
    33e0:	71027812 	tstvc	r2, r2, lsl r8
    33e4:	1c68466a 	stcnel	6, cr4, [r8], #-424
    33e8:	48b080d0 	ldmmiia	r0!, {r4, r6, r7, pc}
    33ec:	90023008 	andls	r3, r2, r8
    33f0:	d1002917 	tstle	r0, r7, lsl r9
    33f4:	291be0bd 	ldmcsdb	fp, {r0, r2, r3, r4, r5, r7, sp, lr, pc}
    33f8:	291cd019 	ldmcsdb	ip, {r0, r3, r4, ip, lr, pc}
    33fc:	291dd061 	ldmcsdb	sp, {r0, r5, r6, ip, lr, pc}
    3400:	e10cd100 	tst	ip, r0, lsl #2
    3404:	d100291f 	tstle	r0, pc, lsl r9
    3408:	2923e131 	stmcsdb	r3!, {r0, r4, r5, r8, sp, lr, pc}
    340c:	e188d100 	orr	sp, r8, r0, lsl #2
    3410:	d1002924 	tstle	r0, r4, lsr #18
    3414:	2927e1a6 	stmcsdb	r7!, {r1, r2, r5, r7, r8, sp, lr, pc}
    3418:	2928d063 	stmcsdb	r8!, {r0, r1, r5, r6, ip, lr, pc}
    341c:	e0b6d100 	adcs	sp, r6, r0, lsl #2
    3420:	d100292a 	tstle	r0, sl, lsr #18
    3424:	292ee07e 	stmcsdb	lr!, {r1, r2, r3, r4, r5, r6, sp, lr, pc}
    3428:	e08bd100 	add	sp, fp, r0, lsl #2
    342c:	0438e0b3 	ldreqt	lr, [r8], #-179
    3430:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    3434:	2807fa0f 	stmcsda	r7, {r0, r1, r2, r3, r9, fp, ip, sp, lr, pc}
    3438:	1c78d136 	ldfnep	f5, [r8], #-216
    343c:	0c000400 	cfstrseq	mvf0, [r0], {0}
    3440:	fa08f7ff 	blx	0x241444
    3444:	d12f2801 	teqle	pc, r1, lsl #16
    3448:	0c000428 	cfstrseq	mvf0, [r0], {40}
    344c:	fa02f7ff 	blx	0xc1450
    3450:	d1292807 	teqle	r9, r7, lsl #16
    3454:	88c04668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}^
    3458:	f9fcf7ff 	ldmnvib	ip!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    345c:	d1232801 	teqle	r3, r1, lsl #16
    3460:	04282100 	streqt	r2, [r8], #-256
    3464:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    3468:	1c06fc81 	stcne	12, cr15, [r6], {129}
    346c:	21001c02 	tstcs	r0, r2, lsl #24
    3470:	0c000438 	cfstrseq	mvf0, [r0], {56}
    3474:	fd94f7fe 	ldc2	7, cr15, [r4, #1016]
    3478:	28001c04 	stmcsda	r0, {r2, sl, fp, ip}
    347c:	1c20da01 	stcne	10, cr13, [r0], #-4
    3480:	2200e7a8 	andcs	lr, r0, #44040192	; 0x2a00000
    3484:	04382100 	ldreqt	r2, [r8], #-256
    3488:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    348c:	1c07f9e9 	stcne	9, cr15, [r7], {233}
    3490:	21002200 	tstcs	r0, r0, lsl #4
    3494:	0c000428 	cfstrseq	mvf0, [r0], {40}
    3498:	f9e2f7ff 	stmnvib	r2!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    349c:	1c011c32 	stcne	12, cr1, [r1], {50}
    34a0:	f0111c38 	andnvs	r1, r1, r8, lsr ip
    34a4:	e7eafd79 	undefined
    34a8:	b4012000 	strlt	r2, [r1]
    34ac:	0c1b042b 	cfldrseq	mvf0, [fp], {43}
    34b0:	04392200 	ldreqt	r2, [r9], #-512
    34b4:	201b0c09 	andcss	r0, fp, r9, lsl #24
    34b8:	f980f000 	stmnvib	r0, {ip, sp, lr, pc}
    34bc:	b0011c04 	andlt	r1, r1, r4, lsl #24
    34c0:	1c52e7dd 	mrrcne	7, 13, lr, r2, cr13
    34c4:	04382100 	ldreqt	r2, [r8], #-256
    34c8:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    34cc:	1c07f9c9 	stcne	9, cr15, [r7], {201}
    34d0:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    34d4:	46681c2a 	strmibt	r1, [r8], -sl, lsr #24
    34d8:	1c387841 	ldcne	8, cr7, [r8], #-260
    34dc:	f9f2f7ff 	ldmnvib	r2!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    34e0:	2100e7cd 	smlabtcs	r0, sp, r7, lr
    34e4:	0c000428 	cfstrseq	mvf0, [r0], {40}
    34e8:	f9baf7ff 	ldmnvib	sl!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    34ec:	78094669 	stmvcda	r9, {r0, r3, r5, r6, r9, sl, lr}
    34f0:	f9faf7ff 	ldmnvib	sl!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    34f4:	20061c01 	andcs	r1, r6, r1, lsl #24
    34f8:	2306b401 	tstcs	r6, #16777216	; 0x1000000
    34fc:	88302200 	ldmhida	r0!, {r9, sp}
    3500:	00ed25e0 	rsceq	r2, sp, r0, ror #11
    3504:	12284005 	eorne	r4, r8, #5	; 0x5
    3508:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    350c:	fc4ef7ff 	mcrr2	7, 15, pc, lr, cr15
    3510:	2800b001 	stmcsda	r0, {r0, ip, sp, pc}
    3514:	9802d0b3 	stmlsda	r2, {r0, r1, r4, r5, r7, ip, lr, pc}
    3518:	8d499902 	stchil	9, cr9, [r9, #-8]
    351c:	854119c9 	strhib	r1, [r1, #-2505]
    3520:	e7ac2403 	str	r2, [ip, r3, lsl #8]!
    3524:	79014668 	stmvcdb	r1, {r3, r5, r6, r9, sl, lr}
    3528:	30304860 	eorccs	r4, r0, r0, ror #16
    352c:	fc74f7fe 	ldc2l	7, cr15, [r4], #-1016
    3530:	04391c2a 	ldreqt	r1, [r9], #-3114
    3534:	485d1409 	ldmmida	sp, {r0, r3, sl, ip}^
    3538:	78003034 	stmvcda	r0, {r2, r4, r5, ip, sp}
    353c:	fcd6f7fe 	ldc2l	7, cr15, [r6], {254}
    3540:	e79c2401 	ldr	r2, [ip, r1, lsl #8]
    3544:	04282100 	streqt	r2, [r8], #-256
    3548:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    354c:	4669f9fd 	undefined
    3550:	70017909 	andvc	r7, r1, r9, lsl #18
    3554:	30344855 	eorccs	r4, r4, r5, asr r8
    3558:	48547801 	ldmmida	r4, {r0, fp, ip, sp, lr}^
    355c:	f7fe3030 	undefined
    3560:	0639fc5b 	undefined
    3564:	48510e09 	ldmmida	r1, {r0, r3, r9, sl, fp}^
    3568:	f7fe3030 	undefined
    356c:	2402fc3d 	strcs	pc, [r2], #-3133
    3570:	1c52e785 	mrrcne	7, 8, lr, r2, cr5
    3574:	04382100 	ldreqt	r2, [r8], #-256
    3578:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    357c:	1c07f971 	stcne	9, cr15, [r7], {113}
    3580:	04282100 	streqt	r2, [r8], #-256
    3584:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    3588:	1c02fbf1 	stcne	11, cr15, [r2], {241}
    358c:	043fe7a3 	ldreqt	lr, [pc], #1955	; 0x3594
    3590:	2f220c3f 	swics	0x00220c3f
    3594:	2401d302 	strcs	sp, [r1], #-770
    3598:	e77043e4 	ldrb	r4, [r0, -r4, ror #7]!
    359c:	0c000428 	cfstrseq	mvf0, [r0], {40}
    35a0:	fbcef7ff 	blx	0xff3c15a6
    35a4:	28111c04 	ldmcsda	r1, {r2, sl, fp, ip}
    35a8:	2c00d2f5 	sfmcs	f5, 1, [r0], {245}
    35ac:	4668d028 	strmibt	sp, [r8], -r8, lsr #32
    35b0:	260088c5 	strcs	r8, [r0], -r5, asr #17
    35b4:	2100e00e 	tstcs	r0, lr
    35b8:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    35bc:	9903f9c5 	stmlsdb	r3, {r0, r2, r6, r7, r8, fp, ip, sp, lr, pc}
    35c0:	98036188 	stmlsda	r3, {r3, r7, r8, sp, lr}
    35c4:	28006980 	stmcsda	r0, {r7, r8, fp, sp, lr}
    35c8:	1c28d01b 	stcne	0, cr13, [r8], #-108
    35cc:	f9f4f7ff 	ldmnvib	r4!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    35d0:	1c761c05 	ldcnel	12, cr1, [r6], #-20
    35d4:	d21442a6 	andles	r4, r4, #1610612746	; 0x6000000a
    35d8:	493300b0 	ldmmidb	r3!, {r4, r5, r7}
    35dc:	90031808 	andls	r1, r3, r8, lsl #16
    35e0:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    35e4:	2807f937 	stmcsda	r7, {r0, r1, r2, r4, r5, r8, fp, ip, sp, lr, pc}
    35e8:	9903d1e5 	stmlsdb	r3, {r0, r2, r5, r6, r7, r8, ip, lr, pc}
    35ec:	00a82202 	adceq	r2, r8, r2, lsl #4
    35f0:	681b9b02 	ldmvsda	fp, {r1, r8, r9, fp, ip, pc}
    35f4:	5e801818 	mcrpl	8, 4, r1, cr0, cr8, {0}
    35f8:	68529a02 	ldmvsda	r2, {r1, r9, fp, ip, pc}^
    35fc:	e7df1810 	undefined
    3600:	00b02600 	adceqs	r2, r0, r0, lsl #12
    3604:	18084928 	stmneda	r8, {r3, r5, r8, fp, lr}
    3608:	61812100 	orrvs	r2, r1, r0, lsl #2
    360c:	30184826 	andccs	r4, r8, r6, lsr #16
    3610:	4a6700b9 	bmi	0x19c38fc
    3614:	f0115851 	andnvs	r5, r1, r1, asr r8
    3618:	1c04fd59 	stcne	13, cr15, [r4], {89}
    361c:	2100e72f 	tstcs	r0, pc, lsr #14
    3620:	0c000428 	cfstrseq	mvf0, [r0], {40}
    3624:	fa36f7ff 	blx	0xdc1628
    3628:	04321c46 	ldreqt	r1, [r2], #-3142
    362c:	21000c12 	tstcs	r0, r2, lsl ip
    3630:	0c000438 	cfstrseq	mvf0, [r0], {56}
    3634:	fcb4f7fe 	ldc2	7, cr15, [r4], #1016
    3638:	28001c04 	stmcsda	r0, {r2, sl, fp, ip}
    363c:	2200dbee 	andcs	sp, r0, #243712	; 0x3b800
    3640:	04382100 	ldreqt	r2, [r8], #-256
    3644:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    3648:	1c07f90b 	stcne	9, cr15, [r7], {11}
    364c:	21004668 	tstcs	r0, r8, ror #12
    3650:	23008041 	tstcs	r0, #65	; 0x41
    3654:	0c12042a 	cfldrseq	mvf0, [r2], {42}
    3658:	1c89a900 	stcne	9, cr10, [r9], {0}
    365c:	f7ff1c38 	undefined
    3660:	1c04fa73 	stcne	10, cr15, [r4], {115}
    3664:	88404668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}^
    3668:	54392100 	ldrplt	r2, [r9], #-256
    366c:	2100e707 	tstcs	r0, r7, lsl #14
    3670:	0c000428 	cfstrseq	mvf0, [r0], {40}
    3674:	f8f4f7ff 	ldmnvia	r4!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    3678:	78094669 	stmvcda	r9, {r0, r3, r5, r6, r9, sl, lr}
    367c:	f934f7ff 	ldmnvdb	r4!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    3680:	1e461c05 	cdpne	12, 4, cr1, cr6, cr5, {0}
    3684:	0ff641b6 	swieq	0x00f641b6
    3688:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    368c:	d0072806 	andle	r2, r7, r6, lsl #16
    3690:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    3694:	d0032804 	andle	r2, r3, r4, lsl #16
    3698:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    369c:	d10f2802 	tstle	pc, r2, lsl #16
    36a0:	d5051c28 	strle	r1, [r5, #-3112]
    36a4:	e0051c76 	and	r1, r5, r6, ror ip
    36a8:	00000100 	andeq	r0, r0, r0, lsl #2
    36ac:	00008680 	andeq	r8, r0, r0, lsl #13
    36b0:	d00e2800 	andle	r2, lr, r0, lsl #16
    36b4:	f014210a 	andnvs	r2, r4, sl, lsl #2
    36b8:	1c08f929 	stcne	9, cr15, [r8], {41}
    36bc:	e7f71c76 	undefined
    36c0:	e0041c28 	and	r1, r4, r8, lsr #24
    36c4:	f014210a 	andnvs	r2, r4, sl, lsl #2
    36c8:	1c08f919 	stcne	9, cr15, [r8], {25}
    36cc:	28001c76 	stmcsda	r0, {r1, r2, r4, r5, r6, sl, fp, ip}
    36d0:	1c76d1f8 	ldfnep	f5, [r6], #-992
    36d4:	0c120432 	cfldrseq	mvf0, [r2], {50}
    36d8:	04382100 	ldreqt	r2, [r8], #-256
    36dc:	f7fe0c00 	ldrnvb	r0, [lr, r0, lsl #24]!
    36e0:	1c04fc5f 	stcne	12, cr15, [r4], {95}
    36e4:	db182800 	blle	0x60d6ec
    36e8:	1c52aa00 	mrrcne	10, 0, sl, r2, cr0
    36ec:	04382100 	ldreqt	r2, [r8], #-256
    36f0:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    36f4:	1c07f8b5 	stcne	8, cr15, [r7], {181}
    36f8:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    36fc:	d0072806 	andle	r2, r7, r6, lsl #16
    3700:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    3704:	d0032804 	andle	r2, r3, r4, lsl #16
    3708:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    370c:	d1052802 	tstle	r5, r2, lsl #16
    3710:	49291c2a 	stmmidb	r9!, {r1, r3, r5, sl, fp, ip}
    3714:	f0111c38 	andnvs	r1, r1, r8, lsr ip
    3718:	e6b0fc9f 	ssat	pc, #17, pc, LSL #25
    371c:	a1251c2a 	teqge	r5, sl, lsr #24
    3720:	2100e7f8 	strcsd	lr, [r0, -r8]
    3724:	0c000428 	cfstrseq	mvf0, [r0], {40}
    3728:	fb20f7ff 	blx	0x84172e
    372c:	d0f41c06 	rscles	r1, r4, r6, lsl #24
    3730:	04121e72 	ldreq	r1, [r2], #-3698
    3734:	21000c12 	tstcs	r0, r2, lsl ip
    3738:	0c000438 	cfstrseq	mvf0, [r0], {56}
    373c:	fc30f7fe 	ldc2	7, cr15, [r0], #-1016
    3740:	28001c04 	stmcsda	r0, {r2, sl, fp, ip}
    3744:	2200dbe9 	andcs	sp, r0, #238592	; 0x3a400
    3748:	04382100 	ldreqt	r2, [r8], #-256
    374c:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    3750:	1c07f887 	stcne	8, cr15, [r7], {135}
    3754:	21002200 	tstcs	r0, r0, lsl #4
    3758:	0c000428 	cfstrseq	mvf0, [r0], {40}
    375c:	f880f7ff 	stmnvia	r0, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    3760:	e69b1e76 	undefined
    3764:	04282100 	streqt	r2, [r8], #-256
    3768:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    376c:	1c06faff 	stcne	10, cr15, [r6], {255}
    3770:	04121c42 	ldreq	r1, [r2], #-3138
    3774:	21000c12 	tstcs	r0, r2, lsl ip
    3778:	0c000438 	cfstrseq	mvf0, [r0], {56}
    377c:	fc10f7fe 	ldc2	7, cr15, [r0], {254}
    3780:	28001c04 	stmcsda	r0, {r2, sl, fp, ip}
    3784:	2200db13 	andcs	sp, r0, #19456	; 0x4c00
    3788:	04382100 	ldreqt	r2, [r8], #-256
    378c:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    3790:	1c07f867 	stcne	8, cr15, [r7], {103}
    3794:	21002200 	tstcs	r0, r0, lsl #4
    3798:	0c000428 	cfstrseq	mvf0, [r0], {40}
    379c:	f860f7ff 	stmnvda	r0!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    37a0:	1c011c32 	stcne	12, cr1, [r1], {50}
    37a4:	f0111c38 	andnvs	r1, r1, r8, lsr ip
    37a8:	2000fbf7 	strcsd	pc, [r0], -r7
    37ac:	e66655b8 	undefined
    37b0:	000001a0 	andeq	r0, r0, r0, lsr #3
    37b4:	00007525 	andeq	r7, r0, r5, lsr #10
    37b8:	0011b3dc 	ldreqsb	fp, [r1], -ip
    37bc:	b083b5f5 	strltd	fp, [r3], r5
    37c0:	1c1d1c0c 	ldcne	12, cr1, [sp], {12}
    37c4:	1c082700 	stcne	7, cr2, [r8], {0}
    37c8:	f844f7ff 	stmnvda	r4, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    37cc:	70484669 	subvc	r4, r8, r9, ror #12
    37d0:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    37d4:	4669f83f 	undefined
    37d8:	46687008 	strmibt	r7, [r8], -r8
    37dc:	28077800 	stmcsda	r7, {fp, ip, sp, lr}
    37e0:	d0264668 	eorle	r4, r6, r8, ror #12
    37e4:	28087800 	stmcsda	r8, {fp, ip, sp, lr}
    37e8:	aa00d038 	bge	0x378d0
    37ec:	46681c52 	undefined
    37f0:	1c208a01 	stcne	10, cr8, [r0], #-4
    37f4:	f834f7ff 	ldmnvda	r4!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    37f8:	466a1c04 	strmibt	r1, [sl], -r4, lsl #24
    37fc:	8d014668 	stchi	6, cr4, [r1, #-416]
    3800:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    3804:	4669f82d 	strmibt	pc, [r9], -sp, lsr #16
    3808:	f7ff7809 	ldrnvb	r7, [pc, r9, lsl #16]!
    380c:	1c01f86d 	stcne	8, cr15, [r1], {109}
    3810:	78024668 	stmvcda	r2, {r3, r5, r6, r9, sl, lr}
    3814:	200c466b 	andcs	r4, ip, fp, ror #12
    3818:	f0005e18 	andnv	r5, r0, r8, lsl lr
    381c:	1c02f8c3 	stcne	8, cr15, [r2], {195}
    3820:	78414668 	stmvcda	r1, {r3, r5, r6, r9, sl, lr}^
    3824:	f7ff1c20 	ldrnvb	r1, [pc, r0, lsr #24]!
    3828:	2000f84d 	andcs	pc, r0, sp, asr #16
    382c:	f7feb005 	ldrnvb	fp, [lr, r5]!
    3830:	8d01fd80 	stchi	13, cr15, [r1, #-512]
    3834:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    3838:	1c06fa99 	stcne	10, cr15, [r6], {153}
    383c:	8d014668 	stchi	6, cr4, [r1, #-416]
    3840:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    3844:	4669fa87 	strmibt	pc, [r9], -r7, lsl #21
    3848:	466880c8 	strmibt	r8, [r8], -r8, asr #1
    384c:	220a88c9 	andcs	r8, sl, #13172736	; 0xc90000
    3850:	4a534351 	bmi	0x14d459c
    3854:	5a516ad2 	bpl	0x145e3a4
    3858:	e0038501 	and	r8, r3, r1, lsl #10
    385c:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    3860:	1c06fa6f 	stcne	10, cr15, [r6], {111}
    3864:	78404668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}^
    3868:	46682807 	strmibt	r2, [r8], -r7, lsl #16
    386c:	7800d136 	stmvcda	r0, {r1, r2, r4, r5, r8, ip, lr, pc}
    3870:	d0022807 	andle	r2, r2, r7, lsl #16
    3874:	43c02000 	bicmi	r2, r0, #0	; 0x0
    3878:	1c32e7d8 	ldcne	7, cr14, [r2], #-864
    387c:	8a014668 	bhi	0x55224
    3880:	f7fe1c20 	ldrnvb	r1, [lr, r0, lsr #24]!
    3884:	1c07fb8d 	stcne	11, cr15, [r7], {141}
    3888:	da012800 	ble	0x4d890
    388c:	e7cd1c38 	undefined
    3890:	81064668 	tsthi	r6, r8, ror #12
    3894:	1c208a01 	stcne	10, cr8, [r0], #-4
    3898:	fa5cf7ff 	blx	0x174189c
    389c:	80884669 	addhi	r4, r8, r9, ror #12
    38a0:	88894668 	stmhiia	r9, {r3, r5, r6, r9, sl, lr}
    38a4:	4351220a 	cmpmi	r1, #-1610612736	; 0xa0000000
    38a8:	6ad24a3d 	bvs	0xff4961a4
    38ac:	82015a51 	andhi	r5, r1, #331776	; 0x51000
    38b0:	70812100 	addvc	r2, r1, r0, lsl #2
    38b4:	78404668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}^
    38b8:	d0032807 	andle	r2, r3, r7, lsl #16
    38bc:	78404668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}^
    38c0:	d1002808 	tstle	r0, r8, lsl #16
    38c4:	46681c64 	strmibt	r1, [r8], -r4, ror #24
    38c8:	28077800 	stmcsda	r7, {fp, ip, sp, lr}
    38cc:	4668d003 	strmibt	sp, [r8], -r3
    38d0:	28087800 	stmcsda	r8, {fp, ip, sp, lr}
    38d4:	1c6dd100 	stfnep	f5, [sp]
    38d8:	e0182600 	ands	r2, r8, r0, lsl #12
    38dc:	28087840 	stmcsda	r8, {r6, fp, ip, sp, lr}
    38e0:	1c20d1e8 	stfned	f5, [r0], #-928
    38e4:	fa2cf7ff 	blx	0xb418e8
    38e8:	81084669 	tsthi	r8, r9, ror #12
    38ec:	21014668 	tstcs	r1, r8, ror #12
    38f0:	e7e77081 	strb	r7, [r7, r1, lsl #1]!
    38f4:	28087800 	stmcsda	r8, {fp, ip, sp, lr}
    38f8:	4668d108 	strmibt	sp, [r8], -r8, lsl #2
    38fc:	28007880 	stmcsda	r0, {r7, fp, ip, sp, lr}
    3900:	0428d004 	streqt	sp, [r8], #-4
    3904:	f7ff0c00 	ldrnvb	r0, [pc, r0, lsl #24]!
    3908:	1c05f857 	stcne	8, cr15, [r5], {87}
    390c:	46681c76 	undefined
    3910:	04368900 	ldreqt	r8, [r6], #-2304
    3914:	42860c36 	addmi	r0, r6, #13824	; 0x3600
    3918:	4668d2b8 	undefined
    391c:	b4018d00 	strlt	r8, [r1], #-3328
    3920:	0c1b042b 	cfldrseq	mvf0, [fp], {43}
    3924:	8a02a801 	bhi	0xad930
    3928:	0c090421 	cfstrseq	mvf0, [r9], {33}
    392c:	200caf01 	andcs	sl, ip, r1, lsl #30
    3930:	f7ff5e38 	undefined
    3934:	1c07ff43 	stcne	15, cr15, [r7], {67}
    3938:	2800b001 	stmcsda	r0, {r0, ip, sp, pc}
    393c:	4668dba6 	strmibt	sp, [r8], -r6, lsr #23
    3940:	28077840 	stmcsda	r7, {r6, fp, ip, sp, lr}
    3944:	d10c4668 	tstle	ip, r8, ror #12
    3948:	8a094669 	bhi	0x2552f4
    394c:	8892466a 	ldmhiia	r2, {r1, r3, r5, r6, r9, sl, lr}
    3950:	435a230a 	cmpmi	sl, #671088640	; 0x28000000
    3954:	6adb4b12 	bvs	0xff6d65a4
    3958:	8852189a 	ldmhida	r2, {r1, r3, r4, r7, fp, ip}^
    395c:	82011889 	andhi	r1, r1, #8978432	; 0x890000
    3960:	7840e00b 	stmvcda	r0, {r0, r1, r3, sp, lr, pc}^
    3964:	d1082808 	tstle	r8, r8, lsl #16
    3968:	78804668 	stmvcia	r0, {r3, r5, r6, r9, sl, lr}
    396c:	d0042800 	andle	r2, r4, r0, lsl #16
    3970:	0c000420 	cfstrseq	mvf0, [r0], {32}
    3974:	f820f7ff 	stmnvda	r0!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    3978:	46681c04 	strmibt	r1, [r8], -r4, lsl #24
    397c:	28077800 	stmcsda	r7, {fp, ip, sp, lr}
    3980:	d1b74668 	movles	r4, r8, ror #12
    3984:	8d094669 	stchi	6, cr4, [r9, #-420]
    3988:	88d2466a 	ldmhiia	r2, {r1, r3, r5, r6, r9, sl, lr}^
    398c:	435a230a 	cmpmi	sl, #671088640	; 0x28000000
    3990:	6adb4b03 	bvs	0xff6d65a4
    3994:	8852189a 	ldmhida	r2, {r1, r3, r4, r7, fp, ip}^
    3998:	85011889 	strhi	r1, [r1, #-2185]
    399c:	0000e7b6 	streqh	lr, [r0], -r6
    39a0:	00008680 	andeq	r8, r0, r0, lsl #13
    39a4:	1c04b530 	cfstr32ne	mvfx11, [r4], {48}
    39a8:	25e01c08 	strcsb	r1, [r0, #3080]!
    39ac:	218000ed 	orrcs	r0, r0, sp, ror #1
    39b0:	40210109 	eormi	r0, r1, r9, lsl #2
    39b4:	06091209 	streq	r1, [r9], -r9, lsl #4
    39b8:	29080e09 	stmcsdb	r8, {r0, r3, r9, sl, fp}
    39bc:	1c29d107 	stfned	f5, [r9], #-28
    39c0:	12094021 	andne	r4, r9, #33	; 0x21
    39c4:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    39c8:	5c594b12 	fmrrdpl	r4, r9, d2
    39cc:	1c21e000 	stcne	0, cr14, [r1]
    39d0:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    39d4:	d0062902 	andle	r2, r6, r2, lsl #18
    39d8:	d0072909 	andle	r2, r7, r9, lsl #18
    39dc:	d0092912 	andle	r2, r9, r2, lsl r9
    39e0:	d014291b 	andles	r2, r4, fp, lsl r9
    39e4:	4241e012 	submi	lr, r1, #18	; 0x12
    39e8:	e0101c08 	ands	r1, r0, r8, lsl #24
    39ec:	41801e40 	orrmi	r1, r0, r0, asr #28
    39f0:	e00c0fc0 	and	r0, ip, r0, asr #31
    39f4:	1c13b404 	cfldrsne	mvf11, [r3], {4}
    39f8:	1c012200 	sfmne	f2, 4, [r1], {0}
    39fc:	12284025 	eorne	r4, r8, #37	; 0x25
    3a00:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    3a04:	f9d2f7ff 	ldmnvib	r2, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    3a08:	e000b001 	and	fp, r0, r1
    3a0c:	f7fc2000 	ldrnvb	r2, [ip, r0]!
    3a10:	0000fd00 	andeq	pc, r0, r0, lsl #26
    3a14:	00000100 	andeq	r0, r0, r0, lsl #2
    3a18:	b083b5f1 	strltd	fp, [r3], r1
    3a1c:	94022400 	strls	r2, [r2], #-1024
    3a20:	218048cd 	orrcs	r4, r0, sp, asr #17
    3a24:	9a030109 	bls	0xc3e50
    3a28:	400a8812 	andmi	r8, sl, r2, lsl r8
    3a2c:	06121212 	undefined
    3a30:	2a080e12 	bcs	0x207280
    3a34:	9903d119 	stmlsdb	r3, {r0, r3, r4, r8, ip, lr, pc}
    3a38:	5e892200 	cdppl	2, 8, cr2, cr9, cr0, {0}
    3a3c:	00d222e0 	sbceqs	r2, r2, r0, ror #5
    3a40:	1211400a 	andnes	r4, r1, #10	; 0xa
    3a44:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    3a48:	46685c45 	strmibt	r5, [r8], -r5, asr #24
    3a4c:	22009903 	andcs	r9, r0, #49152	; 0xc000
    3a50:	06095e89 	streq	r5, [r9], -r9, lsl #29
    3a54:	22021609 	andcs	r1, r2, #9437184	; 0x900000
    3a58:	5e9a9b03 	cdppl	11, 9, cr9, cr10, cr3, {0}
    3a5c:	80411889 	subhi	r1, r1, r9, lsl #17
    3a60:	884a9903 	stmhida	sl, {r0, r1, r8, fp, ip, pc}^
    3a64:	20048082 	andcs	r8, r4, r2, lsl #1
    3a68:	9a03e01d 	bls	0xfbae4
    3a6c:	40118812 	andmis	r8, r1, r2, lsl r8
    3a70:	06091209 	streq	r1, [r9], -r9, lsl #4
    3a74:	29080e09 	stmcsdb	r8, {r0, r3, r9, sl, fp}
    3a78:	9903d10a 	stmlsdb	r3, {r1, r3, r8, ip, lr, pc}
    3a7c:	5e892200 	cdppl	2, 8, cr2, cr9, cr0, {0}
    3a80:	00d222e0 	sbceqs	r2, r2, r0, ror #5
    3a84:	1211400a 	andnes	r4, r1, #10	; 0xa
    3a88:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    3a8c:	e0025c45 	and	r5, r2, r5, asr #24
    3a90:	21009803 	tstcs	r0, r3, lsl #16
    3a94:	46685e45 	strmibt	r5, [r8], -r5, asr #28
    3a98:	884a9903 	stmhida	sl, {r0, r1, r8, fp, ip, pc}^
    3a9c:	99038042 	stmlsdb	r3, {r1, r6, pc}
    3aa0:	8082888a 	addhi	r8, r2, sl, lsl #17
    3aa4:	99032006 	stmlsdb	r3, {r1, r2, sp}
    3aa8:	062d5e0e 	streqt	r5, [sp], -lr, lsl #28
    3aac:	d00d0e2d 	andle	r0, sp, sp, lsr #28
    3ab0:	d00b2d01 	andle	r2, fp, r1, lsl #26
    3ab4:	d0092d03 	andle	r2, r9, r3, lsl #26
    3ab8:	d0072d04 	andle	r2, r7, r4, lsl #26
    3abc:	d0052d05 	andle	r2, r5, r5, lsl #26
    3ac0:	d0032d06 	andle	r2, r3, r6, lsl #26
    3ac4:	d0012d07 	andle	r2, r1, r7, lsl #26
    3ac8:	d10e2d08 	tstle	lr, r8, lsl #26
    3acc:	20002200 	andcs	r2, r0, r0, lsl #4
    3ad0:	0c090431 	cfstrseq	mvf0, [r9], {49}
    3ad4:	a803b407 	stmgeda	r3, {r0, r1, r2, sl, ip, sp, pc}
    3ad8:	88418883 	stmhida	r1, {r0, r1, r7, fp, pc}^
    3adc:	f0001c28 	andnv	r1, r0, r8, lsr #24
    3ae0:	b003f977 	andlt	pc, r3, r7, ror r9
    3ae4:	f7feb004 	ldrnvb	fp, [lr, r4]!
    3ae8:	2d26fc24 	stccs	12, cr15, [r6, #-144]!
    3aec:	aa01d007 	bge	0x77b10
    3af0:	21001c92 	strcsb	r1, [r0, -r2]
    3af4:	88404668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}^
    3af8:	feb2f7fe 	mrc2	7, 5, pc, cr2, cr14, {7}
    3afc:	2d159002 	ldccs	0, cr9, [r5, #-8]
    3b00:	466ad00c 	strmibt	sp, [sl], -ip
    3b04:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    3b08:	f7fe8880 	ldrnvb	r8, [lr, r0, lsl #17]!
    3b0c:	1c07fea9 	stcne	14, cr15, [r7], {169}
    3b10:	78014668 	stmvcda	r1, {r3, r5, r6, r9, sl, lr}
    3b14:	f7fe1c38 	undefined
    3b18:	1c07fee7 	stcne	14, cr15, [r7], {231}
    3b1c:	d0122d33 	andles	r2, r2, r3, lsr sp
    3b20:	d0102d30 	andles	r2, r0, r0, lsr sp
    3b24:	d00e2d32 	andle	r2, lr, r2, lsr sp
    3b28:	d00c2d15 	andle	r2, ip, r5, lsl sp
    3b2c:	d00a2d1a 	andle	r2, sl, sl, lsl sp
    3b30:	1c52aa00 	mrrcne	10, 0, sl, r2, cr0
    3b34:	04302100 	ldreqt	r2, [r0], #-256
    3b38:	f7fe0c00 	ldrnvb	r0, [lr, r0, lsl #24]!
    3b3c:	4669fe91 	undefined
    3b40:	f7fe7849 	ldrnvb	r7, [lr, r9, asr #16]!
    3b44:	1c38fed1 	ldcne	14, cr15, [r8], #-836
    3b48:	43482106 	cmpmi	r8, #-2147483647	; 0x80000001
    3b4c:	20c01831 	sbccs	r1, r0, r1, lsr r8
    3b50:	43080200 	tstmi	r8, #0	; 0x0
    3b54:	4a9c2100 	bmi	0xfe70bf5c
    3b58:	d0102d11 	andles	r2, r0, r1, lsl sp
    3b5c:	d1002d15 	tstle	r0, r5, lsl sp
    3b60:	2d1ae0b7 	ldccs	0, cr14, [sl, #-732]
    3b64:	e0e8d100 	rsc	sp, r8, r0, lsl #2
    3b68:	d0572d26 	subles	r2, r7, r6, lsr #26
    3b6c:	d1002d30 	tstle	r0, r0, lsr sp
    3b70:	2d32e08d 	ldccs	0, cr14, [r2, #-564]!
    3b74:	e09ad100 	adds	sp, sl, r0, lsl #2
    3b78:	d0702d33 	rsbles	r2, r0, r3, lsr sp
    3b7c:	4668e121 	strmibt	lr, [r8], -r1, lsr #2
    3b80:	f7fe8840 	ldrnvb	r8, [lr, r0, asr #16]!
    3b84:	2807fe67 	stmcsda	r7, {r0, r1, r2, r5, r6, r9, sl, fp, ip, sp, lr, pc}
    3b88:	4668d039 	undefined
    3b8c:	f7fe8840 	ldrnvb	r8, [lr, r0, asr #16]!
    3b90:	2808fe61 	stmcsda	r8, {r0, r5, r6, r9, sl, fp, ip, sp, lr, pc}
    3b94:	4668d033 	undefined
    3b98:	f7fe8880 	ldrnvb	r8, [lr, r0, lsl #17]!
    3b9c:	2807fe5b 	stmcsda	r7, {r0, r1, r3, r4, r6, r9, sl, fp, ip, sp, lr, pc}
    3ba0:	4668d005 	strmibt	sp, [r8], -r5
    3ba4:	f7fe8880 	ldrnvb	r8, [lr, r0, lsl #17]!
    3ba8:	2808fe55 	stmcsda	r8, {r0, r2, r4, r6, r9, sl, fp, ip, sp, lr, pc}
    3bac:	0430d127 	ldreqt	sp, [r0], #-295
    3bb0:	f7fe0c00 	ldrnvb	r0, [lr, r0, lsl #24]!
    3bb4:	2807fe4f 	stmcsda	r7, {r0, r1, r2, r3, r6, r9, sl, fp, ip, sp, lr, pc}
    3bb8:	0430d005 	ldreqt	sp, [r0], #-5
    3bbc:	f7fe0c00 	ldrnvb	r0, [lr, r0, lsl #24]!
    3bc0:	2808fe49 	stmcsda	r8, {r0, r3, r6, r9, sl, fp, ip, sp, lr, pc}
    3bc4:	2100d11b 	tstcs	r0, fp, lsl r1
    3bc8:	0c000430 	cfstrseq	mvf0, [r0], {48}
    3bcc:	2300b403 	tstcs	r0, #50331648	; 0x3000000
    3bd0:	8882a802 	stmhiia	r2, {r1, fp, sp, pc}
    3bd4:	1cc9a903 	stcnel	9, cr10, [r9], {3}
    3bd8:	88009805 	stmhida	r0, {r0, r2, fp, ip, pc}
    3bdc:	00e424e0 	rsceq	r2, r4, r0, ror #9
    3be0:	12204004 	eorne	r4, r0, #4	; 0x4
    3be4:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    3be8:	f92ef7ff 	stmnvdb	lr!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    3bec:	a8021c04 	stmgeda	r2, {r2, sl, fp, ip}
    3bf0:	798179c2 	stmvcib	r1, {r1, r6, r7, r8, fp, ip, sp, lr}
    3bf4:	f7fe9804 	ldrnvb	r9, [lr, r4, lsl #16]!
    3bf8:	b002fe65 	andlt	pc, r2, r5, ror #28
    3bfc:	2200e0b9 	andcs	lr, r0, #185	; 0xb9
    3c00:	04312000 	ldreqt	r2, [r1]
    3c04:	b4070c09 	strlt	r0, [r7], #-3081
    3c08:	8883a803 	stmhiia	r3, {r0, r1, fp, sp, pc}
    3c0c:	98068841 	stmlsda	r6, {r0, r6, fp, pc}
    3c10:	f0005f00 	andnv	r5, r0, r0, lsl #30
    3c14:	1c04f8dd 	stcne	8, cr15, [r4], {221}
    3c18:	e0aab003 	adc	fp, sl, r3
    3c1c:	0c000430 	cfstrseq	mvf0, [r0], {48}
    3c20:	2300b403 	tstcs	r0, #50331648	; 0x3000000
    3c24:	8882a802 	stmhiia	r2, {r1, fp, sp, pc}
    3c28:	1cc9a903 	stcnel	9, cr10, [r9], {3}
    3c2c:	88009805 	stmhida	r0, {r0, r2, fp, ip, pc}
    3c30:	00e424e0 	rsceq	r2, r4, r0, ror #9
    3c34:	12204004 	eorne	r4, r0, #4	; 0x4
    3c38:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    3c3c:	f904f7ff 	stmnvdb	r4, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    3c40:	a8021c04 	stmgeda	r2, {r2, sl, fp, ip}
    3c44:	b00279c0 	andlt	r7, r2, r0, asr #19
    3c48:	d0072800 	andle	r2, r7, r0, lsl #16
    3c4c:	495f485f 	ldmmidb	pc, {r0, r1, r2, r3, r4, r6, fp, lr}^
    3c50:	466a8e49 	strmibt	r8, [sl], -r9, asr #28
    3c54:	18898852 	stmneia	r9, {r1, r4, r6, fp, pc}
    3c58:	24038641 	strcs	r8, [r3], #-1601
    3c5c:	466ae089 	strmibt	lr, [sl], -r9, lsl #1
    3c60:	4347200f 	cmpmi	r7, #15	; 0xf
    3c64:	20c219f3 	strcsd	r1, [r2], #147
    3c68:	43180200 	tstmi	r8, #0	; 0x0
    3c6c:	0c000400 	cfstrseq	mvf0, [r0], {0}
    3c70:	fdf6f7fe 	ldc2l	7, cr15, [r6, #1016]!
    3c74:	46681c07 	strmibt	r1, [r8], -r7, lsl #24
    3c78:	1c387801 	ldcne	8, cr7, [r8], #-4
    3c7c:	fe34f7fe 	mrc2	7, 1, pc, cr4, cr14, {7}
    3c80:	46681c02 	strmibt	r1, [r8], -r2, lsl #24
    3c84:	98027981 	stmlsda	r2, {r0, r7, r8, fp, ip, sp, lr}
    3c88:	fe1cf7fe 	mrc2	7, 0, pc, cr12, cr14, {7}
    3c8c:	466ae071 	undefined
    3c90:	0c000400 	cfstrseq	mvf0, [r0], {0}
    3c94:	fde4f7fe 	stc2l	7, cr15, [r4, #1016]!
    3c98:	46681c07 	strmibt	r1, [r8], -r7, lsl #24
    3c9c:	98027981 	stmlsda	r2, {r0, r7, r8, fp, ip, sp, lr}
    3ca0:	fe22f7fe 	mcr2	7, 1, pc, cr2, cr14, {7}
    3ca4:	46681c02 	strmibt	r1, [r8], -r2, lsl #24
    3ca8:	1c387801 	ldcne	8, cr7, [r8], #-4
    3cac:	466ae7ec 	strmibt	lr, [sl], -ip, ror #15
    3cb0:	0c000400 	cfstrseq	mvf0, [r0], {0}
    3cb4:	fdd4f7fe 	ldc2l	7, cr15, [r4, #1016]
    3cb8:	46681c07 	strmibt	r1, [r8], -r7, lsl #24
    3cbc:	1c387801 	ldcne	8, cr7, [r8], #-4
    3cc0:	fe12f7fe 	mrc2	7, 0, pc, cr2, cr14, {7}
    3cc4:	46681c02 	strmibt	r1, [r8], -r2, lsl #24
    3cc8:	98027981 	stmlsda	r2, {r0, r7, r8, fp, ip, sp, lr}
    3ccc:	fdfaf7fe 	ldc2l	7, cr15, [sl, #1016]!
    3cd0:	0436e04f 	ldreqt	lr, [r6], #-79
    3cd4:	42960c36 	addmis	r0, r6, #13824	; 0x3600
    3cd8:	aa00d00a 	bge	0x37d08
    3cdc:	1c301c52 	ldcne	12, cr1, [r0], #-328
    3ce0:	fdbef7fe 	ldc2	7, cr15, [lr, #1016]!
    3ce4:	78494669 	stmvcda	r9, {r0, r3, r5, r6, r9, sl, lr}^
    3ce8:	fdfef7fe 	ldc2l	7, cr15, [lr, #1016]!
    3cec:	e0001c05 	and	r1, r0, r5, lsl #24
    3cf0:	21002500 	tstcs	r0, r0, lsl #10
    3cf4:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    3cf8:	f82cf7ff 	stmnvda	ip!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    3cfc:	4348210a 	cmpmi	r8, #-2147483646	; 0x80000002
    3d00:	6ac94932 	bvs	0xff2561d0
    3d04:	88811808 	stmhiia	r1, {r3, fp, ip}
    3d08:	d302428d 	tstle	r2, #-805306360	; 0xd0000008
    3d0c:	43c02000 	bicmi	r2, r0, #0	; 0x0
    3d10:	8801e6e8 	stmhida	r1, {r3, r5, r6, r7, r9, sl, sp, lr, pc}
    3d14:	43688840 	cmnmi	r8, #4194304	; 0x400000
    3d18:	04001808 	streq	r1, [r0], #-2056
    3d1c:	b4010c00 	strlt	r0, [r1], #-3072
    3d20:	8883a801 	stmhiia	r3, {r0, fp, sp, pc}
    3d24:	041b1c5b 	ldreq	r1, [fp], #-3163
    3d28:	22000c1b 	andcs	r0, r0, #6912	; 0x1b00
    3d2c:	201b8841 	andcss	r8, fp, r1, asr #16
    3d30:	fd44f7ff 	stc2l	7, cr15, [r4, #-1020]
    3d34:	b0011c04 	andlt	r1, r1, r4, lsl #24
    3d38:	0436e01b 	ldreqt	lr, [r6], #-27
    3d3c:	42960c36 	addmis	r0, r6, #13824	; 0x3600
    3d40:	aa00d00c 	bge	0x37d78
    3d44:	1c301c52 	ldcne	12, cr1, [r0], #-328
    3d48:	fd8af7fe 	stc2	7, cr15, [sl, #1016]
    3d4c:	78494669 	stmvcda	r9, {r0, r3, r5, r6, r9, sl, lr}^
    3d50:	fdcaf7fe 	stc2l	7, cr15, [sl, #1016]
    3d54:	e0021c05 	and	r1, r2, r5, lsl #24
    3d58:	00000100 	andeq	r0, r0, r0, lsl #2
    3d5c:	042a2500 	streqt	r2, [sl], #-1280
    3d60:	21000c12 	tstcs	r0, r2, lsl ip
    3d64:	88404668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}^
    3d68:	f91af7fe 	ldmnvdb	sl, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    3d6c:	28001c04 	stmcsda	r0, {r2, sl, fp, ip}
    3d70:	1c20da01 	stcne	10, cr13, [r0], #-4
    3d74:	2100e6b6 	strcsh	lr, [r0, -r6]
    3d78:	88404668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}^
    3d7c:	ffeaf7fe 	swinv	0x00eaf7fe
    3d80:	27001c06 	strcs	r1, [r0, -r6, lsl #24]
    3d84:	0c3f043f 	cfldrseq	mvf0, [pc], #-252
    3d88:	d2f242af 	rscles	r4, r2, #-268435446	; 0xf000000a
    3d8c:	4370200a 	cmnmi	r0, #10	; 0xa
    3d90:	6ac9490e 	bvs	0xff2561d0
    3d94:	21001808 	tstcs	r0, r8, lsl #16
    3d98:	a901b402 	stmgedb	r1, {r1, sl, ip, sp, pc}
    3d9c:	8801888b 	stmhida	r1, {r0, r1, r3, r7, fp, pc}
    3da0:	43788840 	cmnmi	r8, #4194304	; 0x400000
    3da4:	0412180a 	ldreq	r1, [r2], #-2058
    3da8:	a8010c12 	stmgeda	r1, {r1, r4, sl, fp}
    3dac:	1c498841 	mcrrne	8, 4, r8, r9, cr1
    3db0:	0c090409 	cfstrseq	mvf0, [r9], {9}
    3db4:	f7ff201b 	undefined
    3db8:	1c04fd01 	stcne	13, cr15, [r4], {1}
    3dbc:	b0011c7f 	andlt	r1, r1, pc, ror ip
    3dc0:	2401e7e0 	strcs	lr, [r1], #-2016
    3dc4:	e7d443e4 	ldrb	r4, [r4, r4, ror #7]
    3dc8:	0000ffff 	streqd	pc, [r0], -pc
    3dcc:	00008680 	andeq	r8, r0, r0, lsl #13
    3dd0:	b085b5f5 	strltd	fp, [r5], r5
    3dd4:	1c1c1c0e 	ldcne	12, cr1, [ip], {14}
    3dd8:	8e854668 	cdphi	6, 8, cr4, cr5, cr8, {3}
    3ddc:	1c082700 	stcne	7, cr2, [r8], {0}
    3de0:	fd38f7fe 	ldc2	7, cr15, [r8, #-1016]!
    3de4:	70884669 	addvc	r4, r8, r9, ror #12
    3de8:	f7fe1c20 	ldrnvb	r1, [lr, r0, lsr #24]!
    3dec:	4669fd33 	undefined
    3df0:	1c287048 	stcne	0, cr7, [r8], #-288
    3df4:	fd2ef7fe 	stc2	7, cr15, [lr, #-1016]!
    3df8:	70084669 	andvc	r4, r8, r9, ror #12
    3dfc:	78404668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}^
    3e00:	46682807 	strmibt	r2, [r8], -r7, lsl #16
    3e04:	7840d043 	stmvcda	r0, {r0, r1, r6, ip, lr, pc}^
    3e08:	d0562808 	subles	r2, r6, r8, lsl #16
    3e0c:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    3e10:	d0572807 	subles	r2, r7, r7, lsl #16
    3e14:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    3e18:	d06e2808 	rsble	r2, lr, r8, lsl #16
    3e1c:	1c92aa00 	fldmiasne	r2, {s20-s19}
    3e20:	8b014668 	blhi	0x557c8
    3e24:	f7fe1c30 	undefined
    3e28:	1c06fd1b 	stcne	13, cr15, [r6], {27}
    3e2c:	1c52aa00 	mrrcne	10, 0, sl, r2, cr0
    3e30:	8e014668 	cfmadd32hi	mvax3, mvfx4, mvfx1, mvfx8
    3e34:	f7fe1c20 	ldrnvb	r1, [lr, r0, lsr #24]!
    3e38:	1c04fd13 	stcne	13, cr15, [r4], {19}
    3e3c:	4668466a 	strmibt	r4, [r8], -sl, ror #12
    3e40:	1c288f01 	stcne	15, cr8, [r8], #-4
    3e44:	fd0cf7fe 	stc2	7, cr15, [ip, #-1016]
    3e48:	46681c05 	strmibt	r1, [r8], -r5, lsl #24
    3e4c:	1c207841 	stcne	8, cr7, [r0], #-260
    3e50:	fd4af7fe 	stc2l	7, cr15, [sl, #-1016]
    3e54:	46681c04 	strmibt	r1, [r8], -r4, lsl #24
    3e58:	1c287801 	stcne	8, cr7, [r8], #-4
    3e5c:	fd44f7fe 	stc2l	7, cr15, [r4, #-1016]
    3e60:	78094669 	stmvcda	r9, {r0, r3, r5, r6, r9, sl, lr}
    3e64:	a901b402 	stmgedb	r1, {r1, sl, ip, sp, pc}
    3e68:	1c02784b 	stcne	8, cr7, [r2], {75}
    3e6c:	ac011c21 	stcge	12, cr1, [r1], {33}
    3e70:	5e202014 	miapl	acc0, r4, r2
    3e74:	f92cf000 	stmnvdb	ip!, {ip, sp, lr, pc}
    3e78:	a8011c02 	stmgeda	r1, {r1, sl, fp, ip}
    3e7c:	1c307881 	ldcne	8, cr7, [r0], #-516
    3e80:	fd20f7fe 	stc2	7, cr15, [r0, #-1016]!
    3e84:	b0012000 	andlt	r2, r1, r0
    3e88:	f7feb007 	ldrnvb	fp, [lr, r7]!
    3e8c:	8e01fa52 	mcrhi	10, 0, pc, cr1, cr2, {2}
    3e90:	f7fe1c20 	ldrnvb	r1, [lr, r0, lsr #24]!
    3e94:	4669ff6b 	strmibt	pc, [r9], -fp, ror #30
    3e98:	46688088 	strmibt	r8, [r8], -r8, lsl #1
    3e9c:	1c208e01 	stcne	14, cr8, [r0], #-4
    3ea0:	ff58f7fe 	swinv	0x0058f7fe
    3ea4:	81884669 	orrhi	r4, r8, r9, ror #12
    3ea8:	89894668 	stmhiib	r9, {r3, r5, r6, r9, sl, lr}
    3eac:	4351220a 	cmpmi	r1, #-1610612736	; 0xa0000000
    3eb0:	6ad24a86 	bvs	0xff4968d0
    3eb4:	86015a51 	undefined
    3eb8:	1c20e004 	stcne	0, cr14, [r0], #-16
    3ebc:	ff40f7fe 	swinv	0x0040f7fe
    3ec0:	80884669 	addhi	r4, r8, r9, ror #12
    3ec4:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    3ec8:	d1162807 	tstle	r6, r7, lsl #16
    3ecc:	8f014668 	swihi	0x00014668
    3ed0:	f7fe1c28 	ldrnvb	r1, [lr, r8, lsr #24]!
    3ed4:	4669ff4b 	strmibt	pc, [r9], -fp, asr #30
    3ed8:	466880c8 	strmibt	r8, [r8], -r8, asr #1
    3edc:	1c288f01 	stcne	15, cr8, [r8], #-4
    3ee0:	ff38f7fe 	swinv	0x0038f7fe
    3ee4:	81c84669 	bichi	r4, r8, r9, ror #12
    3ee8:	89c94668 	stmhiib	r9, {r3, r5, r6, r9, sl, lr}^
    3eec:	4351220a 	cmpmi	r1, #-1610612736	; 0xa0000000
    3ef0:	6ad24a76 	bvs	0xff4968d0
    3ef4:	87015a51 	smlsdhi	r1, r1, sl, r5
    3ef8:	4668e008 	strmibt	lr, [r8], -r8
    3efc:	28087800 	stmcsda	r8, {fp, ip, sp, lr}
    3f00:	1c28d104 	stfned	f5, [r8], #-16
    3f04:	ff1cf7fe 	swinv	0x001cf7fe
    3f08:	80c84669 	sbchi	r4, r8, r9, ror #12
    3f0c:	78804668 	stmvcia	r0, {r3, r5, r6, r9, sl, lr}
    3f10:	46682807 	strmibt	r2, [r8], -r7, lsl #16
    3f14:	7840d154 	stmvcda	r0, {r2, r4, r6, r8, ip, lr, pc}^
    3f18:	46682807 	strmibt	r2, [r8], -r7, lsl #16
    3f1c:	d1147800 	tstle	r4, r0, lsl #16
    3f20:	46682807 	strmibt	r2, [r8], -r7, lsl #16
    3f24:	88894669 	stmhiia	r9, {r0, r3, r5, r6, r9, sl, lr}
    3f28:	466ad104 	strmibt	sp, [sl], -r4, lsl #2
    3f2c:	429188d2 	addmis	r8, r1, #13762560	; 0xd20000
    3f30:	1c11d900 	ldcne	9, cr13, [r1], {0}
    3f34:	89028101 	stmhidb	r2, {r0, r8, pc}
    3f38:	1c308b01 	ldcne	11, cr8, [r0], #-4
    3f3c:	f830f7fe 	ldmnvda	r0!, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    3f40:	28001c07 	stmcsda	r0, {r0, r1, r2, sl, fp, ip}
    3f44:	1c38da0a 	ldcne	10, cr13, [r8], #-40
    3f48:	2807e79e 	stmcsda	r7, {r1, r2, r3, r4, r7, r8, r9, sl, sp, lr, pc}
    3f4c:	4668d103 	strmibt	sp, [r8], -r3, lsl #2
    3f50:	88c94669 	stmhiia	r9, {r0, r3, r5, r6, r9, sl, lr}^
    3f54:	2000e7ee 	andcs	lr, r0, lr, ror #15
    3f58:	e79543c0 	ldr	r4, [r5, r0, asr #7]
    3f5c:	46694668 	strmibt	r4, [r9], -r8, ror #12
    3f60:	82018909 	andhi	r8, r1, #147456	; 0x24000
    3f64:	1c308b01 	ldcne	11, cr8, [r0], #-4
    3f68:	fef4f7fe 	mrc2	7, 7, pc, cr4, cr14, {7}
    3f6c:	81484669 	cmphi	r8, r9, ror #12
    3f70:	89494668 	stmhidb	r9, {r3, r5, r6, r9, sl, lr}^
    3f74:	4351220a 	cmpmi	r1, #-1610612736	; 0xa0000000
    3f78:	6ad24a54 	bvs	0xff4968d0
    3f7c:	83015a51 	tsthi	r1, #331776	; 0x51000
    3f80:	70c12100 	sbcvc	r2, r1, r0, lsl #2
    3f84:	78804668 	stmvcia	r0, {r3, r5, r6, r9, sl, lr}
    3f88:	d0032807 	andle	r2, r3, r7, lsl #16
    3f8c:	78804668 	stmvcia	r0, {r3, r5, r6, r9, sl, lr}
    3f90:	d1002808 	tstle	r0, r8, lsl #16
    3f94:	46681c76 	undefined
    3f98:	28077840 	stmcsda	r7, {r6, fp, ip, sp, lr}
    3f9c:	4668d003 	strmibt	sp, [r8], -r3
    3fa0:	28087840 	stmcsda	r8, {r6, fp, ip, sp, lr}
    3fa4:	1c64d100 	stfnep	f5, [r4]
    3fa8:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    3fac:	d0032807 	andle	r2, r3, r7, lsl #16
    3fb0:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    3fb4:	d1002808 	tstle	r0, r8, lsl #16
    3fb8:	46681c6d 	strmibt	r1, [r8], -sp, ror #24
    3fbc:	e01b2100 	ands	r2, fp, r0, lsl #2
    3fc0:	28087880 	stmcsda	r8, {r7, fp, ip, sp, lr}
    3fc4:	1c30d1de 	ldfned	f5, [r0], #-888
    3fc8:	febaf7fe 	mrc2	7, 5, pc, cr10, cr14, {7}
    3fcc:	82084669 	andhi	r4, r8, #110100480	; 0x6900000
    3fd0:	21014668 	tstcs	r1, r8, ror #12
    3fd4:	e7dd70c1 	ldrb	r7, [sp, r1, asr #1]
    3fd8:	28087800 	stmcsda	r8, {fp, ip, sp, lr}
    3fdc:	4668d108 	strmibt	sp, [r8], -r8, lsl #2
    3fe0:	280078c0 	stmcsda	r0, {r6, r7, fp, ip, sp, lr}
    3fe4:	0428d004 	streqt	sp, [r8], #-4
    3fe8:	f7fe0c00 	ldrnvb	r0, [lr, r0, lsl #24]!
    3fec:	1c05fce5 	stcne	12, cr15, [r5], {229}
    3ff0:	46694668 	strmibt	r4, [r9], -r8, ror #12
    3ff4:	1c498889 	mcrrne	8, 8, r8, r9, cr9
    3ff8:	88808081 	stmhiia	r0, {r0, r7, pc}
    3ffc:	8a094669 	bhi	0x2559a8
    4000:	d2a04288 	adcle	r4, r0, #-2147483640	; 0x80000008
    4004:	8f024668 	swihi	0x00024668
    4008:	04298e00 	streqt	r8, [r9], #-3584
    400c:	b4070c09 	strlt	r0, [r7], #-3081
    4010:	0c1b0423 	cfldrseq	mvf0, [fp], {35}
    4014:	8b02a803 	blhi	0xae028
    4018:	0c090431 	cfstrseq	mvf0, [r9], {49}
    401c:	2014af03 	andcss	sl, r4, r3, lsl #30
    4020:	f7ff5e38 	undefined
    4024:	1c07fed5 	stcne	14, cr15, [r7], {213}
    4028:	2800b003 	stmcsda	r0, {r0, r1, ip, sp, pc}
    402c:	4668db8b 	strmibt	sp, [r8], -fp, lsl #23
    4030:	28077880 	stmcsda	r7, {r7, fp, ip, sp, lr}
    4034:	d10c4668 	tstle	ip, r8, ror #12
    4038:	8b094669 	blhi	0x2559e4
    403c:	8952466a 	ldmhidb	r2, {r1, r3, r5, r6, r9, sl, lr}^
    4040:	435a230a 	cmpmi	sl, #671088640	; 0x28000000
    4044:	6adb4b21 	bvs	0xff6d6cd0
    4048:	8852189a 	ldmhida	r2, {r1, r3, r4, r7, fp, ip}^
    404c:	83011889 	tsthi	r1, #8978432	; 0x890000
    4050:	7880e00b 	stmvcia	r0, {r0, r1, r3, sp, lr, pc}
    4054:	d1082808 	tstle	r8, r8, lsl #16
    4058:	78c04668 	stmvcia	r0, {r3, r5, r6, r9, sl, lr}^
    405c:	d0042800 	andle	r2, r4, r0, lsl #16
    4060:	0c000430 	cfstrseq	mvf0, [r0], {48}
    4064:	fca8f7fe 	stc2	7, cr15, [r8], #1016
    4068:	46681c06 	strmibt	r1, [r8], -r6, lsl #24
    406c:	28077840 	stmcsda	r7, {r6, fp, ip, sp, lr}
    4070:	d10c4668 	tstle	ip, r8, ror #12
    4074:	8e094669 	cfmadd32hi	mvax3, mvfx4, mvfx9, mvfx9
    4078:	8992466a 	ldmhiib	r2, {r1, r3, r5, r6, r9, sl, lr}
    407c:	435a230a 	cmpmi	sl, #671088640	; 0x28000000
    4080:	6adb4b12 	bvs	0xff6d6cd0
    4084:	8852189a 	ldmhida	r2, {r1, r3, r4, r7, fp, ip}^
    4088:	86011889 	strhi	r1, [r1], -r9, lsl #17
    408c:	7840e00b 	stmvcda	r0, {r0, r1, r3, sp, lr, pc}^
    4090:	d1082808 	tstle	r8, r8, lsl #16
    4094:	78c04668 	stmvcia	r0, {r3, r5, r6, r9, sl, lr}^
    4098:	d0042800 	andle	r2, r4, r0, lsl #16
    409c:	0c000420 	cfstrseq	mvf0, [r0], {32}
    40a0:	fc8af7fe 	stc2	7, cr15, [sl], {254}
    40a4:	46681c04 	strmibt	r1, [r8], -r4, lsl #24
    40a8:	28077800 	stmcsda	r7, {fp, ip, sp, lr}
    40ac:	d1934668 	orrles	r4, r3, r8, ror #12
    40b0:	8f094669 	swihi	0x00094669
    40b4:	89d2466a 	ldmhiib	r2, {r1, r3, r5, r6, r9, sl, lr}^
    40b8:	435a230a 	cmpmi	sl, #671088640	; 0x28000000
    40bc:	6adb4b03 	bvs	0xff6d6cd0
    40c0:	8852189a 	ldmhida	r2, {r1, r3, r4, r7, fp, ip}^
    40c4:	87011889 	strhi	r1, [r1, -r9, lsl #17]
    40c8:	0000e792 	muleq	r0, r2, r7
    40cc:	00008680 	andeq	r8, r0, r0, lsl #13
    40d0:	1c04b5f0 	cfstr32ne	mvfx11, [r4], {240}
    40d4:	1c111c08 	ldcne	12, cr1, [r1], {8}
    40d8:	7d15466a 	ldcvc	6, cr4, [r5, #-424]
    40dc:	01122280 	tsteq	r2, r0, lsl #5
    40e0:	12124022 	andnes	r4, r2, #34	; 0x22
    40e4:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    40e8:	d1082a08 	tstle	r8, r8, lsl #20
    40ec:	00d222e0 	sbceqs	r2, r2, r0, ror #5
    40f0:	12124022 	andnes	r4, r2, #34	; 0x22
    40f4:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    40f8:	5cb64e30 	ldcpl	14, cr4, [r6], #192
    40fc:	1c26e000 	stcne	0, cr14, [r6]
    4100:	43021c0a 	tstmi	r2, #2560	; 0xa00
    4104:	0e360636 	cfmsuba32eq	mvax1, mvax0, mvfx6, mvfx6
    4108:	2e01d010 	mcrcs	0, 0, sp, cr1, cr0, {0}
    410c:	2e03d010 	mcrcs	0, 0, sp, cr3, cr0, {0}
    4110:	2e04d010 	mcrcs	0, 0, sp, cr4, cr0, {0}
    4114:	2e05d010 	mcrcs	0, 0, sp, cr5, cr0, {0}
    4118:	2e06d025 	cdpcs	0, 0, cr13, cr6, cr5, {1}
    411c:	2e07d037 	mcrcs	0, 0, sp, cr7, cr7, {1}
    4120:	2e08d037 	mcrcs	0, 0, sp, cr8, cr7, {1}
    4124:	2e11d037 	mrccs	0, 0, sp, cr1, cr7, {1}
    4128:	e007d039 	and	sp, r7, r9, lsr r0
    412c:	e0421840 	sub	r1, r2, r0, asr #16
    4130:	e0401a40 	sub	r1, r0, r0, asr #20
    4134:	e03e4348 	eors	r4, lr, r8, asr #6
    4138:	d1012900 	tstle	r1, r0, lsl #18
    413c:	e03a2000 	eors	r2, sl, r0
    4140:	d0032b02 	andle	r2, r3, r2, lsl #22
    4144:	d0012b04 	andle	r2, r1, r4, lsl #22
    4148:	d1092b06 	tstle	r9, r6, lsl #22
    414c:	d0032d02 	andle	r2, r3, r2, lsl #26
    4150:	d0012d04 	andle	r2, r1, r4, lsl #26
    4154:	d1032d06 	tstle	r3, r6, lsl #26
    4158:	fbd8f013 	blx	0xff6401ae
    415c:	e02a1c08 	eor	r1, sl, r8, lsl #24
    4160:	fbccf013 	blx	0xff3401b6
    4164:	2900e7fa 	stmcsdb	r0, {r1, r3, r4, r5, r6, r7, r8, r9, sl, sp, lr, pc}
    4168:	2b02d025 	blcs	0xb8204
    416c:	2b04d003 	blcs	0x138180
    4170:	2b06d001 	blcs	0x1b817c
    4174:	2d02d108 	stfcsd	f5, [r2, #-32]
    4178:	2d04d003 	stccs	0, cr13, [r4, #-12]
    417c:	2d06d001 	stccs	0, cr13, [r6, #-4]
    4180:	f013d102 	andnvs	sp, r3, r2, lsl #2
    4184:	e016fbc3 	ands	pc, r6, r3, asr #23
    4188:	fbb8f013 	blx	0xfee401de
    418c:	4001e013 	andmi	lr, r1, r3, lsl r0
    4190:	1c10e7e4 	ldcne	7, cr14, [r0], {228}
    4194:	4001e00f 	andmi	lr, r1, pc
    4198:	401043c8 	andmis	r4, r0, r8, asr #7
    419c:	b420e00b 	strltt	lr, [r0], #-11
    41a0:	1c011c0a 	stcne	12, cr1, [r1], {10}
    41a4:	00c020e0 	sbceq	r2, r0, r0, ror #1
    41a8:	12004020 	andne	r4, r0, #32	; 0x20
    41ac:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    41b0:	fdfcf7fe 	ldc2l	7, cr15, [ip, #1016]!
    41b4:	f7feb001 	ldrnvb	fp, [lr, r1]!
    41b8:	0000f8bc 	streqh	pc, [r0], -ip
    41bc:	00000100 	andeq	r0, r0, r0, lsl #2
    41c0:	43c02001 	bicmi	r2, r0, #1	; 0x1
    41c4:	00004770 	andeq	r4, r0, r0, ror r7
    41c8:	b08cb5f0 	strltd	fp, [ip], r0
    41cc:	27001c05 	strcs	r1, [r0, -r5, lsl #24]
    41d0:	21808800 	orrcs	r8, r0, r0, lsl #16
    41d4:	40010109 	andmi	r0, r1, r9, lsl #2
    41d8:	06001208 	streq	r1, [r0], -r8, lsl #4
    41dc:	28080e00 	stmcsda	r8, {r9, sl, fp}
    41e0:	2000d10a 	andcs	sp, r0, sl, lsl #2
    41e4:	21e05e28 	mvncs	r5, r8, lsr #28
    41e8:	400100c9 	andmi	r0, r1, r9, asr #1
    41ec:	06001208 	streq	r1, [r0], -r8, lsl #4
    41f0:	49d70e00 	ldmmiib	r7, {r9, sl, fp}^
    41f4:	e0015c09 	and	r5, r1, r9, lsl #24
    41f8:	5e292000 	cdppl	0, 2, cr2, cr9, cr0, {0}
    41fc:	060948d5 	undefined
    4200:	29160e09 	ldmcsdb	r6, {r0, r3, r9, sl, fp}
    4204:	2918d015 	ldmcsdb	r8, {r0, r2, r4, ip, lr, pc}
    4208:	e1d6d100 	bics	sp, r6, r0, lsl #2
    420c:	d1002919 	tstle	r0, r9, lsl r9
    4210:	291ee0b9 	ldmcsdb	lr, {r0, r3, r4, r5, r7, sp, lr, pc}
    4214:	e2efd100 	rsc	sp, pc, #0	; 0x0
    4218:	d1002920 	tstle	r0, r0, lsr #18
    421c:	2921e335 	stmcsdb	r1!, {r0, r2, r4, r5, r8, r9, sp, lr, pc}
    4220:	e27ad100 	rsbs	sp, sl, #0	; 0x0
    4224:	d1002922 	tstle	r0, r2, lsr #18
    4228:	2931e141 	ldmcsdb	r1!, {r0, r6, r8, sp, lr, pc}
    422c:	e1c0d100 	bic	sp, r0, r0, lsl #2
    4230:	4668e39a 	undefined
    4234:	80818869 	addhi	r8, r1, r9, ror #16
    4238:	800188a9 	andhi	r8, r1, r9, lsr #17
    423c:	5e2c2006 	cdppl	0, 2, cr2, cr12, cr6, {0}
    4240:	89294668 	stmhidb	r9!, {r3, r5, r6, r9, sl, lr}
    4244:	888080c1 	stmhiia	r0, {r0, r6, r7, pc}
    4248:	88094669 	stmhida	r9, {r0, r3, r5, r6, r9, sl, lr}
    424c:	d0104288 	andles	r4, r0, r8, lsl #5
    4250:	b4012000 	strlt	r2, [r1]
    4254:	8803a801 	stmhida	r3, {r0, fp, sp, pc}
    4258:	88812200 	stmhiia	r1, {r9, sp}
    425c:	f7ff201b 	undefined
    4260:	1c07faad 	stcne	10, cr15, [r7], {173}
    4264:	2800b001 	stmcsda	r0, {r0, ip, sp, pc}
    4268:	1c38da03 	ldcne	10, cr13, [r8], #-12
    426c:	f7feb00c 	ldrnvb	fp, [lr, ip]!
    4270:	2100f860 	tstcsp	r0, r0, ror #16
    4274:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    4278:	fd6cf7fe 	stc2l	7, cr15, [ip, #-1016]!
    427c:	81c84669 	bichi	r4, r8, r9, ror #12
    4280:	042448b5 	streqt	r4, [r4], #-2229
    4284:	42840c24 	addmi	r0, r4, #9216	; 0x2400
    4288:	aa02d00c 	bge	0xb82c0
    428c:	1c202100 	stfnes	f2, [r0]
    4290:	fae6f7fe 	blx	0xff9c2290
    4294:	46681c04 	strmibt	r1, [r8], -r4, lsl #24
    4298:	1c207a01 	stcne	10, cr7, [r0], #-4
    429c:	fb24f7fe 	blx	0x94229e
    42a0:	e0001c04 	and	r1, r0, r4, lsl #24
    42a4:	21002400 	tstcs	r0, r0, lsl #8
    42a8:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    42ac:	fd5ef7fe 	ldc2l	7, cr15, [lr, #-1016]
    42b0:	1c061c05 	stcne	12, cr1, [r6], {5}
    42b4:	d3014284 	tstle	r1, #1073741832	; 0x40000008
    42b8:	e7d72000 	ldrb	r2, [r7, r0]
    42bc:	89c04668 	stmhiib	r0, {r3, r5, r6, r9, sl, lr}^
    42c0:	4348210a 	cmpmi	r8, #-2147483646	; 0x80000002
    42c4:	46689004 	strmibt	r9, [r8], -r4
    42c8:	88894669 	stmhiia	r9, {r0, r3, r5, r6, r9, sl, lr}
    42cc:	82c11c49 	sbchi	r1, r1, #18688	; 0x4900
    42d0:	f7fe88c0 	ldrnvb	r8, [lr, r0, asr #17]!
    42d4:	2807fabf 	stmcsda	r7, {r0, r1, r2, r3, r4, r5, r7, r9, fp, ip, sp, lr, pc}
    42d8:	9804d015 	stmlsda	r4, {r0, r2, r4, ip, lr, pc}
    42dc:	6ac9499f 	bvs	0xff256960
    42e0:	21001808 	tstcs	r0, r8, lsl #16
    42e4:	a901b402 	stmgedb	r1, {r1, sl, ip, sp, pc}
    42e8:	880188cb 	stmhida	r1, {r0, r1, r3, r6, r7, fp, pc}
    42ec:	43608840 	cmnmi	r0, #4194304	; 0x400000
    42f0:	0412180a 	ldreq	r1, [r2], #-2058
    42f4:	a8010c12 	stmgeda	r1, {r1, r4, sl, fp}
    42f8:	201b8ac1 	andcss	r8, fp, r1, asr #21
    42fc:	fa5ef7ff 	blx	0x17c2300
    4300:	b0011c07 	andlt	r1, r1, r7, lsl #24
    4304:	2100e7b1 	strcsh	lr, [r0, -r1]
    4308:	88c04668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}^
    430c:	fd22f7fe 	stc2	7, cr15, [r2, #-1016]!
    4310:	85884669 	strhi	r4, [r8, #1641]
    4314:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    4318:	f7fe88c0 	ldrnvb	r8, [lr, r0, asr #17]!
    431c:	1b31fd27 	blne	0xc837c0
    4320:	d2014281 	andle	r4, r1, #268435464	; 0x10000008
    4324:	e0001b2d 	and	r1, r0, sp, lsr #22
    4328:	26001c05 	strcs	r1, [r0], -r5, lsl #24
    432c:	0c360436 	cfldrseq	mvf0, [r6], #-216
    4330:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    4334:	d29842ae 	addles	r4, r8, #-536870902	; 0xe000000a
    4338:	6ac14888 	bvs	0xff056560
    433c:	18089804 	stmneda	r8, {r2, fp, ip, pc}
    4340:	8d92466a 	ldchi	6, cr4, [r2, #424]
    4344:	435a230a 	cmpmi	sl, #671088640	; 0x28000000
    4348:	880a1889 	stmhida	sl, {r0, r3, r7, fp, ip}
    434c:	43718849 	cmnmi	r1, #4784128	; 0x490000
    4350:	04091851 	streq	r1, [r9], #-2129
    4354:	b4020c09 	strlt	r0, [r2], #-3081
    4358:	88cba901 	stmhiia	fp, {r0, r8, fp, sp, pc}^
    435c:	041b1c5b 	ldreq	r1, [fp], #-3163
    4360:	88010c1b 	stmhida	r1, {r0, r1, r3, r4, sl, fp}
    4364:	19a28840 	stmneib	r2!, {r6, fp, pc}
    4368:	180a4350 	stmneda	sl, {r4, r6, r8, r9, lr}
    436c:	0c120412 	cfldrseq	mvf0, [r2], {18}
    4370:	8ac1a801 	bhi	0xff06e37c
    4374:	f7ff201b 	undefined
    4378:	1c07fa21 	stcne	10, cr15, [r7], {33}
    437c:	2800b001 	stmcsda	r0, {r0, ip, sp, pc}
    4380:	1c76dbc0 	ldcnel	11, cr13, [r6], #-768
    4384:	4668e7d2 	undefined
    4388:	80818869 	addhi	r8, r1, r9, ror #16
    438c:	800188a9 	andhi	r8, r1, r9, lsr #17
    4390:	5e2c2006 	cdppl	0, 2, cr2, cr12, cr6, {0}
    4394:	89294668 	stmhidb	r9!, {r3, r5, r6, r9, sl, lr}
    4398:	210080c1 	smlabtcs	r0, r1, r0, r8
    439c:	f7fe8800 	ldrnvb	r8, [lr, r0, lsl #16]!
    43a0:	1c07fce5 	stcne	12, cr15, [r7], {229}
    43a4:	0424486c 	streqt	r4, [r4], #-2156
    43a8:	42840c24 	addmi	r0, r4, #9216	; 0x2400
    43ac:	aa02d00c 	bge	0xb83e4
    43b0:	1c202100 	stfnes	f2, [r0]
    43b4:	fa54f7fe 	blx	0x15423b4
    43b8:	46681c04 	strmibt	r1, [r8], -r4, lsl #24
    43bc:	1c207a01 	stcne	10, cr7, [r0], #-4
    43c0:	fa92f7fe 	blx	0xfe4c23c0
    43c4:	e0001c04 	and	r1, r0, r4, lsl #24
    43c8:	1c3d2400 	cfldrsne	mvf2, [sp]
    43cc:	88c04668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}^
    43d0:	42884961 	addmi	r4, r8, #1589248	; 0x184000
    43d4:	aa02d00c 	bge	0xb840c
    43d8:	21001c52 	tstcs	r0, r2, asr ip
    43dc:	88c04668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}^
    43e0:	fa3ef7fe 	blx	0xfc23e0
    43e4:	7a494669 	bvc	0x1255d90
    43e8:	fa7ef7fe 	blx	0x1fc23e8
    43ec:	e0021c06 	and	r1, r2, r6, lsl #24
    43f0:	04361b2e 	ldreqt	r1, [r6], #-2862
    43f4:	42a50c36 	adcmi	r0, r5, #13824	; 0x3600
    43f8:	2200d207 	andcs	sp, r0, #1879048192	; 0x70000000
    43fc:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    4400:	f7fd8880 	ldrnvb	r8, [sp, r0, lsl #17]!
    4404:	1c07fdcd 	stcne	13, cr15, [r7], {205}
    4408:	1b3de72f 	blne	0xf7e0cc
    440c:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    4410:	d20042ae 	andle	r4, r0, #-536870902	; 0xe000000a
    4414:	042a1c35 	streqt	r1, [sl], #-3125
    4418:	21000c12 	tstcs	r0, r2, lsl ip
    441c:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    4420:	fdbef7fd 	ldc2	7, cr15, [lr, #1012]!
    4424:	28001c07 	stmcsda	r0, {r0, r1, r2, sl, fp, ip}
    4428:	2100dbee 	smlattcs	r0, lr, fp, sp
    442c:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    4430:	fc90f7fe 	ldc2	7, cr15, [r0], {254}
    4434:	81c84669 	bichi	r4, r8, r9, ror #12
    4438:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    443c:	f7fe8800 	ldrnvb	r8, [lr, r0, lsl #16]!
    4440:	4669fc89 	strmibt	pc, [r9], -r9, lsl #25
    4444:	26008388 	strcs	r8, [r0], -r8, lsl #7
    4448:	0c360436 	cfldrseq	mvf0, [r6], #-216
    444c:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    4450:	d2d942ae 	sbcles	r4, r9, #-536870902	; 0xe000000a
    4454:	6ac04841 	bvs	0xff016560
    4458:	89c94669 	stmhiib	r9, {r0, r3, r5, r6, r9, sl, lr}^
    445c:	4351220a 	cmpmi	r1, #-1610612736	; 0xa0000000
    4460:	466a1841 	strmibt	r1, [sl], -r1, asr #16
    4464:	230a8b92 	tstcs	sl, #149504	; 0x24800
    4468:	1880435a 	stmneia	r0, {r1, r3, r4, r6, r8, r9, lr}
    446c:	88408802 	stmhida	r0, {r1, fp, pc}^
    4470:	435819a3 	cmpmi	r8, #2670592	; 0x28c000
    4474:	04001810 	streq	r1, [r0], #-2064
    4478:	b4010c00 	strlt	r0, [r1], #-3072
    447c:	8803a801 	stmhida	r3, {r0, fp, sp, pc}
    4480:	041b1c5b 	ldreq	r1, [fp], #-3163
    4484:	88080c1b 	stmhida	r8, {r0, r1, r3, r4, sl, fp}
    4488:	43718849 	cmnmi	r1, #4784128	; 0x490000
    448c:	04121842 	ldreq	r1, [r2], #-2114
    4490:	a8010c12 	stmgeda	r1, {r1, r4, sl, fp}
    4494:	1c498881 	mcrrne	8, 8, r8, r9, cr1
    4498:	0c090409 	cfstrseq	mvf0, [r9], {9}
    449c:	f7ff201b 	undefined
    44a0:	1c07f98d 	stcne	9, cr15, [r7], {141}
    44a4:	2800b001 	stmcsda	r0, {r0, ip, sp, pc}
    44a8:	1c76dbae 	ldcnel	11, cr13, [r6], #-696
    44ac:	4668e7cc 	strmibt	lr, [r8], -ip, asr #15
    44b0:	80818869 	addhi	r8, r1, r9, ror #16
    44b4:	800188a9 	andhi	r8, r1, r9, lsr #17
    44b8:	5e2c2006 	cdppl	0, 2, cr2, cr12, cr6, {0}
    44bc:	89294668 	stmhidb	r9!, {r3, r5, r6, r9, sl, lr}
    44c0:	210080c1 	smlabtcs	r0, r1, r0, r8
    44c4:	f7fe8800 	ldrnvb	r8, [lr, r0, lsl #16]!
    44c8:	1e47fc51 	mcrne	12, 2, pc, cr7, cr1, {2}
    44cc:	04244822 	streqt	r4, [r4], #-2082
    44d0:	42840c24 	addmi	r0, r4, #9216	; 0x2400
    44d4:	aa02d00c 	bge	0xb850c
    44d8:	1c202100 	stfnes	f2, [r0]
    44dc:	f9c0f7fe 	stmnvib	r0, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    44e0:	46681c04 	strmibt	r1, [r8], -r4, lsl #24
    44e4:	1c207a01 	stcne	10, cr7, [r0], #-4
    44e8:	f9fef7fe 	ldmnvib	lr!, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    44ec:	e0001c04 	and	r1, r0, r4, lsl #24
    44f0:	043f2400 	ldreqt	r2, [pc], #1024	; 0x44f8
    44f4:	1c3d0c3f 	ldcne	12, cr0, [sp], #-252
    44f8:	90041b38 	andls	r1, r4, r8, lsr fp
    44fc:	88c04668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}^
    4500:	42884915 	addmi	r4, r8, #344064	; 0x54000
    4504:	aa02d00c 	bge	0xb853c
    4508:	21001c52 	tstcs	r0, r2, asr ip
    450c:	88c04668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}^
    4510:	f9a6f7fe 	stmnvib	r6!, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    4514:	7a494669 	bvc	0x1255ec0
    4518:	f9e6f7fe 	stmnvib	r6!, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    451c:	e0021c06 	and	r1, r2, r6, lsl #24
    4520:	04369e04 	ldreqt	r9, [r6], #-3588
    4524:	42a50c36 	adcmi	r0, r5, #13824	; 0x3600
    4528:	2201d21a 	andcs	sp, r1, #-1610612735	; 0xa0000001
    452c:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    4530:	f7fd8880 	ldrnvb	r8, [sp, r0, lsl #17]!
    4534:	1c07fd35 	stcne	13, cr15, [r7], {53}
    4538:	db072800 	blle	0x1ce540
    453c:	21002200 	tstcs	r0, r0, lsl #4
    4540:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    4544:	f98cf7fe 	stmnvib	ip, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    4548:	70012100 	andvc	r2, r1, r0, lsl #2
    454c:	46c0e68d 	strmib	lr, [r0], sp, lsl #13
    4550:	00000100 	andeq	r0, r0, r0, lsl #2
    4554:	0000fffd 	streqd	pc, [r0], -sp
    4558:	0000ffff 	streqd	pc, [r0], -pc
    455c:	00008680 	andeq	r8, r0, r0, lsl #13
    4560:	98041b3d 	stmlsda	r4, {r0, r2, r3, r4, r5, r8, r9, fp, ip}
    4564:	d2004286 	andle	r4, r0, #1610612744	; 0x60000008
    4568:	1c6a1c35 	stcnel	12, cr1, [sl], #-212
    456c:	0c120412 	cfldrseq	mvf0, [r2], {18}
    4570:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    4574:	f7fd8880 	ldrnvb	r8, [sp, r0, lsl #17]!
    4578:	1c07fd13 	stcne	13, cr15, [r7], {19}
    457c:	db172800 	blle	0x5ce584
    4580:	21002200 	tstcs	r0, r0, lsl #4
    4584:	88804668 	stmhiia	r0, {r3, r5, r6, r9, sl, lr}
    4588:	f96af7fe 	stmnvdb	sl!, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    458c:	22009009 	andcs	r9, r0, #9	; 0x9
    4590:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    4594:	f7fe8800 	ldrnvb	r8, [lr, r0, lsl #16]!
    4598:	9006f963 	andls	pc, r6, r3, ror #18
    459c:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    45a0:	19011c2a 	stmnedb	r1, {r1, r3, r5, sl, fp, ip}
    45a4:	f0109809 	andnvs	r9, r0, r9, lsl #16
    45a8:	9809fcf7 	stmlsda	r9, {r0, r1, r2, r4, r5, r6, r7, sl, fp, ip, sp, lr, pc}
    45ac:	55412100 	strplb	r2, [r1, #-256]
    45b0:	1c28e65b 	stcne	6, cr14, [r8], #-364
    45b4:	fb28f7fc 	blx	0xa425ae
    45b8:	4669e725 	strmibt	lr, [r9], -r5, lsr #14
    45bc:	800a88aa 	andhi	r8, sl, sl, lsr #17
    45c0:	5e692102 	powple	f2, f1, f2
    45c4:	0fcb466a 	swieq	0x00cb466a
    45c8:	10491859 	subne	r1, r9, r9, asr r8
    45cc:	82901808 	addhis	r1, r0, #524288	; 0x80000
    45d0:	e0012600 	and	r2, r1, r0, lsl #12
    45d4:	1c761c7f 	ldcnel	12, cr1, [r6], #-508
    45d8:	8a804668 	bhi	0xfe015f80
    45dc:	0c360436 	cfldrseq	mvf0, [r6], #-216
    45e0:	d2114286 	andles	r4, r1, #1610612744	; 0x60000008
    45e4:	00714668 	rsbeqs	r4, r1, r8, ror #12
    45e8:	88ca1869 	stmhiia	sl, {r0, r3, r5, r6, fp, ip}^
    45ec:	88418042 	stmhida	r1, {r1, r6, pc}^
    45f0:	f7fe8800 	ldrnvb	r8, [lr, r0, lsl #16]!
    45f4:	2800fa0d 	stmcsda	r0, {r0, r2, r3, r9, fp, ip, sp, lr, pc}
    45f8:	2100d0ec 	smlattcs	r0, ip, r0, sp
    45fc:	88404668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}^
    4600:	fbb4f7fe 	blx	0xfed42602
    4604:	e7e6183f 	undefined
    4608:	0c12043a 	cfldrseq	mvf0, [r2], {58}
    460c:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    4610:	f7fd8800 	ldrnvb	r8, [sp, r0, lsl #16]!
    4614:	1c07fcc5 	stcne	12, cr15, [r7], {197}
    4618:	dbc92800 	blle	0xff24e620
    461c:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    4620:	f7fe8800 	ldrnvb	r8, [lr, r0, lsl #16]!
    4624:	4669fb97 	undefined
    4628:	46688388 	strmibt	r8, [r8], -r8, lsl #7
    462c:	81412100 	cmphi	r1, r0, lsl #2
    4630:	e01e2600 	ands	r2, lr, r0, lsl #12
    4634:	49ce9804 	stmmiib	lr, {r2, fp, ip, pc}^
    4638:	18086ac9 	stmneda	r8, {r0, r3, r6, r7, r9, fp, sp, lr}
    463c:	b4022100 	strlt	r2, [r2], #-256
    4640:	884ba901 	stmhida	fp, {r0, r8, fp, sp, pc}^
    4644:	88408801 	stmhida	r0, {r0, fp, pc}^
    4648:	8952aa01 	ldmhidb	r2, {r0, r9, fp, sp, pc}^
    464c:	180a4350 	stmneda	sl, {r4, r6, r8, r9, lr}
    4650:	0c120412 	cfldrseq	mvf0, [r2], {18}
    4654:	89c1a801 	stmhiib	r1, {r0, fp, sp, pc}^
    4658:	f7ff201b 	undefined
    465c:	1c07f8af 	stcne	8, cr15, [r7], {175}
    4660:	2800b001 	stmcsda	r0, {r0, ip, sp, pc}
    4664:	4668dba4 	strmibt	sp, [r8], -r4, lsr #23
    4668:	89494669 	stmhidb	r9, {r0, r3, r5, r6, r9, sl, lr}^
    466c:	81411c49 	cmphi	r1, r9, asr #24
    4670:	46681c76 	undefined
    4674:	04368a80 	ldreqt	r8, [r6], #-2688
    4678:	42860c36 	addmi	r0, r6, #13824	; 0x3600
    467c:	4668d298 	undefined
    4680:	18690071 	stmneda	r9!, {r0, r4, r5, r6}^
    4684:	804288ca 	subhi	r8, r2, sl, asr #17
    4688:	210a8b80 	smlabbcs	sl, r0, fp, r8
    468c:	90044348 	andls	r4, r4, r8, asr #6
    4690:	46694668 	strmibt	r4, [r9], -r8, ror #12
    4694:	1c498809 	mcrrne	8, 0, r8, r9, cr9
    4698:	884181c1 	stmhida	r1, {r0, r6, r7, r8, pc}^
    469c:	f7fe8800 	ldrnvb	r8, [lr, r0, lsl #16]!
    46a0:	2800f9b7 	stmcsda	r0, {r0, r1, r2, r4, r5, r7, r8, fp, ip, sp, lr, pc}
    46a4:	2100d0c6 	smlabtcs	r0, r6, r0, sp
    46a8:	88404668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}^
    46ac:	fb52f7fe 	blx	0x14c26ae
    46b0:	82c84669 	sbchi	r4, r8, #110100480	; 0x6900000
    46b4:	48ae2400 	stmmiia	lr!, {sl, sp}
    46b8:	46696ac0 	strmibt	r6, [r9], -r0, asr #21
    46bc:	220a8ac9 	andcs	r8, sl, #823296	; 0xc9000
    46c0:	18414351 	stmneda	r1, {r0, r4, r6, r8, r9, lr}^
    46c4:	0424888a 	streqt	r8, [r4], #-2186
    46c8:	42940c24 	addmis	r0, r4, #9216	; 0x2400
    46cc:	9a04d2d0 	bls	0x139214
    46d0:	880a1880 	stmhida	sl, {r7, fp, ip}
    46d4:	43618849 	cmnmi	r1, #4784128	; 0x490000
    46d8:	04091851 	streq	r1, [r9], #-2129
    46dc:	b4020c09 	strlt	r0, [r2], #-3081
    46e0:	884ba901 	stmhida	fp, {r0, r8, fp, sp, pc}^
    46e4:	041b1c5b 	ldreq	r1, [fp], #-3163
    46e8:	88010c1b 	stmhida	r1, {r0, r1, r3, r4, sl, fp}
    46ec:	aa018840 	bge	0x667f4
    46f0:	43508952 	cmpmi	r0, #1343488	; 0x148000
    46f4:	0412180a 	ldreq	r1, [r2], #-2058
    46f8:	a8010c12 	stmgeda	r1, {r1, r4, sl, fp}
    46fc:	201b89c1 	andcss	r8, fp, r1, asr #19
    4700:	f85cf7ff 	ldmnvda	ip, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    4704:	b0011c07 	andlt	r1, r1, r7, lsl #24
    4708:	db3b2800 	blle	0xece710
    470c:	46694668 	strmibt	r4, [r9], -r8, ror #12
    4710:	1c498949 	mcrrne	9, 4, r8, r9, cr9
    4714:	1c648141 	stfnep	f0, [r4], #-260
    4718:	4669e7cd 	strmibt	lr, [r9], -sp, asr #15
    471c:	800a88aa 	andhi	r8, sl, sl, lsr #17
    4720:	5e692102 	powple	f2, f1, f2
    4724:	0fcb466a 	swieq	0x00cb466a
    4728:	10491859 	subne	r1, r9, r9, asr r8
    472c:	82901808 	addhis	r1, r0, #524288	; 0x80000
    4730:	e0072600 	and	r2, r7, r0, lsl #12
    4734:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    4738:	f7fe8840 	ldrnvb	r8, [lr, r0, asr #16]!
    473c:	1e40fb17 	mcrne	11, 2, pc, cr0, cr7, {0}
    4740:	1c76183f 	ldcnel	8, cr1, [r6], #-252
    4744:	8a804668 	bhi	0xfe0160ec
    4748:	0c360436 	cfldrseq	mvf0, [r6], #-216
    474c:	d20f4286 	andle	r4, pc, #1610612744	; 0x60000008
    4750:	00714668 	rsbeqs	r4, r1, r8, ror #12
    4754:	88ca1869 	stmhiia	sl, {r0, r3, r5, r6, fp, ip}^
    4758:	88408042 	stmhida	r0, {r1, r6, pc}^
    475c:	04001c40 	streq	r1, [r0], #-3136
    4760:	f7fe0c00 	ldrnvb	r0, [lr, r0, lsl #24]!
    4764:	2801f877 	stmcsda	r1, {r0, r1, r2, r4, r5, r6, fp, ip, sp, lr, pc}
    4768:	2000d0e4 	andcs	sp, r0, r4, ror #1
    476c:	e57d43c0 	ldrb	r4, [sp, #-960]!
    4770:	043a1c7f 	ldreqt	r1, [sl], #-3199
    4774:	21000c12 	tstcs	r0, r2, lsl ip
    4778:	88004668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}
    477c:	fc10f7fd 	ldc2	7, cr15, [r0], {253}
    4780:	28001c07 	stmcsda	r0, {r0, r1, r2, sl, fp, ip}
    4784:	e570da00 	ldrb	sp, [r0, #-2560]!
    4788:	21004668 	tstcs	r0, r8, ror #12
    478c:	22008141 	andcs	r8, r0, #1073741840	; 0x40000010
    4790:	f7fe8800 	ldrnvb	r8, [lr, r0, lsl #16]!
    4794:	9006f865 	andls	pc, r6, r5, ror #16
    4798:	e0202600 	eor	r2, r0, r0, lsl #12
    479c:	00714668 	rsbeqs	r4, r1, r8, ror #12
    47a0:	88ca1869 	stmhiia	sl, {r0, r3, r5, r6, fp, ip}^
    47a4:	22008042 	andcs	r8, r0, #66	; 0x42
    47a8:	88402100 	stmhida	r0, {r8, sp}^
    47ac:	f858f7fe 	ldmnvda	r8, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    47b0:	21001c04 	tstcs	r0, r4, lsl #24
    47b4:	88404668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}^
    47b8:	fad8f7fe 	blx	0xff6427b8
    47bc:	1e404669 	cdpne	6, 4, cr4, cr0, cr9, {3}
    47c0:	46688048 	strmibt	r8, [r8], -r8, asr #32
    47c4:	1c218842 	stcne	8, cr8, [r1], #-264
    47c8:	f0109804 	andnvs	r9, r0, r4, lsl #16
    47cc:	4668fbe5 	strmibt	pc, [r8], -r5, ror #23
    47d0:	89494669 	stmhidb	r9, {r0, r3, r5, r6, r9, sl, lr}^
    47d4:	8852466a 	ldmhida	r2, {r1, r3, r5, r6, r9, sl, lr}^
    47d8:	81411889 	smlalbbhi	r1, r1, r9, r8
    47dc:	46681c76 	undefined
    47e0:	99068940 	stmlsdb	r6, {r6, r8, fp, pc}
    47e4:	90041808 	andls	r1, r4, r8, lsl #16
    47e8:	8a804668 	bhi	0xfe016190
    47ec:	0c360436 	cfldrseq	mvf0, [r6], #-216
    47f0:	d3d34286 	bicles	r4, r3, #1610612744	; 0x60000008
    47f4:	e6a79804 	strt	r9, [r7], r4, lsl #16
    47f8:	88694668 	stmhida	r9!, {r3, r5, r6, r9, sl, lr}^
    47fc:	88a98081 	stmhiia	r9!, {r0, r7, pc}
    4800:	20068001 	andcs	r8, r6, r1
    4804:	46685e2c 	strmibt	r5, [r8], -ip, lsr #28
    4808:	80c18929 	sbchi	r8, r1, r9, lsr #18
    480c:	04202100 	streqt	r2, [r0], #-256
    4810:	f7fe0c00 	ldrnvb	r0, [lr, r0, lsl #24]!
    4814:	4669faab 	strmibt	pc, [r9], -fp, lsr #21
    4818:	46688048 	strmibt	r8, [r8], -r8, asr #32
    481c:	1e6d8845 	cdpne	8, 6, cr8, cr13, cr5, {2}
    4820:	88c02100 	stmhiia	r0, {r8, sp}^
    4824:	f936f7fe 	ldmnvdb	r6!, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    4828:	0c2d042d 	cfstrseq	mvf0, [sp], #-180
    482c:	d11e4285 	tstle	lr, r5, lsl #5
    4830:	b4012000 	strlt	r2, [r1]
    4834:	88c3a801 	stmhiia	r3, {r0, fp, sp, pc}^
    4838:	88812200 	stmhiia	r1, {r9, sp}
    483c:	f7fe201b 	undefined
    4840:	1c07ffbd 	stcne	15, cr15, [r7], {189}
    4844:	2800b001 	stmcsda	r0, {r0, ip, sp, pc}
    4848:	2200db1e 	andcs	sp, r0, #30720	; 0x7800
    484c:	04202100 	streqt	r2, [r0], #-256
    4850:	f7fe0c00 	ldrnvb	r0, [lr, r0, lsl #24]!
    4854:	1c04f805 	stcne	8, cr15, [r4], {5}
    4858:	21004668 	tstcs	r0, r8, ror #12
    485c:	23008441 	tstcs	r0, #1090519040	; 0x41000000
    4860:	a9088882 	stmgedb	r8, {r1, r7, fp, pc}
    4864:	1c201c89 	stcne	12, cr1, [r0], #-548
    4868:	f9ecf7fe 	stmnvib	ip!, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    486c:	aa03e5cb 	bge	0xfdfa0
    4870:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    4874:	f7fd8800 	ldrnvb	r8, [sp, r0, lsl #16]!
    4878:	9006fff3 	strlsd	pc, [r6], -r3
    487c:	46682201 	strmibt	r2, [r8], -r1, lsl #4
    4880:	98067b01 	stmlsda	r6, {r0, r8, r9, fp, ip, sp, lr}
    4884:	f81ef7fe 	ldmnvda	lr, {r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    4888:	4668e4ef 	strmibt	lr, [r8], -pc, ror #9
    488c:	800188a9 	andhi	r8, r1, r9, lsr #17
    4890:	5e2c2006 	cdppl	0, 2, cr2, cr12, cr6, {0}
    4894:	89294668 	stmhidb	r9!, {r3, r5, r6, r9, sl, lr}
    4898:	896980c1 	stmhidb	r9!, {r0, r6, r7, pc}^
    489c:	aa038401 	bge	0xe58a8
    48a0:	21001c52 	tstcs	r0, r2, asr ip
    48a4:	5e282002 	cdppl	0, 2, cr2, cr8, cr2, {0}
    48a8:	0c000400 	cfstrseq	mvf0, [r0], {0}
    48ac:	ffd8f7fd 	swinv	0x00d8f7fd
    48b0:	aa039009 	bge	0xe88dc
    48b4:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    48b8:	f7fd8800 	ldrnvb	r8, [sp, r0, lsl #16]!
    48bc:	9006ffd1 	ldrlsd	pc, [r6], -r1
    48c0:	2100aa02 	tstcs	r0, r2, lsl #20
    48c4:	0c000420 	cfstrseq	mvf0, [r0], {32}
    48c8:	ffcaf7fd 	swinv	0x00caf7fd
    48cc:	46681c04 	strmibt	r1, [r8], -r4, lsl #24
    48d0:	492888c0 	stmmidb	r8!, {r6, r7, fp, pc}
    48d4:	d00c4288 	andle	r4, ip, r8, lsl #5
    48d8:	1c52aa02 	mrrcne	10, 0, sl, r2, cr2
    48dc:	46682100 	strmibt	r2, [r8], -r0, lsl #2
    48e0:	f7fd88c0 	ldrnvb	r8, [sp, r0, asr #17]!
    48e4:	4669ffbd 	undefined
    48e8:	f7fd7a49 	ldrnvb	r7, [sp, r9, asr #20]!
    48ec:	1c06fffd 	stcne	15, cr15, [r6], {253}
    48f0:	2600e000 	strcs	lr, [r0], -r0
    48f4:	8c004668 	stchi	6, cr4, [r0], {104}
    48f8:	4288491e 	addmi	r4, r8, #491520	; 0x78000
    48fc:	aa07d00c 	bge	0x1f8934
    4900:	21001c92 	strcsb	r1, [r0, -r2]
    4904:	8c004668 	stchi	6, cr4, [r0], {104}
    4908:	ffaaf7fd 	swinv	0x00aaf7fd
    490c:	7f894669 	swivc	0x00894669
    4910:	ffeaf7fd 	swinv	0x00eaf7fd
    4914:	e0001c05 	and	r1, r0, r5, lsl #24
    4918:	aa0a2500 	bge	0x28dd20
    491c:	19a04916 	stmneib	r0!, {r1, r2, r4, r8, fp, lr}
    4920:	fbd8f010 	blx	0xff64096a
    4924:	d1152801 	tstle	r5, r1, lsl #16
    4928:	1c76e000 	ldcnel	0, cr14, [r6]
    492c:	0c360436 	cfldrseq	mvf0, [r6], #-216
    4930:	780119a0 	stmvcda	r1, {r5, r7, r8, fp, ip}
    4934:	d3f82930 	mvnles	r2, #786432	; 0xc0000
    4938:	283a7800 	ldmcsda	sl!, {fp, ip, sp, lr}
    493c:	0436d2f5 	ldreqt	sp, [r6], #-757
    4940:	19a00c36 	stmneib	r0!, {r1, r2, r4, r5, sl, fp}
    4944:	29307801 	ldmcsdb	r0!, {r0, fp, ip, sp, lr}
    4948:	7800d306 	stmvcda	r0, {r1, r2, r8, r9, ip, lr, pc}
    494c:	d203283a 	andle	r2, r3, #3801088	; 0x3a0000
    4950:	e7f41c76 	undefined
    4954:	2600950a 	strcs	r9, [r0], -sl, lsl #10
    4958:	46689a0a 	strmibt	r9, [r8], -sl, lsl #20
    495c:	98097b41 	stmlsda	r9, {r0, r6, r8, r9, fp, ip, sp, lr}
    4960:	ffb0f7fd 	swinv	0x00b0f7fd
    4964:	e78a1c32 	undefined
    4968:	43ff2701 	mvnmis	r2, #262144	; 0x40000
    496c:	0000e47d 	andeq	lr, r0, sp, ror r4
    4970:	00008680 	andeq	r8, r0, r0, lsl #13
    4974:	0000ffff 	streqd	pc, [r0], -pc
    4978:	0011b3dc 	ldreqsb	fp, [r1], -ip
    497c:	2804b510 	stmcsda	r4, {r4, r8, sl, ip, sp, pc}
    4980:	2020d302 	eorcs	sp, r0, r2, lsl #6
    4984:	e01f43c0 	ands	r4, pc, r0, asr #7
    4988:	43432314 	cmpmi	r3, #1342177280	; 0x50000000
    498c:	690a49a9 	stmvsdb	sl, {r0, r3, r5, r7, r8, fp, lr}
    4990:	6a646854 	bvs	0x191eae8
    4994:	7a2418e4 	bvc	0x90ad2c
    4998:	d0052c0b 	andle	r2, r5, fp, lsl #24
    499c:	6a646854 	bvs	0x191eaf4
    49a0:	7a2418e4 	bvc	0x90ad38
    49a4:	d1052c0a 	tstle	r5, sl, lsl #24
    49a8:	6a646854 	bvs	0x191eb00
    49ac:	7c1b18e3 	ldcvc	8, cr1, [fp], {227}
    49b0:	d0012b00 	andle	r2, r1, r0, lsl #22
    49b4:	e7e5201f 	undefined
    49b8:	69522308 	ldmvsdb	r2, {r3, r8, r9, sp}^
    49bc:	18106a52 	ldmneda	r0, {r1, r4, r6, r9, fp, sp, lr}
    49c0:	7800309c 	stmvcda	r0, {r2, r3, r4, r7, ip, sp}
    49c4:	56c01808 	strplb	r1, [r0], r8, lsl #16
    49c8:	0000e2bd 	streqh	lr, [r0], -sp
    49cc:	28041c01 	stmcsda	r4, {r0, sl, fp, ip}
    49d0:	2000d301 	andcs	sp, r0, r1, lsl #6
    49d4:	2013e019 	andcss	lr, r3, r9, lsl r0
    49d8:	48964341 	ldmmiia	r6, {r0, r6, r8, r9, lr}
    49dc:	69506902 	ldmvsdb	r0, {r1, r8, fp, sp, lr}^
    49e0:	18406a40 	stmneda	r0, {r6, r9, fp, sp, lr}^
    49e4:	69537c00 	ldmvsdb	r3, {sl, fp, ip, sp, lr}^
    49e8:	185b6a5b 	ldmneda	fp, {r0, r1, r3, r4, r6, r9, fp, sp, lr}^
    49ec:	1ac07c5b 	bne	0xff023b60
    49f0:	6950d509 	ldmvsdb	r0, {r0, r3, r8, sl, ip, lr, pc}^
    49f4:	18406a40 	stmneda	r0, {r6, r9, fp, sp, lr}^
    49f8:	30107c00 	andccs	r7, r0, r0, lsl #24
    49fc:	6a526952 	bvs	0x149ef4c
    4a00:	7c491851 	mcrrvc	8, 5, r1, r9, cr1
    4a04:	06001a40 	streq	r1, [r0], -r0, asr #20
    4a08:	b0000e00 	andlt	r0, r0, r0, lsl #28
    4a0c:	00004770 	andeq	r4, r0, r0, ror r7
    4a10:	4668b5f9 	undefined
    4a14:	28047800 	stmcsda	r4, {fp, ip, sp, lr}
    4a18:	2020d301 	eorcs	sp, r0, r1, lsl #6
    4a1c:	2911e06b 	ldmcsdb	r1, {r0, r1, r3, r5, r6, sp, lr, pc}
    4a20:	4668d203 	strmibt	sp, [r8], -r3, lsl #4
    4a24:	28117900 	ldmcsda	r1, {r8, fp, ip, sp, lr}
    4a28:	2012d301 	andcss	sp, r2, r1, lsl #6
    4a2c:	4668e063 	strmibt	lr, [r8], -r3, rrx
    4a30:	25147803 	ldrcs	r7, [r4, #-2051]
    4a34:	4c7f435d 	ldcmil	3, cr4, [pc], #-372
    4a38:	68466920 	stmvsda	r6, {r5, r8, fp, sp, lr}^
    4a3c:	19766a76 	ldmnedb	r6!, {r1, r2, r4, r5, r6, r9, fp, sp, lr}^
    4a40:	2e0b7a36 	mcrcs	10, 0, r7, cr11, cr6, {1}
    4a44:	6846d005 	stmvsda	r6, {r0, r2, ip, lr, pc}^
    4a48:	19766a76 	ldmnedb	r6!, {r1, r2, r4, r5, r6, r9, fp, sp, lr}^
    4a4c:	2e0a7a36 	mcrcs	10, 0, r7, cr10, cr6, {1}
    4a50:	6846d10c 	stmvsda	r6, {r2, r3, r8, ip, lr, pc}^
    4a54:	19756a76 	ldmnedb	r5!, {r1, r2, r4, r5, r6, r9, fp, sp, lr}^
    4a58:	2d007c2d 	stccs	12, cr7, [r0, #-180]
    4a5c:	6945d106 	stmvsdb	r5, {r1, r2, r8, ip, lr, pc}^
    4a60:	18ed6a6d 	stmneia	sp!, {r0, r2, r3, r5, r6, r9, fp, sp, lr}^
    4a64:	782d359c 	stmvcda	sp!, {r2, r3, r4, r7, r8, sl, ip, sp}
    4a68:	d0062d00 	andle	r2, r6, r0, lsl #26
    4a6c:	6a6d6945 	bvs	0x1b5ef88
    4a70:	359c18ed 	ldrcc	r1, [ip, #2285]
    4a74:	2d04782d 	stccs	8, cr7, [r4, #-180]
    4a78:	2513d13c 	ldrcs	sp, [r3, #-316]
    4a7c:	6946435d 	stmvsdb	r6, {r0, r2, r3, r4, r6, r8, r9, lr}^
    4a80:	19766a76 	ldmnedb	r6!, {r1, r2, r4, r5, r6, r9, fp, sp, lr}^
    4a84:	2700365c 	smlsdcs	r0, ip, r6, r3
    4a88:	69407037 	stmvsdb	r0, {r0, r1, r2, r4, r5, ip, sp, lr}^
    4a8c:	19406a40 	stmnedb	r0, {r6, r9, fp, sp, lr}^
    4a90:	7007305d 	andvc	r3, r7, sp, asr r0
    4a94:	78004668 	stmvcda	r0, {r3, r5, r6, r9, sl, lr}
    4a98:	43702613 	cmnmi	r0, #19922944	; 0x1300000
    4a9c:	69364e65 	ldmvsdb	r6!, {r0, r2, r5, r6, r9, sl, fp, lr}
    4aa0:	6a766976 	bvs	0x1d9f080
    4aa4:	364c1836 	undefined
    4aa8:	d0031c08 	andle	r1, r3, r8, lsl #24
    4aac:	5c171e40 	ldcpl	14, cr1, [r7], {64}
    4ab0:	d1fb5437 	mvnles	r5, r7, lsr r4
    4ab4:	69426920 	stmvsdb	r2, {r5, r8, fp, sp, lr}^
    4ab8:	19526a52 	ldmnedb	r2, {r1, r4, r6, r9, fp, sp, lr}^
    4abc:	7011325c 	andvcs	r3, r1, ip, asr r2
    4ac0:	6a496941 	bvs	0x125efcc
    4ac4:	466a1949 	strmibt	r1, [sl], -r9, asr #18
    4ac8:	748a7912 	strvc	r7, [sl], #2322
    4acc:	6a496941 	bvs	0x125efd8
    4ad0:	319c18c9 	orrccs	r1, ip, r9, asr #17
    4ad4:	700a2201 	andvc	r2, sl, r1, lsl #4
    4ad8:	6a496941 	bvs	0x125efe4
    4adc:	694031a4 	stmvsdb	r0, {r2, r5, r7, r8, ip, sp}^
    4ae0:	30a46a40 	adccc	r6, r4, r0, asr #20
    4ae4:	466b7800 	strmibt	r7, [fp], -r0, lsl #16
    4ae8:	409a781b 	addmis	r7, sl, fp, lsl r8
    4aec:	700a4302 	andvc	r4, sl, r2, lsl #6
    4af0:	e0012000 	and	r2, r1, r0
    4af4:	43c0201f 	bicmi	r2, r0, #31	; 0x1f
    4af8:	fa9af7fd 	blx	0xfe6c2af4
    4afc:	1c05b5f0 	cfstr32ne	mvfx11, [r5], {240}
    4b00:	1c141c0e 	ldcne	12, cr1, [r4], {14}
    4b04:	d3022804 	tstle	r2, #262144	; 0x40000
    4b08:	43c02020 	bicmi	r2, r0, #32	; 0x20
    4b0c:	2e11e061 	cdpcs	0, 1, cr14, cr1, cr1, {3}
    4b10:	2012d301 	andcss	sp, r2, r1, lsl #6
    4b14:	f7ffe7f9 	undefined
    4b18:	42b0ff59 	adcmis	pc, r0, #356	; 0x164
    4b1c:	201fd202 	andcss	sp, pc, r2, lsl #4
    4b20:	e05643c0 	subs	r4, r6, r0, asr #7
    4b24:	43692113 	cmnmi	r9, #-1073741820	; 0xc0000004
    4b28:	69004842 	stmvsdb	r0, {r1, r6, fp, lr}
    4b2c:	6a526942 	bvs	0x149f03c
    4b30:	7c521852 	mrrcvc	8, 5, r1, r2, cr2
    4b34:	04121992 	ldreq	r1, [r2], #-2450
    4b38:	2a100c12 	bcs	0x407b88
    4b3c:	2210d325 	andcss	sp, r0, #-1811939328	; 0x94000000
    4b40:	6a406940 	bvs	0x101f048
    4b44:	7c401840 	mcrrvc	8, 4, r1, r0, cr0
    4b48:	06121a12 	undefined
    4b4c:	20130e12 	andcss	r0, r3, r2, lsl lr
    4b50:	4b384368 	blmi	0xe158f8
    4b54:	695b691b 	ldmvsdb	fp, {r0, r1, r3, r4, r8, fp, sp, lr}^
    4b58:	18186a5b 	ldmneda	r8, {r0, r1, r3, r4, r6, r9, fp, sp, lr}
    4b5c:	23137c40 	tstcs	r3, #16384	; 0x4000
    4b60:	4f34436b 	swimi	0x0034436b
    4b64:	697f693f 	ldmvsdb	pc!, {r0, r1, r2, r3, r4, r5, r8, fp, sp, lr}^
    4b68:	18fb6a7f 	ldmneia	fp!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}^
    4b6c:	1c10181b 	ldcne	8, cr1, [r0], {27}
    4b70:	1e40d003 	cdpne	0, 4, cr13, cr0, cr3, {0}
    4b74:	54275c1f 	strplt	r5, [r7], #-3103
    4b78:	482ed1fb 	stmmida	lr!, {r0, r1, r3, r4, r5, r6, r7, r8, ip, lr, pc}
    4b7c:	69406900 	stmvsdb	r0, {r8, fp, sp, lr}^
    4b80:	18406a40 	stmneda	r0, {r6, r9, fp, sp, lr}^
    4b84:	74432300 	strvcb	r2, [r3], #-768
    4b88:	06361ab6 	undefined
    4b8c:	20130e36 	andcss	r0, r3, r6, lsr lr
    4b90:	4a284368 	bmi	0xa15938
    4b94:	69526912 	ldmvsdb	r2, {r1, r4, r8, fp, sp, lr}^
    4b98:	18106a52 	ldmneda	r0, {r1, r4, r6, r9, fp, sp, lr}
    4b9c:	22137c40 	andcss	r7, r3, #16384	; 0x4000
    4ba0:	4a244355 	bmi	0x9158fc
    4ba4:	69526912 	ldmvsdb	r2, {r1, r4, r8, fp, sp, lr}^
    4ba8:	19526a52 	ldmnedb	r2, {r1, r4, r6, r9, fp, sp, lr}^
    4bac:	1c301812 	ldcne	8, cr1, [r0], #-72
    4bb0:	1e40d003 	cdpne	0, 4, cr13, cr0, cr3, {0}
    4bb4:	54235c13 	strplt	r5, [r3], #-3091
    4bb8:	481ed1fb 	ldmmida	lr, {r0, r1, r3, r4, r5, r6, r7, r8, ip, lr, pc}
    4bbc:	69506902 	ldmvsdb	r0, {r1, r8, fp, sp, lr}^
    4bc0:	18406a40 	stmneda	r0, {r6, r9, fp, sp, lr}^
    4bc4:	6a526952 	bvs	0x149f114
    4bc8:	7c491851 	mcrrvc	8, 5, r1, r9, cr1
    4bcc:	74411989 	strvcb	r1, [r1], #-2441
    4bd0:	f7fd2000 	ldrnvb	r2, [sp, r0]!
    4bd4:	0000fbae 	andeq	pc, r0, lr, lsr #23
    4bd8:	1c04b570 	cfstr32ne	mvfx11, [r4], {112}
    4bdc:	88006880 	stmhida	r0, {r7, fp, sp, lr}
    4be0:	fee2f7fd 	mcr2	7, 7, pc, cr2, cr13, {7}
    4be4:	68e360a0 	stmvsia	r3!, {r5, r7, sp, lr}^
    4be8:	1c012200 	sfmne	f2, 4, [r1], {0}
    4bec:	4d112080 	ldcmi	0, cr2, [r1, #-512]
    4bf0:	692d692d 	stmvsdb	sp!, {r0, r2, r3, r5, r8, fp, sp, lr}
    4bf4:	682d6a6d 	stmvsda	sp!, {r0, r2, r3, r5, r6, r9, fp, sp, lr}
    4bf8:	fb00f012 	blx	0x40c4a
    4bfc:	020921ff 	andeq	r2, r9, #-1073741761	; 0xc000003f
    4c00:	d1164208 	tstle	r6, r8, lsl #4
    4c04:	0e120602 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    4c08:	435a2315 	cmpmi	sl, #1409286144	; 0x54000000
    4c0c:	189a4b82 	ldmneia	sl, {r1, r7, r8, r9, fp, lr}
    4c10:	2372324a 	cmncs	r2, #-1610612732	; 0xa0000004
    4c14:	68a27013 	stmvsia	r2!, {r0, r1, r4, ip, sp, lr}
    4c18:	0e1b0603 	cfmsub32eq	mvax0, mvfx0, mvfx11, mvfx3
    4c1c:	436b2515 	cmnmi	fp, #88080384	; 0x5400000
    4c20:	18eb4d7d 	stmneia	fp!, {r0, r2, r3, r4, r5, r6, r8, sl, fp, lr}^
    4c24:	2500334b 	strcs	r3, [r0, #-843]
    4c28:	555e5d56 	ldrplb	r5, [lr, #-3414]
    4c2c:	2e001c6d 	cdpcs	12, 0, cr1, cr0, cr13, {3}
    4c30:	e03bd1fa 	ldrsh	sp, [fp], -sl
    4c34:	0000015c 	andeq	r0, r0, ip, asr r1
    4c38:	1c04b570 	cfstr32ne	mvfx11, [r4], {112}
    4c3c:	88006880 	stmhida	r0, {r7, fp, sp, lr}
    4c40:	feb2f7fd 	mrc2	7, 5, pc, cr2, cr13, {7}
    4c44:	68e360a0 	stmvsia	r3!, {r5, r7, sp, lr}^
    4c48:	1c012200 	sfmne	f2, 4, [r1], {0}
    4c4c:	e00b208b 	and	r2, fp, fp, lsl #1
    4c50:	1c04b570 	cfstr32ne	mvfx11, [r4], {112}
    4c54:	88006880 	stmhida	r0, {r7, fp, sp, lr}
    4c58:	fea6f7fd 	mcr2	7, 5, pc, cr6, cr13, {7}
    4c5c:	68e360a0 	stmvsia	r3!, {r5, r7, sp, lr}^
    4c60:	1c012200 	sfmne	f2, 4, [r1], {0}
    4c64:	46c0208c 	strmib	r2, [r0], ip, lsl #1
    4c68:	692d4dbf 	stmvsdb	sp!, {r0, r1, r2, r3, r4, r5, r7, r8, sl, fp, lr}
    4c6c:	6a6d692d 	bvs	0x1b5f128
    4c70:	f012682d 	andnvs	r6, r2, sp, lsr #16
    4c74:	21fffac3 	mvncss	pc, r3, asr #21
    4c78:	42080209 	andmi	r0, r8, #-1879048192	; 0x90000000
    4c7c:	0602d116 	undefined
    4c80:	23150e12 	tstcs	r5, #288	; 0x120
    4c84:	4b64435a 	blmi	0x19159f4
    4c88:	324a189a 	subcc	r1, sl, #10092544	; 0x9a0000
    4c8c:	70132377 	andvcs	r2, r3, r7, ror r3
    4c90:	060368a2 	streq	r6, [r3], -r2, lsr #17
    4c94:	25150e1b 	ldrcs	r0, [r5, #-3611]
    4c98:	4d5f436b 	ldcmil	3, cr4, [pc, #-428]
    4c9c:	334b18eb 	cmpcc	fp, #15400960	; 0xeb0000
    4ca0:	5d562500 	cfldr64pl	mvdx2, [r6]
    4ca4:	1c6d555e 	cfstr64ne	mvdx5, [sp], #-376
    4ca8:	d1fa2e00 	mvnles	r2, r0, lsl #28
    4cac:	40016822 	andmi	r6, r1, r2, lsr #16
    4cb0:	68618011 	stmvsda	r1!, {r0, r4, pc}^
    4cb4:	20007008 	andcs	r7, r0, r8
    4cb8:	bc02bc70 	stclt	12, cr11, [r2], {112}
    4cbc:	00004708 	andeq	r4, r0, r8, lsl #14
    4cc0:	1c04b570 	cfstr32ne	mvfx11, [r4], {112}
    4cc4:	88066880 	stmhida	r6, {r7, fp, sp, lr}
    4cc8:	680168e0 	stmvsda	r1, {r5, r6, r7, fp, sp, lr}
    4ccc:	04091c49 	streq	r1, [r9], #-3145
    4cd0:	1c300c09 	ldcne	12, cr0, [r0], #-36
    4cd4:	f9b0f7fd 	ldmnvib	r0!, {r0, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}
    4cd8:	28001c05 	stmcsda	r0, {r0, r2, sl, fp, ip}
    4cdc:	1c30db1b 	ldcne	11, cr13, [r0], #-108
    4ce0:	fe62f7fd 	mcr2	7, 3, pc, cr2, cr13, {7}
    4ce4:	68e360a0 	stmvsia	r3!, {r5, r7, sp, lr}^
    4ce8:	68611c02 	stmvsda	r1!, {r1, sl, fp, ip}^
    4cec:	4e9e2082 	cdpmi	0, 9, cr2, cr14, cr2, {4}
    4cf0:	69366936 	ldmvsdb	r6!, {r1, r2, r4, r5, r8, fp, sp, lr}
    4cf4:	68366a76 	ldmvsda	r6!, {r1, r2, r4, r5, r6, r9, fp, sp, lr}
    4cf8:	fa7ef012 	blx	0x1fc0d48
    4cfc:	680968e1 	stmvsda	r9, {r0, r5, r6, r7, fp, sp, lr}
    4d00:	230068a2 	tstcs	r0, #10616832	; 0xa20000
    4d04:	68215453 	stmvsda	r1!, {r0, r1, r4, r6, sl, ip, lr}
    4d08:	021222ff 	andeqs	r2, r2, #-268435441	; 0xf000000f
    4d0c:	800a4002 	andhi	r4, sl, r2
    4d10:	70086861 	andvc	r6, r8, r1, ror #16
    4d14:	e7cf1c28 	strb	r1, [pc, r8, lsr #24]
    4d18:	1c04b530 	cfstr32ne	mvfx11, [r4], {48}
    4d1c:	88006880 	stmhida	r0, {r7, fp, sp, lr}
    4d20:	fe42f7fd 	mcr2	7, 2, pc, cr2, cr13, {7}
    4d24:	68e360a0 	stmvsia	r3!, {r5, r7, sp, lr}^
    4d28:	68611c02 	stmvsda	r1!, {r1, sl, fp, ip}^
    4d2c:	4d8e2083 	stcmi	0, cr2, [lr, #524]
    4d30:	692d692d 	stmvsdb	sp!, {r0, r2, r3, r5, r8, fp, sp, lr}
    4d34:	682d6a6d 	stmvsda	sp!, {r0, r2, r3, r5, r6, r9, fp, sp, lr}
    4d38:	fa60f012 	blx	0x1840d88
    4d3c:	22ff6821 	rsccss	r6, pc, #2162688	; 0x210000
    4d40:	40020212 	andmi	r0, r2, r2, lsl r2
    4d44:	6861800a 	stmvsda	r1!, {r1, r3, pc}^
    4d48:	f7fb7008 	ldrnvb	r7, [fp, r8]!
    4d4c:	0000fb61 	andeq	pc, r0, r1, ror #22
    4d50:	1c04b530 	cfstr32ne	mvfx11, [r4], {48}
    4d54:	78006840 	stmvcda	r0, {r6, fp, sp, lr}
    4d58:	d3042810 	tstle	r4, #1048576	; 0x100000
    4d5c:	21936820 	orrcss	r6, r3, r0, lsr #16
    4d60:	80010209 	andhi	r0, r1, r9, lsl #4
    4d64:	2300e01a 	tstcs	r0, #26	; 0x1a
    4d68:	68612200 	stmvsda	r1!, {r9, sp}^
    4d6c:	4d7e2084 	ldcmil	0, cr2, [lr, #-528]!
    4d70:	692d692d 	stmvsdb	sp!, {r0, r2, r3, r5, r8, fp, sp, lr}
    4d74:	682d6a6d 	stmvsda	sp!, {r0, r2, r3, r5, r6, r9, fp, sp, lr}
    4d78:	fa40f012 	blx	0x1040dc8
    4d7c:	22002115 	andcs	r2, r0, #1073741829	; 0x40000005
    4d80:	781b6863 	ldmvcda	fp, {r0, r1, r5, r6, fp, sp, lr}
    4d84:	4d24434b 	stcmi	3, cr4, [r4, #-300]!
    4d88:	334a18eb 	cmpcc	sl, #15400960	; 0xeb0000
    4d8c:	545a1e49 	ldrplb	r1, [sl], #-3657
    4d90:	6821d1fc 	stmvsda	r1!, {r2, r3, r4, r5, r6, r7, r8, ip, lr, pc}
    4d94:	021222ff 	andeqs	r2, r2, #-268435441	; 0xf000000f
    4d98:	800a4002 	andhi	r4, sl, r2
    4d9c:	f7fb2000 	ldrnvb	r2, [fp, r0]!
    4da0:	0000fb38 	andeq	pc, r0, r8, lsr fp
    4da4:	1c04b5f0 	cfstr32ne	mvfx11, [r4], {240}
    4da8:	880068c0 	stmhida	r0, {r6, r7, fp, sp, lr}
    4dac:	fdfcf7fd 	ldc2l	7, cr15, [ip, #1012]!
    4db0:	200060e0 	andcs	r6, r0, r0, ror #1
    4db4:	43412115 	cmpmi	r1, #1073741829	; 0x40000005
    4db8:	18514a17 	ldmneda	r1, {r0, r1, r2, r4, r9, fp, lr}^
    4dbc:	68e2314b 	stmvsia	r2!, {r0, r1, r3, r6, r8, ip, sp}^
    4dc0:	5d8d2600 	stcpl	6, cr2, [sp]
    4dc4:	1c765d93 	ldcnel	13, cr5, [r6], #-588
    4dc8:	d10342ab 	smlatble	r3, fp, r2, r4
    4dcc:	d1f82b00 	mvnles	r2, r0, lsl #22
    4dd0:	e0002700 	and	r2, r0, r0, lsl #14
    4dd4:	2f001b5f 	swics	0x00001b5f
    4dd8:	2115d113 	tstcs	r5, r3, lsl r1
    4ddc:	4a0e4341 	bmi	0x395ae8
    4de0:	314a1851 	cmpcc	sl, r1, asr r8
    4de4:	29777809 	ldmcsdb	r7!, {r0, r3, fp, ip, sp, lr}^
    4de8:	2101d101 	tstcs	r1, r1, lsl #2
    4dec:	2100e000 	tstcs	r0, r0
    4df0:	701168a2 	andvcs	r6, r1, r2, lsr #17
    4df4:	22006821 	andcs	r6, r0, #2162688	; 0x210000
    4df8:	6861800a 	stmvsda	r1!, {r1, r3, pc}^
    4dfc:	f7fd7008 	ldrnvb	r7, [sp, r8]!
    4e00:	1c40fa97 	mcrrne	10, 9, pc, r0, cr7
    4e04:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    4e08:	d3d32810 	bicles	r2, r3, #1048576	; 0x100000
    4e0c:	20ffd1f2 	ldrcssh	sp, [pc, #18]	; 0x4e26
    4e10:	22886821 	addcs	r6, r8, #2162688	; 0x210000
    4e14:	e7ef0212 	undefined
    4e18:	00008680 	andeq	r8, r0, r0, lsl #13
    4e1c:	1c04b531 	cfstr32ne	mvfx11, [r4], {49}
    4e20:	88006840 	stmhida	r0, {r6, fp, sp, lr}
    4e24:	fdc0f7fd 	stc2l	7, cr15, [r0, #1012]
    4e28:	68a06060 	stmvsia	r0!, {r5, r6, sp, lr}
    4e2c:	f7fd8800 	ldrnvb	r8, [sp, r0, lsl #16]!
    4e30:	60a0fdbb 	strvsh	pc, [r0], fp
    4e34:	1c02466b 	stcne	6, cr4, [r2], {107}
    4e38:	20a36861 	adccs	r6, r3, r1, ror #16
    4e3c:	692d4d4a 	stmvsdb	sp!, {r1, r3, r6, r8, sl, fp, lr}
    4e40:	6a6d692d 	bvs	0x1b5f2fc
    4e44:	f012682d 	andnvs	r6, r2, sp, lsr #16
    4e48:	21fff9d9 	ldrcssb	pc, [pc, #153]	; 0x4ee9
    4e4c:	40010209 	andmi	r0, r1, r9, lsl #4
    4e50:	80016820 	andhi	r6, r1, r0, lsr #16
    4e54:	bc382000 	ldclt	0, cr2, [r8]
    4e58:	4708bc02 	strmi	fp, [r8, -r2, lsl #24]
    4e5c:	1c04b530 	cfstr32ne	mvfx11, [r4], {48}
    4e60:	88006840 	stmhida	r0, {r6, fp, sp, lr}
    4e64:	fda0f7fd 	stc2	7, cr15, [r0, #1012]!
    4e68:	23006060 	tstcs	r0, #96	; 0x60
    4e6c:	1c012200 	sfmne	f2, 4, [r1], {0}
    4e70:	4d3d2085 	ldcmi	0, cr2, [sp, #-532]!
    4e74:	692d692d 	stmvsdb	sp!, {r0, r2, r3, r5, r8, fp, sp, lr}
    4e78:	682d6a6d 	stmvsda	sp!, {r0, r2, r3, r5, r6, r9, fp, sp, lr}
    4e7c:	f9bef012 	ldmnvib	lr!, {r1, r4, ip, sp, lr, pc}
    4e80:	020921ff 	andeq	r2, r9, #-1073741761	; 0xc000003f
    4e84:	68204001 	stmvsda	r0!, {r0, lr}
    4e88:	f7fb8001 	ldrnvb	r8, [fp, r1]!
    4e8c:	0000fac1 	andeq	pc, r0, r1, asr #21
    4e90:	1c04b530 	cfstr32ne	mvfx11, [r4], {48}
    4e94:	88006840 	stmhida	r0, {r6, fp, sp, lr}
    4e98:	fd86f7fd 	stc2	7, cr15, [r6, #1012]
    4e9c:	4d326060 	ldcmi	0, cr6, [r2, #-384]!
    4ea0:	1c012213 	sfmne	f2, 4, [r1], {19}
    4ea4:	69c06928 	stmvsib	r0, {r3, r5, r8, fp, sp, lr}^
    4ea8:	1d806a40 	fstsne	s12, [r0, #256]
    4eac:	f952f010 	ldmnvdb	r2, {r4, ip, sp, lr, pc}^
    4eb0:	68a12001 	stmvsia	r1!, {r0, sp}
    4eb4:	29017809 	stmcsdb	r1, {r0, r3, fp, ip, sp, lr}
    4eb8:	69c96929 	stmvsib	r9, {r0, r3, r5, r8, fp, sp, lr}^
    4ebc:	d1016a49 	tstle	r1, r9, asr #20
    4ec0:	e0017708 	and	r7, r1, r8, lsl #14
    4ec4:	770a2200 	strvc	r2, [sl, -r0, lsl #4]
    4ec8:	69ca6929 	stmvsib	sl, {r0, r3, r5, r8, fp, sp, lr}^
    4ecc:	68e36a52 	stmvsia	r3!, {r1, r4, r6, r9, fp, sp, lr}^
    4ed0:	7753781b 	smmlavc	r3, fp, r8, r7
    4ed4:	6a5269ca 	bvs	0x149f604
    4ed8:	80932300 	addhis	r2, r3, r0, lsl #6
    4edc:	6a5269ca 	bvs	0x149f60c
    4ee0:	6a4969c9 	bvs	0x125f60c
    4ee4:	43087e89 	tstmi	r8, #2192	; 0x890
    4ee8:	68207690 	stmvsda	r0!, {r4, r7, r9, sl, ip, sp, lr}
    4eec:	f7fb7003 	ldrnvb	r7, [fp, r3]!
    4ef0:	0000fa8f 	andeq	pc, r0, pc, lsl #21
    4ef4:	491cb510 	ldmmidb	ip, {r4, r8, sl, ip, sp, pc}
    4ef8:	69ca6909 	stmvsib	sl, {r0, r3, r8, fp, sp, lr}^
    4efc:	68436a52 	stmvsda	r3, {r1, r4, r6, r9, fp, sp, lr}^
    4f00:	8013881b 	andhis	r8, r3, fp, lsl r8
    4f04:	6a5269ca 	bvs	0x149f634
    4f08:	881b6883 	ldmhida	fp, {r0, r1, r7, fp, sp, lr}
    4f0c:	69ca8053 	stmvsib	sl, {r0, r1, r4, r6, pc}^
    4f10:	69036a52 	stmvsdb	r3, {r1, r4, r6, r9, fp, sp, lr}
    4f14:	7753781b 	smmlavc	r3, fp, r8, r7
    4f18:	6a5269ca 	bvs	0x149f648
    4f1c:	6a5b69cb 	bvs	0x16df650
    4f20:	24017e9b 	strcs	r7, [r1], #-3739
    4f24:	7694431c 	undefined
    4f28:	781268c2 	ldmvcda	r2, {r1, r6, r7, fp, sp, lr}
    4f2c:	69c92a01 	stmvsib	r9, {r0, r9, fp, sp}^
    4f30:	d1016a49 	tstle	r1, r9, asr #20
    4f34:	e0002203 	and	r2, r0, r3, lsl #4
    4f38:	770a2202 	strvc	r2, [sl, -r2, lsl #4]
    4f3c:	46c06800 	strmib	r6, [r0], r0, lsl #16
    4f40:	70012100 	andvc	r2, r1, r0, lsl #2
    4f44:	bc102000 	ldclt	0, cr2, [r0], {0}
    4f48:	4708bc02 	strmi	fp, [r8, -r2, lsl #24]
    4f4c:	69094906 	stmvsdb	r9, {r1, r2, r8, fp, lr}
    4f50:	69cb6802 	stmvsib	fp, {r1, fp, sp, lr}^
    4f54:	7edb6a5b 	mrcvc	10, 6, r6, cr11, cr11, {2}
    4f58:	68407013 	stmvsda	r0, {r0, r1, r4, ip, sp, lr}^
    4f5c:	6a4969c9 	bvs	0x125f688
    4f60:	70017e89 	andvc	r7, r1, r9, lsl #29
    4f64:	47702000 	ldrmib	r2, [r0, -r0]!
    4f68:	0000015c 	andeq	r0, r0, ip, asr r1
    4f6c:	6909498a 	stmvsdb	r9, {r1, r3, r7, r8, fp, lr}
    4f70:	6a5269ca 	bvs	0x149f6a0
    4f74:	781b6843 	ldmvcda	fp, {r0, r1, r6, fp, sp, lr}
    4f78:	680276d3 	stmvsda	r2, {r0, r1, r4, r6, r7, r9, sl, ip, sp, lr}
    4f7c:	6a5b69cb 	bvs	0x16df6b0
    4f80:	70137edb 	ldrvcsb	r7, [r3], -fp
    4f84:	6a5269ca 	bvs	0x149f6b4
    4f88:	6a4969c9 	bvs	0x125f6b4
    4f8c:	68807e89 	stmvsia	r0, {r0, r3, r7, r9, sl, fp, ip, sp, lr}
    4f90:	43087800 	tstmi	r8, #0	; 0x0
    4f94:	20007690 	mulcs	r0, r0, r6
    4f98:	00004770 	andeq	r4, r0, r0, ror r7
    4f9c:	6841b530 	stmvsda	r1, {r4, r5, r8, sl, ip, sp, pc}^
    4fa0:	2a04780a 	bcs	0x122fd0
    4fa4:	497cd229 	ldmmidb	ip!, {r0, r3, r5, r9, ip, lr, pc}^
    4fa8:	68836909 	stmvsia	r3, {r0, r3, r8, fp, sp, lr}
    4fac:	6a64688c 	bvs	0x191f1e4
    4fb0:	342018a4 	strcct	r1, [r0], #-2212
    4fb4:	25807824 	strcs	r7, [r0, #2084]
    4fb8:	1c2c4025 	stcne	0, cr4, [ip], #-148
    4fbc:	2401d000 	strcs	sp, [r1]
    4fc0:	00d2701c 	sbceqs	r7, r2, ip, lsl r0
    4fc4:	688c68c3 	stmvsia	ip, {r0, r1, r6, r7, fp, sp, lr}
    4fc8:	18a46a64 	stmneia	r4!, {r2, r5, r6, r9, fp, sp, lr}
    4fcc:	701c7924 	andvcs	r7, ip, r4, lsr #18
    4fd0:	781b6903 	ldmvcda	fp, {r0, r1, r8, fp, sp, lr}
    4fd4:	d00c2b00 	andle	r2, ip, r0, lsl #22
    4fd8:	6a5b688b 	bvs	0x16df20c
    4fdc:	2400189b 	strcs	r1, [r0], #-2203
    4fe0:	688b711c 	stmvsia	fp, {r2, r3, r4, r8, ip, sp, lr}
    4fe4:	189b6a5b 	ldmneia	fp, {r0, r1, r3, r4, r6, r9, fp, sp, lr}
    4fe8:	6889709c 	stmvsia	r9, {r2, r3, r4, r7, ip, sp, lr}
    4fec:	18896a49 	stmneia	r9, {r0, r3, r6, r9, fp, sp, lr}
    4ff0:	680070cc 	stmvsda	r0, {r2, r3, r6, r7, ip, sp, lr}
    4ff4:	70012100 	andvc	r2, r1, r0, lsl #2
    4ff8:	6801e008 	stmvsda	r1, {r3, sp, lr, pc}
    4ffc:	43d2220f 	bicmis	r2, r2, #-268435456	; 0xf0000000
    5000:	6881700a 	stmvsia	r1, {r1, r3, ip, sp, lr}
    5004:	700a2200 	andvc	r2, sl, r0, lsl #4
    5008:	700268c0 	andvc	r6, r2, r0, asr #17
    500c:	fa00f7fb 	blx	0x43000
    5010:	6804b5f0 	stmvsda	r4, {r4, r5, r6, r7, r8, sl, ip, sp, pc}
    5014:	780d6841 	stmvcda	sp, {r0, r6, fp, sp, lr}
    5018:	780f68c1 	stmvcda	pc, {r0, r6, r7, fp, sp, lr}
    501c:	88066880 	stmhida	r6, {r7, fp, sp, lr}
    5020:	f7fd1c30 	undefined
    5024:	1c02fcc1 	stcne	12, cr15, [r2], {193}
    5028:	200a1c3b 	andcs	r1, sl, fp, lsr ip
    502c:	48bd4346 	ldmmiia	sp!, {r1, r2, r6, r8, r9, lr}
    5030:	19806ac0 	stmneib	r0, {r6, r7, r9, fp, sp, lr}
    5034:	06098881 	streq	r8, [r9], -r1, lsl #17
    5038:	1c280e09 	stcne	14, cr0, [r8], #-36
    503c:	fce8f7ff 	stc2l	7, cr15, [r8], #1020
    5040:	f7fd7020 	ldrnvb	r7, [sp, r0, lsr #32]!
    5044:	0000f975 	andeq	pc, r0, r5, ror r9
    5048:	1c04b530 	cfstr32ne	mvfx11, [r4], {48}
    504c:	78056840 	stmvcda	r5, {r6, fp, sp, lr}
    5050:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    5054:	6821fc93 	stmvsda	r1!, {r0, r1, r4, r7, sl, fp, ip, sp, lr, pc}
    5058:	1c287008 	stcne	0, cr7, [r8], #-32
    505c:	fcb6f7ff 	ldc2	7, cr15, [r6], #1020
    5060:	700868a1 	andvc	r6, r8, r1, lsr #17
    5064:	f9d4f7fb 	ldmnvib	r4, {r0, r1, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    5068:	6804b5f0 	stmvsda	r4, {r4, r5, r6, r7, r8, sl, ip, sp, pc}
    506c:	780d6841 	stmvcda	sp, {r0, r6, fp, sp, lr}
    5070:	780e68c1 	stmvcda	lr, {r0, r6, r7, fp, sp, lr}
    5074:	88076880 	stmhida	r7, {r7, fp, sp, lr}
    5078:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    507c:	7020fc7f 	eorvc	pc, r0, pc, ror ip
    5080:	f7ff1c28 	ldrnvb	r1, [pc, r8, lsr #24]!
    5084:	2100fca3 	smlatbcs	r0, r3, ip, pc
    5088:	29005661 	stmcsdb	r0, {r0, r5, r6, r9, sl, ip, lr}
    508c:	2800db14 	stmcsda	r0, {r2, r4, r8, r9, fp, ip, lr, pc}
    5090:	42b0d012 	adcmis	sp, r0, #18	; 0x12
    5094:	1c06d200 	sfmne	f5, 1, [r6], {0}
    5098:	1c381c31 	ldcne	12, cr1, [r8], #-196
    509c:	ffccf7fc 	swinv	0x00ccf7fc
    50a0:	db102800 	blle	0x40f0a8
    50a4:	f7fd1c38 	undefined
    50a8:	1c02fc7f 	stcne	12, cr15, [r2], {127}
    50ac:	1c281c31 	stcne	12, cr1, [r8], #-196
    50b0:	fd24f7ff 	stc2	7, cr15, [r4, #-1020]!
    50b4:	e0057020 	and	r7, r5, r0, lsr #32
    50b8:	1c382100 	ldfnes	f2, [r8]
    50bc:	ffbcf7fc 	swinv	0x00bcf7fc
    50c0:	db002800 	blle	0xf0c8
    50c4:	f7fd2000 	ldrnvb	r2, [sp, r0]!
    50c8:	0000f934 	andeq	pc, r0, r4, lsr r9
    50cc:	1c04b530 	cfstr32ne	mvfx11, [r4], {48}
    50d0:	78284d0a 	stmvcda	r8!, {r1, r3, r8, sl, fp, lr}
    50d4:	d1032800 	tstle	r3, r0, lsl #16
    50d8:	faa4f00f 	blx	0xfe94111c
    50dc:	ffd8f00f 	swinv	0x00d8f00f
    50e0:	28157828 	ldmcsda	r5, {r3, r5, fp, ip, sp, lr}
    50e4:	2000d301 	andcs	sp, r0, r1, lsl #6
    50e8:	1c40e000 	marne	acc0, lr, r0
    50ec:	f00f7028 	andnv	r7, pc, r8, lsr #32
    50f0:	6821ff71 	stmvsda	r1!, {r0, r4, r5, r6, r8, r9, sl, fp, ip, sp, lr, pc}
    50f4:	f7fb8008 	ldrnvb	r8, [fp, r8]!
    50f8:	46c0f98b 	strmib	pc, [r0], fp, lsl #19
    50fc:	0000b59e 	muleq	r0, lr, r5
    5100:	21af6800 	movcs	r6, r0, lsl #16
    5104:	4a870089 	bmi	0xfe1c5330
    5108:	60015851 	andvs	r5, r1, r1, asr r8
    510c:	47702000 	ldrmib	r2, [r0, -r0]!
    5110:	1c04b530 	cfstr32ne	mvfx11, [r4], {48}
    5114:	88056880 	stmhida	r5, {r7, fp, sp, lr}
    5118:	f7fd1c28 	ldrnvb	r1, [sp, r8, lsr #24]!
    511c:	60a0fc45 	adcvs	pc, r0, r5, asr #24
    5120:	4345200a 	cmpmi	r5, #10	; 0xa
    5124:	6ac0487f 	bvs	0xff017328
    5128:	88821940 	stmhiia	r2, {r6, r8, fp, ip}
    512c:	686068a1 	stmvsda	r0!, {r0, r5, r7, fp, sp, lr}^
    5130:	f7fd7800 	ldrnvb	r7, [sp, r0, lsl #16]!
    5134:	6821fa8b 	stmvsda	r1!, {r0, r1, r3, r7, r9, fp, ip, sp, lr, pc}
    5138:	28007008 	stmcsda	r0, {r3, ip, sp, lr}
    513c:	2105da03 	tstcs	r5, r3, lsl #20
    5140:	428843c9 	addmi	r4, r8, #603979779	; 0x24000003
    5144:	2000da00 	andcs	sp, r0, r0, lsl #20
    5148:	f963f7fb 	stmnvdb	r3!, {r0, r1, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    514c:	28041c01 	stmcsda	r4, {r0, sl, fp, ip}
    5150:	200fd302 	andcs	sp, pc, r2, lsl #6
    5154:	e01843c0 	ands	r4, r8, r0, asr #7
    5158:	4a0e4873 	bmi	0x39732c
    515c:	28015e10 	stmcsda	r1, {r4, r9, sl, fp, ip, lr}
    5160:	2020d101 	eorcs	sp, r0, r1, lsl #2
    5164:	4a71e011 	bmi	0x1c7d1b0
    5168:	d00a4290 	mulle	sl, r0, r2
    516c:	232f4a08 	teqcs	pc, #32768	; 0x8000
    5170:	4b094359 	blmi	0x255edc
    5174:	681b691b 	ldmvsda	fp, {r0, r1, r3, r4, r8, fp, sp, lr}
    5178:	18596a5b 	ldmneda	r9, {r0, r1, r3, r4, r6, r9, fp, sp, lr}^
    517c:	29005c89 	stmcsdb	r0, {r0, r3, r7, sl, fp, ip, lr}
    5180:	201fd101 	andcss	sp, pc, r1, lsl #2
    5184:	0600e7e6 	streq	lr, [r0], -r6, ror #15
    5188:	b0001600 	andlt	r1, r0, r0, lsl #12
    518c:	46c04770 	undefined
    5190:	000003aa 	andeq	r0, r0, sl, lsr #7
    5194:	00008680 	andeq	r8, r0, r0, lsl #13
    5198:	0000015c 	andeq	r0, r0, ip, asr r1
    519c:	b081b5f1 	strltd	fp, [r1], r1
    51a0:	68409801 	stmvsda	r0, {r0, fp, ip, pc}^
    51a4:	98017806 	stmlsda	r1, {r1, r2, fp, ip, sp, lr}
    51a8:	880468c0 	stmhida	r4, {r6, r7, fp, sp, lr}
    51ac:	46691c37 	undefined
    51b0:	f7fd1c30 	undefined
    51b4:	1c05fab5 	stcne	10, cr15, [r5], {181}
    51b8:	db182800 	blle	0x60f1c0
    51bc:	88004668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}
    51c0:	d0142800 	andles	r2, r4, r0, lsl #16
    51c4:	88014668 	stmhida	r1, {r3, r5, r6, r9, sl, lr}
    51c8:	f7fc1c20 	ldrnvb	r1, [ip, r0, lsr #24]!
    51cc:	2800ff35 	stmcsda	r0, {r0, r2, r4, r5, r8, r9, sl, fp, ip, sp, lr, pc}
    51d0:	1c20db61 	stcne	11, cr13, [r0], #-388
    51d4:	fbe8f7fd 	blx	0xffa431d2
    51d8:	98011c01 	stmlsda	r1, {r0, sl, fp, ip}
    51dc:	78036880 	stmvcda	r3, {r7, fp, sp, lr}
    51e0:	88024668 	stmhida	r2, {r3, r5, r6, r9, sl, lr}
    51e4:	f7fd1c38 	undefined
    51e8:	1c05facf 	stcne	10, cr15, [r5], {207}
    51ec:	2101e00a 	tstcs	r1, sl
    51f0:	f7fc1c20 	ldrnvb	r1, [ip, r0, lsr #24]!
    51f4:	2800ff21 	stmcsda	r0, {r0, r5, r8, r9, sl, fp, ip, sp, lr, pc}
    51f8:	1c20db4d 	stcne	11, cr13, [r0], #-308
    51fc:	fbd4f7fd 	blx	0xff5431fa
    5200:	70012100 	andvc	r2, r1, r0, lsl #2
    5204:	d13a2d40 	teqle	sl, r0, asr #26
    5208:	d2382e0a 	eorles	r2, r8, #160	; 0xa0
    520c:	49454846 	stmmidb	r5, {r1, r2, r6, fp, lr}^
    5210:	2000180c 	andcs	r1, r0, ip, lsl #16
    5214:	28005e20 	stmcsda	r0, {r5, r9, sl, fp, ip, lr}
    5218:	2000da01 	andcs	sp, r0, r1, lsl #20
    521c:	27008020 	strcs	r8, [r0, -r0, lsr #32]
    5220:	1c7fe004 	ldcnel	0, cr14, [pc], #-16
    5224:	0e3f063f 	cfmsuba32eq	mvax1, mvax0, mvfx15, mvfx15
    5228:	d2282f03 	eorle	r2, r8, #12	; 0xc
    522c:	1c407920 	mcrrne	9, 2, r7, r0, cr0
    5230:	06007120 	streq	r7, [r0], -r0, lsr #2
    5234:	28040e00 	stmcsda	r4, {r9, sl, fp}
    5238:	2001d101 	andcs	sp, r1, r1, lsl #2
    523c:	79207120 	stmvcdb	r0!, {r5, r8, ip, sp, lr}
    5240:	ff84f7ff 	swinv	0x0084f7ff
    5244:	d1ec2800 	mvnle	r2, r0, lsl #16
    5248:	1c304d14 	ldcne	13, cr4, [r0], #-80
    524c:	70a8300a 	adcvc	r3, r8, sl
    5250:	1c2170ee 	stcne	0, cr7, [r1], #-952
    5254:	b4031c28 	strlt	r1, [r3], #-3112
    5258:	79222301 	stmvcdb	r2!, {r0, r8, r9, sp}
    525c:	200a2105 	andcs	r2, sl, r5, lsl #2
    5260:	682d692d 	stmvsda	sp!, {r0, r2, r3, r5, r8, fp, sp, lr}
    5264:	682d6a6d 	stmvsda	sp!, {r0, r2, r3, r5, r6, r9, fp, sp, lr}
    5268:	ffc8f011 	swinv	0x00c8f011
    526c:	f7ff7920 	ldrnvb	r7, [pc, r0, lsr #18]!
    5270:	1c05ff6d 	stcne	15, cr15, [r5], {109}
    5274:	2820b002 	stmcsda	r0!, {r1, ip, sp, pc}
    5278:	2001d101 	andcs	sp, r1, r1, lsl #2
    527c:	98017160 	stmlsda	r1, {r5, r6, r8, ip, sp, lr}
    5280:	70056800 	andvc	r6, r5, r0, lsl #16
    5284:	da052d00 	ble	0x15068c
    5288:	43c02005 	bicmi	r2, r0, #5	; 0x5
    528c:	db014285 	blle	0x55ca8
    5290:	e0001c28 	and	r1, r0, r8, lsr #24
    5294:	f7fc2000 	ldrnvb	r2, [ip, r0]!
    5298:	46c0fecb 	strmib	pc, [r0], fp, asr #29
    529c:	0000015c 	andeq	r0, r0, ip, asr r1
    52a0:	1c04b510 	cfstr32ne	mvfx11, [r4], {16}
    52a4:	78006840 	stmvcda	r0, {r6, fp, sp, lr}
    52a8:	ff50f7ff 	swinv	0x0050f7ff
    52ac:	70086821 	andvc	r6, r8, r1, lsr #16
    52b0:	0000e648 	andeq	lr, r0, r8, asr #12
    52b4:	6804b5f0 	stmvsda	r4, {r4, r5, r6, r7, r8, sl, ip, sp, pc}
    52b8:	780d6841 	stmvcda	sp, {r0, r6, fp, sp, lr}
    52bc:	88066880 	stmhida	r6, {r7, fp, sp, lr}
    52c0:	f7fd1c30 	undefined
    52c4:	4917fb71 	ldmmidb	r7, {r0, r4, r5, r6, r8, r9, fp, ip, sp, lr, pc}
    52c8:	4356220a 	cmpmi	r6, #-1610612736	; 0xa0000000
    52cc:	19926aca 	ldmneib	r2, {r1, r3, r6, r7, r9, fp, sp, lr}
    52d0:	4a158896 	bmi	0x567530
    52d4:	2100188f 	smlabbcs	r0, pc, r8, r1
    52d8:	29005e79 	stmcsdb	r0, {r0, r3, r4, r5, r6, r9, sl, fp, ip, lr}
    52dc:	2100da01 	tstcs	r0, r1, lsl #20
    52e0:	1c398039 	ldcne	0, cr8, [r9], #-228
    52e4:	2300b403 	tstcs	r0, #50331648	; 0x3000000
    52e8:	06311c2a 	ldreqt	r1, [r1], -sl, lsr #24
    52ec:	200a0e09 	andcs	r0, sl, r9, lsl #28
    52f0:	692d4d88 	stmvsdb	sp!, {r3, r7, r8, sl, fp, lr}
    52f4:	6a6d682d 	bvs	0x1b5f3b0
    52f8:	f011682d 	andnvs	r6, r1, sp, lsr #16
    52fc:	2000ff7f 	andcs	pc, r0, pc, ror pc
    5300:	b0025e38 	andlt	r5, r2, r8, lsr lr
    5304:	d1042801 	tstle	r4, r1, lsl #16
    5308:	70202020 	eorvc	r2, r0, r0, lsr #32
    530c:	71782001 	cmnvc	r8, r1
    5310:	4906e005 	stmmidb	r6, {r0, r2, sp, lr, pc}
    5314:	d1014288 	smlabble	r1, r8, r2, r4
    5318:	43c0201f 	bicmi	r2, r0, #31	; 0x1f
    531c:	f7fd7020 	ldrnvb	r7, [sp, r0, lsr #32]!
    5320:	0000f807 	andeq	pc, r0, r7, lsl #16
    5324:	00008680 	andeq	r8, r0, r0, lsl #13
    5328:	000002b2 	streqh	r0, [r0], -r2
    532c:	ffff9400 	swinv	0x00ff9400
    5330:	43c02001 	bicmi	r2, r0, #1	; 0x1
    5334:	00004770 	andeq	r4, r0, r0, ror r7
    5338:	4976b410 	ldmmidb	r6!, {r4, sl, ip, sp, pc}^
    533c:	6a8a6909 	bvs	0xfe29f768
    5340:	6a8b6a52 	bvs	0xfe2dfc90
    5344:	7e9b6a5b 	mrcvc	10, 4, r6, cr11, cr11, {2}
    5348:	431c2410 	tstmi	ip, #268435456	; 0x10000000
    534c:	68007694 	stmvsda	r0, {r2, r4, r7, r9, sl, ip, sp, lr}
    5350:	6a496a89 	bvs	0x125fd7c
    5354:	78093121 	stmvcda	r9, {r0, r5, r8, ip, sp}
    5358:	43514a02 	cmpmi	r1, #8192	; 0x2000
    535c:	20006001 	andcs	r6, r0, r1
    5360:	4770bc10 	undefined
    5364:	0000ea60 	andeq	lr, r0, r0, ror #20
    5368:	b09bb5f0 	ldrltsh	fp, [fp], r0
    536c:	68051c04 	stmvsda	r5, {r2, sl, fp, ip}
    5370:	68a14668 	stmvsia	r1!, {r3, r5, r6, r9, sl, lr}
    5374:	80818809 	addhi	r8, r1, r9, lsl #16
    5378:	880068e0 	stmhida	r0, {r5, r6, r7, fp, sp, lr}
    537c:	28419000 	stmcsda	r1, {ip, pc}^
    5380:	2100d30d 	tstcs	r0, sp, lsl #6
    5384:	88006920 	stmhida	r0, {r5, r8, fp, sp, lr}
    5388:	fe56f7fc 	mrc2	7, 2, pc, cr6, cr12, {7}
    538c:	20007028 	andcs	r7, r0, r8, lsr #32
    5390:	28005628 	stmcsda	r0, {r3, r5, r9, sl, ip, lr}
    5394:	2012db62 	andcss	sp, r2, r2, ror #22
    5398:	702843c0 	eorvc	r4, r8, r0, asr #7
    539c:	6860e05d 	stmvsda	r0!, {r0, r2, r3, r4, r6, sp, lr, pc}^
    53a0:	f7fd8800 	ldrnvb	r8, [sp, r0, lsl #16]!
    53a4:	6060fb01 	rsbvs	pc, r0, r1, lsl #22
    53a8:	aa132300 	bge	0x4cdfb0
    53ac:	20901c01 	addcss	r1, r0, r1, lsl #24
    53b0:	69364e58 	ldmvsdb	r6!, {r3, r4, r6, r9, sl, fp, lr}
    53b4:	6a766936 	bvs	0x1d9f894
    53b8:	f0116836 	andnvs	r6, r1, r6, lsr r8
    53bc:	1c07ff1d 	stcne	15, cr15, [r7], {29}
    53c0:	023626ff 	eoreqs	r2, r6, #267386880	; 0xff00000
    53c4:	d13b4230 	teqle	fp, r0, lsr r2
    53c8:	46694668 	strmibt	r4, [r9], -r8, ror #12
    53cc:	81018889 	smlabbhi	r1, r9, r8, r8
    53d0:	aa02466b 	bge	0x96d84
    53d4:	3114a913 	tstcc	r4, r3, lsl r9
    53d8:	4f4e2094 	swimi	0x004e2094
    53dc:	693f693f 	ldmvsdb	pc!, {r0, r1, r2, r3, r4, r5, r8, fp, sp, lr}
    53e0:	683f6a7f 	ldmvsda	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    53e4:	ff06f011 	swinv	0x0006f011
    53e8:	42301c07 	eormis	r1, r0, #1792	; 0x700
    53ec:	4668d128 	strmibt	sp, [r8], -r8, lsr #2
    53f0:	88096921 	stmhida	r9, {r0, r5, r8, fp, sp, lr}
    53f4:	99008081 	stmlsdb	r0, {r0, r7, pc}
    53f8:	0c090409 	cfstrseq	mvf0, [r9], {9}
    53fc:	f7fc8880 	ldrnvb	r8, [ip, r0, lsl #17]!
    5400:	1c06fe1b 	stcne	14, cr15, [r6], {27}
    5404:	da0c2800 	ble	0x30f40c
    5408:	22002300 	andcs	r2, r0, #0	; 0x0
    540c:	20922100 	addcss	r2, r2, r0, lsl #2
    5410:	69244c40 	stmvsdb	r4!, {r6, sl, fp, lr}
    5414:	6a646924 	bvs	0x191f8ac
    5418:	f0116824 	andnvs	r6, r1, r4, lsr #16
    541c:	1c30fef1 	ldcne	14, cr15, [r0], #-964
    5420:	4668e01c 	undefined
    5424:	f7fd8880 	ldrnvb	r8, [sp, r0, lsl #17]!
    5428:	6120fabf 	strvsh	pc, [r0, -pc]!
    542c:	a9029800 	stmgedb	r2, {fp, ip, pc}
    5430:	69221c89 	stmvsdb	r2!, {r0, r3, r7, sl, fp, ip}
    5434:	d0032800 	andle	r2, r3, r0, lsl #16
    5438:	5c0b1e40 	stcpl	14, cr1, [fp], {64}
    543c:	d1fb5413 	mvnles	r5, r3, lsl r4
    5440:	70280a38 	eorvc	r0, r8, r8, lsr sl
    5444:	22002300 	andcs	r2, r0, #0	; 0x0
    5448:	20922100 	addcss	r2, r2, r0, lsl #2
    544c:	69244c31 	stmvsdb	r4!, {r0, r4, r5, sl, fp, lr}
    5450:	6a646924 	bvs	0x191f8e8
    5454:	f0116824 	andnvs	r6, r1, r4, lsr #16
    5458:	2000fed3 	ldrcsd	pc, [r0], -r3
    545c:	f7fcb01b 	undefined
    5460:	0000ff68 	andeq	pc, r0, r8, ror #30
    5464:	b09bb5f0 	ldrltsh	fp, [fp], r0
    5468:	68051c04 	stmvsda	r5, {r2, sl, fp, ip}
    546c:	68a14668 	stmvsia	r1!, {r3, r5, r6, r9, sl, lr}
    5470:	80818809 	addhi	r8, r1, r9, lsl #16
    5474:	88006860 	stmhida	r0, {r5, r6, fp, sp, lr}
    5478:	fa96f7fd 	blx	0xfe5c3474
    547c:	68e06060 	stmvsia	r0!, {r5, r6, sp, lr}^
    5480:	1c308806 	ldcne	8, cr8, [r0], #-24
    5484:	fa90f7fd 	blx	0xfe443480
    5488:	200a60e0 	andcs	r6, sl, r0, ror #1
    548c:	48224346 	stmmida	r2!, {r1, r2, r6, r8, r9, lr}
    5490:	19806ac0 	stmneib	r0, {r6, r7, r9, fp, sp, lr}
    5494:	90008880 	andls	r8, r0, r0, lsl #17
    5498:	d3032841 	tstle	r3, #4259840	; 0x410000
    549c:	43c02012 	bicmi	r2, r0, #18	; 0x12
    54a0:	e0337028 	eors	r7, r3, r8, lsr #32
    54a4:	23004e1b 	tstcs	r0, #432	; 0x1b0
    54a8:	6861aa13 	stmvsda	r1!, {r0, r1, r4, r9, fp, sp, pc}^
    54ac:	69372090 	ldmvsdb	r7!, {r4, r7, sp}
    54b0:	6a7f693f 	bvs	0x1fdf9b4
    54b4:	f011683f 	andnvs	r6, r1, pc, lsr r8
    54b8:	21fffe9d 	ldrcsb	pc, [pc, #237]	; 0x55ad
    54bc:	42080209 	andmi	r0, r8, #-1879048192	; 0x90000000
    54c0:	4668d118 	undefined
    54c4:	88894669 	stmhiia	r9, {r0, r3, r5, r6, r9, sl, lr}
    54c8:	98008101 	stmlsda	r0, {r0, r8, pc}
    54cc:	aa0268e1 	bge	0x9f858
    54d0:	28001c92 	stmcsda	r0, {r1, r4, r7, sl, fp, ip}
    54d4:	1e40d003 	cdpne	0, 4, cr13, cr0, cr3, {0}
    54d8:	54135c0b 	ldrpl	r5, [r3], #-3083
    54dc:	466bd1fb 	undefined
    54e0:	a913aa02 	ldmgedb	r3, {r1, r9, fp, sp, pc}
    54e4:	20953114 	addcss	r3, r5, r4, lsl r1
    54e8:	69246934 	stmvsdb	r4!, {r2, r4, r5, r8, fp, sp, lr}
    54ec:	68246a64 	stmvsda	r4!, {r2, r5, r6, r9, fp, sp, lr}
    54f0:	fe86f011 	mcr2	0, 4, pc, cr6, cr1, {0}
    54f4:	70280a00 	eorvc	r0, r8, r0, lsl #20
    54f8:	22002300 	andcs	r2, r0, #0	; 0x0
    54fc:	20922100 	addcss	r2, r2, r0, lsl #2
    5500:	69246934 	stmvsdb	r4!, {r2, r4, r5, r8, fp, sp, lr}
    5504:	68246a64 	stmvsda	r4!, {r2, r5, r6, r9, fp, sp, lr}
    5508:	fe7af011 	mrc2	0, 3, pc, cr10, cr1, {0}
    550c:	b01b2000 	andlts	r2, fp, r0
    5510:	ff0ff7fc 	swinv	0x000ff7fc
    5514:	0000015c 	andeq	r0, r0, ip, asr r1
    5518:	00008680 	andeq	r8, r0, r0, lsl #13
    551c:	49c7b5f0 	stmmiib	r7, {r4, r5, r6, r7, r8, sl, ip, sp, pc}^
    5520:	4cbd6008 	ldcmi	0, cr6, [sp], #32
    5524:	6020483e 	eorvs	r4, r0, lr, lsr r8
    5528:	6060483e 	rsbvs	r4, r0, lr, lsr r8
    552c:	1825483f 	stmneda	r5!, {r0, r1, r2, r3, r4, r5, fp, lr}
    5530:	72a82000 	adcvc	r2, r8, #0	; 0x0
    5534:	210048c0 	smlabtcs	r0, r0, r8, r4
    5538:	20005421 	andcs	r5, r0, r1, lsr #8
    553c:	2300493c 	tstcs	r0, #983040	; 0xf0000
    5540:	18a20082 	stmneia	r2!, {r1, r7}
    5544:	1c405453 	cfstrdne	mvd5, [r0], {83}
    5548:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    554c:	d3f72803 	mvnles	r2, #196608	; 0x30000
    5550:	fc30f00f 	ldc2	0, cr15, [r0], #-60
    5554:	f8e0f00b 	stmnvia	r0!, {r0, r1, r3, ip, sp, lr, pc}^
    5558:	182048b0 	stmneda	r0!, {r4, r5, r7, fp, lr}
    555c:	70012111 	andvc	r2, r1, r1, lsl r1
    5560:	70412100 	subvc	r2, r1, r0, lsl #2
    5564:	70c16041 	sbcvc	r6, r1, r1, asr #32
    5568:	52a14a2f 	adcpl	r4, r1, #192512	; 0x2f000
    556c:	52a14a31 	adcpl	r4, r1, #200704	; 0x31000
    5570:	7001210b 	andvc	r2, r1, fp, lsl #2
    5574:	72012101 	andvc	r2, r1, #1073741824	; 0x40000000
    5578:	482f71a9 	stmmida	pc!, {r0, r3, r5, r7, r8, ip, sp, lr}
    557c:	70411820 	subvc	r1, r1, r0, lsr #16
    5580:	26002100 	strcs	r2, [r0], -r0, lsl #2
    5584:	434a221f 	cmpmi	sl, #-268435455	; 0xf0000001
    5588:	33231c23 	teqcc	r3, #8960	; 0x2300
    558c:	1c49549e 	cfstrdne	mvd5, [r9], {158}
    5590:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    5594:	d3f5291e 	mvnles	r2, #491520	; 0x78000
    5598:	7006712e 	andvc	r7, r6, lr, lsr #2
    559c:	49272000 	stmmidb	r7!, {sp}
    55a0:	27071861 	strcs	r1, [r7, -r1, ror #16]
    55a4:	4343232f 	cmpmi	r3, #-1140850688	; 0xbc000000
    55a8:	4b25469c 	blmi	0x957020
    55ac:	18d24a9a 	ldmneia	r2, {r1, r3, r4, r7, r9, fp, lr}^
    55b0:	1e7f4462 	cdpne	4, 7, cr4, cr15, cr2, {3}
    55b4:	d1fc55d6 	ldrlesb	r5, [ip, #86]!
    55b8:	3b242710 	blcc	0x90f200
    55bc:	18d24a96 	ldmneia	r2, {r1, r2, r4, r7, r9, fp, lr}^
    55c0:	1e7f4462 	cdpne	4, 7, cr4, cr15, cr2, {3}
    55c4:	d1fc55d6 	ldrlesb	r5, [ip, #86]!
    55c8:	33102704 	tstcc	r0, #1048576	; 0x100000
    55cc:	18d24a92 	ldmneia	r2, {r1, r4, r7, r9, fp, lr}^
    55d0:	1e7f4462 	cdpne	4, 7, cr4, cr15, cr2, {3}
    55d4:	d1fc55d6 	ldrlesb	r5, [ip, #86]!
    55d8:	1d1b2710 	ldcne	7, cr2, [fp, #-64]
    55dc:	18d24a8e 	ldmneia	r2, {r1, r2, r3, r7, r9, fp, lr}^
    55e0:	1e7f4462 	cdpne	4, 7, cr4, cr15, cr2, {3}
    55e4:	d1fc55d6 	ldrlesb	r5, [ip, #86]!
    55e8:	4342222f 	cmpmi	r2, #-268435454	; 0xf0000002
    55ec:	548b23ff 	strpl	r2, [fp], #1023
    55f0:	549e1c4b 	ldrpl	r1, [lr], #3147
    55f4:	549e1c8b 	ldrpl	r1, [lr], #3211
    55f8:	06001c40 	streq	r1, [r0], -r0, asr #24
    55fc:	28040e00 	stmcsda	r4, {r9, sl, fp}
    5600:	2102d3cf 	smlabtcs	r2, pc, r3, sp
    5604:	18204887 	stmneda	r0!, {r0, r1, r2, r7, fp, lr}
    5608:	f954f00b 	ldmnvdb	r4, {r0, r1, r3, ip, sp, lr, pc}^
    560c:	f94cf00b 	stmnvdb	ip, {r0, r1, r3, ip, sp, lr, pc}^
    5610:	fdf8f00b 	ldc2l	0, cr15, [r8, #44]!
    5614:	54264886 	strplt	r4, [r6], #-2182
    5618:	706e702e 	rsbvc	r7, lr, lr, lsr #32
    561c:	ffd6f000 	swinv	0x00d6f000
    5620:	00107fc5 	andeqs	r7, r0, r5, asr #31
    5624:	00108169 	andeqs	r8, r0, r9, ror #2
    5628:	0000086e 	andeq	r0, r0, lr, ror #16
    562c:	0000075d 	andeq	r0, r0, sp, asr r7
    5630:	00000ba8 	andeq	r0, r0, r8, lsr #23
    5634:	0000076c 	andeq	r0, r0, ip, ror #14
    5638:	0000047f 	andeq	r0, r0, pc, ror r4
    563c:	000003d5 	ldreqd	r0, [r0], -r5
    5640:	000003ce 	andeq	r0, r0, lr, asr #7
    5644:	4d74b5f3 	cfldr64mi	mvdx11, [r4, #-972]!
    5648:	182c4874 	stmneda	ip!, {r2, r4, r5, r6, fp, lr}
    564c:	fe24f000 	cdp2	0, 2, cr15, cr4, cr0, {0}
    5650:	d1092800 	tstle	r9, r0, lsl #16
    5654:	70202011 	eorvc	r2, r0, r1, lsl r0
    5658:	70602000 	rsbvc	r2, r0, r0
    565c:	70e06060 	rscvc	r6, r0, r0, rrx
    5660:	219668e0 	orrcss	r6, r6, r0, ror #17
    5664:	80010209 	andhi	r0, r1, r9, lsl #4
    5668:	f82af001 	stmnvda	sl!, {r0, ip, sp, lr, pc}
    566c:	182f486c 	stmneda	pc!, {r2, r3, r5, r6, fp, lr}
    5670:	f936f00b 	ldmnvdb	r6!, {r0, r1, r3, ip, sp, lr, pc}
    5674:	782071b8 	stmvcda	r0!, {r3, r4, r5, r7, r8, ip, sp, lr}
    5678:	d12c2811 	teqle	ip, r1, lsl r8
    567c:	496979b8 	stmmidb	r9!, {r3, r4, r5, r7, r8, fp, ip, sp, lr}^
    5680:	4969186e 	stmmidb	r9!, {r1, r2, r3, r5, r6, fp, ip}^
    5684:	7a221869 	bvc	0x88b830
    5688:	d0042a00 	andle	r2, r4, r0, lsl #20
    568c:	d0082a01 	andle	r2, r8, r1, lsl #20
    5690:	d0132a02 	andles	r2, r3, r2, lsl #20
    5694:	2000e01f 	andcs	lr, r0, pc, lsl r0
    5698:	71f87038 	mvnvcs	r7, r8, lsr r0
    569c:	f8fcf00b 	ldmnvia	ip!, {r0, r1, r3, ip, sp, lr, pc}^
    56a0:	2800e019 	stmcsda	r0, {r0, r3, r4, sp, lr, pc}
    56a4:	2000d017 	andcs	sp, r0, r7, lsl r0
    56a8:	20027008 	andcs	r7, r2, r8
    56ac:	72207038 	eorvc	r7, r0, #56	; 0x38
    56b0:	fa90f00b 	blx	0xfe4416e4
    56b4:	f908f00b 	stmnvdb	r8, {r0, r1, r3, ip, sp, lr, pc}
    56b8:	e0092101 	and	r2, r9, r1, lsl #2
    56bc:	d10a2800 	tstle	sl, r0, lsl #16
    56c0:	70382001 	eorvcs	r2, r8, r1
    56c4:	20007220 	andcs	r7, r0, r0, lsr #4
    56c8:	f00b7008 	andnv	r7, fp, r8
    56cc:	2102f901 	tstcsp	r2, r1, lsl #18
    56d0:	f00b1c30 	andnv	r1, fp, r0, lsr ip
    56d4:	4855f8ef 	ldmmida	r5, {r0, r1, r2, r3, r5, r6, r7, fp, ip, sp, lr, pc}^
    56d8:	54292100 	strplt	r2, [r9], #-256
    56dc:	182c4854 	stmneda	ip!, {r2, r4, r6, fp, lr}
    56e0:	07c07878 	undefined
    56e4:	7878d524 	ldmvcda	r8!, {r2, r5, r8, sl, ip, lr, pc}^
    56e8:	400121fe 	strmid	r2, [r1], -lr
    56ec:	78f87079 	ldmvcia	r8!, {r0, r3, r4, r5, r6, ip, sp, lr}^
    56f0:	d0062801 	andle	r2, r6, r1, lsl #16
    56f4:	d00d2802 	andle	r2, sp, r2, lsl #16
    56f8:	d0122803 	andles	r2, r2, r3, lsl #16
    56fc:	d0132804 	andles	r2, r3, r4, lsl #16
    5700:	f00be016 	andnv	lr, fp, r6, lsl r0
    5704:	2002fda9 	andcs	pc, r2, r9, lsr #27
    5708:	787870f8 	ldmvcda	r8!, {r3, r4, r5, r6, r7, ip, sp, lr}^
    570c:	43012101 	tstmi	r1, #1073741824	; 0x40000000
    5710:	e00d7079 	and	r7, sp, r9, ror r0
    5714:	18284847 	stmneda	r8!, {r0, r1, r2, r6, fp, lr}
    5718:	fe1af00b 	wxornv	wr15, wr10, wr11
    571c:	70202001 	eorvc	r2, r0, r1
    5720:	f000e009 	andnv	lr, r0, r9
    5724:	e003ff31 	and	pc, r3, r1, lsr pc
    5728:	70202000 	eorvc	r2, r0, r0
    572c:	fea2f00b 	cdp2	0, 10, cr15, cr2, cr11, {0}
    5730:	28007820 	stmcsda	r0, {r5, fp, ip, sp, lr}
    5734:	f000d001 	andnv	sp, r0, r1
    5738:	483fff55 	ldmmida	pc!, {r0, r2, r4, r6, r8, r9, sl, fp, ip, sp, lr, pc}
    573c:	7821182c 	stmvcda	r1!, {r2, r3, r5, fp, ip}
    5740:	18283841 	stmneda	r8!, {r0, r6, fp, ip, sp}
    5744:	29009001 	stmcsdb	r0, {r0, ip, pc}
    5748:	9801d004 	stmlsda	r1, {r2, ip, lr, pc}
    574c:	f848f00f 	stmnvda	r8, {r0, r1, r2, r3, ip, sp, lr, pc}^
    5750:	70202000 	eorvc	r2, r0, r0
    5754:	90002000 	andls	r2, r0, r0
    5758:	182c482d 	stmneda	ip!, {r0, r2, r3, r5, fp, lr}
    575c:	f00f4e37 	andnv	r4, pc, r7, lsr lr
    5760:	2801fb19 	stmcsda	r1, {r0, r3, r4, r8, r9, fp, ip, sp, lr, pc}
    5764:	6a806830 	bvs	0xfe01f82c
    5768:	d1146a40 	tstle	r4, r0, asr #20
    576c:	21013020 	tstcs	r1, r0, lsr #32
    5770:	f00f7001 	andnv	r7, pc, r1
    5774:	2801fa77 	stmcsda	r1, {r0, r1, r2, r4, r5, r6, r9, fp, ip, sp, lr, pc}
    5778:	2140d12f 	cmpcs	r0, pc, lsr #2
    577c:	f00e1c20 	andnv	r1, lr, r0, lsr #24
    5780:	9000fff1 	strlsd	pc, [r0], -r1
    5784:	71382001 	teqvc	r8, r1
    5788:	6a806830 	bvs	0xfe01f850
    578c:	30206a40 	eorcc	r6, r0, r0, asr #20
    5790:	70012102 	andvc	r2, r1, r2, lsl #2
    5794:	3020e021 	eorcc	lr, r0, r1, lsr #32
    5798:	70012100 	andvc	r2, r1, r0, lsl #2
    579c:	fb56f00f 	blx	0x15c17e2
    57a0:	28017938 	stmcsda	r1, {r3, r4, r5, r8, fp, ip, sp, lr}
    57a4:	2000d119 	andcs	sp, r0, r9, lsl r1
    57a8:	f00f7138 	andnv	r7, pc, r8, lsr r1
    57ac:	e010fad5 	ldrsb	pc, [r0], -r5
    57b0:	466b7020 	strmibt	r7, [fp], -r0, lsr #32
    57b4:	182a4817 	stmneda	sl!, {r0, r1, r2, r4, fp, lr}
    57b8:	20841c21 	addcs	r1, r4, r1, lsr #24
    57bc:	693f6837 	ldmvsdb	pc!, {r0, r1, r2, r4, r5, fp, sp, lr}
    57c0:	683f6a7f 	ldmvsda	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    57c4:	fd16f011 	ldc2	0, cr15, [r6, #-68]
    57c8:	f00f7820 	andnv	r7, pc, r0, lsr #16
    57cc:	f00ffab3 	strnvh	pc, [pc], -r3
    57d0:	21fffacb 	mvncss	pc, fp, asr #21
    57d4:	42080209 	andmi	r0, r8, #-1879048192	; 0x90000000
    57d8:	9800d0ea 	stmlsda	r0, {r1, r3, r5, r6, r7, ip, lr, pc}
    57dc:	d0112800 	andles	r2, r1, r0, lsl #16
    57e0:	04009800 	streq	r9, [r0], #-2048
    57e4:	b4010c00 	strlt	r0, [r1], #-3072
    57e8:	aa012301 	bge	0x4e3f4
    57ec:	1c209902 	stcne	9, cr9, [r0], #-8
    57f0:	f830f000 	ldmnvda	r0!, {ip, sp, lr, pc}
    57f4:	b0019801 	andlt	r9, r1, r1, lsl #16
    57f8:	d0032800 	andle	r2, r3, r0, lsl #16
    57fc:	98019900 	stmlsda	r1, {r8, fp, ip, pc}
    5800:	ffeef00e 	swinv	0x00eef00e
    5804:	f850f00b 	ldmnvda	r0, {r0, r1, r3, ip, sp, lr, pc}^
    5808:	bc01bcfc 	stclt	12, cr11, [r1], {252}
    580c:	46c04700 	strmib	r4, [r0], r0, lsl #14
    5810:	00000695 	muleq	r0, r5, r6
    5814:	00000697 	muleq	r0, r7, r6
    5818:	00008a54 	andeq	r8, r0, r4, asr sl
    581c:	00000bb4 	streqh	r0, [r0], -r4
    5820:	00000763 	andeq	r0, r0, r3, ror #14
    5824:	0000076e 	andeq	r0, r0, lr, ror #14
    5828:	00000505 	andeq	r0, r0, r5, lsl #10
    582c:	00000486 	andeq	r0, r0, r6, lsl #9
    5830:	00000979 	andeq	r0, r0, r9, ror r9
    5834:	0000097a 	andeq	r0, r0, sl, ror r9
    5838:	0000071a 	andeq	r0, r0, sl, lsl r7
    583c:	00009624 	andeq	r9, r0, r4, lsr #12
    5840:	f00fb500 	andnv	fp, pc, r0, lsl #10
    5844:	f00bfb0b 	andnv	pc, fp, fp, lsl #22
    5848:	f00bfe15 	andnv	pc, fp, r5, lsl lr
    584c:	bc01fb65 	stclt	11, cr15, [r1], {101}
    5850:	00004700 	andeq	r4, r0, r0, lsl #14
    5854:	1c04b5fb 	cfstr32ne	mvfx11, [r4], {251}
    5858:	1c161c0d 	ldcne	12, cr1, [r6], {13}
    585c:	8c014668 	stchi	6, cr4, [r1], {104}
    5860:	08427a00 	stmeqda	r2, {r9, fp, ip, sp, lr}^
    5864:	0092483f 	addeqs	r4, r2, pc, lsr r8
    5868:	189a4b3f 	ldmneia	sl, {r0, r1, r2, r3, r4, r5, r8, r9, fp, lr}
    586c:	90001810 	andls	r1, r0, r0, lsl r8
    5870:	207f2780 	rsbcss	r2, pc, r0, lsl #15
    5874:	78129a00 	ldmvcda	r2, {r9, fp, ip, pc}
    5878:	d14e2a00 	cmple	lr, r0, lsl #20
    587c:	68134a3b 	ldmvsda	r3, {r0, r1, r3, r4, r5, r9, fp, lr}
    5880:	40107822 	andmis	r7, r0, r2, lsr #16
    5884:	2801d01b 	stmcsda	r1, {r0, r1, r3, r4, ip, lr, pc}
    5888:	2802d002 	stmcsda	r2, {r1, ip, lr, pc}
    588c:	e041d037 	sub	sp, r1, r7, lsr r0
    5890:	7a004668 	bvc	0x17238
    5894:	1c33b403 	cfldrsne	mvf11, [r3], #-12
    5898:	1c611caa 	stcnel	12, cr1, [r1], #-680
    589c:	f0007860 	andnv	r7, r0, r0, ror #16
    58a0:	a902f867 	stmgedb	r2, {r0, r1, r2, r5, r6, fp, ip, sp, lr, pc}
    58a4:	78208088 	stmvcda	r0!, {r3, r7, pc}
    58a8:	4238b002 	eormis	fp, r8, #2	; 0x2
    58ac:	2000d01e 	andcs	sp, r0, lr, lsl r0
    58b0:	98007030 	stmlsda	r0, {r4, r5, ip, sp, lr}
    58b4:	78499900 	stmvcda	r9, {r8, fp, ip, pc}^
    58b8:	7047430f 	subvc	r4, r7, pc, lsl #6
    58bc:	7830e04d 	ldmvcda	r0!, {r0, r2, r3, r6, sp, lr, pc}
    58c0:	70301e40 	eorvcs	r1, r0, r0, asr #28
    58c4:	42387820 	eormis	r7, r8, #2097152	; 0x200000
    58c8:	1c32d008 	ldcne	0, cr13, [r2], #-32
    58cc:	1c202100 	stfnes	f2, [r0]
    58d0:	6a5b6a5b 	bvs	0x16e0244
    58d4:	f011691b 	andnvs	r6, r1, fp, lsl r9
    58d8:	e03efc8b 	eors	pc, lr, fp, lsl #25
    58dc:	1ca91c32 	stcne	12, cr1, [r9], #200
    58e0:	6a5b1c20 	bvs	0x16cc968
    58e4:	691b6a5b 	ldmvsdb	fp, {r0, r1, r3, r4, r6, r9, fp, sp, lr}
    58e8:	fc82f011 	stc2	0, cr15, [r2], {17}
    58ec:	28007830 	stmcsda	r0, {r4, r5, fp, ip, sp, lr}
    58f0:	1c80d033 	stcne	0, cr13, [r0], {51}
    58f4:	20027030 	andcs	r7, r2, r0, lsr r0
    58f8:	78607028 	stmvcda	r0!, {r3, r5, ip, sp, lr}^
    58fc:	7860e02c 	stmvcda	r0!, {r2, r3, r5, sp, lr, pc}^
    5900:	d2072814 	andle	r2, r7, #1310720	; 0x140000
    5904:	21001c32 	tstcs	r0, r2, lsr ip
    5908:	6a5b1c20 	bvs	0x16cc990
    590c:	691b6a5b 	ldmvsdb	fp, {r0, r1, r3, r4, r6, r9, fp, sp, lr}
    5910:	fc6ef011 	stc2l	0, cr15, [lr], #-68
    5914:	70302000 	eorvcs	r2, r0, r0
    5918:	9a00e01f 	bls	0x3d99c
    591c:	40107852 	andmis	r7, r0, r2, asr r8
    5920:	d11a2801 	tstle	sl, r1, lsl #16
    5924:	7a004668 	bvc	0x172cc
    5928:	1c33b403 	cfldrsne	mvf11, [r3], #-12
    592c:	1c211caa 	stcne	12, cr1, [r1], #-680
    5930:	78c09802 	stmvcia	r0, {r1, fp, ip, pc}^
    5934:	f81cf000 	ldmnvda	ip, {ip, sp, lr, pc}
    5938:	8088a902 	addhi	sl, r8, r2, lsl #18
    593c:	78409802 	stmvcda	r0, {r1, fp, ip, pc}^
    5940:	4238b002 	eormis	fp, r8, #2	; 0x2
    5944:	7830d1e6 	ldmvcda	r0!, {r1, r2, r5, r6, r7, r8, ip, lr, pc}
    5948:	d0062800 	andle	r2, r6, r0, lsl #16
    594c:	70301c80 	eorvcs	r1, r0, r0, lsl #25
    5950:	70282002 	eorvc	r2, r8, r2
    5954:	78c09800 	stmvcia	r0, {fp, ip, pc}^
    5958:	46687068 	strmibt	r7, [r8], -r8, rrx
    595c:	f0028880 	andnv	r8, r2, r0, lsl #17
    5960:	0000f96d 	andeq	pc, r0, sp, ror #18
    5964:	00000ba8 	andeq	r0, r0, r8, lsr #23
    5968:	00008a54 	andeq	r8, r0, r4, asr sl
    596c:	00009624 	andeq	r9, r0, r4, lsr #12
    5970:	b089b5f3 	strltd	fp, [r9], r3
    5974:	1c1d1c14 	ldcne	12, cr1, [sp], {20}
    5978:	7806a810 	stmvcda	r6, {r4, fp, sp, pc}
    597c:	48db0871 	ldmmiia	fp, {r0, r4, r5, r6, fp}^
    5980:	18104adb 	ldmneda	r0, {r0, r1, r3, r4, r6, r7, r9, fp, lr}
    5984:	48db9002 	ldmmiia	fp, {r1, ip, pc}^
    5988:	aa091810 	bge	0x24b9d0
    598c:	3a807812 	bcc	0xfe0239dc
    5990:	d9002a24 	stmledb	r0, {r2, r5, r9, fp, sp}
    5994:	a302e078 	tstge	r2, #120	; 0x78
    5998:	5a9b0052 	bpl	0xfe6c5ae8
    599c:	46c0449f 	undefined
    59a0:	004a0258 	subeq	r0, sl, r8, asr r2
    59a4:	00ea0294 	smlaleq	r0, sl, r4, r2
    59a8:	031e0228 	tsteq	lr, #-2147483646	; 0x80000002
    59ac:	03ca0370 	biceq	r0, sl, #-1073741823	; 0xc0000001
    59b0:	04300418 	ldreqt	r0, [r0], #-1048
    59b4:	019408c4 	orreqs	r0, r4, r4, asr #17
    59b8:	08c401d6 	stmeqia	r4, {r1, r2, r4, r6, r7, r8}^
    59bc:	08c408c4 	stmeqia	r4, {r2, r6, r7, fp}^
    59c0:	04b00478 	ldreqt	r0, [r0], #1144
    59c4:	08c404e4 	stmeqia	r4, {r2, r5, r6, r7, sl}^
    59c8:	05b00508 	ldreq	r0, [r0, #1288]!
    59cc:	063e08c4 	ldreqt	r0, [lr], -r4, asr #17
    59d0:	08c406ba 	stmeqia	r4, {r1, r3, r4, r5, r7, r9, sl}^
    59d4:	071a06f8 	undefined
    59d8:	08c408c4 	stmeqia	r4, {r2, r6, r7, fp}^
    59dc:	08c408c4 	stmeqia	r4, {r2, r6, r7, fp}^
    59e0:	07900774 	undefined
    59e4:	08c407c2 	stmeqia	r4, {r1, r6, r7, r8, r9, sl}^
    59e8:	980a0896 	stmlsda	sl, {r1, r2, r4, r7, fp}
    59ec:	90007d40 	andls	r7, r0, r0, asr #26
    59f0:	7d89990a 	stcvc	9, cr9, [r9, #40]
    59f4:	18400209 	stmneda	r0, {r0, r3, r9}^
    59f8:	990a9000 	stmlsdb	sl, {ip, pc}
    59fc:	04097dc9 	streq	r7, [r9], #-3529
    5a00:	90001840 	andls	r1, r0, r0, asr #16
    5a04:	7e09990a 	cdpvc	9, 0, cr9, cr9, cr10, {0}
    5a08:	18400609 	stmneda	r0, {r0, r3, r9, sl}^
    5a0c:	22149000 	andcss	r9, r4, #0	; 0x0
    5a10:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    5a14:	f000a804 	andnv	sl, r0, r4, lsl #16
    5a18:	49b7fd8d 	ldmmiib	r7!, {r0, r2, r3, r7, r8, sl, fp, ip, sp, lr, pc}
    5a1c:	a8043114 	stmgeda	r4, {r2, r4, r8, ip, sp}
    5a20:	fbaef00f 	blx	0xfebc1a66
    5a24:	d10d2800 	tstle	sp, r0, lsl #16
    5a28:	311c49b3 	ldrcch	r4, [ip, -r3]
    5a2c:	f00fa804 	andnv	sl, pc, r4, lsl #16
    5a30:	2800fba7 	stmcsda	r0, {r0, r1, r2, r5, r7, r8, r9, fp, ip, sp, lr, pc}
    5a34:	49b0d106 	ldmmiib	r0!, {r1, r2, r8, ip, lr, pc}
    5a38:	a8043124 	stmgeda	r4, {r2, r5, r8, ip, sp}
    5a3c:	fba0f00f 	blx	0xfe841a82
    5a40:	d0052800 	andle	r2, r5, r0, lsl #16
    5a44:	2200466b 	andcs	r4, r0, #112197632	; 0x6b00000
    5a48:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    5a4c:	e0042089 	and	r2, r4, r9, lsl #1
    5a50:	2200466b 	andcs	r4, r0, #112197632	; 0x6b00000
    5a54:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    5a58:	4fa82081 	swimi	0x00a82081
    5a5c:	693f683f 	ldmvsdb	pc!, {r0, r1, r2, r3, r4, r5, fp, sp, lr}
    5a60:	683f6a7f 	ldmvsda	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    5a64:	fbc6f011 	blx	0xff1c1ab2
    5a68:	0a381c07 	beq	0xe0ca8c
    5a6c:	70677020 	rsbvc	r7, r7, r0, lsr #32
    5a70:	70282002 	eorvc	r2, r8, r2
    5a74:	020020ff 	andeq	r2, r0, #255	; 0xff
    5a78:	d1054207 	tstle	r5, r7, lsl #4
    5a7c:	d50307f6 	strle	r0, [r3, #-2038]
    5a80:	0e000638 	cfmadd32eq	mvax1, mvfx0, mvfx0, mvfx8
    5a84:	f944f00f 	stmnvdb	r4, {r0, r1, r2, r3, ip, sp, lr, pc}^
    5a88:	0088e3ec 	addeq	lr, r8, ip, ror #7
    5a8c:	18084998 	stmneda	r8, {r3, r4, r7, r8, fp, lr}
    5a90:	1846499b 	stmneda	r6, {r0, r1, r3, r4, r7, r8, fp, lr}^
    5a94:	29007831 	stmcsdb	r0, {r0, r4, r5, fp, ip, sp, lr}
    5a98:	7828d126 	stmvcda	r8!, {r1, r2, r5, r8, ip, lr, pc}
    5a9c:	90001ec0 	andls	r1, r0, r0, asr #29
    5aa0:	9a0a466b 	bls	0x297454
    5aa4:	990a1c92 	stmlsdb	sl, {r1, r4, r7, sl, fp, ip}
    5aa8:	20831c49 	addcs	r1, r3, r9, asr #24
    5aac:	683f4f93 	ldmvsda	pc!, {r0, r1, r4, r7, r8, r9, sl, fp, lr}
    5ab0:	6a7f693f 	bvs	0x1fdffb4
    5ab4:	f011683f 	andnvs	r6, r1, pc, lsr r8
    5ab8:	1c07fb9d 	stcne	11, cr15, [r7], {157}
    5abc:	70a09800 	adcvc	r9, r0, r0, lsl #16
    5ac0:	04009800 	streq	r9, [r0], #-2048
    5ac4:	70e00e00 	rscvc	r0, r0, r0, lsl #28
    5ac8:	a9117828 	ldmgedb	r1, {r3, r5, fp, ip, sp, lr}
    5acc:	42888809 	addmi	r8, r8, #589824	; 0x90000
    5ad0:	a811d02b 	ldmgeda	r1, {r0, r1, r3, r5, ip, lr, pc}
    5ad4:	28008800 	stmcsda	r0, {fp, pc}
    5ad8:	2083d027 	addcs	sp, r3, r7, lsr #32
    5adc:	200170f0 	strcsd	r7, [r1], -r0
    5ae0:	70307070 	eorvcs	r7, r0, r0, ror r0
    5ae4:	e01c70b7 	ldrh	r7, [ip], -r7
    5ae8:	91007829 	tstls	r0, r9, lsr #16
    5aec:	9a0a466b 	bls	0x2974a0
    5af0:	18414984 	stmneda	r1, {r2, r7, r8, fp, lr}^
    5af4:	4f812083 	swimi	0x00812083
    5af8:	693f683f 	ldmvsdb	pc!, {r0, r1, r2, r3, r4, r5, fp, sp, lr}
    5afc:	683f6a7f 	ldmvsda	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    5b00:	fb78f011 	blx	0x1e41b4e
    5b04:	78e01c07 	stmvcia	r0!, {r0, r1, r2, sl, fp, ip}^
    5b08:	78a10200 	stmvcia	r1!, {r9}
    5b0c:	98004301 	stmlsda	r0, {r0, r8, r9, lr}
    5b10:	70a01808 	adcvc	r1, r0, r8, lsl #16
    5b14:	0e000400 	cfcpyseq	mvf0, mvf0
    5b18:	a81170e0 	ldmgeda	r1, {r5, r6, r7, ip, sp, lr}
    5b1c:	28008800 	stmcsda	r0, {fp, pc}
    5b20:	2000d001 	andcs	sp, r0, r1
    5b24:	2000e39d 	mulcs	r0, sp, r3
    5b28:	0a387030 	beq	0xe21bf0
    5b2c:	70677020 	rsbvc	r7, r7, r0, lsr #32
    5b30:	e3962004 	orrs	r2, r6, #4	; 0x4
    5b34:	7d40980a 	stcvcl	8, cr9, [r0, #-40]
    5b38:	990a9000 	stmlsdb	sl, {ip, pc}
    5b3c:	02097d89 	andeq	r7, r9, #8768	; 0x2240
    5b40:	90001840 	andls	r1, r0, r0, asr #16
    5b44:	7dc9990a 	stcvcl	9, cr9, [r9, #40]
    5b48:	18400409 	stmneda	r0, {r0, r3, sl}^
    5b4c:	990a9000 	stmlsdb	sl, {ip, pc}
    5b50:	06097e09 	streq	r7, [r9], -r9, lsl #28
    5b54:	90001840 	andls	r1, r0, r0, asr #16
    5b58:	2200466b 	andcs	r4, r0, #112197632	; 0x6b00000
    5b5c:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    5b60:	4f66208b 	swimi	0x0066208b
    5b64:	693f683f 	ldmvsdb	pc!, {r0, r1, r2, r3, r4, r5, fp, sp, lr}
    5b68:	683f6a7f 	ldmvsda	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    5b6c:	fb42f011 	blx	0x10c1bba
    5b70:	0a001c07 	beq	0xcb94
    5b74:	466be77a 	undefined
    5b78:	990a2200 	stmlsdb	sl, {r9, sp}
    5b7c:	208c1c49 	addcs	r1, ip, r9, asr #24
    5b80:	683f4f5e 	ldmvsda	pc!, {r1, r2, r3, r4, r6, r8, r9, sl, fp, lr}
    5b84:	6a7f693f 	bvs	0x1fe0088
    5b88:	f011683f 	andnvs	r6, r1, pc, lsr r8
    5b8c:	1c07fb33 	stcne	11, cr15, [r7], {51}
    5b90:	70200a00 	eorvc	r0, r0, r0, lsl #20
    5b94:	98007067 	stmlsda	r0, {r0, r1, r2, r5, r6, ip, sp, lr}
    5b98:	980070a0 	stmlsda	r0, {r5, r7, ip, sp, lr}
    5b9c:	0e000400 	cfcpyseq	mvf0, mvf0
    5ba0:	980070e0 	stmlsda	r0, {r5, r6, r7, ip, sp, lr}
    5ba4:	71200c00 	teqvc	r0, r0, lsl #24
    5ba8:	0e009800 	cdpeq	8, 0, cr9, cr0, cr0, {0}
    5bac:	20067160 	andcs	r7, r6, r0, ror #2
    5bb0:	20ff7028 	rsccss	r7, pc, r8, lsr #32
    5bb4:	42070200 	andmi	r0, r7, #0	; 0x0
    5bb8:	07f6d105 	ldreqb	sp, [r6, r5, lsl #2]!
    5bbc:	0638d503 	ldreqt	sp, [r8], -r3, lsl #10
    5bc0:	f00f0e00 	andnv	r0, pc, r0, lsl #28
    5bc4:	e34df8a5 	cmpp	sp, #10813440	; 0xa50000
    5bc8:	d50307f6 	strle	r0, [r3, #-2038]
    5bcc:	7840980a 	stmvcda	r0, {r1, r3, fp, ip, pc}^
    5bd0:	f8b0f00f 	ldmnvia	r0!, {r0, r1, r2, r3, ip, sp, lr, pc}
    5bd4:	2200466b 	andcs	r4, r0, #112197632	; 0x6b00000
    5bd8:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    5bdc:	4e472084 	cdpmi	0, 4, cr2, cr7, cr4, {4}
    5be0:	69366836 	ldmvsdb	r6!, {r1, r2, r4, r5, fp, sp, lr}
    5be4:	68366a76 	ldmvsda	r6!, {r1, r2, r4, r5, r6, r9, fp, sp, lr}
    5be8:	fb06f011 	blx	0x1c1c36
    5bec:	0a001c07 	beq	0xcc10
    5bf0:	70677020 	rsbvc	r7, r7, r0, lsr #32
    5bf4:	e3342002 	teq	r4, #2	; 0x2
    5bf8:	2200466b 	andcs	r4, r0, #112197632	; 0x6b00000
    5bfc:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    5c00:	4f3e2080 	swimi	0x003e2080
    5c04:	693f683f 	ldmvsdb	pc!, {r0, r1, r2, r3, r4, r5, fp, sp, lr}
    5c08:	683f6a7f 	ldmvsda	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    5c0c:	faf2f011 	blx	0xffcc1c58
    5c10:	0a001c07 	beq	0xcc34
    5c14:	70677020 	rsbvc	r7, r7, r0, lsr #32
    5c18:	70a09800 	adcvc	r9, r0, r0, lsl #16
    5c1c:	04009800 	streq	r9, [r0], #-2048
    5c20:	70e00e00 	rscvc	r0, r0, r0, lsl #28
    5c24:	0c009800 	stceq	8, cr9, [r0], {0}
    5c28:	98007120 	stmlsda	r0, {r5, r8, ip, sp, lr}
    5c2c:	71600e00 	cmnvc	r0, r0, lsl #28
    5c30:	e71e2006 	ldr	r2, [lr, -r6]
    5c34:	78c0980a 	stmvcia	r0, {r1, r3, fp, ip, pc}^
    5c38:	90000200 	andls	r0, r0, r0, lsl #4
    5c3c:	7889990a 	stmvcia	r9, {r1, r3, r8, fp, ip, pc}
    5c40:	91004301 	tstls	r0, r1, lsl #6
    5c44:	297b1c0e 	ldmcsdb	fp!, {r1, r2, r3, sl, fp, ip}^
    5c48:	482fd312 	stmmida	pc!, {r1, r4, r8, r9, ip, lr, pc}
    5c4c:	18084928 	stmneda	r8, {r3, r5, r8, fp, lr}
    5c50:	29117801 	ldmcsdb	r1, {r0, fp, ip, sp, lr}
    5c54:	492dd10c 	stmmidb	sp!, {r2, r3, r8, ip, lr, pc}
    5c58:	18514a25 	ldmneda	r1, {r0, r2, r5, r9, fp, lr}^
    5c5c:	800a9a00 	andhi	r9, sl, r0, lsl #20
    5c60:	78529a0a 	ldmvcda	r2, {r1, r3, r9, fp, ip, pc}^
    5c64:	2282804a 	addcs	r8, r2, #74	; 0x4a
    5c68:	210c770a 	tstcs	ip, sl, lsl #14
    5c6c:	e7587001 	ldrb	r7, [r8, -r1]
    5c70:	1d009800 	stcne	8, cr9, [r0]
    5c74:	466b7028 	strmibt	r7, [fp], -r8, lsr #32
    5c78:	990a1d22 	stmlsdb	sl, {r1, r5, r8, sl, fp, ip}
    5c7c:	20821c49 	addcs	r1, r2, r9, asr #24
    5c80:	682d4d1e 	stmvsda	sp!, {r1, r2, r3, r4, r8, sl, fp, lr}
    5c84:	6a6d692d 	bvs	0x1b60140
    5c88:	f011682d 	andnvs	r6, r1, sp, lsr #16
    5c8c:	1c07fab7 	stcne	10, cr15, [r7], {183}
    5c90:	70200a00 	eorvc	r0, r0, r0, lsl #20
    5c94:	70a67067 	adcvc	r7, r6, r7, rrx
    5c98:	0c000430 	cfstrseq	mvf0, [r0], {48}
    5c9c:	70e00a00 	rscvc	r0, r0, r0, lsl #20
    5ca0:	42b09800 	adcmis	r9, r0, #0	; 0x0
    5ca4:	9800d20a 	stmlsda	r0, {r1, r3, r9, ip, lr, pc}
    5ca8:	21001a30 	tstcs	r0, r0, lsr sl
    5cac:	18a29a00 	stmneia	r2!, {r9, fp, ip, pc}
    5cb0:	28001d12 	stmcsda	r0, {r1, r4, r8, sl, fp, ip}
    5cb4:	1e40d002 	cdpne	0, 4, cr13, cr0, cr2, {0}
    5cb8:	d1fc5411 	mvnles	r5, r1, lsl r4
    5cbc:	466be2d2 	undefined
    5cc0:	990a2200 	stmlsdb	sl, {r9, sp}
    5cc4:	20851c49 	addcs	r1, r5, r9, asr #24
    5cc8:	68364e0c 	ldmvsda	r6!, {r2, r3, r9, sl, fp, lr}
    5ccc:	6a766936 	bvs	0x1da01ac
    5cd0:	f0116836 	andnvs	r6, r1, r6, lsr r8
    5cd4:	1c07fa91 	stcne	10, cr15, [r7], {145}
    5cd8:	70200a00 	eorvc	r0, r0, r0, lsl #20
    5cdc:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    5ce0:	1c201c64 	stcne	12, cr1, [r0], #-400
    5ce4:	fc42f000 	mcrr2	0, 0, pc, r2, cr0
    5ce8:	e2ba2015 	adcs	r2, sl, #21	; 0x15
    5cec:	0000075d 	andeq	r0, r0, sp, asr r7
    5cf0:	00008a54 	andeq	r8, r0, r4, asr sl
    5cf4:	0000060d 	andeq	r0, r0, sp, lsl #12
    5cf8:	00118d8c 	andeqs	r8, r1, ip, lsl #27
    5cfc:	00009624 	andeq	r9, r0, r4, lsr #12
    5d00:	00000ba8 	andeq	r0, r0, r8, lsr #23
    5d04:	00000baa 	andeq	r0, r0, sl, lsr #23
    5d08:	00000bb4 	streqh	r0, [r0], -r4
    5d0c:	00000b88 	andeq	r0, r0, r8, lsl #23
    5d10:	1ca2466b 	stcne	6, cr4, [r2], #428
    5d14:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    5d18:	4fde2086 	swimi	0x00de2086
    5d1c:	693f683f 	ldmvsdb	pc!, {r0, r1, r2, r3, r4, r5, fp, sp, lr}
    5d20:	683f6a7f 	ldmvsda	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    5d24:	fa66f011 	blx	0x19c1d70
    5d28:	0a001c07 	beq	0xcd4c
    5d2c:	70677020 	rsbvc	r7, r7, r0, lsr #32
    5d30:	28007820 	stmcsda	r0, {r5, fp, ip, sp, lr}
    5d34:	9800d111 	stmlsda	r0, {r0, r4, r8, ip, lr, pc}
    5d38:	980075a0 	stmlsda	r0, {r5, r7, r8, sl, ip, sp, lr}
    5d3c:	0e000400 	cfcpyseq	mvf0, mvf0
    5d40:	980075e0 	stmlsda	r0, {r5, r6, r7, r8, sl, ip, sp, lr}
    5d44:	76200c00 	strvct	r0, [r0], -r0, lsl #24
    5d48:	0e009800 	cdpeq	8, 0, cr9, cr0, cr0, {0}
    5d4c:	07f67660 	ldreqb	r7, [r6, r0, ror #12]!
    5d50:	7860d509 	stmvcda	r0!, {r0, r3, r8, sl, ip, lr, pc}^
    5d54:	ffdcf00e 	swinv	0x00dcf00e
    5d58:	2018e005 	andcss	lr, r8, r5
    5d5c:	1ca42100 	stfnes	f2, [r4]
    5d60:	54211e40 	strplt	r1, [r1], #-3648
    5d64:	201ad1fc 	ldrcssh	sp, [sl], -ip
    5d68:	466be27b 	undefined
    5d6c:	990a1ca2 	stmlsdb	sl, {r1, r5, r7, sl, fp, ip}
    5d70:	20871c49 	addcs	r1, r7, r9, asr #24
    5d74:	68364ec7 	ldmvsda	r6!, {r0, r1, r2, r6, r7, r9, sl, fp, lr}
    5d78:	6a766936 	bvs	0x1da0258
    5d7c:	f0116836 	andnvs	r6, r1, r6, lsr r8
    5d80:	1c07fa3b 	stcne	10, cr15, [r7], {59}
    5d84:	70200a00 	eorvc	r0, r0, r0, lsl #20
    5d88:	78207067 	stmvcda	r0!, {r0, r1, r2, r5, r6, ip, sp, lr}
    5d8c:	d10c2800 	tstle	ip, r0, lsl #16
    5d90:	75a09800 	strvc	r9, [r0, #2048]!
    5d94:	04009800 	streq	r9, [r0], #-2048
    5d98:	75e00e00 	strvcb	r0, [r0, #3584]!
    5d9c:	0c009800 	stceq	8, cr9, [r0], {0}
    5da0:	98007620 	stmlsda	r0, {r5, r9, sl, ip, sp, lr}
    5da4:	76600e00 	strvcbt	r0, [r0], -r0, lsl #28
    5da8:	2018e7dd 	ldrcssb	lr, [r8], -sp
    5dac:	1ca42100 	stfnes	f2, [r4]
    5db0:	54211e40 	strplt	r1, [r1], #-3648
    5db4:	e7d6d1fc 	undefined
    5db8:	70202000 	eorvc	r2, r0, r0
    5dbc:	7060207c 	rsbvc	r2, r0, ip, ror r0
    5dc0:	70a02001 	adcvc	r2, r0, r1
    5dc4:	70e02000 	rscvc	r2, r0, r0
    5dc8:	71202001 	teqvc	r0, r1
    5dcc:	e2482005 	sub	r2, r8, #5	; 0x5
    5dd0:	7d40980a 	stcvcl	8, cr9, [r0, #-40]
    5dd4:	990a9000 	stmlsdb	sl, {ip, pc}
    5dd8:	02097d89 	andeq	r7, r9, #8768	; 0x2240
    5ddc:	90001840 	andls	r1, r0, r0, asr #16
    5de0:	7dc9990a 	stcvcl	9, cr9, [r9, #40]
    5de4:	18400409 	stmneda	r0, {r0, r3, sl}^
    5de8:	990a9000 	stmlsdb	sl, {ip, pc}
    5dec:	06097e09 	streq	r7, [r9], -r9, lsl #28
    5df0:	90001840 	andls	r1, r0, r0, asr #16
    5df4:	2200466b 	andcs	r4, r0, #112197632	; 0x6b00000
    5df8:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    5dfc:	4fa52089 	swimi	0x00a52089
    5e00:	693f683f 	ldmvsdb	pc!, {r0, r1, r2, r3, r4, r5, fp, sp, lr}
    5e04:	683f6a7f 	ldmvsda	pc!, {r0, r1, r2, r3, r4, r5, r6, r9, fp, sp, lr}
    5e08:	f9f4f011 	ldmnvib	r4!, {r0, r4, ip, sp, lr, pc}^
    5e0c:	0a001c07 	beq	0xce30
    5e10:	70677020 	rsbvc	r7, r7, r0, lsr #32
    5e14:	e62c2002 	strt	r2, [ip], -r2
    5e18:	1ca2466b 	stcne	6, cr4, [r2], #428
    5e1c:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    5e20:	4e9c2090 	mrcmi	0, 4, r2, cr12, cr0, {4}
    5e24:	69366836 	ldmvsdb	r6!, {r1, r2, r4, r5, fp, sp, lr}
    5e28:	68366a76 	ldmvsda	r6!, {r1, r2, r4, r5, r6, r9, fp, sp, lr}
    5e2c:	f9e4f011 	stmnvib	r4!, {r0, r4, ip, sp, lr, pc}^
    5e30:	0a001c07 	beq	0xce54
    5e34:	20007020 	andcs	r7, r0, r0, lsr #32
    5e38:	78207060 	stmvcda	r0!, {r5, r6, ip, sp, lr}
    5e3c:	d0052800 	andle	r2, r5, r0, lsl #16
    5e40:	2100201e 	tstcs	r0, lr, lsl r0
    5e44:	1e401ca4 	cdpne	12, 4, cr1, cr0, cr4, {5}
    5e48:	d1fc5421 	mvnles	r5, r1, lsr #8
    5e4c:	e2082020 	and	r2, r8, #32	; 0x20
    5e50:	1ca2466b 	stcne	6, cr4, [r2], #428
    5e54:	2091990a 	addcss	r9, r1, sl, lsl #18
    5e58:	68364e8e 	ldmvsda	r6!, {r1, r2, r3, r7, r9, sl, fp, lr}
    5e5c:	6a766936 	bvs	0x1da033c
    5e60:	f0116836 	andnvs	r6, r1, r6, lsr r8
    5e64:	1c07f9c9 	stcne	9, cr15, [r7], {201}
    5e68:	70200a00 	eorvc	r0, r0, r0, lsl #20
    5e6c:	70602000 	rsbvc	r2, r0, r0
    5e70:	28007820 	stmcsda	r0, {r5, fp, ip, sp, lr}
    5e74:	201ed0ea 	andcss	sp, lr, sl, ror #1
    5e78:	1ca42100 	stfnes	f2, [r4]
    5e7c:	54211e40 	strplt	r1, [r1], #-3648
    5e80:	e7e3d1fc 	undefined
    5e84:	22002300 	andcs	r2, r0, #0	; 0x0
    5e88:	20922100 	addcss	r2, r2, r0, lsl #2
    5e8c:	68364e81 	ldmvsda	r6!, {r0, r7, r9, sl, fp, lr}
    5e90:	6a766936 	bvs	0x1da0370
    5e94:	f0116836 	andnvs	r6, r1, r6, lsr r8
    5e98:	1c07f9af 	stcne	9, cr15, [r7], {175}
    5e9c:	70200a00 	eorvc	r0, r0, r0, lsl #20
    5ea0:	70602000 	rsbvc	r2, r0, r0
    5ea4:	e1dc2002 	bics	r2, ip, r2
    5ea8:	7840980a 	stmvcda	r0, {r1, r3, fp, ip, pc}^
    5eac:	990a9001 	stmlsdb	sl, {r0, ip, pc}
    5eb0:	02097889 	andeq	r7, r9, #8978432	; 0x890000
    5eb4:	91014301 	tstls	r1, r1, lsl #6
    5eb8:	990a1c08 	stmlsdb	sl, {r3, sl, fp, ip}
    5ebc:	040978c9 	streq	r7, [r9], #-2249
    5ec0:	91014301 	tstls	r1, r1, lsl #6
    5ec4:	990a1c08 	stmlsdb	sl, {r3, sl, fp, ip}
    5ec8:	06097909 	streq	r7, [r9], -r9, lsl #18
    5ecc:	91014301 	tstls	r1, r1, lsl #6
    5ed0:	7840980a 	stmvcda	r0, {r1, r3, fp, ip, pc}^
    5ed4:	980a7060 	stmlsda	sl, {r5, r6, ip, sp, lr}
    5ed8:	70a07880 	adcvc	r7, r0, r0, lsl #17
    5edc:	78c0980a 	stmvcia	r0, {r1, r3, fp, ip, pc}^
    5ee0:	980a70e0 	stmlsda	sl, {r5, r6, r7, ip, sp, lr}
    5ee4:	71207900 	teqvc	r0, r0, lsl #18
    5ee8:	7940980a 	stmvcdb	r0, {r1, r3, fp, ip, pc}^
    5eec:	980a7160 	stmlsda	sl, {r5, r6, r8, ip, sp, lr}
    5ef0:	71a07980 	movvc	r7, r0, lsl #19
    5ef4:	7a00980a 	bvc	0x2bf24
    5ef8:	90000200 	andls	r0, r0, r0, lsl #4
    5efc:	79c9990a 	stmvcib	r9, {r1, r3, r8, fp, ip, pc}^
    5f00:	91004301 	tstls	r0, r1, lsl #6
    5f04:	1dc81c0e 	stcnel	12, cr1, [r8, #56]
    5f08:	466b7028 	strmibt	r7, [fp], -r8, lsr #32
    5f0c:	a9011d62 	stmgedb	r1, {r1, r5, r6, r8, sl, fp, ip}
    5f10:	4d602094 	stcmil	0, cr2, [r0, #-592]!
    5f14:	692d682d 	stmvsdb	sp!, {r0, r2, r3, r5, fp, sp, lr}
    5f18:	682d6a6d 	stmvsda	sp!, {r0, r2, r3, r5, r6, r9, fp, sp, lr}
    5f1c:	f96ef011 	stmnvdb	lr!, {r0, r4, ip, sp, lr, pc}^
    5f20:	0a001c07 	beq	0xcf44
    5f24:	98007020 	stmlsda	r0, {r5, ip, sp, lr}
    5f28:	98007160 	stmlsda	r0, {r5, r6, r8, ip, sp, lr}
    5f2c:	0e000400 	cfcpyseq	mvf0, mvf0
    5f30:	980071a0 	stmlsda	r0, {r5, r7, r8, ip, sp, lr}
    5f34:	0c360436 	cfldrseq	mvf0, [r6], #-216
    5f38:	d30042b0 	tstle	r0, #11	; 0xb
    5f3c:	9800e192 	stmlsda	r0, {r1, r4, r7, r8, sp, lr, pc}
    5f40:	04001a30 	streq	r1, [r0], #-2608
    5f44:	21000c00 	tstcs	r0, r0, lsl #24
    5f48:	18a29a00 	stmneia	r2!, {r9, fp, ip, pc}
    5f4c:	e6b01dd2 	ssat	r1, #17, r2, ASR #27
    5f50:	7840980a 	stmvcda	r0, {r1, r3, fp, ip, pc}^
    5f54:	980a7060 	stmlsda	sl, {r5, r6, ip, sp, lr}
    5f58:	70a07880 	adcvc	r7, r0, r0, lsl #17
    5f5c:	78c0980a 	stmvcia	r0, {r1, r3, fp, ip, pc}^
    5f60:	980a70e0 	stmlsda	sl, {r5, r6, r7, ip, sp, lr}
    5f64:	71207900 	teqvc	r0, r0, lsl #18
    5f68:	7840980a 	stmvcda	r0, {r1, r3, fp, ip, pc}^
    5f6c:	990a9001 	stmlsdb	sl, {r0, ip, pc}
    5f70:	02097889 	andeq	r7, r9, #8978432	; 0x890000
    5f74:	91014301 	tstls	r1, r1, lsl #6
    5f78:	990a1c08 	stmlsdb	sl, {r3, sl, fp, ip}
    5f7c:	040978c9 	streq	r7, [r9], #-2249
    5f80:	91014301 	tstls	r1, r1, lsl #6
    5f84:	990a1c08 	stmlsdb	sl, {r3, sl, fp, ip}
    5f88:	06097909 	streq	r7, [r9], -r9, lsl #18
    5f8c:	91014301 	tstls	r1, r1, lsl #6
    5f90:	7a00980a 	bvc	0x2bfc0
    5f94:	90000200 	andls	r0, r0, r0, lsl #4
    5f98:	79c9990a 	stmvcib	r9, {r1, r3, r8, fp, ip, pc}^
    5f9c:	91004301 	tstls	r0, r1, lsl #6
    5fa0:	990a980a 	stmlsdb	sl, {r1, r3, fp, ip, pc}
    5fa4:	72017989 	andvc	r7, r1, #2244608	; 0x224000
    5fa8:	990a980a 	stmlsdb	sl, {r1, r3, fp, ip, pc}
    5fac:	71c17949 	bicvc	r7, r1, r9, asr #18
    5fb0:	9a0a466b 	bls	0x297964
    5fb4:	a9011dd2 	stmgedb	r1, {r1, r4, r6, r7, r8, sl, fp, ip}
    5fb8:	4e362095 	mrcmi	0, 1, r2, cr6, cr5, {4}
    5fbc:	69366836 	ldmvsdb	r6!, {r1, r2, r4, r5, fp, sp, lr}
    5fc0:	68366a76 	ldmvsda	r6!, {r1, r2, r4, r5, r6, r9, fp, sp, lr}
    5fc4:	f918f011 	ldmnvdb	r8, {r0, r4, ip, sp, lr, pc}
    5fc8:	0a001c07 	beq	0xcfec
    5fcc:	98007020 	stmlsda	r0, {r5, ip, sp, lr}
    5fd0:	98007160 	stmlsda	r0, {r5, r6, r8, ip, sp, lr}
    5fd4:	0e000400 	cfcpyseq	mvf0, mvf0
    5fd8:	200771a0 	andcs	r7, r7, r0, lsr #3
    5fdc:	208ae141 	addcs	lr, sl, r1, asr #2
    5fe0:	20047020 	andcs	r7, r4, r0, lsr #32
    5fe4:	1c622100 	stfnee	f2, [r2]
    5fe8:	54111e40 	ldrpl	r1, [r1], #-3648
    5fec:	2005d1fc 	strcsd	sp, [r5], -ip
    5ff0:	07f67028 	ldreqb	r7, [r6, r8, lsr #32]!
    5ff4:	2000d530 	andcs	sp, r0, r0, lsr r5
    5ff8:	5c09499d 	stcpl	9, cr4, [r9], {157}
    5ffc:	18129a0a 	ldmneda	r2, {r1, r3, r9, fp, ip, pc}
    6000:	42917852 	addmis	r7, r1, #5373952	; 0x520000
    6004:	1c40d128 	stfnep	f5, [r0], {40}
    6008:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    600c:	d3f32812 	mvnles	r2, #1179648	; 0x120000
    6010:	4820d122 	stmmida	r0!, {r1, r5, r8, ip, lr, pc}
    6014:	68c16800 	stmvsia	r1, {fp, sp, lr}^
    6018:	22756a49 	rsbcss	r6, r5, #299008	; 0x49000
    601c:	33751c0b 	cmncc	r5, #2816	; 0xb00
    6020:	25fe781b 	ldrcsb	r7, [lr, #2075]!
    6024:	548d401d 	strpl	r4, [sp], #29
    6028:	6a4968c1 	bvs	0x1260334
    602c:	68c23175 	stmvsia	r2, {r0, r2, r4, r5, r6, r8, ip, sp}^
    6030:	32756a52 	rsbccs	r6, r5, #335872	; 0x52000
    6034:	23027812 	tstcs	r2, #1179648	; 0x120000
    6038:	700b4313 	andvc	r4, fp, r3, lsl r3
    603c:	6a406a00 	bvs	0x1020844
    6040:	8001498c 	andhi	r4, r1, ip, lsl #19
    6044:	70202000 	eorvc	r2, r0, r0
    6048:	70602059 	rsbvc	r2, r0, r9, asr r0
    604c:	70a02065 	adcvc	r2, r0, r5, rrx
    6050:	70e02073 	rscvc	r2, r0, r3, ror r0
    6054:	71202000 	teqvc	r0, r0
    6058:	2001e104 	andcs	lr, r1, r4, lsl #2
    605c:	a9037028 	stmgedb	r3, {r3, r5, ip, sp, lr}
    6060:	1c40980a 	mcrrne	8, 0, r9, r0, cr10
    6064:	2300b403 	tstcs	r0, #50331648	; 0x3000000
    6068:	21002200 	tstcs	r0, r0, lsl #4
    606c:	f001200e 	andnv	r2, r1, lr
    6070:	b002ffa9 	andlt	pc, r2, r9, lsr #31
    6074:	d1092800 	tstle	r9, r0, lsl #16
    6078:	70202000 	eorvc	r2, r0, r0
    607c:	1c49990a 	mcrrne	9, 0, r9, r9, cr10
    6080:	4aad4882 	bmi	0xfeb58290
    6084:	f0011810 	andnv	r1, r1, r0, lsl r8
    6088:	e0ebfd6b 	rsc	pc, fp, fp, ror #26
    608c:	70202094 	mlavc	r0, r4, r0, r2
    6090:	46c0e0e8 	strmib	lr, [r0], r8, ror #1
    6094:	00009624 	andeq	r9, r0, r4, lsr #12
    6098:	1c612000 	stcnel	0, cr2, [r1]
    609c:	00d2228f 	sbceqs	r2, r2, pc, lsl #5
    60a0:	181b4ba5 	ldmneda	fp, {r0, r2, r5, r7, r8, r9, fp, lr}
    60a4:	540a5c9a 	strpl	r5, [sl], #-3226
    60a8:	06001c40 	streq	r1, [r0], -r0, asr #24
    60ac:	28070e00 	stmcsda	r7, {r9, sl, fp}
    60b0:	2000d3f3 	strcsd	sp, [r0], -r3
    60b4:	20087020 	andcs	r7, r8, r0, lsr #32
    60b8:	2000e0d3 	ldrcsd	lr, [r0], -r3
    60bc:	49737020 	ldmmidb	r3!, {r5, ip, sp, lr}^
    60c0:	18514a9d 	ldmneda	r1, {r0, r2, r3, r4, r7, r9, fp, lr}^
    60c4:	200f1c62 	andcs	r1, pc, r2, ror #24
    60c8:	5c0b1e40 	stcpl	14, cr1, [fp], {64}
    60cc:	d1fb5413 	mvnles	r5, r3, lsl r4
    60d0:	00c0208f 	sbceq	r2, r0, pc, lsl #1
    60d4:	18094998 	stmneda	r9, {r3, r4, r7, r8, fp, lr}
    60d8:	30101c20 	andccs	r1, r0, r0, lsr #24
    60dc:	fd2cf001 	stc2	0, cr15, [ip, #-4]!
    60e0:	49954865 	ldmmiib	r5, {r0, r2, r5, r6, fp, lr}
    60e4:	75e05c08 	strvcb	r5, [r0, #3080]!
    60e8:	5c084864 	stcpl	8, cr4, [r8], {100}
    60ec:	48647620 	stmmida	r4!, {r5, r9, sl, ip, sp, lr}^
    60f0:	76605c08 	strvcbt	r5, [r0], -r8, lsl #24
    60f4:	5c084863 	stcpl	8, cr4, [r8], {99}
    60f8:	496576a0 	stmmidb	r5!, {r5, r7, r9, sl, ip, sp, lr}^
    60fc:	69096809 	stmvsdb	r9, {r0, r3, fp, sp, lr}
    6100:	1d096a49 	fstsne	s12, [r9, #-292]
    6104:	2004341b 	andcs	r3, r4, fp, lsl r4
    6108:	5c0a1e40 	stcpl	14, cr1, [sl], {64}
    610c:	d1fb5422 	mvnles	r5, r2, lsr #8
    6110:	e0a6201f 	adc	r2, r6, pc, lsl r0
    6114:	22002300 	andcs	r2, r0, #0	; 0x0
    6118:	20a02100 	adccs	r2, r0, r0, lsl #2
    611c:	68364e5c 	ldmvsda	r6!, {r2, r3, r4, r6, r9, sl, fp, lr}
    6120:	6a766936 	bvs	0x1da0600
    6124:	f0116836 	andnvs	r6, r1, r6, lsr r8
    6128:	1c07f867 	stcne	8, cr15, [r7], {103}
    612c:	e0962000 	adds	r2, r6, r0
    6130:	70212100 	eorvc	r2, r1, r0, lsl #2
    6134:	7849990a 	stmvcda	r9, {r1, r3, r8, fp, ip, pc}^
    6138:	990a7061 	stmlsdb	sl, {r0, r5, r6, ip, sp, lr}
    613c:	29007849 	stmcsdb	r0, {r0, r3, r6, fp, ip, sp, lr}
    6140:	9802d107 	stmlsda	r2, {r0, r1, r2, r8, ip, lr, pc}
    6144:	99027800 	stmlsdb	r2, {fp, ip, sp, lr}
    6148:	1a407849 	bne	0x1024274
    614c:	0e800680 	cdpeq	6, 8, cr0, cr0, cr0, {4}
    6150:	7801e004 	stmvcda	r1, {r2, sp, lr, pc}
    6154:	1a087840 	bne	0x22425c
    6158:	0e400640 	cdpeq	6, 4, cr0, cr0, cr0, {2}
    615c:	200370a0 	andcs	r7, r3, r0, lsr #1
    6160:	2100e07f 	tstcs	r0, pc, ror r0
    6164:	990a7021 	stmlsdb	sl, {r0, r5, ip, sp, lr}
    6168:	70617849 	rsbvc	r7, r1, r9, asr #16
    616c:	7889990a 	stmvcia	r9, {r1, r3, r8, fp, ip, pc}
    6170:	07f67029 	ldreqb	r7, [r6, r9, lsr #32]!
    6174:	223bd501 	eorcss	sp, fp, #4194304	; 0x400000
    6178:	2279e000 	rsbcss	lr, r9, #0	; 0x0
    617c:	785b9b0a 	ldmvcda	fp, {r1, r3, r8, r9, fp, ip, pc}^
    6180:	d1382b00 	teqle	r8, r0, lsl #22
    6184:	d32d428a 	teqle	sp, #-1610612728	; 0xa0000008
    6188:	e0122100 	ands	r2, r2, r0, lsl #2
    618c:	483e1862 	ldmmida	lr!, {r1, r5, r6, fp, ip}
    6190:	18f34e69 	ldmneia	r3!, {r0, r3, r5, r6, r9, sl, fp, lr}^
    6194:	70d05c18 	sbcvcs	r5, r0, r8, lsl ip
    6198:	78429802 	stmvcda	r2, {r1, fp, ip, pc}^
    619c:	9b021c50 	blls	0x8d2e4
    61a0:	11461c52 	cmpne	r6, r2, asr ip
    61a4:	18300eb6 	ldmneda	r0!, {r1, r2, r4, r5, r7, r9, sl, fp}
    61a8:	400626c0 	andmi	r2, r6, r0, asr #13
    61ac:	70581b90 	ldrvcb	r1, [r8], #-176
    61b0:	78281c49 	stmvcda	r8!, {r0, r3, r6, sl, fp, ip}
    61b4:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    61b8:	d2054281 	andle	r4, r5, #268435464	; 0x10000008
    61bc:	78439802 	stmvcda	r3, {r1, fp, ip, pc}^
    61c0:	78009802 	stmvcda	r0, {r1, fp, ip, pc}
    61c4:	d1e14298 	strleb	r4, [r1, #40]!
    61c8:	782870a1 	stmvcda	r8!, {r0, r5, r7, ip, sp, lr}
    61cc:	22001a40 	andcs	r1, r0, #262144	; 0x40000
    61d0:	1cc91861 	stcnel	8, cr1, [r9], {97}
    61d4:	d0022800 	andle	r2, r2, r0, lsl #16
    61d8:	540a1e40 	strpl	r1, [sl], #-3648
    61dc:	7828d1fc 	stmvcda	r8!, {r2, r3, r4, r5, r6, r7, r8, ip, lr, pc}
    61e0:	e03e1cc0 	eors	r1, lr, r0, asr #25
    61e4:	7020208a 	eorvc	r2, r0, sl, lsl #1
    61e8:	7840980a 	stmvcda	r0, {r1, r3, fp, ip, pc}^
    61ec:	20007060 	andcs	r7, r0, r0, rrx
    61f0:	702870a0 	eorvc	r7, r8, r0, lsr #1
    61f4:	428ae7f3 	addmi	lr, sl, #63700992	; 0x3cc0000
    61f8:	2100d3f4 	strcsd	sp, [r0, -r4]
    61fc:	0609782a 	streq	r7, [r9], -sl, lsr #16
    6200:	42910e09 	addmis	r0, r1, #144	; 0x90
    6204:	7843d2e0 	stmvcda	r3, {r5, r6, r7, r9, ip, lr, pc}^
    6208:	429a7802 	addmis	r7, sl, #131072	; 0x20000
    620c:	1866d0dc 	stmneda	r6!, {r2, r3, r4, r6, r7, ip, lr, pc}^
    6210:	46944a20 	ldrmi	r4, [r4], r0, lsr #20
    6214:	18d24a48 	ldmneia	r2, {r3, r6, r9, fp, lr}^
    6218:	5cd24663 	ldcpll	6, cr4, [r2], {99}
    621c:	784370f2 	stmvcda	r3, {r1, r4, r5, r6, r7, ip, sp, lr}^
    6220:	1c5b1c5a 	mrrcne	12, 5, r1, fp, cr10
    6224:	0eb61156 	mrceq	1, 5, r1, cr6, cr6, {2}
    6228:	26c018b2 	undefined
    622c:	1b9a4016 	blne	0xfe69628c
    6230:	1c497042 	mcrrne	0, 4, r7, r9, cr2
    6234:	07f6e7e2 	ldreqb	lr, [r6, r2, ror #15]!
    6238:	a903d510 	stmgedb	r3, {r4, r8, sl, ip, lr, pc}
    623c:	20001c89 	andcs	r1, r0, r9, lsl #25
    6240:	2300b403 	tstcs	r0, #50331648	; 0x3000000
    6244:	21002200 	tstcs	r0, r0, lsl #4
    6248:	f001200b 	andnv	r2, r1, fp
    624c:	b002febb 	strlth	pc, [r2], -fp
    6250:	d1012800 	tstle	r1, r0, lsl #16
    6254:	e0022000 	and	r2, r2, r0
    6258:	e000208a 	and	r2, r0, sl, lsl #1
    625c:	7020208a 	eorvc	r2, r0, sl, lsl #1
    6260:	70282001 	eorvc	r2, r8, r1
    6264:	0c000438 	cfstrseq	mvf0, [r0], {56}
    6268:	f001b00b 	andnv	fp, r1, fp
    626c:	46c0ff69 	strmib	pc, [r0], r9, ror #30
    6270:	00118d8c 	andeqs	r8, r1, ip, lsl #27
    6274:	0000a55a 	andeq	sl, r0, sl, asr r5
    6278:	000003d7 	ldreqd	r0, [r0], -r7
    627c:	00000406 	andeq	r0, r0, r6, lsl #8
    6280:	00000435 	andeq	r0, r0, r5, lsr r4
    6284:	00000464 	andeq	r0, r0, r4, ror #8
    6288:	0000071d 	andeq	r0, r0, sp, lsl r7
    628c:	00000466 	andeq	r0, r0, r6, ror #8
    6290:	00009624 	andeq	r9, r0, r4, lsr #12
    6294:	0000058d 	andeq	r0, r0, sp, lsl #11
    6298:	a900b5f1 	stmgedb	r0, {r0, r4, r5, r6, r7, r8, sl, ip, sp, pc}
    629c:	46681c89 	strmibt	r1, [r8], -r9, lsl #25
    62a0:	fbb4f00a 	blx	0xfed422d2
    62a4:	28011c04 	stmcsda	r1, {r2, sl, fp, ip}
    62a8:	4668d13b 	undefined
    62ac:	28008800 	stmcsda	r0, {fp, pc}
    62b0:	4668d037 	undefined
    62b4:	491f8800 	ldmmidb	pc, {fp, pc}
    62b8:	18514a1f 	ldmneda	r1, {r0, r1, r2, r3, r4, r9, fp, lr}^
    62bc:	4b1e4a21 	blmi	0x798b48
    62c0:	2800189a 	stmcsda	r0, {r1, r3, r4, r7, fp, ip}
    62c4:	1e40d003 	cdpne	0, 4, cr13, cr0, cr3, {0}
    62c8:	54135c0b 	ldrpl	r5, [r3], #-3083
    62cc:	481ad1fb 	ldmmida	sl, {r0, r1, r3, r4, r5, r6, r7, r8, ip, lr, pc}
    62d0:	5c41491a 	mcrrpl	9, 1, r4, r1, cr10
    62d4:	18854a1a 	stmneia	r5, {r1, r3, r4, r9, fp, lr}
    62d8:	d1022901 	tstle	r2, r1, lsl #18
    62dc:	f834f000 	ldmnvda	r4!, {ip, sp, lr, pc}
    62e0:	2902e01d 	stmcsdb	r2, {r0, r2, r3, r4, sp, lr, pc}
    62e4:	4669d11d 	undefined
    62e8:	70298809 	eorvc	r8, r9, r9, lsl #16
    62ec:	1845490f 	stmneda	r5, {r0, r1, r2, r3, r8, fp, lr}^
    62f0:	88094669 	stmhida	r9, {r0, r3, r5, r6, r9, sl, lr}
    62f4:	490e7029 	stmmidb	lr, {r0, r3, r5, ip, sp, lr}
    62f8:	46691846 	strmibt	r1, [r9], -r6, asr #16
    62fc:	b4028849 	strlt	r8, [r2], #-2121
    6300:	1c2a2302 	stcne	3, cr2, [sl], #-8
    6304:	4f0f1c31 	swimi	0x000f1c31
    6308:	f7ff19c0 	ldrnvb	r1, [pc, r0, asr #19]!
    630c:	7829faa3 	stmvcda	r9!, {r0, r1, r5, r7, r9, fp, ip, sp, lr, pc}
    6310:	2900b001 	stmcsdb	r0, {r0, ip, sp, pc}
    6314:	1c0ad005 	stcne	0, cr13, [sl], {5}
    6318:	f00a1c30 	andnv	r1, sl, r0, lsr ip
    631c:	2000fb07 	andcs	pc, r0, r7, lsl #22
    6320:	1c207028 	stcne	0, cr7, [r0], #-160
    6324:	bc02bcf8 	stclt	12, cr11, [r2], {248}
    6328:	46c04708 	strmib	r4, [r0], r8, lsl #14
    632c:	00000589 	andeq	r0, r0, r9, lsl #11
    6330:	00000509 	andeq	r0, r0, r9, lsl #10
    6334:	0000076e 	andeq	r0, r0, lr, ror #14
    6338:	00008a54 	andeq	r8, r0, r4, asr sl
    633c:	00000763 	andeq	r0, r0, r3, ror #14
    6340:	00000505 	andeq	r0, r0, r5, lsl #10
    6344:	00000485 	andeq	r0, r0, r5, lsl #9
    6348:	f000b5f1 	strnvd	fp, [r0], -r1
    634c:	2800f97d 	stmcsda	r0, {r0, r2, r3, r4, r5, r6, r8, fp, ip, sp, lr, pc}
    6350:	486ed023 	stmmida	lr!, {r0, r1, r5, ip, lr, pc}^
    6354:	180849b8 	stmneda	r8, {r3, r4, r5, r7, r8, fp, lr}
    6358:	4a6d7a01 	bmi	0x1b64b64
    635c:	189a4bb6 	ldmneia	sl, {r1, r2, r4, r5, r7, r8, r9, fp, lr}
    6360:	78139200 	ldmvcda	r3, {r9, ip, pc}
    6364:	4c6c7802 	stcmil	8, cr7, [ip], #-8
    6368:	192d4db3 	stmnedb	sp!, {r0, r1, r4, r5, r7, r8, sl, fp, lr}
    636c:	68244c6f 	stmvsda	r4!, {r0, r1, r2, r3, r5, r6, sl, fp, lr}
    6370:	2e1579c6 	cdpcs	9, 1, cr7, cr5, cr6, {6}
    6374:	2e16d012 	mrccs	0, 0, sp, cr6, cr2, {0}
    6378:	2e17d02b 	cdpcs	0, 1, cr13, cr7, cr11, {1}
    637c:	2e1ad02e 	cdpcs	0, 1, cr13, cr10, cr14, {1}
    6380:	2e1bd03d 	mrccs	0, 0, sp, cr11, cr13, {1}
    6384:	e091d100 	adds	sp, r1, r0, lsl #2
    6388:	d1002e1e 	tstle	r0, lr, lsl lr
    638c:	2e1fe095 	mrccs	0, 0, lr, cr15, cr5, {4}
    6390:	e09bd100 	adds	sp, fp, r0, lsl #2
    6394:	d1002e20 	tstle	r0, r0, lsr #28
    6398:	e0b5e09e 	umlals	lr, r5, lr, r0
    639c:	d1fc2b11 	mvnles	r2, r1, lsl fp
    63a0:	49a5485c 	stmmiib	r5!, {r2, r3, r4, r6, fp, lr}
    63a4:	38b91809 	ldmccia	r9!, {r0, r3, fp, ip}
    63a8:	18104aa3 	ldmneda	r0, {r0, r1, r5, r7, r9, fp, lr}
    63ac:	fbc4f001 	blx	0xff1423ba
    63b0:	6800485e 	stmvsda	r0, {r1, r2, r3, r4, r6, fp, lr}
    63b4:	6a496a81 	bvs	0x1260dc0
    63b8:	6a406a80 	bvs	0x1020dc0
    63bc:	22c07fc0 	sbccs	r7, r0, #768	; 0x300
    63c0:	77ca4302 	strvcb	r4, [sl, r2, lsl #6]
    63c4:	21009800 	tstcs	r0, r0, lsl #16
    63c8:	98006141 	stmlsda	r0, {r0, r6, r8, sp, lr}
    63cc:	70012106 	andvc	r2, r1, r6, lsl #2
    63d0:	2b11e09a 	blcs	0x47e640
    63d4:	9800d1fc 	stmlsda	r0, {r2, r3, r4, r5, r6, r7, r8, ip, lr, pc}
    63d8:	e7f82105 	ldrb	r2, [r8, r5, lsl #2]!
    63dc:	d0f72950 	rscles	r2, r7, r0, asr r9
    63e0:	d0f52953 	rscles	r2, r5, r3, asr r9
    63e4:	6a406aa0 	bvs	0x1020e6c
    63e8:	70013025 	andvc	r3, r1, r5, lsr #32
    63ec:	6a406aa0 	bvs	0x1020e74
    63f0:	6a496aa1 	bvs	0x1260e7c
    63f4:	22087fc9 	andcs	r7, r8, #804	; 0x324
    63f8:	77c2430a 	strvcb	r4, [r2, sl, lsl #6]
    63fc:	2100e084 	smlabbcs	r0, r4, r0, lr
    6400:	4a454f8d 	bmi	0x115a23c
    6404:	434b232f 	cmpmi	fp, #-1140850688	; 0xbc000000
    6408:	18e34c8b 	stmneia	r3!, {r0, r1, r3, r7, sl, fp, lr}^
    640c:	7813189a 	ldmvcda	r3, {r1, r3, r4, r7, fp, ip}
    6410:	42a37a44 	adcmi	r7, r3, #278528	; 0x44000
    6414:	7803d130 	stmvcda	r3, {r4, r5, r8, ip, lr, pc}
    6418:	408c2410 	addmi	r2, ip, r0, lsl r4
    641c:	401d43e5 	andmis	r4, sp, r5, ror #7
    6420:	24077005 	strcs	r7, [r7], #-5
    6424:	4b3d2500 	blmi	0xf4f82c
    6428:	434e262f 	cmpmi	lr, #49283072	; 0x2f00000
    642c:	18f319be 	ldmneia	r3!, {r1, r2, r3, r4, r5, r7, r8, fp, ip}^
    6430:	551d1e64 	ldrpl	r1, [sp, #-3684]
    6434:	2410d1fc 	ldrcs	sp, [r0], #-508
    6438:	262f4b39 	undefined
    643c:	19be434e 	ldmneib	lr!, {r1, r2, r3, r6, r8, r9, lr}
    6440:	1e6418f3 	mcrne	8, 3, r1, cr4, cr3, {7}
    6444:	d1fc551d 	mvnles	r5, sp, lsl r5
    6448:	4b362404 	blmi	0xd8f460
    644c:	434e262f 	cmpmi	lr, #49283072	; 0x2f00000
    6450:	18f319be 	ldmneia	r3!, {r1, r2, r3, r4, r5, r7, r8, fp, ip}^
    6454:	551d1e64 	ldrpl	r1, [sp, #-3684]
    6458:	2410d1fc 	ldrcs	sp, [r0], #-508
    645c:	262f4b32 	undefined
    6460:	4e754371 	mrcmi	3, 3, r4, cr5, cr1, {3}
    6464:	18c91871 	stmneia	r9, {r0, r4, r5, r6, fp, ip}^
    6468:	550d1e64 	strpl	r1, [sp, #-3684]
    646c:	21ffd1fc 	ldrcssh	sp, [pc, #28]	; 0x6490
    6470:	70557011 	subvcs	r7, r5, r1, lsl r0
    6474:	21047095 	swpcs	r7, r5, [r4]
    6478:	06091c49 	streq	r1, [r9], -r9, asr #24
    647c:	29040e09 	stmcsdb	r4, {r0, r3, r9, sl, fp}
    6480:	492ad3bf 	stmmidb	sl!, {r0, r1, r2, r3, r4, r5, r7, r8, r9, ip, lr, pc}
    6484:	78006809 	stmvcda	r0, {r0, r3, fp, sp, lr}
    6488:	421022f0 	andmis	r2, r0, #15	; 0xf
    648c:	6a88d105 	bvs	0xfe23a8a8
    6490:	7fc26a40 	swivc	0x00c26a40
    6494:	401323fd 	ldrmish	r2, [r3], -sp
    6498:	6a8877c3 	bvs	0xfe2243ac
    649c:	6a896a40 	bvs	0xfe260da4
    64a0:	7e896a49 	cdpvc	10, 8, cr6, cr9, cr9, {2}
    64a4:	430a2208 	tstmi	sl, #-2147483648	; 0x80000000
    64a8:	e02d7682 	eor	r7, sp, r2, lsl #13
    64ac:	d1062901 	tstle	r6, r1, lsl #18
    64b0:	70297a41 	eorvc	r7, r9, r1, asr #20
    64b4:	43112102 	tstmi	r1, #-2147483648	; 0x80000000
    64b8:	2901e789 	stmcsdb	r1, {r0, r3, r7, r8, r9, sl, sp, lr, pc}
    64bc:	21ffd124 	mvncss	sp, r4, lsr #2
    64c0:	78017029 	stmvcda	r1, {r0, r3, r5, ip, sp, lr}
    64c4:	400a22fd 	strmid	r2, [sl], -sp
    64c8:	e01d7002 	ands	r7, sp, r2
    64cc:	6a406aa0 	bvs	0x1020f54
    64d0:	06497fc1 	streqb	r7, [r9], -r1, asr #31
    64d4:	e0160e49 	ands	r0, r6, r9, asr #28
    64d8:	4b574915 	blmi	0x15d8934
    64dc:	29015c59 	stmcsdb	r1, {r0, r3, r4, r6, sl, fp, ip, lr}
    64e0:	2101d109 	tstcs	r1, r9, lsl #2
    64e4:	7002430a 	andvc	r4, r2, sl, lsl #6
    64e8:	6a406aa0 	bvs	0x1020f70
    64ec:	6a526aa2 	bvs	0x14a0f7c
    64f0:	43117fd2 	tstmi	r1, #840	; 0x348
    64f4:	21fee007 	mvncss	lr, r7
    64f8:	400a7802 	andmi	r7, sl, r2, lsl #16
    64fc:	6aa07002 	bvs	0xfe82250c
    6500:	7fc26a40 	swivc	0x00c26a40
    6504:	77c14011 	undefined
    6508:	fc42f001 	mcrr2	0, 0, pc, r2, cr1
    650c:	0000047f 	andeq	r0, r0, pc, ror r4
    6510:	00000bb4 	streqh	r0, [r0], -r4
    6514:	00000487 	andeq	r0, r0, r7, lsl #9
    6518:	000003d5 	ldreqd	r0, [r0], -r5
    651c:	000003ce 	andeq	r0, r0, lr, asr #7
    6520:	000003aa 	andeq	r0, r0, sl, lsr #7
    6524:	000003ba 	streqh	r0, [r0], -sl
    6528:	000003be 	streqh	r0, [r0], -lr
    652c:	00009624 	andeq	r9, r0, r4, lsr #12
    6530:	00000976 	andeq	r0, r0, r6, ror r9
    6534:	2300b570 	tstcs	r0, #469762048	; 0x1c000000
    6538:	e0012400 	and	r2, r1, r0, lsl #8
    653c:	1c645585 	cfstr64ne	mvdx5, [r4], #-532
    6540:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    6544:	d2094294 	andle	r4, r9, #1073741833	; 0x40000009
    6548:	5d0d1c26 	stcpl	12, cr1, [sp, #-152]
    654c:	dbf52d61 	blle	0xffd51ad8
    6550:	daf32d7b 	ble	0xffcd1b44
    6554:	e7f13d20 	ldrb	r3, [r1, r0, lsr #26]!
    6558:	1c525483 	cfldrdne	mvd5, [r2], {131}
    655c:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    6560:	d3f92a14 	mvnles	r2, #81920	; 0x14000
    6564:	bc01bc70 	stclt	12, cr11, [r1], {112}
    6568:	00004700 	andeq	r4, r0, r0, lsl #14
    656c:	780b2214 	stmvcda	fp, {r2, r4, r9, sp}
    6570:	d0012b00 	andle	r2, r1, r0, lsl #22
    6574:	e0001c49 	and	r1, r0, r9, asr #24
    6578:	70032300 	andvc	r2, r3, r0, lsl #6
    657c:	1e521c40 	cdpne	12, 5, cr1, cr2, cr0, {2}
    6580:	b000d1f5 	strltd	sp, [r0], -r5
    6584:	00004770 	andeq	r4, r0, r0, ror r7
    6588:	4a2bb5f0 	bmi	0xaf3d50
    658c:	18114811 	ldmneda	r1, {r0, r4, fp, lr}
    6590:	80482000 	subhi	r2, r8, r0
    6594:	48108008 	ldmmida	r0, {r3, pc}
    6598:	e00a1813 	and	r1, sl, r3, lsl r8
    659c:	1956785c 	ldmnedb	r6, {r2, r3, r4, r6, fp, ip, sp, lr}^
    65a0:	19174d0e 	ldmnedb	r7, {r1, r2, r3, r8, sl, fp, lr}
    65a4:	54355d7d 	ldrplt	r5, [r5], #-3453
    65a8:	705c1c64 	subvcs	r1, ip, r4, ror #24
    65ac:	1c408808 	mcrrne	8, 0, r8, r0, cr8
    65b0:	880d8008 	stmhida	sp, {r3, pc}
    65b4:	781c480a 	ldmvcda	ip, {r1, r3, fp, lr}
    65b8:	d3ef42a5 	mvnle	r4, #1342177290	; 0x5000000a
    65bc:	1a698849 	bne	0x1a686e8
    65c0:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    65c4:	f00a1810 	andnv	r1, sl, r0, lsl r8
    65c8:	46c0fe1f 	undefined
    65cc:	bc01bcf0 	stclt	12, cr11, [r1], {240}
    65d0:	46c04700 	strmib	r4, [r0], r0, lsl #14
    65d4:	00000b7e 	andeq	r0, r0, lr, ror fp
    65d8:	00000691 	muleq	r0, r1, r6
    65dc:	00000611 	andeq	r0, r0, r1, lsl r6
    65e0:	00000a7e 	andeq	r0, r0, lr, ror sl
    65e4:	4668b571 	undefined
    65e8:	fef4f00a 	cdp2	0, 15, cr15, cr4, cr10, {0}
    65ec:	88004668 	stmhida	r0, {r3, r5, r6, r9, sl, lr}
    65f0:	d01d2800 	andles	r2, sp, r0, lsl #16
    65f4:	49102000 	ldmmidb	r0, {sp}
    65f8:	188a4a10 	stmneia	sl, {r4, r9, fp, lr}
    65fc:	180c4b10 	stmneda	ip, {r4, r8, r9, fp, lr}
    6600:	781418e3 	ldmvcda	r4, {r0, r1, r5, r6, r7, fp, ip}
    6604:	194d4d0f 	stmnedb	sp, {r0, r1, r2, r3, r8, sl, fp, lr}^
    6608:	552e781e 	strpl	r7, [lr, #-2078]!
    660c:	1c647814 	stcnel	8, cr7, [r4], #-80
    6610:	06247014 	undefined
    6614:	2c800e24 	stccs	14, cr0, [r0], {36}
    6618:	2400d301 	strcs	sp, [r0], #-769
    661c:	24007014 	strcs	r7, [r0], #-20
    6620:	1c40701c 	mcrrne	0, 1, r7, r0, cr12
    6624:	881b466b 	ldmhida	fp, {r0, r1, r3, r5, r6, r9, sl, lr}
    6628:	0c000400 	cfstrseq	mvf0, [r0], {0}
    662c:	d3e54298 	mvnle	r4, #-2147483639	; 0x80000009
    6630:	bc01bc78 	stclt	12, cr11, [r1], {120}
    6634:	00004700 	andeq	r4, r0, r0, lsl #14
    6638:	00008a54 	andeq	r8, r0, r4, asr sl
    663c:	0000060d 	andeq	r0, r0, sp, lsl #12
    6640:	0000097a 	andeq	r0, r0, sl, ror r9
    6644:	0000058d 	andeq	r0, r0, sp, lsl #11
    6648:	2200b570 	andcs	fp, r0, #469762048	; 0x1c000000
    664c:	4b132400 	blmi	0x4cf654
    6650:	5cc14819 	stcpll	8, cr4, [r1], {25}
    6654:	e0031e4e 	and	r1, r3, lr, asr #28
    6658:	5ced1945 	stcpll	9, cr1, [sp], #276
    665c:	1c641952 	stcnel	9, cr1, [r4], #-328
    6660:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    6664:	42b41c25 	adcmis	r1, r4, #9472	; 0x2500
    6668:	0412dbf6 	ldreq	sp, [r2], #-3062
    666c:	42530c12 	submis	r0, r3, #4608	; 0x1200
    6670:	18404a09 	stmneda	r0, {r0, r3, r9, fp, lr}^
    6674:	041b1880 	ldreq	r1, [fp], #-2176
    6678:	0a190c1b 	beq	0x6496ec
    667c:	42917802 	addmis	r7, r1, #131072	; 0x20000
    6680:	7840d106 	stmvcda	r0, {r1, r2, r8, ip, lr, pc}^
    6684:	0e1b061b 	cfmsub32eq	mvax0, mvfx0, mvfx11, mvfx11
    6688:	d1014283 	smlabble	r1, r3, r2, r4
    668c:	e0002001 	and	r2, r0, r1
    6690:	bc702000 	ldcltl	0, cr2, [r0]
    6694:	4708bc02 	strmi	fp, [r8, -r2, lsl #24]
    6698:	00000484 	andeq	r0, r0, r4, lsl #9
    669c:	00000485 	andeq	r0, r0, r5, lsl #9
    66a0:	49052000 	stmmidb	r5, {sp}
    66a4:	54884a05 	strpl	r4, [r8], #2565
    66a8:	5488322f 	strpl	r3, [r8], #559
    66ac:	5488322f 	strpl	r3, [r8], #559
    66b0:	5488322f 	strpl	r3, [r8], #559
    66b4:	00004770 	andeq	r4, r0, r0, ror r7
    66b8:	00008a54 	andeq	r8, r0, r4, asr sl
    66bc:	000003d6 	ldreqd	r0, [r0], -r6
    66c0:	b093b5f0 	ldrltsh	fp, [r3], r0
    66c4:	21004668 	tstcs	r0, r8, ror #12
    66c8:	48da7281 	ldmmiia	sl, {r0, r7, r9, ip, sp, lr}^
    66cc:	180849da 	stmneda	r8, {r1, r3, r4, r6, r7, r8, fp, lr}
    66d0:	48da9008 	ldmmiia	sl, {r3, ip, pc}^
    66d4:	90051808 	andls	r1, r5, r8, lsl #16
    66d8:	180848d9 	stmneda	r8, {r0, r3, r4, r6, r7, fp, lr}
    66dc:	48d99009 	ldmmiia	r9, {r0, r3, ip, pc}^
    66e0:	900d1808 	andls	r1, sp, r8, lsl #16
    66e4:	180848d8 	stmneda	r8, {r3, r4, r6, r7, fp, lr}
    66e8:	48d8900e 	ldmmiia	r8, {r1, r2, r3, ip, pc}^
    66ec:	48d8180c 	ldmmiia	r8, {r2, r3, fp, ip}^
    66f0:	90061808 	andls	r1, r6, r8, lsl #16
    66f4:	180848d7 	stmneda	r8, {r0, r1, r2, r4, r6, r7, fp, lr}
    66f8:	48d79000 	ldmmiia	r7, {ip, pc}^
    66fc:	900b1808 	andls	r1, fp, r8, lsl #16
    6700:	180848d6 	stmneda	r8, {r1, r2, r4, r6, r7, fp, lr}
    6704:	48d69003 	ldmmiia	r6, {r0, r1, ip, pc}^
    6708:	90041808 	andls	r1, r4, r8, lsl #16
    670c:	180d48d5 	stmneda	sp, {r0, r2, r4, r6, r7, fp, lr}
    6710:	180f48d5 	stmneda	pc, {r0, r2, r4, r6, r7, fp, lr}
    6714:	180e48d5 	stmneda	lr, {r0, r2, r4, r6, r7, fp, lr}
    6718:	7c3120fe 	ldcvc	0, cr2, [r1], #-1016
    671c:	d9012910 	stmledb	r1, {r4, r8, fp, sp}
    6720:	f9f9f001 	ldmnvib	r9!, {r0, ip, sp, lr, pc}^
    6724:	0049a201 	subeq	sl, r9, r1, lsl #4
    6728:	44975a52 	ldrmi	r5, [r7], #2642
    672c:	02d20386 	sbceqs	r0, r2, #402653186	; 0x18000002
    6730:	05de05f6 	ldreqb	r0, [lr, #1526]
    6734:	0d5e0f0c 	ldceql	15, cr0, [lr, #-48]
    6738:	11541214 	cmpne	r4, r4, lsl r2
    673c:	11c411a8 	bicne	r1, r4, r8, lsr #3
    6740:	002009b8 	streqh	r0, [r0], -r8
    6744:	060a08ec 	streq	r0, [sl], -ip, ror #17
    6748:	126212e4 	rsbne	r1, r2, #1073741838	; 0x4000000e
    674c:	7c391358 	ldcvc	3, cr1, [r9], #-352
    6750:	2a097c72 	bcs	0x265920
    6754:	e192d900 	orrs	sp, r2, r0, lsl #18
    6758:	0052a301 	subeqs	sl, r2, r1, lsl #6
    675c:	449f5a9b 	ldrmi	r5, [pc], #2715	; 0x6764
    6760:	002e0012 	eoreq	r0, lr, r2, lsl r0
    6764:	00580036 	subeqs	r0, r8, r6, lsr r0
    6768:	00c2008c 	sbceq	r0, r2, ip, lsl #1
    676c:	01bc0126 	moveqs	r0, r6, lsr #2
    6770:	025e01fe 	subeqs	r0, lr, #-2147483585	; 0x8000003f
    6774:	680048be 	stmvsda	r0, {r1, r2, r3, r4, r5, r7, fp, lr}
    6778:	6a406a80 	bvs	0x1021180
    677c:	680949bc 	stmvsda	r9, {r2, r3, r4, r5, r7, r8, fp, lr}
    6780:	6a496a89 	bvs	0x12611ac
    6784:	22047fc9 	andcs	r7, r4, #804	; 0x324
    6788:	77c2430a 	strvcb	r4, [r2, sl, lsl #6]
    678c:	e2412001 	sub	r2, r1, #1	; 0x1
    6790:	f0019809 	andnv	r9, r1, r9, lsl #16
    6794:	e172fb89 	cmnp	r2, r9, lsl #23
    6798:	21019800 	tstcs	r1, r0, lsl #16
    679c:	76317081 	ldrvct	r7, [r1], -r1, lsl #1
    67a0:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    67a4:	22007470 	andcs	r7, r0, #1879048192	; 0x70000000
    67a8:	20002100 	andcs	r2, r0, r0, lsl #2
    67ac:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    67b0:	f00a2027 	andnv	r2, sl, r7, lsr #32
    67b4:	b003fa17 	andlt	pc, r3, r7, lsl sl
    67b8:	2928e161 	stmcsdb	r8!, {r0, r5, r6, r8, sp, lr, pc}
    67bc:	e15ed000 	cmp	lr, r0
    67c0:	208f9905 	addcs	r9, pc, r5, lsl #18
    67c4:	4a9c00c0 	bmi	0xfe706acc
    67c8:	f0011810 	andnv	r1, r1, r0, lsl r8
    67cc:	9805f9b5 	stmlsda	r5, {r0, r2, r4, r5, r7, r8, fp, ip, sp, lr, pc}
    67d0:	ff84f00d 	swinv	0x0084f00d
    67d4:	21002200 	tstcs	r0, r0, lsl #4
    67d8:	b4072000 	strlt	r2, [r7]
    67dc:	20292300 	eorcs	r2, r9, r0, lsl #6
    67e0:	fa00f00a 	blx	0x42810
    67e4:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    67e8:	b0037470 	andlt	r7, r3, r0, ror r4
    67ec:	292ce147 	stmcsdb	ip!, {r0, r1, r2, r6, r8, sp, lr, pc}
    67f0:	e144d000 	cmp	r4, r0
    67f4:	4a904991 	bmi	0xfe418e40
    67f8:	4a9e1851 	bmi	0xfe78c944
    67fc:	189a4b8e 	ldmneia	sl, {r1, r2, r3, r7, r8, r9, fp, lr}
    6800:	1e402008 	cdpne	0, 4, cr2, cr0, cr8, {0}
    6804:	54135c0b 	ldrpl	r5, [r3], #-3083
    6808:	2200d1fb 	andcs	sp, r0, #-1073741762	; 0xc000003e
    680c:	20002100 	andcs	r2, r0, r0, lsl #2
    6810:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    6814:	f00a202a 	andnv	r2, sl, sl, lsr #32
    6818:	7c70f9e5 	ldcvcl	9, cr15, [r0], #-916
    681c:	74701c40 	ldrvcbt	r1, [r0], #-3136
    6820:	e12cb003 	teq	ip, r3
    6824:	d000292d 	andle	r2, r0, sp, lsr #18
    6828:	7c79e129 	ldfvcp	f6, [r9], #-164
    682c:	d51007c9 	ldrle	r0, [r0, #-1993]
    6830:	21017a78 	tstcs	r1, r8, ror sl
    6834:	72794301 	rsbvcs	r4, r9, #67108864	; 0x4000000
    6838:	6800488d 	stmvsda	r0, {r0, r2, r3, r7, fp, lr}
    683c:	6a406a80 	bvs	0x1021244
    6840:	6809498b 	stmvsda	r9, {r0, r1, r3, r7, r8, fp, lr}
    6844:	6a496a89 	bvs	0x1261270
    6848:	22017fc9 	andcs	r7, r1, #804	; 0x324
    684c:	77c2430a 	strvcb	r4, [r2, sl, lsl #6]
    6850:	7a79e009 	bvc	0x1e7e87c
    6854:	72794001 	rsbvcs	r4, r9, #1	; 0x1
    6858:	68094985 	stmvsda	r9, {r0, r2, r7, r8, fp, lr}
    685c:	6a496a89 	bvs	0x1261288
    6860:	40107fca 	andmis	r7, r0, sl, asr #31
    6864:	980077c8 	stmlsda	r0, {r3, r6, r7, r8, r9, sl, ip, sp, lr}
    6868:	70012100 	andvc	r2, r1, r0, lsl #2
    686c:	70419800 	subvc	r9, r1, r0, lsl #16
    6870:	20002200 	andcs	r2, r0, r0, lsl #4
    6874:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    6878:	f00a2007 	andnv	r2, sl, r7
    687c:	7c70f9b3 	ldcvcl	9, cr15, [r0], #-716
    6880:	74701c40 	ldrvcbt	r1, [r0], #-3136
    6884:	e0fab003 	rscs	fp, sl, r3
    6888:	d1362918 	teqle	r6, r8, lsl r9
    688c:	98009905 	stmlsda	r0, {r0, r2, r8, fp, ip, pc}
    6890:	221f7800 	andcss	r7, pc, #0	; 0x0
    6894:	4a684350 	bmi	0x1a175dc
    6898:	301c1810 	andccs	r1, ip, r0, lsl r8
    689c:	f94cf001 	stmnvdb	ip, {r0, ip, sp, lr, pc}^
    68a0:	98009908 	stmlsda	r0, {r3, r8, fp, ip, pc}
    68a4:	221f7800 	andcss	r7, pc, #0	; 0x0
    68a8:	4a634350 	bmi	0x18d75f0
    68ac:	30081810 	andcc	r1, r8, r0, lsl r8
    68b0:	f956f001 	ldmnvdb	r6, {r0, ip, sp, lr, pc}^
    68b4:	78009800 	stmvcda	r0, {fp, ip, pc}
    68b8:	4348211f 	cmpmi	r8, #-1073741817	; 0xc0000007
    68bc:	1808495e 	stmneda	r8, {r1, r2, r3, r4, r6, r8, fp, lr}
    68c0:	21023023 	tstcs	r2, r3, lsr #32
    68c4:	495f7001 	ldmmidb	pc, {r0, ip, sp, lr}^
    68c8:	18514a5b 	ldmneda	r1, {r0, r1, r3, r4, r6, r9, fp, lr}^
    68cc:	4b5a4a61 	blmi	0x1699258
    68d0:	231f5c9a 	tstcs	pc, #39424	; 0x9a00
    68d4:	4b58435a 	blmi	0x1617644
    68d8:	3218189a 	andccs	r1, r8, #10092544	; 0x9a0000
    68dc:	1e402004 	cdpne	0, 4, cr2, cr0, cr4, {0}
    68e0:	54135c0b 	ldrpl	r5, [r3], #-3083
    68e4:	9800d1fb 	stmlsda	r0, {r0, r1, r3, r4, r5, r6, r7, r8, ip, lr, pc}
    68e8:	78099900 	stmvcda	r9, {r8, fp, ip, pc}
    68ec:	70011c49 	andvc	r1, r1, r9, asr #24
    68f0:	99009800 	stmlsdb	r0, {fp, ip, pc}
    68f4:	1c497849 	mcrrne	8, 4, r7, r9, cr9
    68f8:	7c387041 	ldcvc	0, cr7, [r8], #-260
    68fc:	d10b2819 	tstle	fp, r9, lsl r8
    6900:	21002200 	tstcs	r0, r0, lsl #4
    6904:	b4072000 	strlt	r2, [r7]
    6908:	202f2300 	eorcs	r2, pc, r0, lsl #6
    690c:	f96af00a 	stmnvdb	sl!, {r1, r3, ip, sp, lr, pc}^
    6910:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    6914:	b0037470 	andlt	r7, r3, r0, ror r4
    6918:	74382000 	ldrvct	r2, [r8]
    691c:	2930e0af 	ldmcsdb	r0!, {r0, r1, r2, r3, r5, r7, sp, lr, pc}
    6920:	e0acd000 	adc	sp, ip, r0
    6924:	70387cb8 	ldrvch	r7, [r8], -r8
    6928:	70787c78 	rsbvcs	r7, r8, r8, ror ip
    692c:	28017ab8 	stmcsda	r1, {r3, r4, r5, r7, r9, fp, ip, sp, lr}
    6930:	2200d109 	andcs	sp, r0, #1073741826	; 0x40000002
    6934:	20002100 	andcs	r2, r0, r0, lsl #2
    6938:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    693c:	f00a2033 	andnv	r2, sl, r3, lsr r0
    6940:	b003f951 	andlt	pc, r3, r1, asr r9
    6944:	2200e008 	andcs	lr, r0, #8	; 0x8
    6948:	20002100 	andcs	r2, r0, r0, lsl #2
    694c:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    6950:	f00a2034 	andnv	r2, sl, r4, lsr r0
    6954:	b003f947 	andlt	pc, r3, r7, asr #18
    6958:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    695c:	e1a37470 	mov	r7, r0, ror r4
    6960:	d11d2931 	tstle	sp, r1, lsr r9
    6964:	72f87cb8 	rscvcs	r7, r8, #47104	; 0xb800
    6968:	28007c78 	stmcsda	r0, {r3, r4, r5, r6, sl, fp, ip, sp, lr}
    696c:	2200d10c 	andcs	sp, r0, #3	; 0x3
    6970:	20002100 	andcs	r2, r0, r0, lsl #2
    6974:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    6978:	f00a2003 	andnv	r2, sl, r3
    697c:	7c70f933 	ldcvcl	9, cr15, [r0], #-204
    6980:	74701c40 	ldrvcbt	r1, [r0], #-3136
    6984:	e00bb003 	and	fp, fp, r3
    6988:	76302000 	ldrvct	r2, [r0], -r0
    698c:	201172b8 	ldrcsh	r7, [r1], -r8
    6990:	20007430 	andcs	r7, r0, r0, lsr r4
    6994:	61707470 	cmnvs	r0, r0, ror r4
    6998:	69f074f0 	ldmvsib	r0!, {r4, r5, r6, r7, sl, ip, sp, lr}^
    699c:	80012100 	andhi	r2, r1, r0, lsl #2
    69a0:	28327c38 	ldmcsda	r2!, {r3, r4, r5, sl, fp, ip, sp, lr}
    69a4:	2200d16b 	andcs	sp, r0, #-1073741798	; 0xc000001a
    69a8:	20002100 	andcs	r2, r0, r0, lsl #2
    69ac:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    69b0:	f00a2003 	andnv	r2, sl, r3
    69b4:	7c70f917 	ldcvcl	9, cr15, [r0], #-92
    69b8:	74701c40 	ldrvcbt	r1, [r0], #-3136
    69bc:	e05eb003 	subs	fp, lr, r3
    69c0:	d15c291b 	cmple	ip, fp, lsl r9
    69c4:	07c07c78 	undefined
    69c8:	d5027a78 	strle	r7, [r2, #-2680]
    69cc:	43012102 	tstmi	r1, #-2147483648	; 0x80000000
    69d0:	21fde001 	mvncss	lr, r1
    69d4:	72794001 	rsbvcs	r4, r9, #1	; 0x1
    69d8:	68004825 	stmvsda	r0, {r0, r2, r5, fp, lr}
    69dc:	6a406a80 	bvs	0x10213e4
    69e0:	22fb7fc1 	rsccss	r7, fp, #772	; 0x304
    69e4:	77c2400a 	strvcb	r4, [r2, sl]
    69e8:	72b82000 	adcvcs	r2, r8, #0	; 0x0
    69ec:	74302011 	ldrvct	r2, [r0], #-17
    69f0:	74702000 	ldrvcbt	r2, [r0]
    69f4:	74f06170 	ldrvcbt	r6, [r0], #368
    69f8:	210069f0 	strcsd	r6, [r0, -r0]
    69fc:	e03e8001 	eors	r8, lr, r1
    6a00:	1c017c70 	stcne	12, cr7, [r1], {112}
    6a04:	d83a2805 	ldmleda	sl!, {r0, r2, fp, sp}
    6a08:	0049a201 	subeq	sl, r9, r1, lsl #4
    6a0c:	44975e52 	ldrmi	r5, [r7], #3666
    6a10:	fd7e000a 	ldc2l	0, cr0, [lr, #-40]!
    6a14:	00660ed8 	ldreqd	r0, [r6], #-232
    6a18:	008a0070 	addeq	r0, sl, r0, ror r0
    6a1c:	68094914 	stmvsda	r9, {r2, r4, r8, fp, lr}
    6a20:	6a496a89 	bvs	0x126144c
    6a24:	07497fc9 	streqb	r7, [r9, -r9, asr #31]
    6a28:	1c40d501 	cfstr64ne	mvdx13, [r0], {1}
    6a2c:	1c80e0f2 	stcne	0, cr14, [r0], {242}
    6a30:	46c0e0f0 	undefined
    6a34:	0000048e 	andeq	r0, r0, lr, lsl #9
    6a38:	00008a54 	andeq	r8, r0, r4, asr sl
    6a3c:	00000487 	andeq	r0, r0, r7, lsl #9
    6a40:	00000bb5 	streqh	r0, [r0], -r5
    6a44:	0000049e 	muleq	r0, lr, r4
    6a48:	0000076e 	andeq	r0, r0, lr, ror #14
    6a4c:	00000505 	andeq	r0, r0, r5, lsl #10
    6a50:	000003d5 	ldreqd	r0, [r0], -r5
    6a54:	00000761 	andeq	r0, r0, r1, ror #14
    6a58:	000003ce 	andeq	r0, r0, lr, asr #7
    6a5c:	00000872 	andeq	r0, r0, r2, ror r8
    6a60:	00000976 	andeq	r0, r0, r6, ror r9
    6a64:	00000b84 	andeq	r0, r0, r4, lsl #23
    6a68:	00000476 	andeq	r0, r0, r6, ror r4
    6a6c:	00000ba4 	andeq	r0, r0, r4, lsr #23
    6a70:	00009624 	andeq	r9, r0, r4, lsr #12
    6a74:	00000466 	andeq	r0, r0, r6, ror #8
    6a78:	f0019809 	andnv	r9, r1, r9, lsl #16
    6a7c:	f001f9cf 	andnv	pc, r1, pc, asr #19
    6a80:	2200f84c 	andcs	pc, r0, #4980736	; 0x4c0000
    6a84:	20002100 	andcs	r2, r0, r0, lsl #2
    6a88:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    6a8c:	f00a2025 	andnv	r2, sl, r5, lsr #32
    6a90:	7c70f8a9 	ldcvcl	8, cr15, [r0], #-676
    6a94:	74701c40 	ldrvcbt	r1, [r0], #-3136
    6a98:	e7f0b003 	ldrb	fp, [r0, r3]!
    6a9c:	28267c38 	stmcsda	r6!, {r3, r4, r5, sl, fp, ip, sp, lr}
    6aa0:	2000d1ed 	andcs	sp, r0, sp, ror #3
    6aa4:	61707470 	cmnvs	r0, r0, ror r4
    6aa8:	200174f0 	strcsd	r7, [r1], -r0
    6aac:	200b72b8 	strcsh	r7, [fp], -r8
    6ab0:	e7e47430 	undefined
    6ab4:	49ca7c70 	stmmiib	sl, {r4, r5, r6, sl, fp, ip, sp, lr}^
    6ab8:	18554aca 	ldmneda	r5, {r1, r3, r6, r7, r9, fp, lr}^
    6abc:	28081c01 	stmcsda	r8, {r0, sl, fp, ip}
    6ac0:	a202d8dd 	andge	sp, r2, #14483456	; 0xdd0000
    6ac4:	5a520049 	bpl	0x1486bf0
    6ac8:	46c04497 	undefined
    6acc:	004e0012 	subeq	r0, lr, r2, lsl r0
    6ad0:	0102006e 	tsteq	r2, lr, rrx
    6ad4:	0e1e0110 	mrceq	1, 0, r0, cr14, cr0, {0}
    6ad8:	0184014c 	orreq	r0, r4, ip, asr #2
    6adc:	48c201f2 	stmmiia	r2, {r1, r4, r5, r6, r7, r8}^
    6ae0:	6a806800 	bvs	0xfe020ae8
    6ae4:	7fc06a40 	swivc	0x00c06a40
    6ae8:	d5140740 	ldrle	r0, [r4, #-1856]
    6aec:	680048be 	stmvsda	r0, {r1, r2, r3, r4, r5, r7, fp, lr}
    6af0:	6a406a80 	bvs	0x10214f8
    6af4:	680949bc 	stmvsda	r9, {r2, r3, r4, r5, r7, r8, fp, lr}
    6af8:	6a496a89 	bvs	0x1261524
    6afc:	22047fc9 	andcs	r7, r4, #804	; 0x324
    6b00:	77c2430a 	strvcb	r4, [r2, sl, lsl #6]
    6b04:	21009800 	tstcs	r0, r0, lsl #16
    6b08:	7c707241 	lfmvc	f7, 2, [r0], #-260
    6b0c:	74701c40 	ldrvcbt	r1, [r0], #-3136
    6b10:	fec2f009 	cdp2	0, 12, cr15, cr2, cr9, {0}
    6b14:	2004e7b3 	strcsh	lr, [r4], -r3
    6b18:	9800e07c 	stmlsda	r0, {r2, r3, r4, r5, r6, sp, lr, pc}
    6b1c:	1c407a40 	mcrrne	10, 4, r7, r0, cr0
    6b20:	72489900 	subvc	r9, r8, #0	; 0x0
    6b24:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    6b28:	d3a82865 	movle	r2, #6619136	; 0x650000
    6b2c:	feb6f009 	cdp2	0, 11, cr15, cr6, cr9, {0}
    6b30:	80282000 	eorhi	r2, r8, r0
    6b34:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    6b38:	8828e06c 	stmhida	r8!, {r2, r3, r5, r6, sp, lr, pc}
    6b3c:	80281c40 	eorhi	r1, r8, r0, asr #24
    6b40:	040049aa 	streq	r4, [r0], #-2474
    6b44:	42880c00 	addmi	r0, r8, #0	; 0x0
    6b48:	48a9d399 	stmmiia	r9!, {r0, r3, r4, r7, r8, r9, ip, lr, pc}
    6b4c:	4aa52100 	bmi	0xfe94ef54
    6b50:	1e803208 	cdpne	2, 8, cr3, cr0, cr8, {0}
    6b54:	d1fc5211 	mvnles	r5, r1, lsl r2
    6b58:	4da22400 	cfstrsmi	mvf2, [r2]
    6b5c:	21002007 	tstcs	r0, r7
    6b60:	4362222f 	cmnmi	r2, #-268435454	; 0xf0000002
    6b64:	18eb4ba3 	stmneia	fp!, {r0, r1, r5, r7, r8, r9, fp, lr}^
    6b68:	1e40189a 	mcrne	8, 2, r1, cr0, cr10, {4}
    6b6c:	d1fc5411 	mvnles	r5, r1, lsl r4
    6b70:	222f2010 	eorcs	r2, pc, #16	; 0x10
    6b74:	4ba04362 	blmi	0xfe817904
    6b78:	189a18eb 	ldmneia	sl, {r0, r1, r3, r5, r6, r7, fp, ip}
    6b7c:	54111e40 	ldrpl	r1, [r1], #-3648
    6b80:	2004d1fc 	strcsd	sp, [r4], -ip
    6b84:	4362222f 	cmnmi	r2, #-268435454	; 0xf0000002
    6b88:	18eb4b9c 	stmneia	fp!, {r2, r3, r4, r7, r8, r9, fp, lr}^
    6b8c:	1e40189a 	mcrne	8, 2, r1, cr0, cr10, {4}
    6b90:	d1fc5411 	mvnles	r5, r1, lsl r4
    6b94:	222f2010 	eorcs	r2, pc, #16	; 0x10
    6b98:	4b994362 	blmi	0xfe657928
    6b9c:	189a18eb 	ldmneia	sl, {r0, r1, r3, r5, r6, r7, fp, ip}
    6ba0:	54111e40 	ldrpl	r1, [r1], #-3648
    6ba4:	202fd1fc 	strcsd	sp, [pc], -ip
    6ba8:	99064360 	stmlsdb	r6, {r5, r6, r8, r9, lr}
    6bac:	540a22ff 	strpl	r2, [sl], #-767
    6bb0:	1c499906 	mcrrne	9, 0, r9, r9, cr6
    6bb4:	540a2200 	strpl	r2, [sl], #-512
    6bb8:	1c899906 	stcne	9, cr9, [r9], {6}
    6bbc:	1c64540a 	cfstrdne	mvd5, [r4], #-40
    6bc0:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    6bc4:	d3c92c04 	bicle	r2, r9, #1024	; 0x400
    6bc8:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    6bcc:	9800e022 	stmlsda	r0, {r1, r5, sp, lr, pc}
    6bd0:	70812101 	addvc	r2, r1, r1, lsl #2
    6bd4:	7c707631 	ldcvcl	6, cr7, [r0], #-196
    6bd8:	e01b1c40 	ands	r1, fp, r0, asr #24
    6bdc:	22009900 	andcs	r9, r0, #0	; 0x0
    6be0:	990071ca 	stmlsdb	r0, {r1, r3, r6, r7, r8, ip, sp, lr}
    6be4:	29027889 	stmcsdb	r2, {r0, r3, r7, fp, ip, sp, lr}
    6be8:	2400d113 	strcs	sp, [r0], #-275
    6bec:	4360202f 	cmnmi	r0, #47	; 0x2f
    6bf0:	1c499906 	mcrrne	9, 0, r9, r9, cr6
    6bf4:	28005c08 	stmcsda	r0, {r3, sl, fp, ip, lr}
    6bf8:	9800d003 	stmlsda	r0, {r0, r1, ip, lr, pc}
    6bfc:	43212180 	teqmi	r1, #32	; 0x20
    6c00:	1c6471c1 	stfnee	f7, [r4], #-772
    6c04:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    6c08:	d3ef2c04 	mvnle	r2, #1024	; 0x400
    6c0c:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    6c10:	1c80e000 	stcne	0, cr14, [r0], {0}
    6c14:	ff80f000 	swinv	0x0080f000
    6c18:	4a72497a 	bmi	0x1c99208
    6c1c:	aa0f1851 	bge	0x3ccd68
    6c20:	1e802008 	cdpne	0, 8, cr2, cr0, cr8, {0}
    6c24:	52135a0b 	andpls	r5, r3, #45056	; 0xb000
    6c28:	2000d1fb 	strcsd	sp, [r0], -fp
    6c2c:	3108a90f 	tstcc	r8, pc, lsl #18
    6c30:	60486008 	subvs	r6, r8, r8
    6c34:	21002200 	tstcs	r0, r0, lsl #4
    6c38:	4b6a4872 	blmi	0x1a98e08
    6c3c:	b4071818 	strlt	r1, [r7], #-2072
    6c40:	20212300 	eorcs	r2, r1, r0, lsl #6
    6c44:	ffcef009 	swinv	0x00cef009
    6c48:	74702007 	ldrvcbt	r2, [r0], #-7
    6c4c:	e716b003 	ldr	fp, [r6, -r3]
    6c50:	28227c38 	stmcsda	r2!, {r3, r4, r5, sl, fp, ip, sp, lr}
    6c54:	e712d000 	ldr	sp, [r2, -r0]
    6c58:	79c49800 	stmvcib	r4, {fp, ip, pc}^
    6c5c:	d5110620 	ldrle	r0, [r1, #-1568]
    6c60:	21002200 	tstcs	r0, r0, lsl #4
    6c64:	b4072000 	strlt	r2, [r7]
    6c68:	48672300 	stmmida	r7!, {r8, r9, sp}^
    6c6c:	438c2180 	orrmi	r2, ip, #32	; 0x20
    6c70:	434c212f 	cmpmi	ip, #-1073741813	; 0xc000000b
    6c74:	1909495b 	stmnedb	r9, {r0, r1, r3, r4, r6, r8, fp, lr}
    6c78:	200b5c09 	andcs	r5, fp, r9, lsl #24
    6c7c:	ffb2f009 	swinv	0x00b2f009
    6c80:	e669b003 	strbt	fp, [r9], -r3
    6c84:	68004858 	stmvsda	r0, {r3, r4, r6, fp, lr}
    6c88:	6a406a80 	bvs	0x1021690
    6c8c:	07407fc0 	streqb	r7, [r0, -r0, asr #31]
    6c90:	2000d501 	andcs	sp, r0, r1, lsl #10
    6c94:	20117630 	andcss	r7, r1, r0, lsr r6
    6c98:	20007430 	andcs	r7, r0, r0, lsr r4
    6c9c:	61707470 	cmnvs	r0, r0, ror r4
    6ca0:	69f074f0 	ldmvsib	r0!, {r4, r5, r6, r7, sl, ip, sp, lr}^
    6ca4:	80012100 	andhi	r2, r1, r0, lsl #2
    6ca8:	6800484f 	stmvsda	r0, {r0, r1, r2, r3, r6, fp, lr}
    6cac:	6a496a81 	bvs	0x12616b8
    6cb0:	6a406a80 	bvs	0x10216b8
    6cb4:	22087e80 	andcs	r7, r8, #2048	; 0x800
    6cb8:	768a4302 	strvc	r4, [sl], r2, lsl #6
    6cbc:	9800e3b3 	stmlsda	r0, {r0, r1, r4, r5, r7, r8, r9, sp, lr, pc}
    6cc0:	28007a00 	stmcsda	r0, {r9, fp, ip, sp, lr}
    6cc4:	e3aed100 	mov	sp, #0	; 0x0
    6cc8:	99004850 	stmlsdb	r0, {r4, r6, fp, lr}
    6ccc:	228079c9 	addcs	r7, r0, #3293184	; 0x324000
    6cd0:	222f4391 	eorcs	r4, pc, #1140850690	; 0x44000002
    6cd4:	4a434351 	bmi	0x10d7a20
    6cd8:	22011851 	andcs	r1, r1, #5308416	; 0x510000
    6cdc:	69f0540a 	ldmvsib	r0!, {r1, r3, sl, ip, lr}^
    6ce0:	80012100 	andhi	r2, r1, r0, lsl #2
    6ce4:	98007021 	stmlsda	r0, {r0, r5, ip, sp, lr}
    6ce8:	70812102 	addvc	r2, r1, r2, lsl #2
    6cec:	f0097631 	andnv	r7, r9, r1, lsr r6
    6cf0:	f009ff71 	andnv	pc, r9, r1, ror pc
    6cf4:	2101fde9 	smlattcs	r1, r9, sp, pc
    6cf8:	f009980e 	andnv	r9, r9, lr, lsl #16
    6cfc:	2011fddb 	ldrcssb	pc, [r1], -fp
    6d00:	20007430 	andcs	r7, r0, r0, lsr r4
    6d04:	61707470 	cmnvs	r0, r0, ror r4
    6d08:	e38c74f0 	orr	r7, ip, #-268435456	; 0xf0000000
    6d0c:	28007c70 	stmcsda	r0, {r4, r5, r6, sl, fp, ip, sp, lr}
    6d10:	f000d101 	andnv	sp, r0, r1, lsl #2
    6d14:	2801fdea 	stmcsda	r1, {r1, r3, r5, r6, r7, r8, sl, fp, ip, sp, lr, pc}
    6d18:	e384d000 	orr	sp, r4, #0	; 0x0
    6d1c:	210069f0 	strcsd	r6, [r0, -r0]
    6d20:	e7ec8001 	strb	r8, [ip, r1]!
    6d24:	28007c70 	stmcsda	r0, {r4, r5, r6, sl, fp, ip, sp, lr}
    6d28:	2801d002 	stmcsda	r1, {r1, ip, lr, pc}
    6d2c:	e37ad0f6 	cmn	sl, #246	; 0xf6
    6d30:	f0009809 	andnv	r9, r0, r9, lsl #16
    6d34:	e376ffc3 	cmnp	r6, #780	; 0x30c
    6d38:	88e94668 	stmhiia	r9!, {r3, r5, r6, r9, sl, lr}^
    6d3c:	7c398601 	ldcvc	6, cr8, [r9], #-4
    6d40:	72027bfa 	andvc	r7, r2, #256000	; 0x3e800
    6d44:	7c727820 	ldcvcl	8, cr7, [r2], #-128
    6d48:	d9002a0a 	stmledb	r0, {r1, r3, r9, fp, sp}
    6d4c:	a302e36b 	tstge	r2, #-1409286143	; 0xac000001
    6d50:	5e9b0052 	mrcpl	0, 4, r0, cr11, cr2, {2}
    6d54:	46c0449f 	undefined
    6d58:	0016ffd8 	ldreqsb	pc, [r6], -r8
    6d5c:	010800c8 	smlabteq	r8, r8, r0, r0
    6d60:	0202018e 	andeq	r0, r2, #-2147483613	; 0x80000023
    6d64:	0260023c 	rsbeq	r0, r0, #-1073741821	; 0xc0000003
    6d68:	0b92029e 	bleq	0xfe4877e8
    6d6c:	4827ffa6 	stmmida	r7!, {r1, r2, r5, r7, r8, r9, sl, fp, ip, sp, lr, pc}
    6d70:	222f7871 	eorcs	r7, pc, #7405568	; 0x710000
    6d74:	4a1b4351 	bmi	0x6d7ac0
    6d78:	5c081851 	stcpl	8, cr1, [r8], {81}
    6d7c:	d0212800 	eorle	r2, r1, r0, lsl #16
    6d80:	21019803 	tstcs	r1, r3, lsl #16
    6d84:	98037001 	stmlsda	r3, {r0, ip, sp, lr}
    6d88:	70412181 	subvc	r2, r1, r1, lsl #3
    6d8c:	010921b9 	streqh	r2, [r9, -r9]
    6d90:	4a1f1851 	bmi	0x7ccedc
    6d94:	189a4b13 	ldmneia	sl, {r0, r1, r4, r8, r9, fp, lr}
    6d98:	1f002014 	swine	0x00002014
    6d9c:	5013580b 	andpls	r5, r3, fp, lsl #16
    6da0:	481cd1fb 	ldmmida	ip, {r0, r1, r3, r4, r5, r6, r7, r8, ip, lr, pc}
    6da4:	1808490f 	stmneda	r8, {r0, r1, r2, r3, r8, fp, lr}
    6da8:	4a0e491b 	bmi	0x39921c
    6dac:	68021851 	stmvsda	r2, {r0, r4, r6, fp, ip}
    6db0:	221a600a 	andcss	r6, sl, #10	; 0xa
    6db4:	9803211a 	stmlsda	r3, {r1, r3, r4, r8, sp}
    6db8:	fdb8f009 	ldc2	0, cr15, [r8, #36]!
    6dbc:	81682000 	cmnhi	r8, r0
    6dc0:	e31d2002 	tst	sp, #2	; 0x2
    6dc4:	49158968 	ldmmidb	r5, {r3, r5, r6, r8, fp, pc}
    6dc8:	d3054288 	tstle	r5, #-2147483640	; 0x80000008
    6dcc:	219a69f0 	ldrcssh	r6, [sl, r0]
    6dd0:	80010209 	andhi	r0, r1, r9, lsl #4
    6dd4:	e3132008 	tst	r3, #8	; 0x8
    6dd8:	81681c40 	cmnhi	r8, r0, asr #24
    6ddc:	46c0e323 	strmib	lr, [r0], r3, lsr #6
    6de0:	0000076c 	andeq	r0, r0, ip, ror #14
    6de4:	00008a54 	andeq	r8, r0, r4, asr sl
    6de8:	00009624 	andeq	r9, r0, r4, lsr #12
    6dec:	000007d1 	ldreqd	r0, [r0], -r1
    6df0:	000003a2 	andeq	r0, r0, r2, lsr #7
    6df4:	000003ce 	andeq	r0, r0, lr, asr #7
    6df8:	000003aa 	andeq	r0, r0, sl, lsr #7
    6dfc:	000003ba 	streqh	r0, [r0], -sl
    6e00:	000003be 	streqh	r0, [r0], -lr
    6e04:	00000466 	andeq	r0, r0, r6, ror #8
    6e08:	000003d5 	ldreqd	r0, [r0], -r5
    6e0c:	000003d6 	ldreqd	r0, [r0], -r6
    6e10:	00000874 	andeq	r0, r0, r4, ror r8
    6e14:	00000b84 	andeq	r0, r0, r4, lsl #23
    6e18:	00000888 	andeq	r0, r0, r8, lsl #17
    6e1c:	00007530 	andeq	r7, r0, r0, lsr r5
    6e20:	d1132804 	tstle	r3, r4, lsl #16
    6e24:	7a004668 	bvc	0x187cc
    6e28:	d10f2802 	tstle	pc, r2, lsl #16
    6e2c:	d10d2981 	smlabble	sp, r1, r9, r2
    6e30:	28007c78 	stmcsda	r0, {r3, r4, r5, r6, sl, fp, ip, sp, lr}
    6e34:	7cb8d106 	ldfvcd	f5, [r8], #24
    6e38:	20038128 	andcs	r8, r3, r8, lsr #2
    6e3c:	20007470 	andcs	r7, r0, r0, ror r4
    6e40:	e0037020 	and	r7, r3, r0, lsr #32
    6e44:	800869f1 	strhid	r6, [r8], -r1
    6e48:	74702008 	ldrvcbt	r2, [r0], #-8
    6e4c:	49cf8968 	stmmiib	pc, {r3, r5, r6, r8, fp, pc}^
    6e50:	d3c14288 	bicle	r4, r1, #-2147483640	; 0x80000008
    6e54:	219769f0 	ldrcssh	r6, [r7, r0]
    6e58:	80010209 	andhi	r0, r1, r9, lsl #4
    6e5c:	e2cf2008 	sbc	r2, pc, #8	; 0x8
    6e60:	81682000 	cmnhi	r8, r0
    6e64:	49ca6828 	stmmiib	sl, {r3, r5, fp, sp, lr}^
    6e68:	d3004288 	tstle	r0, #-2147483640	; 0x80000008
    6e6c:	80a81e48 	adchi	r1, r8, r8, asr #28
    6e70:	0c000400 	cfstrseq	mvf0, [r0], {0}
    6e74:	d303287c 	tstle	r3, #8126464	; 0x7c0000
    6e78:	9001207b 	andls	r2, r1, fp, ror r0
    6e7c:	e0022004 	and	r2, r2, r4
    6e80:	900188a8 	andls	r8, r1, r8, lsr #17
    6e84:	74702005 	ldrvcbt	r2, [r0], #-5
    6e88:	46694668 	strmibt	r4, [r9], -r8, ror #12
    6e8c:	72418e09 	subvc	r8, r1, #144	; 0x90
    6e90:	48c0ab01 	stmmiia	r0, {r0, r8, r9, fp, sp, pc}^
    6e94:	180a49c0 	stmneda	sl, {r6, r7, r8, fp, lr}
    6e98:	1c49a902 	mcrrne	9, 0, sl, r9, cr2
    6e9c:	4cbf2082 	ldcmi	0, cr2, [pc], #520
    6ea0:	69246824 	stmvsdb	r4!, {r2, r5, fp, sp, lr}
    6ea4:	68246a64 	stmvsda	r4!, {r2, r5, r6, r9, fp, sp, lr}
    6ea8:	f9aaf010 	stmnvib	sl!, {r4, ip, sp, lr, pc}
    6eac:	1cd288aa 	ldcnel	8, cr8, [r2], {170}
    6eb0:	21019803 	tstcs	r1, r3, lsl #16
    6eb4:	98037001 	stmlsda	r3, {r0, ip, sp, lr}
    6eb8:	70412183 	subvc	r2, r1, r3, lsl #3
    6ebc:	89299803 	stmhidb	r9!, {r0, r1, fp, ip, pc}
    6ec0:	04127081 	ldreq	r7, [r2], #-129
    6ec4:	99010c12 	stmlsdb	r1, {r1, r4, sl, fp}
    6ec8:	06091cc9 	streq	r1, [r9], -r9, asr #25
    6ecc:	98030e09 	stmlsda	r3, {r0, r3, r9, sl, fp}
    6ed0:	fd2cf009 	stc2	0, cr15, [ip, #-36]!
    6ed4:	990188a8 	stmlsdb	r1, {r3, r5, r7, fp, pc}
    6ed8:	80a81a40 	adchi	r1, r8, r0, asr #20
    6edc:	99016828 	stmlsdb	r1, {r3, r5, fp, sp, lr}
    6ee0:	60281a40 	eorvs	r1, r8, r0, asr #20
    6ee4:	f009e29f 	mulnv	r9, pc, r2
    6ee8:	2800fd17 	stmcsda	r0, {r0, r1, r2, r4, r8, sl, fp, ip, sp, lr, pc}
    6eec:	e29ad100 	adds	sp, sl, #0	; 0x0
    6ef0:	81682000 	cmnhi	r8, r0
    6ef4:	288088a8 	stmcsia	r0, {r3, r5, r7, fp, pc}
    6ef8:	2180d302 	orrcs	sp, r0, r2, lsl #6
    6efc:	e0009101 	and	r9, r0, r1, lsl #2
    6f00:	99019001 	stmlsdb	r1, {r0, ip, pc}
    6f04:	80a81a40 	adchi	r1, r8, r0, asr #20
    6f08:	99016828 	stmlsdb	r1, {r3, r5, fp, sp, lr}
    6f0c:	60281a40 	eorvs	r1, r8, r0, asr #20
    6f10:	88e94668 	stmhiia	r9!, {r3, r5, r6, r9, sl, lr}^
    6f14:	ab017241 	blge	0x63820
    6f18:	a9029a03 	stmgedb	r2, {r0, r1, r9, fp, ip, pc}
    6f1c:	20821c49 	addcs	r1, r2, r9, asr #24
    6f20:	683f4f9e 	ldmvsda	pc!, {r1, r2, r3, r4, r7, r8, r9, sl, fp, lr}
    6f24:	6a7f693f 	bvs	0x1fe1428
    6f28:	f010683f 	andnvs	r6, r0, pc, lsr r8
    6f2c:	2180f963 	orrcs	pc, r0, r3, ror #18
    6f30:	42880209 	addmi	r0, r8, #-1879048192	; 0x90000000
    6f34:	2000d301 	andcs	sp, r0, r1, lsl #6
    6f38:	99019001 	stmlsdb	r1, {r0, ip, pc}
    6f3c:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    6f40:	f0099803 	andnv	r9, r9, r3, lsl #16
    6f44:	88a8fd2f 	stmhiia	r8!, {r0, r1, r2, r3, r5, r8, sl, fp, ip, sp, lr, pc}
    6f48:	d0002800 	andle	r2, r0, r0, lsl #16
    6f4c:	2005e26b 	andcs	lr, r5, fp, ror #4
    6f50:	20007470 	andcs	r7, r0, r0, ror r4
    6f54:	70208168 	eorvc	r8, r0, r8, ror #2
    6f58:	2806e265 	stmcsda	r6, {r0, r2, r5, r6, r9, sp, lr, pc}
    6f5c:	2983d115 	stmcsib	r3, {r0, r2, r4, r8, ip, lr, pc}
    6f60:	4668d113 	undefined
    6f64:	28027a00 	stmcsda	r2, {r9, fp, ip, sp, lr}
    6f68:	8928d10f 	stmhidb	r8!, {r0, r1, r2, r3, r8, ip, lr, pc}
    6f6c:	42887cb9 	addmi	r7, r8, #47360	; 0xb900
    6f70:	7c78d10b 	ldfvcp	f5, [r8], #-44
    6f74:	d1082800 	tstle	r8, r0, lsl #16
    6f78:	28006828 	stmcsda	r0, {r3, r5, fp, sp, lr}
    6f7c:	2003d001 	andcs	sp, r3, r1
    6f80:	2006e000 	andcs	lr, r6, r0
    6f84:	20007470 	andcs	r7, r0, r0, ror r4
    6f88:	89687020 	stmhidb	r8!, {r5, ip, sp, lr}^
    6f8c:	4288497f 	addmi	r4, r8, #2080768	; 0x1fc000
    6f90:	e721d22e 	str	sp, [r1, -lr, lsr #4]!
    6f94:	21019803 	tstcs	r1, r3, lsl #16
    6f98:	98037001 	stmlsda	r3, {r0, ip, sp, lr}
    6f9c:	70412184 	subvc	r2, r1, r4, lsl #3
    6fa0:	89299803 	stmhidb	r9!, {r0, r1, fp, ip, pc}
    6fa4:	22037081 	andcs	r7, r3, #129	; 0x81
    6fa8:	98032103 	stmlsda	r3, {r0, r1, r8, sp}
    6fac:	fcbef009 	ldc2	0, cr15, [lr], #36
    6fb0:	81682000 	cmnhi	r8, r0
    6fb4:	e2232007 	eor	r2, r3, #7	; 0x7
    6fb8:	d1162804 	tstle	r6, r4, lsl #16
    6fbc:	d1142984 	tstle	r4, r4, lsl #19
    6fc0:	7a004668 	bvc	0x18968
    6fc4:	d1102802 	tstle	r0, r2, lsl #16
    6fc8:	7cb98928 	ldcvc	9, cr8, [r9], #160
    6fcc:	d10c4288 	smlabble	ip, r8, r2, r4
    6fd0:	28007c78 	stmcsda	r0, {r3, r4, r5, r6, sl, fp, ip, sp, lr}
    6fd4:	d10169f0 	strled	r6, [r1, -r0]
    6fd8:	e0012100 	and	r2, r1, r0, lsl #2
    6fdc:	0209219b 	andeq	r2, r9, #-1073741786	; 0xc0000026
    6fe0:	20088001 	andcs	r8, r8, r1
    6fe4:	20007470 	andcs	r7, r0, r0, ror r4
    6fe8:	89687020 	stmhidb	r8!, {r5, ip, sp, lr}^
    6fec:	42884967 	addmi	r4, r8, #1687552	; 0x19c000
    6ff0:	e72fd300 	str	sp, [pc, -r0, lsl #6]!
    6ff4:	4668e6f0 	undefined
    6ff8:	8e094669 	cfmadd32hi	mvax3, mvfx4, mvfx9, mvfx9
    6ffc:	23007201 	tstcs	r0, #268435456	; 0x10000000
    7000:	a9022200 	stmgedb	r2, {r9, sp}
    7004:	4c652084 	stcmil	0, cr2, [r5], #-528
    7008:	69246824 	stmvsdb	r4!, {r2, r5, fp, sp, lr}
    700c:	68246a64 	stmvsda	r4!, {r2, r5, r6, r9, fp, sp, lr}
    7010:	f8f6f010 	ldmnvia	r6!, {r4, ip, sp, lr, pc}^
    7014:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    7018:	7c70e1f2 	ldfvcp	f6, [r0], #-968
    701c:	d0022800 	andle	r2, r2, r0, lsl #16
    7020:	d0322801 	eorles	r2, r2, r1, lsl #16
    7024:	2078e1ff 	ldrcssh	lr, [r8], #-31
    7028:	46689001 	strmibt	r9, [r8], -r1
    702c:	724188e9 	subvc	r8, r1, #15269888	; 0xe90000
    7030:	485bab01 	ldmmida	fp, {r0, r8, r9, fp, sp, pc}^
    7034:	180a4958 	stmneda	sl, {r3, r4, r6, r8, fp, lr}
    7038:	1c49a902 	mcrrne	9, 0, sl, r9, cr2
    703c:	4c572082 	mrrcmi	0, 8, r2, r7, cr2
    7040:	69246824 	stmvsdb	r4!, {r2, r5, fp, sp, lr}
    7044:	68246a64 	stmvsda	r4!, {r2, r5, r6, r9, fp, sp, lr}
    7048:	f8daf010 	ldmnvia	sl, {r4, ip, sp, lr, pc}^
    704c:	22029903 	andcs	r9, r2, #49152	; 0xc000
    7050:	9903700a 	stmlsdb	r3, {r1, r3, ip, sp, lr}
    7054:	704a7832 	subvc	r7, sl, r2, lsr r8
    7058:	0a029903 	beq	0xad46c
    705c:	9903708a 	stmlsdb	r3, {r1, r3, r7, ip, sp, lr}
    7060:	980370c8 	stmlsda	r3, {r3, r6, r7, ip, sp, lr}
    7064:	710188a9 	smlatbvc	r1, r9, r8, r8
    7068:	88a99803 	stmhiia	r9!, {r0, r1, fp, ip, pc}
    706c:	71410a09 	cmpvc	r1, r9, lsl #20
    7070:	1d9288aa 	ldcne	8, cr8, [r2, #680]
    7074:	0c120412 	cfldrseq	mvf0, [r2], {18}
    7078:	9803217e 	stmlsda	r3, {r1, r2, r3, r4, r5, r6, r8, sp}
    707c:	fc56f009 	mrrc2	0, 0, pc, r6, cr9
    7080:	387888a8 	ldmccda	r8!, {r3, r5, r7, fp, pc}^
    7084:	200180a8 	andcs	r8, r1, r8, lsr #1
    7088:	f009e1ba 	strnvh	lr, [r9], -sl
    708c:	2800fc45 	stmcsda	r0, {r0, r2, r6, sl, fp, ip, sp, lr, pc}
    7090:	e1c8d100 	bic	sp, r8, r0, lsl #2
    7094:	288188a8 	stmcsia	r1, {r3, r5, r7, fp, pc}
    7098:	3880d304 	stmccia	r0, {r2, r8, r9, ip, lr, pc}
    709c:	208080a8 	addcs	r8, r0, r8, lsr #1
    70a0:	e00a9001 	and	r9, sl, r1
    70a4:	20009001 	andcs	r9, r0, r1
    70a8:	69f080a8 	ldmvsib	r0!, {r3, r5, r7, pc}^
    70ac:	80012100 	andhi	r2, r1, r0, lsl #2
    70b0:	74302011 	ldrvct	r2, [r0], #-17
    70b4:	61717471 	cmnvs	r1, r1, ror r4
    70b8:	466874f1 	undefined
    70bc:	724188e9 	subvc	r8, r1, #15269888	; 0xe90000
    70c0:	9a03ab01 	bls	0xf1ccc
    70c4:	1c49a902 	mcrrne	9, 0, sl, r9, cr2
    70c8:	4c342082 	ldcmi	0, cr2, [r4], #-520
    70cc:	69246824 	stmvsdb	r4!, {r2, r5, fp, sp, lr}
    70d0:	68246a64 	stmvsda	r4!, {r2, r5, r6, r9, fp, sp, lr}
    70d4:	f894f010 	ldmnvia	r4, {r4, ip, sp, lr, pc}
    70d8:	06099901 	streq	r9, [r9], -r1, lsl #18
    70dc:	98030e09 	stmlsda	r3, {r0, r3, r9, sl, fp}
    70e0:	fc60f009 	stc2l	0, cr15, [r0], #-36
    70e4:	4668e19f 	undefined
    70e8:	72017cb1 	andvc	r7, r1, #45312	; 0xb100
    70ec:	7c707c39 	ldcvcl	12, cr7, [r0], #-228
    70f0:	78129a00 	ldmvcda	r2, {r9, fp, ip, pc}
    70f4:	781b9b04 	ldmvcda	fp, {r2, r8, r9, fp, ip, pc}
    70f8:	4d274c2a 	stcmi	12, cr4, [r7, #-168]!
    70fc:	940a192c 	strls	r1, [sl], #-2348
    7100:	28081c04 	stmcsda	r8, {r2, sl, fp, ip}
    7104:	e18ed900 	orr	sp, lr, r0, lsl #18
    7108:	0064a501 	rsbeq	sl, r4, r1, lsl #10
    710c:	44af5b2d 	strmit	r5, [pc], #2861	; 0x7114
    7110:	001007d8 	ldreqsb	r0, [r0], -r8
    7114:	005e0018 	subeqs	r0, lr, r8, lsl r0
    7118:	01820114 	orreq	r0, r2, r4, lsl r1
    711c:	031602e0 	tsteq	r6, #14	; 0xe
    7120:	98090350 	stmlsda	r9, {r4, r6, r8, r9}
    7124:	fe4af000 	cdp2	0, 4, cr15, cr10, cr0, {0}
    7128:	2400e17d 	strcs	lr, [r0], #-381
    712c:	4360201f 	cmnmi	r0, #31	; 0x1f
    7130:	18094919 	stmneda	r9, {r0, r3, r4, r8, fp, lr}
    7134:	32234a18 	eorcc	r4, r3, #98304	; 0x18000
    7138:	07805c10 	usada8eq	r0, r0, ip, r5
    713c:	3123d502 	teqcc	r3, r2, lsl #10
    7140:	e0012082 	and	r2, r1, r2, lsl #1
    7144:	20003123 	andcs	r3, r0, r3, lsr #2
    7148:	1c647008 	stcnel	0, cr7, [r4], #-32
    714c:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    7150:	d3eb2c1e 	mvnle	r2, #7680	; 0x1e00
    7154:	21002200 	tstcs	r0, r0, lsl #4
    7158:	b4072000 	strlt	r2, [r7]
    715c:	220a2300 	andcs	r2, sl, #0	; 0x0
    7160:	f009211e 	andnv	r2, r9, lr, lsl r1
    7164:	7c70fd3f 	ldcvcl	13, cr15, [r0], #-252
    7168:	74701c40 	ldrvcbt	r1, [r0], #-3136
    716c:	e15ab003 	cmp	sl, r3
    7170:	d1192b01 	tstle	r9, r1, lsl #22
    7174:	21002200 	tstcs	r0, r0, lsl #4
    7178:	b4072000 	strlt	r2, [r7]
    717c:	20012300 	andcs	r2, r1, r0, lsl #6
    7180:	fd30f009 	ldc2	0, cr15, [r0, #-36]!
    7184:	74702007 	ldrvcbt	r2, [r0], #-7
    7188:	e04ab003 	sub	fp, sl, r3
    718c:	00007530 	andeq	r7, r0, r0, lsr r5
    7190:	0000ea5c 	andeq	lr, r0, ip, asr sl
    7194:	00000875 	andeq	r0, r0, r5, ror r8
    7198:	00008a54 	andeq	r8, r0, r4, asr sl
    719c:	00009624 	andeq	r9, r0, r4, lsr #12
    71a0:	00000878 	andeq	r0, r0, r8, ror r8
    71a4:	00000bcc 	andeq	r0, r0, ip, asr #23
    71a8:	d12f290f 	teqle	pc, pc, lsl #18
    71ac:	d2382a1e 	eorles	r2, r8, #122880	; 0x1e000
    71b0:	fd0cf009 	stc2	0, cr15, [ip, #-36]
    71b4:	1c80a802 	stcne	8, cr10, [r0], {2}
    71b8:	2301b401 	tstcs	r1, #16777216	; 0x1000000
    71bc:	99099a0e 	stmlsdb	r9, {r1, r2, r3, r9, fp, ip, pc}
    71c0:	f0009806 	andnv	r9, r0, r6, lsl #16
    71c4:	b001fcd7 	ldrltd	pc, [r1], -r7
    71c8:	0e240604 	cfmadda32eq	mvax0, mvax0, mvfx4, mvfx4
    71cc:	d2142c1e 	andles	r2, r4, #7680	; 0x1e00
    71d0:	7a804668 	bvc	0xfe018b78
    71d4:	d0192800 	andles	r2, r9, r0, lsl #16
    71d8:	4344201f 	cmpmi	r4, #31	; 0x1f
    71dc:	190048bb 	stmnedb	r0, {r0, r1, r3, r4, r5, r7, fp, lr}
    71e0:	1c022123 	stfnes	f2, [r2], {35}
    71e4:	78123223 	ldmvcda	r2, {r0, r1, r5, r9, ip, sp}
    71e8:	0e520652 	mrceq	6, 2, r0, cr2, cr2, {2}
    71ec:	98005442 	stmlsda	r0, {r1, r6, sl, ip, lr}
    71f0:	78099900 	stmvcda	r9, {r8, fp, ip, pc}
    71f4:	70011c49 	andvc	r1, r1, r9, asr #24
    71f8:	2200e008 	andcs	lr, r0, #8	; 0x8
    71fc:	20002100 	andcs	r2, r0, r0, lsl #2
    7200:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    7204:	f0092001 	andnv	r2, r9, r1
    7208:	b003fced 	andlt	pc, r3, sp, ror #25
    720c:	28107c38 	ldmcsda	r0, {r3, r4, r5, sl, fp, ip, sp, lr}
    7210:	2000d107 	andcs	sp, r0, r7, lsl #2
    7214:	980a74b0 	stmlsda	sl, {r4, r5, r7, sl, ip, sp, lr}
    7218:	70012100 	andvc	r2, r1, r0, lsl #2
    721c:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    7220:	f7ff7470 	undefined
    7224:	2b01fb79 	blcs	0x86010
    7228:	2008d101 	andcs	sp, r8, r1, lsl #2
    722c:	4669e0e8 	strmibt	lr, [r9], -r8, ror #1
    7230:	06247a0c 	streqt	r7, [r4], -ip, lsl #20
    7234:	2c1e0e24 	ldccs	14, cr0, [lr], {36}
    7238:	211fd217 	tstcs	pc, r7, lsl r2
    723c:	4ba34361 	blmi	0xfe8d7fc8
    7240:	2123185b 	teqcs	r3, fp, asr r8
    7244:	1c645c59 	stcnel	12, cr5, [r4], #-356
    7248:	d0012901 	andle	r2, r1, r1, lsl #18
    724c:	d1f02902 	mvnles	r2, r2, lsl #18
    7250:	1c4074b4 	cfstrdne	mvd7, [r0], {180}
    7254:	22007470 	andcs	r7, r0, #1879048192	; 0x70000000
    7258:	20002100 	andcs	r2, r0, r0, lsl #2
    725c:	331cb407 	tstcc	ip, #117440512	; 0x7000000
    7260:	f0092004 	andnv	r2, r9, r4
    7264:	b003fcbf 	strlth	pc, [r3], -pc
    7268:	d000e0dd 	ldrled	lr, [r0], -sp
    726c:	980ae0db 	stmlsda	sl, {r0, r1, r3, r4, r6, r7, sp, lr, pc}
    7270:	1c407800 	mcrrne	8, 0, r7, r0, cr0
    7274:	7008990a 	andvc	r9, r8, sl, lsl #18
    7278:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    727c:	d3002803 	tstle	r0, #196608	; 0x30000
    7280:	9800e0f4 	stmlsda	r0, {r2, r4, r5, r6, r7, sp, lr, pc}
    7284:	42907840 	addmis	r7, r0, #4194304	; 0x400000
    7288:	f7ffd101 	ldrnvb	sp, [pc, r1, lsl #2]!
    728c:	2000fbaf 	andcs	pc, r0, pc, lsr #23
    7290:	e0c874b0 	strh	r7, [r8], #64
    7294:	d1732911 	cmnle	r3, r1, lsl r9
    7298:	99009800 	stmlsdb	r0, {fp, ip, pc}
    729c:	1c497849 	mcrrne	8, 4, r7, r9, cr9
    72a0:	7cb47041 	ldcvc	0, cr7, [r4], #260
    72a4:	99051e64 	stmlsdb	r5, {r2, r5, r6, r9, sl, fp, ip}
    72a8:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    72ac:	4360201f 	cmnmi	r0, #31	; 0x1f
    72b0:	18104a86 	ldmneda	r0, {r1, r2, r7, r9, fp, lr}
    72b4:	f000301c 	andnv	r3, r0, ip, lsl r0
    72b8:	2801fc47 	stmcsda	r1, {r0, r1, r2, r6, sl, fp, ip, sp, lr, pc}
    72bc:	2400d00f 	strcs	sp, [r0], #-15
    72c0:	201f9905 	andcss	r9, pc, r5, lsl #18
    72c4:	4a814360 	bmi	0xfe05804c
    72c8:	301c1810 	andccs	r1, ip, r0, lsl r8
    72cc:	fc3cf000 	ldc2	0, cr15, [ip]
    72d0:	d0042801 	andle	r2, r4, r1, lsl #16
    72d4:	06241c64 	streqt	r1, [r4], -r4, ror #24
    72d8:	2c1e0e24 	ldccs	14, cr0, [lr], {36}
    72dc:	201fd3f0 	ldrcssh	sp, [pc], -r0
    72e0:	497a4360 	ldmmidb	sl!, {r5, r6, r8, r9, lr}^
    72e4:	90011808 	andls	r1, r1, r8, lsl #16
    72e8:	90073008 	andls	r3, r7, r8
    72ec:	d2412c1e 	suble	r2, r1, #7680	; 0x1e00
    72f0:	28007e38 	stmcsda	r0, {r3, r4, r5, r9, sl, fp, ip, sp, lr}
    72f4:	9807d108 	stmlsda	r7, {r3, r8, ip, lr, pc}
    72f8:	28007800 	stmcsda	r0, {fp, ip, sp, lr}
    72fc:	4974d11f 	ldmmidb	r4!, {r0, r1, r2, r3, r4, r8, ip, lr, pc}^
    7300:	f0009807 	andnv	r9, r0, r7, lsl #16
    7304:	e01afc2d 	ands	pc, sl, sp, lsr #24
    7308:	18084872 	stmneda	r8, {r1, r4, r5, r6, fp, lr}
    730c:	434c211f 	cmpmi	ip, #-1073741817	; 0xc0000007
    7310:	1909496e 	stmnedb	r9, {r1, r2, r3, r5, r6, r8, fp, lr}
    7314:	24003108 	strcs	r3, [r0], #-264
    7318:	5d0a5d03 	stcpl	13, cr5, [sl, #-12]
    731c:	429a1c64 	addmis	r1, sl, #25600	; 0x6400
    7320:	2a00d103 	bcs	0x3b734
    7324:	2500d1f8 	strcs	sp, [r0, #-504]
    7328:	1ad5e000 	bne	0xff57f330
    732c:	d0062d00 	andle	r2, r6, r0, lsl #26
    7330:	98079908 	stmlsda	r7, {r3, r8, fp, ip, pc}
    7334:	fc14f000 	ldc2	0, cr15, [r4], {0}
    7338:	21014668 	tstcs	r1, r8, ror #12
    733c:	98077281 	stmlsda	r7, {r0, r7, r9, ip, sp, lr}
    7340:	28027ec0 	stmcsda	r2, {r6, r7, r9, sl, fp, ip, sp, lr}
    7344:	4668d113 	undefined
    7348:	28017a80 	stmcsda	r1, {r7, r9, fp, ip, sp, lr}
    734c:	2200d10f 	andcs	sp, r0, #-1073741821	; 0xc0000003
    7350:	31189901 	tstcc	r8, r1, lsl #18
    7354:	b4079807 	strlt	r9, [r7], #-2055
    7358:	331c9b04 	tstcc	ip, #4096	; 0x1000
    735c:	20052100 	andcs	r2, r5, r0, lsl #2
    7360:	fc40f009 	mcrr2	0, 0, pc, r0, cr9
    7364:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    7368:	b0037470 	andlt	r7, r3, r0, ror r4
    736c:	7c70e002 	ldcvcl	0, cr14, [r0], #-8
    7370:	74701e40 	ldrvcbt	r1, [r0], #-3648
    7374:	99079807 	stmlsdb	r7, {r0, r1, r2, fp, ip, pc}
    7378:	22407ec9 	subcs	r7, r0, #3216	; 0xc90
    737c:	76c2430a 	strvcb	r4, [r2], sl, lsl #6
    7380:	28127c38 	ldmcsda	r2, {r3, r4, r5, sl, fp, ip, sp, lr}
    7384:	e74cd000 	strb	sp, [ip, -r0]
    7388:	7800980a 	stmvcda	r0, {r1, r3, fp, ip, pc}
    738c:	d12d2802 	teqle	sp, r2, lsl #16
    7390:	7cb09905 	ldcvc	9, cr9, [r0], #20
    7394:	06001e40 	streq	r1, [r0], -r0, asr #28
    7398:	221f0e00 	andcss	r0, pc, #0	; 0x0
    739c:	4a4b4350 	bmi	0x12d80e4
    73a0:	301c1810 	andccs	r1, ip, r0, lsl r8
    73a4:	fbd0f000 	blx	0xff4433ae
    73a8:	d01a2801 	andles	r2, sl, r1, lsl #16
    73ac:	e0042400 	and	r2, r4, r0, lsl #8
    73b0:	06241c64 	streqt	r1, [r4], -r4, ror #24
    73b4:	2c1e0e24 	ldccs	14, cr0, [lr], {36}
    73b8:	201fd213 	andcss	sp, pc, r3, lsl r2
    73bc:	49434360 	stmmidb	r3, {r5, r6, r8, r9, lr}^
    73c0:	9905180d 	stmlsdb	r5, {r0, r2, r3, fp, ip}
    73c4:	301c1c28 	andccs	r1, ip, r8, lsr #24
    73c8:	fbbef000 	blx	0xfefc33d2
    73cc:	d1ef2801 	mvnle	r2, r1, lsl #16
    73d0:	5c282023 	stcpl	0, cr2, [r8], #-140
    73d4:	d1042801 	tstle	r4, r1, lsl #16
    73d8:	3508493d 	strcc	r4, [r8, #-2365]
    73dc:	f0001c28 	andnv	r1, r0, r8, lsr #24
    73e0:	9800fbbf 	stmlsda	r0, {r0, r1, r2, r3, r4, r5, r7, r8, r9, fp, ip, sp, lr, pc}
    73e4:	78499900 	stmvcda	r9, {r8, fp, ip, pc}^
    73e8:	70411c49 	subvc	r1, r1, r9, asr #24
    73ec:	1e407c70 	mcrne	12, 2, r7, cr0, cr0, {3}
    73f0:	2917e716 	ldmcsdb	r7, {r1, r2, r4, r8, r9, sl, sp, lr, pc}
    73f4:	7c78d117 	ldfvcp	f5, [r8], #-92
    73f8:	d1022850 	tstle	r2, r0, asr r8
    73fc:	30fe7c70 	rscccs	r7, lr, r0, ror ip
    7400:	4935e38a 	ldmmidb	r5!, {r1, r3, r7, r8, r9, sp, lr, pc}
    7404:	6a896809 	bvs	0xfe261430
    7408:	31256a49 	teqcc	r5, r9, asr #20
    740c:	48327008 	ldmmida	r2!, {r3, ip, sp, lr}
    7410:	6a806800 	bvs	0xfe021418
    7414:	49306a40 	ldmmidb	r0!, {r6, r9, fp, sp, lr}
    7418:	6a896809 	bvs	0xfe261444
    741c:	7fc96a49 	swivc	0x00c96a49
    7420:	430a2208 	tstmi	sl, #-2147483648	; 0x80000000
    7424:	e37877c2 	cmn	r8, #50855936	; 0x3080000
    7428:	d1fc2910 	mvnles	r2, r0, lsl r9
    742c:	e00c2400 	and	r2, ip, r0, lsl #8
    7430:	21003023 	tstcs	r0, r3, lsr #32
    7434:	98007001 	stmlsda	r0, {r0, ip, sp, lr}
    7438:	70012100 	andvc	r2, r1, r0, lsl #2
    743c:	70419800 	subvc	r9, r1, r0, lsl #16
    7440:	06241c64 	streqt	r1, [r4], -r4, ror #24
    7444:	2c1e0e24 	ldccs	14, cr0, [lr], {36}
    7448:	211fd210 	tstcs	pc, r0, lsl r2
    744c:	481f4361 	ldmmida	pc, {r0, r5, r6, r8, r9, lr}
    7450:	4a1e1840 	bmi	0x78d558
    7454:	5c513223 	lfmpl	f3, 2, [r1], {35}
    7458:	d5e90789 	strleb	r0, [r9, #1929]!
    745c:	21023023 	tstcs	r2, r3, lsr #32
    7460:	4668e7e8 	strmibt	lr, [r8], -r8, ror #15
    7464:	06247a04 	streqt	r7, [r4], -r4, lsl #20
    7468:	2c1e0e24 	ldccs	14, cr0, [lr], {36}
    746c:	f7ffd301 	ldrnvb	sp, [pc, r1, lsl #6]!
    7470:	201ffabd 	ldrcsh	pc, [pc], -sp
    7474:	49154360 	ldmmidb	r5, {r5, r6, r8, r9, lr}
    7478:	21231808 	teqcs	r3, r8, lsl #16
    747c:	29015c41 	stmcsdb	r1, {r0, r6, sl, fp, ip, lr}
    7480:	3023d102 	eorcc	sp, r3, r2, lsl #2
    7484:	70012100 	andvc	r2, r1, r0, lsl #2
    7488:	e7ec1c64 	strb	r1, [ip, r4, ror #24]!
    748c:	7c707c39 	ldcvcl	12, cr7, [r0], #-228
    7490:	d8192804 	ldmleda	r9, {r2, fp, sp}
    7494:	0040a201 	subeq	sl, r0, r1, lsl #4
    7498:	44975a12 	ldrmi	r5, [r7], #2578
    749c:	003e0008 	eoreqs	r0, lr, r8
    74a0:	01620082 	smulbbeq	r2, r2, r0
    74a4:	2200018a 	andcs	r0, r0, #-2147483614	; 0x80000022
    74a8:	20002100 	andcs	r2, r0, r0, lsl #2
    74ac:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    74b0:	20092101 	andcs	r2, r9, r1, lsl #2
    74b4:	fb96f009 	blx	0xfe5c34e2
    74b8:	980e9908 	stmlsda	lr, {r3, r8, fp, ip, pc}
    74bc:	fb3cf000 	blx	0xf434c6
    74c0:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    74c4:	b0037470 	andlt	r7, r3, r0, ror r4
    74c8:	46c0e327 	strmib	lr, [r0], r7, lsr #6
    74cc:	00008a54 	andeq	r8, r0, r4, asr sl
    74d0:	00118db8 	ldreqh	r8, [r1], -r8
    74d4:	0000048e 	andeq	r0, r0, lr, lsl #9
    74d8:	00009624 	andeq	r9, r0, r4, lsr #12
    74dc:	28137c38 	ldmcsda	r3, {r3, r4, r5, sl, fp, ip, sp, lr}
    74e0:	7c78d1f2 	ldfvcp	f5, [r8], #-968
    74e4:	d1212801 	teqle	r1, r1, lsl #16
    74e8:	7cb99806 	ldcvc	8, cr9, [r9], #24
    74ec:	48d97001 	ldmmiia	r9, {r0, ip, sp, lr}^
    74f0:	6a806800 	bvs	0xfe0214f8
    74f4:	49d76a40 	ldmmiib	r7, {r6, r9, fp, sp, lr}^
    74f8:	6a896809 	bvs	0xfe261524
    74fc:	7fc96a49 	swivc	0x00c96a49
    7500:	430a2202 	tstmi	sl, #536870912	; 0x20000000
    7504:	220077c2 	andcs	r7, r0, #50855936	; 0x3080000
    7508:	20002100 	andcs	r2, r0, r0, lsl #2
    750c:	9b0eb407 	blls	0x3b4530
    7510:	f0092004 	andnv	r2, r9, r4
    7514:	7c70fb67 	ldcvcl	11, cr15, [r0], #-412
    7518:	74701c40 	ldrvcbt	r1, [r0], #-3136
    751c:	e2fcb003 	rscs	fp, ip, #3	; 0x3
    7520:	d10e291a 	tstle	lr, sl, lsl r9
    7524:	78009806 	stmvcda	r0, {r1, r2, fp, ip, pc}
    7528:	d1f828ff 	ldrlesh	r2, [r8, #143]!
    752c:	74302011 	ldrvct	r2, [r0], #-17
    7530:	74702000 	ldrvcbt	r2, [r0]
    7534:	74f06170 	ldrvcbt	r6, [r0], #368
    7538:	219569f0 	ldrcssh	r6, [r5, r0]
    753c:	f7ff0209 	ldrnvb	r0, [pc, r9, lsl #4]!
    7540:	2911fa5d 	ldmcsdb	r1, {r0, r2, r3, r4, r6, r9, fp, ip, sp, lr, pc}
    7544:	a802d14d 	stmgeda	r2, {r0, r2, r3, r6, r8, ip, lr, pc}
    7548:	b4011c80 	strlt	r1, [r1], #-3200
    754c:	9a0e2302 	bls	0x39015c
    7550:	98069909 	stmlsda	r6, {r0, r3, r8, fp, ip, pc}
    7554:	fb0ef000 	blx	0x3c355e
    7558:	0604b001 	streq	fp, [r4], -r1
    755c:	2c1e0e24 	ldccs	14, cr0, [lr], {36}
    7560:	9908d22a 	stmlsdb	r8, {r1, r3, r5, r9, ip, lr, pc}
    7564:	4abd48bc 	bmi	0xfef5985c
    7568:	f0001810 	andnv	r1, r0, r0, lsl r8
    756c:	9905faf9 	stmlsdb	r5, {r0, r3, r4, r5, r6, r7, r9, fp, ip, sp, lr, pc}
    7570:	f000980b 	andnv	r9, r0, fp, lsl #16
    7574:	211ffae1 	tstcsp	pc, r1, ror #21
    7578:	4ab84361 	bmi	0xfee18304
    757c:	31181851 	tstcc	r8, r1, asr r8
    7580:	4bb64ab7 	blmi	0xfed9a064
    7584:	2004189a 	mulcs	r4, sl, r8
    7588:	5c0b1e40 	stcpl	14, cr1, [fp], {64}
    758c:	d1fb5413 	mvnles	r5, r3, lsl r4
    7590:	4344201f 	cmpmi	r4, #31	; 0x1f
    7594:	190348b1 	stmnedb	r3, {r0, r4, r5, r7, fp, lr}
    7598:	1c192200 	lfmne	f2, 4, [r9], {0}
    759c:	1c183118 	ldfnes	f3, [r8], {24}
    75a0:	b4073008 	strlt	r3, [r7], #-8
    75a4:	2100331c 	tstcs	r0, ip, lsl r3
    75a8:	f0092005 	andnv	r2, r9, r5
    75ac:	7c70fb1b 	ldcvcl	11, cr15, [r0], #-108
    75b0:	74701c40 	ldrvcbt	r1, [r0], #-3136
    75b4:	e014b003 	ands	fp, r4, r3
    75b8:	21002200 	tstcs	r0, r0, lsl #4
    75bc:	b4072000 	strlt	r2, [r7]
    75c0:	98092300 	stmlsda	r9, {r8, r9, sp}
    75c4:	20087801 	andcs	r7, r8, r1, lsl #16
    75c8:	fb0cf009 	blx	0x3435f6
    75cc:	74302011 	ldrvct	r2, [r0], #-17
    75d0:	74702000 	ldrvcbt	r2, [r0]
    75d4:	74f06170 	ldrvcbt	r6, [r0], #368
    75d8:	219569f0 	ldrcssh	r6, [r5, r0]
    75dc:	80010209 	andhi	r0, r1, r9, lsl #4
    75e0:	7c38b003 	ldcvc	0, cr11, [r8], #-12
    75e4:	d11e2812 	tstle	lr, r2, lsl r8
    75e8:	21002200 	tstcs	r0, r0, lsl #4
    75ec:	b4072000 	strlt	r2, [r7]
    75f0:	98092300 	stmlsda	r9, {r8, r9, sp}
    75f4:	20087801 	andcs	r7, r8, r1, lsl #16
    75f8:	faf4f009 	blx	0xffd43624
    75fc:	e114b003 	tst	r4, r3
    7600:	d1102917 	tstle	r0, r7, lsl r9
    7604:	28507c78 	ldmcsda	r0, {r3, r4, r5, r6, sl, fp, ip, sp, lr}^
    7608:	2200d1ee 	andcs	sp, r0, #-2147483589	; 0x8000003b
    760c:	20002100 	andcs	r2, r0, r0, lsl #2
    7610:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    7614:	78019809 	stmvcda	r1, {r0, r3, fp, ip, pc}
    7618:	f009200b 	andnv	r2, r9, fp
    761c:	7c70fae3 	ldcvcl	10, cr15, [r0], #-908
    7620:	74701c40 	ldrvcbt	r1, [r0], #-3136
    7624:	e278b003 	rsbs	fp, r8, #3	; 0x3
    7628:	7a009800 	bvc	0x2d630
    762c:	d0fa2800 	rscles	r2, sl, r0, lsl #16
    7630:	21019806 	tstcs	r1, r6, lsl #16
    7634:	f7ff7041 	ldrnvb	r7, [pc, r1, asr #32]!
    7638:	7c39fb52 	ldcvc	11, cr15, [r9], #-328
    763c:	28067c70 	stmcsda	r6, {r4, r5, r6, sl, fp, ip, sp, lr}
    7640:	a202d8f1 	andge	sp, r2, #15794176	; 0xf10000
    7644:	5e120040 	cdppl	0, 1, cr0, cr2, cr0, {2}
    7648:	46c04497 	undefined
    764c:	fad6029e 	blx	0xff5880cc
    7650:	0036000e 	eoreqs	r0, r6, lr
    7654:	01e60184 	mvneq	r0, r4, lsl #3
    7658:	2200022c 	andcs	r0, r0, #-1073741822	; 0xc0000002
    765c:	20002100 	andcs	r2, r0, r0, lsl #2
    7660:	9807b407 	stmlsda	r7, {r0, r1, r2, sl, ip, sp, pc}
    7664:	211f7800 	tstcs	pc, r0, lsl #16
    7668:	497c4348 	ldmmidb	ip!, {r3, r6, r8, r9, lr}^
    766c:	331c180b 	tstcc	ip, #720896	; 0xb0000
    7670:	20022100 	andcs	r2, r2, r0, lsl #2
    7674:	fab6f009 	blx	0xfedc36a0
    7678:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    767c:	b0037470 	andlt	r7, r3, r0, ror r4
    7680:	2913e24b 	ldmcsdb	r3, {r0, r1, r3, r6, r9, sp, lr, pc}
    7684:	e098d000 	adds	sp, r8, r0
    7688:	28017c78 	stmcsda	r1, {r3, r4, r5, r6, sl, fp, ip, sp, lr}
    768c:	e08ad000 	add	sp, sl, r0
    7690:	99044874 	stmlsdb	r4, {r2, r4, r5, r6, fp, lr}
    7694:	222f7849 	eorcs	r7, pc, #4784128	; 0x490000
    7698:	4a704351 	bmi	0x1c183e4
    769c:	7cba1851 	ldcvc	8, cr1, [sl], #324
    76a0:	486c540a 	stmmida	ip!, {r1, r3, sl, ip, lr}^
    76a4:	6a806800 	bvs	0xfe0216ac
    76a8:	496a6a40 	stmmidb	sl!, {r6, r9, fp, sp, lr}^
    76ac:	6a896809 	bvs	0xfe2616d8
    76b0:	7fc96a49 	swivc	0x00c96a49
    76b4:	430a2202 	tstmi	sl, #536870912	; 0x20000000
    76b8:	496b77c2 	stmmidb	fp!, {r1, r6, r7, r8, r9, sl, ip, sp, lr}^
    76bc:	5c514a67 	mrrcpl	10, 6, r4, r1, cr7
    76c0:	4351221f 	cmpmi	r1, #-268435455	; 0xf0000001
    76c4:	18514a65 	ldmneda	r1, {r0, r2, r5, r6, r9, fp, lr}^
    76c8:	4a68311c 	bmi	0x1a13b40
    76cc:	4c634b66 	stcmil	11, cr4, [r3], #-408
    76d0:	785b18e3 	ldmvcda	fp, {r0, r1, r5, r6, r7, fp, ip}^
    76d4:	4363242f 	cmnmi	r3, #788529152	; 0x2f000000
    76d8:	18e34c60 	stmneia	r3!, {r5, r6, sl, fp, lr}^
    76dc:	2007189a 	mulcs	r7, sl, r8
    76e0:	5c0b1e40 	stcpl	14, cr1, [fp], {64}
    76e4:	d1fb5413 	mvnles	r5, r3, lsl r4
    76e8:	78009804 	stmvcda	r0, {r2, fp, ip, pc}
    76ec:	4348211f 	cmpmi	r8, #-1073741817	; 0xc0000007
    76f0:	1809495a 	stmneda	r9, {r1, r3, r4, r6, r8, fp, lr}
    76f4:	48583108 	ldmmida	r8, {r3, r8, ip, sp}^
    76f8:	78529a04 	ldmvcda	r2, {r2, r9, fp, ip, pc}^
    76fc:	435a232f 	cmpmi	sl, #-1140850688	; 0xbc000000
    7700:	189a4b56 	ldmneia	sl, {r1, r2, r4, r6, r8, r9, fp, lr}
    7704:	f0001810 	andnv	r1, r0, r0, lsl r8
    7708:	4957fa2b 	ldmmidb	r7, {r0, r1, r3, r5, r9, fp, ip, sp, lr, pc}^
    770c:	5c514a53 	mrrcpl	10, 5, r4, r1, cr3
    7710:	4351221f 	cmpmi	r1, #-268435455	; 0xf0000001
    7714:	18514a51 	ldmneda	r1, {r0, r4, r6, r9, fp, lr}^
    7718:	4a513118 	bmi	0x1453b80
    771c:	18e34b52 	stmneia	r3!, {r1, r4, r6, r8, r9, fp, lr}^
    7720:	242f785b 	strcst	r7, [pc], #2139	; 0x7728
    7724:	4c4d4363 	mcrrmi	3, 6, r4, sp, cr3
    7728:	189a18e3 	ldmneia	sl, {r0, r1, r5, r6, r7, fp, ip}
    772c:	1e402004 	cdpne	0, 4, cr2, cr0, cr4, {0}
    7730:	54135c0b 	ldrpl	r5, [r3], #-3083
    7734:	9804d1fb 	stmlsda	r4, {r0, r1, r3, r4, r5, r6, r7, r8, ip, lr, pc}
    7738:	211f7800 	tstcs	pc, r0, lsl #16
    773c:	49474348 	stmmidb	r7, {r3, r6, r8, r9, lr}^
    7740:	30231808 	eorcc	r1, r3, r8, lsl #16
    7744:	70012102 	andvc	r2, r1, r2, lsl #2
    7748:	78409804 	stmvcda	r0, {r2, fp, ip, pc}^
    774c:	d1042801 	tstle	r4, r1, lsl #16
    7750:	21207a78 	teqcs	r0, r8, ror sl
    7754:	72794301 	rsbvcs	r4, r9, #67108864	; 0x4000000
    7758:	7a79e009 	bvc	0x1e7f784
    775c:	d1012802 	tstle	r1, r2, lsl #16
    7760:	e0022040 	and	r2, r2, r0, asr #32
    7764:	d1022803 	tstle	r2, r3, lsl #16
    7768:	43082080 	tstmi	r8, #128	; 0x80
    776c:	98047278 	stmlsda	r4, {r3, r4, r5, r6, r9, ip, sp, lr}
    7770:	212f7840 	teqcs	pc, r0, asr #16
    7774:	49394348 	ldmmidb	r9!, {r3, r6, r8, r9, lr}
    7778:	2200180b 	andcs	r1, r0, #720896	; 0xb0000
    777c:	78009804 	stmvcda	r0, {r2, fp, ip, pc}
    7780:	4348211f 	cmpmi	r8, #-1073741817	; 0xc0000007
    7784:	18094935 	stmneda	r9, {r0, r2, r4, r5, r8, fp, lr}
    7788:	48333118 	ldmmida	r3!, {r3, r4, r8, ip, sp}
    778c:	b4071818 	strlt	r1, [r7], #-2072
    7790:	181b4836 	ldmneda	fp, {r1, r2, r4, r5, fp, lr}
    7794:	20052100 	andcs	r2, r5, r0, lsl #2
    7798:	fa24f009 	blx	0x9437c4
    779c:	1cc07c70 	stcnel	12, cr7, [r0], {112}
    77a0:	b0037470 	andlt	r7, r3, r0, ror r4
    77a4:	69f0e009 	ldmvsib	r0!, {r0, r3, sp, lr, pc}^
    77a8:	02092195 	andeq	r2, r9, #1073741861	; 0x40000025
    77ac:	20118001 	andcss	r8, r1, r1
    77b0:	20007430 	andcs	r7, r0, r0, lsr r4
    77b4:	61707470 	cmnvs	r0, r0, ror r4
    77b8:	7c3874f0 	cfldrsvc	mvf7, [r8], #-960
    77bc:	d1672815 	cmnle	r7, r5, lsl r8
    77c0:	210269f0 	strcsd	r6, [r2, -r0]
    77c4:	20008001 	andcs	r8, r0, r1
    77c8:	7c706270 	lfmvc	f6, 2, [r0], #-448
    77cc:	e1a31c40 	mov	r1, r0, asr #24
    77d0:	28006a70 	stmcsda	r0, {r4, r5, r6, r9, fp, sp, lr}
    77d4:	4926d026 	stmmidb	r6!, {r1, r2, r5, ip, lr, pc}
    77d8:	18514a20 	ldmneda	r1, {r5, r9, fp, lr}^
    77dc:	4a256a49 	bmi	0x962108
    77e0:	4c1e4b21 	ldcmi	11, cr4, [lr], {33}
    77e4:	785b18e3 	ldmvcda	fp, {r0, r1, r5, r6, r7, fp, ip}^
    77e8:	4363242f 	cmnmi	r3, #788529152	; 0x2f000000
    77ec:	18e34c1b 	stmneia	r3!, {r0, r1, r3, r4, sl, fp, lr}^
    77f0:	2010189a 	mulcss	r0, sl, r8
    77f4:	5c0b1e40 	stcpl	14, cr1, [fp], {64}
    77f8:	d1fb5413 	mvnles	r5, r3, lsl r4
    77fc:	21006a72 	tstcs	r0, r2, ror sl
    7800:	b4072000 	strlt	r2, [r7]
    7804:	78009807 	stmvcda	r0, {r0, r1, r2, fp, ip, pc}
    7808:	4348211f 	cmpmi	r8, #-1073741817	; 0xc0000007
    780c:	180b4913 	stmneda	fp, {r0, r1, r4, r8, fp, lr}
    7810:	2200331c 	andcs	r3, r0, #1879048192	; 0x70000000
    7814:	200a2100 	andcs	r2, sl, r0, lsl #2
    7818:	f9e4f009 	stmnvib	r4!, {r0, r3, ip, sp, lr, pc}^
    781c:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    7820:	b0037470 	andlt	r7, r3, r0, ror r4
    7824:	28137c38 	ldmcsda	r3, {r3, r4, r5, sl, fp, ip, sp, lr}
    7828:	69f0d132 	ldmvsib	r0!, {r1, r4, r5, r8, ip, lr, pc}^
    782c:	02092195 	andeq	r2, r9, #1073741861	; 0x40000025
    7830:	2913e0ed 	ldmcsdb	r3, {r0, r2, r3, r5, r6, r7, sp, lr, pc}
    7834:	69f0d109 	ldmvsib	r0!, {r0, r3, r8, ip, lr, pc}^
    7838:	02092195 	andeq	r2, r9, #1073741861	; 0x40000025
    783c:	20118001 	andcss	r8, r1, r1
    7840:	20007430 	andcs	r7, r0, r0, lsr r4
    7844:	61707470 	cmnvs	r0, r0, ror r4
    7848:	7c3874f0 	cfldrsvc	mvf7, [r8], #-960
    784c:	d11f281f 	tstle	pc, pc, lsl r8
    7850:	e1612003 	cmn	r1, r3
    7854:	00009624 	andeq	r9, r0, r4, lsr #12
    7858:	000003aa 	andeq	r0, r0, sl, lsr #7
    785c:	00008a54 	andeq	r8, r0, r4, asr sl
    7860:	000003ba 	streqh	r0, [r0], -sl
    7864:	000003d5 	ldreqd	r0, [r0], -r5
    7868:	00000976 	andeq	r0, r0, r6, ror r9
    786c:	000003ce 	andeq	r0, r0, lr, asr #7
    7870:	00000ba4 	andeq	r0, r0, r4, lsr #23
    7874:	000003be 	streqh	r0, [r0], -lr
    7878:	28177c38 	ldmcsda	r7, {r3, r4, r5, sl, fp, ip, sp, lr}
    787c:	f7ffd108 	ldrnvb	sp, [pc, r8, lsl #2]!
    7880:	7c70fa4d 	ldcvcl	10, cr15, [r0], #-308
    7884:	d0302800 	eorles	r2, r0, r0, lsl #16
    7888:	d0022801 	andle	r2, r2, r1, lsl #16
    788c:	d01a2802 	andles	r2, sl, r2, lsl #16
    7890:	9804e143 	stmlsda	r4, {r0, r1, r6, r8, sp, lr, pc}
    7894:	48a27803 	stmmiia	r2!, {r0, r1, fp, ip, sp, lr}
    7898:	434b212f 	cmpmi	fp, #-1073741813	; 0xc000000b
    789c:	18c949a1 	stmneia	r9, {r0, r5, r7, r8, fp, lr}^
    78a0:	2cff5c0c 	ldccsl	12, cr5, [pc], #48
    78a4:	9804d0eb 	stmlsda	r4, {r0, r1, r3, r5, r6, r7, ip, lr, pc}
    78a8:	22007004 	andcs	r7, r0, #4	; 0x4
    78ac:	20002100 	andcs	r2, r0, r0, lsl #2
    78b0:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    78b4:	20081c21 	andcs	r1, r8, r1, lsr #24
    78b8:	f994f009 	ldmnvib	r4, {r0, r3, ip, sp, lr, pc}
    78bc:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    78c0:	b0037470 	andlt	r7, r3, r0, ror r4
    78c4:	7c38e129 	ldfvcd	f6, [r8], #-164
    78c8:	d1fb281a 	mvnles	r2, sl, lsl r8
    78cc:	78009804 	stmvcda	r0, {r2, fp, ip, pc}
    78d0:	42887cb9 	addmi	r7, r8, #47360	; 0xb900
    78d4:	7c70e7d2 	ldcvcl	7, cr14, [r0], #-840
    78d8:	d0062800 	andle	r2, r6, r0, lsl #16
    78dc:	d1012801 	tstle	r1, r1, lsl #16
    78e0:	f8caf7ff 	stmnvia	sl, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, ip, sp, lr, pc}^
    78e4:	f7ff2802 	ldrnvb	r2, [pc, r2, lsl #16]!
    78e8:	9809fa21 	stmlsda	r9, {r0, r5, r9, fp, ip, sp, lr, pc}
    78ec:	f9aaf000 	stmnvib	sl!, {ip, sp, lr, pc}
    78f0:	7c70e113 	ldfvcp	f6, [r0], #-76
    78f4:	d8fb2803 	ldmleia	fp!, {r0, r1, fp, sp}^
    78f8:	0040a101 	subeq	sl, r0, r1, lsl #2
    78fc:	448f5e09 	strmi	r5, [pc], #3593	; 0x7904
    7900:	f820ffe8 	stmnvda	r0!, {r3, r5, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
    7904:	ff760006 	swinv	0x00760006
    7908:	21002200 	tstcs	r0, r0, lsl #4
    790c:	b4072000 	strlt	r2, [r7]
    7910:	78009807 	stmvcda	r0, {r0, r1, r2, fp, ip, pc}
    7914:	4348211f 	cmpmi	r8, #-1073741817	; 0xc0000007
    7918:	180b4982 	stmneda	fp, {r1, r7, r8, fp, lr}
    791c:	2100331c 	tstcs	r0, ip, lsl r3
    7920:	f0092006 	andnv	r2, r9, r6
    7924:	9807f95f 	stmlsda	r7, {r0, r1, r2, r3, r4, r6, r8, fp, ip, sp, lr, pc}
    7928:	211f7800 	tstcs	pc, r0, lsl #16
    792c:	497d4348 	ldmmidb	sp!, {r3, r6, r8, r9, lr}^
    7930:	30231808 	eorcc	r1, r3, r8, lsl #16
    7934:	70012100 	andvc	r2, r1, r0, lsl #2
    7938:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    793c:	b0037470 	andlt	r7, r3, r0, ror r4
    7940:	7c70e0eb 	ldcvcl	0, cr14, [r0], #-940
    7944:	d0022800 	andle	r2, r2, r0, lsl #16
    7948:	d01d2801 	andles	r2, sp, r1, lsl #16
    794c:	6a70e0e5 	bvs	0x1c3fce8
    7950:	d0fb2800 	rscles	r2, fp, r0, lsl #16
    7954:	4a734974 	bmi	0x1cd9f2c
    7958:	6a491851 	bvs	0x124daa4
    795c:	4b714a73 	blmi	0x1c5a330
    7960:	2010189a 	mulcss	r0, sl, r8
    7964:	5c0b1e40 	stcpl	14, cr1, [fp], {64}
    7968:	d1fb5413 	mvnles	r5, r3, lsl r4
    796c:	21006a72 	tstcs	r0, r2, ror sl
    7970:	b4072000 	strlt	r2, [r7]
    7974:	22009b0e 	andcs	r9, r0, #14336	; 0x3800
    7978:	f009200a 	andnv	r2, r9, sl
    797c:	7c70f933 	ldcvcl	9, cr15, [r0], #-204
    7980:	74701c40 	ldrvcbt	r1, [r0], #-3136
    7984:	e0c8b003 	sbc	fp, r8, r3
    7988:	281f7c38 	ldmcsda	pc, {r3, r4, r5, sl, fp, ip, sp, lr}
    798c:	e0c0d1fb 	strd	sp, [r0], #27
    7990:	29037c71 	stmcsdb	r3, {r0, r4, r5, r6, sl, fp, ip, sp, lr}
    7994:	a202d8f7 	andge	sp, r2, #16187392	; 0xf70000
    7998:	5e520049 	cdppl	0, 5, cr0, cr2, cr9, {2}
    799c:	46c04497 	undefined
    79a0:	f782ff4a 	strnv	pc, [r2, sl, asr #30]
    79a4:	00260008 	eoreq	r0, r6, r8
    79a8:	21002200 	tstcs	r0, r0, lsl #4
    79ac:	b4072000 	strlt	r2, [r7]
    79b0:	98072300 	stmlsda	r7, {r8, r9, sp}
    79b4:	201c7801 	andcss	r7, ip, r1, lsl #16
    79b8:	f914f009 	ldmnvdb	r4, {r0, r3, ip, sp, lr, pc}
    79bc:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    79c0:	b0037470 	andlt	r7, r3, r0, ror r4
    79c4:	7c39e0a9 	ldcvc	0, cr14, [r9], #-676
    79c8:	d1fb2920 	mvnles	r2, r0, lsr #18
    79cc:	78099904 	stmvcda	r9, {r2, r8, fp, ip, pc}
    79d0:	d1102901 	tstle	r0, r1, lsl #18
    79d4:	21017a78 	tstcs	r1, r8, ror sl
    79d8:	72794301 	rsbvcs	r4, r9, #67108864	; 0x4000000
    79dc:	68004854 	stmvsda	r0, {r2, r4, r6, fp, lr}
    79e0:	6a406a80 	bvs	0x10223e8
    79e4:	68094952 	stmvsda	r9, {r1, r4, r6, r8, fp, lr}
    79e8:	6a496a89 	bvs	0x1262414
    79ec:	22017fc9 	andcs	r7, r1, #804	; 0x324
    79f0:	77c2430a 	strvcb	r4, [r2, sl, lsl #6]
    79f4:	7a79e009 	bvc	0x1e7fa20
    79f8:	72794001 	rsbvcs	r4, r9, #1	; 0x1
    79fc:	6809494c 	stmvsda	r9, {r2, r3, r6, r8, fp, lr}
    7a00:	6a496a89 	bvs	0x126242c
    7a04:	40107fca 	andmis	r7, r0, sl, asr #31
    7a08:	69f077c8 	ldmvsib	r0!, {r3, r6, r7, r8, r9, sl, ip, sp, lr}^
    7a0c:	f7ff2100 	ldrnvb	r2, [pc, r0, lsl #2]!
    7a10:	7c70f987 	ldcvcl	9, cr15, [r0], #-540
    7a14:	d8142803 	ldmleda	r4, {r0, r1, fp, sp}
    7a18:	0040a101 	subeq	sl, r0, r1, lsl #2
    7a1c:	448f5e09 	strmi	r5, [pc], #3593	; 0x7a24
    7a20:	f056fec8 	subnvs	pc, r6, r8, asr #29
    7a24:	00220006 	eoreq	r0, r2, r6
    7a28:	21002200 	tstcs	r0, r0, lsl #4
    7a2c:	b4072000 	strlt	r2, [r7]
    7a30:	21012300 	tstcs	r1, r0, lsl #6
    7a34:	f0092034 	andnv	r2, r9, r4, lsr r0
    7a38:	7c70f8d5 	ldcvcl	8, cr15, [r0], #-852
    7a3c:	74701c40 	ldrvcbt	r1, [r0], #-3136
    7a40:	e06ab003 	rsb	fp, sl, r3
    7a44:	28327c38 	ldmcsda	r2!, {r3, r4, r5, sl, fp, ip, sp, lr}
    7a48:	7c78d167 	ldfvcp	f5, [r8], #-412
    7a4c:	d1dc2850 	bicles	r2, ip, r0, asr r8
    7a50:	76302000 	ldrvct	r2, [r0], -r0
    7a54:	68004836 	stmvsda	r0, {r1, r2, r4, r5, fp, lr}
    7a58:	6a406a80 	bvs	0x1022460
    7a5c:	68094934 	stmvsda	r9, {r2, r4, r5, r8, fp, lr}
    7a60:	6a496a89 	bvs	0x126248c
    7a64:	22047fc9 	andcs	r7, r4, #804	; 0x324
    7a68:	77c2430a 	strvcb	r4, [r2, sl, lsl #6]
    7a6c:	68004830 	stmvsda	r0, {r4, r5, fp, lr}
    7a70:	6a406a80 	bvs	0x1022478
    7a74:	6809492e 	stmvsda	r9, {r1, r2, r3, r5, r8, fp, lr}
    7a78:	6a496a89 	bvs	0x12624a4
    7a7c:	22087e89 	andcs	r7, r8, #2192	; 0x890
    7a80:	7682430a 	strvc	r4, [r2], sl, lsl #6
    7a84:	7c70e7c1 	ldcvcl	7, cr14, [r0], #-772
    7a88:	28041c01 	stmcsda	r4, {r0, sl, fp, ip}
    7a8c:	a202d845 	andge	sp, r2, #4521984	; 0x450000
    7a90:	5e520049 	cdppl	0, 5, cr0, cr2, cr9, {2}
    7a94:	46c04497 	undefined
    7a98:	f298000a 	addnvs	r0, r8, #10	; 0xa
    7a9c:	003e0028 	eoreqs	r0, lr, r8, lsr #32
    7aa0:	49240058 	stmmidb	r4!, {r3, r4, r6}
    7aa4:	78529a04 	ldmvcda	r2, {r2, r9, fp, ip, pc}^
    7aa8:	435a232f 	cmpmi	sl, #-1140850688	; 0xbc000000
    7aac:	189a4b1d 	ldmneia	sl, {r0, r2, r3, r4, r8, r9, fp, lr}
    7ab0:	29015c51 	stmcsdb	r1, {r0, r4, r6, sl, fp, ip, lr}
    7ab4:	7c70d102 	ldfvcp	f5, [r0], #-8
    7ab8:	e02d1c80 	eor	r1, sp, r0, lsl #25
    7abc:	e02b1c40 	eor	r1, fp, r0, asr #24
    7ac0:	73f82000 	mvnvcs	r2, #0	; 0x0
    7ac4:	78019804 	stmvcda	r1, {r2, fp, ip, pc}
    7ac8:	98031c0a 	stmlsda	r3, {r1, r3, sl, fp, ip}
    7acc:	ff2ef008 	swinv	0x002ef008
    7ad0:	1c407c70 	mcrrne	12, 7, r7, r0, cr0
    7ad4:	f008e020 	andnv	lr, r8, r0, lsr #32
    7ad8:	2800ff1f 	stmcsda	r0, {r0, r1, r2, r3, r4, r8, r9, sl, fp, ip, sp, lr, pc}
    7adc:	9804d01d 	stmlsda	r4, {r0, r2, r3, r4, ip, lr, pc}
    7ae0:	28007880 	stmcsda	r0, {r7, fp, ip, sp, lr}
    7ae4:	2000d091 	mulcs	r0, r1, r0
    7ae8:	7c708168 	ldfvcp	f0, [r0], #-416
    7aec:	e0131c40 	ands	r1, r3, r0, asr #24
    7af0:	28027bf8 	stmcsda	r2, {r3, r4, r5, r6, r7, r8, r9, fp, ip, sp, lr}
    7af4:	e6c2d100 	strb	sp, [r2], r0, lsl #2
    7af8:	1c408968 	mcrrne	9, 6, r8, r0, cr8
    7afc:	21ff8168 	mvncss	r8, r8, ror #2
    7b00:	040031f6 	streq	r3, [r0], #-502
    7b04:	42880c00 	addmi	r0, r8, #0	; 0x0
    7b08:	69f0d307 	ldmvsib	r0!, {r0, r1, r2, r8, r9, ip, lr, pc}^
    7b0c:	02092196 	andeq	r2, r9, #-2147483611	; 0x80000025
    7b10:	f7ff8001 	ldrnvb	r8, [pc, r1]!
    7b14:	2000f8f4 	strcsd	pc, [r0], -r4
    7b18:	b0137470 	andlts	r7, r3, r0, ror r4
    7b1c:	fd56f7fe 	ldc2l	7, cr15, [r6, #-1016]
    7b20:	000003d5 	ldreqd	r0, [r0], -r5
    7b24:	00008a54 	andeq	r8, r0, r4, asr sl
    7b28:	00000ba4 	andeq	r0, r0, r4, lsr #23
    7b2c:	000003be 	streqh	r0, [r0], -lr
    7b30:	00009624 	andeq	r9, r0, r4, lsr #12
    7b34:	000003d6 	ldreqd	r0, [r0], -r6
    7b38:	1e522207 	cdpne	2, 5, cr2, cr2, cr7, {0}
    7b3c:	54835c8b 	strpl	r5, [r3], #3211
    7b40:	2007d1fb 	strcsd	sp, [r7], -fp
    7b44:	00004770 	andeq	r4, r0, r0, ror r7
    7b48:	2400b510 	strcs	fp, [r0], #-1296
    7b4c:	f00d2207 	andnv	r2, sp, r7, lsl #4
    7b50:	2800fa0b 	stmcsda	r0, {r0, r1, r3, r9, fp, ip, sp, lr, pc}
    7b54:	2401d100 	strcs	sp, [r1], #-256
    7b58:	bc101c20 	ldclt	12, cr1, [r0], {32}
    7b5c:	4708bc02 	strmi	fp, [r8, -r2, lsl #24]
    7b60:	1e52220f 	cdpne	2, 5, cr2, cr2, cr15, {0}
    7b64:	54835c8b 	strpl	r5, [r3], #3211
    7b68:	2100d1fb 	strcsd	sp, [r0, -fp]
    7b6c:	20107381 	andcss	r7, r0, r1, lsl #7
    7b70:	00004770 	andeq	r4, r0, r0, ror r7
    7b74:	1c14b5fb 	cfldr32ne	mvfx11, [r4], {251}
    7b78:	20009d08 	andcs	r9, r0, r8, lsl #26
    7b7c:	26007028 	strcs	r7, [r0], -r8, lsr #32
    7b80:	4370201f 	cmnmi	r0, #31	; 0x1f
    7b84:	180f49a4 	stmneda	pc, {r2, r5, r7, r8, fp, lr}
    7b88:	1c389900 	ldcne	9, cr9, [r8]
    7b8c:	f7ff301c 	undefined
    7b90:	2801ffdb 	stmcsda	r1, {r0, r1, r3, r4, r6, r7, r8, r9, sl, fp, ip, sp, lr, pc}
    7b94:	2023d120 	eorcs	sp, r3, r0, lsr #2
    7b98:	28005c38 	stmcsda	r0, {r3, r4, r5, sl, fp, ip, lr}
    7b9c:	0600d01c 	undefined
    7ba0:	2001d54a 	andcs	sp, r1, sl, asr #10
    7ba4:	20237028 	eorcs	r7, r3, r8, lsr #32
    7ba8:	06495c39 	undefined
    7bac:	54390e49 	ldrplt	r0, [r9], #-3657
    7bb0:	28015c38 	stmcsda	r1, {r3, r4, r5, sl, fp, ip, lr}
    7bb4:	3723d103 	strcc	sp, [r3, -r3, lsl #2]!
    7bb8:	7a004668 	bvc	0x19560
    7bbc:	2c007038 	stccs	0, cr7, [r0], {56}
    7bc0:	211fd03a 	tstcs	pc, sl, lsr r0
    7bc4:	4a944371 	bmi	0xfe518990
    7bc8:	31181851 	tstcc	r8, r1, asr r8
    7bcc:	1e402004 	cdpne	0, 4, cr2, cr0, cr4, {0}
    7bd0:	540a5c22 	strpl	r5, [sl], #-3106
    7bd4:	e02fd1fb 	strd	sp, [pc], -fp
    7bd8:	04361c76 	ldreqt	r1, [r6], #-3190
    7bdc:	2e1e0c36 	mrccs	12, 0, r0, cr14, cr6, {1}
    7be0:	2600d3ce 	strcs	sp, [r0], -lr, asr #7
    7be4:	201f498c 	andcss	r4, pc, ip, lsl #19
    7be8:	180f4370 	stmneda	pc, {r4, r5, r6, r8, r9, lr}
    7bec:	5c382023 	ldcpl	0, cr2, [r8], #-140
    7bf0:	d11c2800 	tstle	ip, r0, lsl #16
    7bf4:	70282002 	eorvc	r2, r8, r2
    7bf8:	46692023 	strmibt	r2, [r9], -r3, lsr #32
    7bfc:	54397a09 	ldrplt	r7, [r9], #-2569
    7c00:	1c389900 	ldcne	9, cr9, [r8]
    7c04:	f7ff301c 	undefined
    7c08:	9901ff97 	stmlsdb	r1, {r0, r1, r2, r4, r7, r8, r9, sl, fp, ip, sp, lr, pc}
    7c0c:	1c383708 	ldcne	7, cr3, [r8], #-32
    7c10:	ffa6f7ff 	swinv	0x00a6f7ff
    7c14:	d1d42c00 	bicles	r2, r4, r0, lsl #24
    7c18:	21002004 	tstcs	r0, r4
    7c1c:	4372221f 	cmnmi	r2, #-268435455	; 0xf0000001
    7c20:	189a4b7d 	ldmneia	sl, {r0, r2, r3, r4, r5, r6, r8, r9, fp, lr}
    7c24:	1e403218 	mcrne	2, 2, r3, cr0, cr8, {0}
    7c28:	d1fc5411 	mvnles	r5, r1, lsl r4
    7c2c:	1c76e004 	ldcnel	0, cr14, [r6], #-16
    7c30:	0c360436 	cfldrseq	mvf0, [r6], #-216
    7c34:	d3d62e1e 	bicles	r2, r6, #480	; 0x1e0
    7c38:	46c01c30 	undefined
    7c3c:	bc02bcfe 	stclt	12, cr11, [r2], {254}
    7c40:	00004708 	andeq	r4, r0, r8, lsl #14
    7c44:	1c04b5f0 	cfstr32ne	mvfx11, [r4], {240}
    7c48:	481b4d73 	ldmmida	fp, {r0, r1, r4, r5, r6, r8, sl, fp, lr}
    7c4c:	7837182e 	ldmvcda	r7!, {r1, r2, r3, r5, fp, ip}
    7c50:	18294856 	stmneda	r9!, {r1, r2, r4, r6, fp, lr}
    7c54:	2f002000 	swics	0x00002000
    7c58:	2f01d004 	swics	0x0001d004
    7c5c:	2f02d00f 	swics	0x0002d00f
    7c60:	e025d016 	eor	sp, r5, r6, lsl r0
    7c64:	29017809 	stmcsdb	r1, {r0, r3, fp, ip, sp, lr}
    7c68:	f7fed004 	ldrnvb	sp, [lr, r4]!
    7c6c:	1c7ffd19 	ldcnel	13, cr15, [pc], #-100
    7c70:	e01e7037 	ands	r7, lr, r7, lsr r0
    7c74:	78207030 	stmvcda	r0!, {r4, r5, ip, sp, lr}
    7c78:	70201c40 	eorvc	r1, r0, r0, asr #24
    7c7c:	f008e019 	andnv	lr, r8, r9, lsl r0
    7c80:	2801fe3d 	stmcsda	r1, {r0, r2, r3, r4, r5, r9, sl, fp, ip, sp, lr, pc}
    7c84:	f008d115 	andnv	sp, r8, r5, lsl r1
    7c88:	7830fe23 	ldmvcda	r0!, {r0, r1, r5, r9, sl, fp, ip, sp, lr, pc}
    7c8c:	e00f1c40 	and	r1, pc, r0, asr #24
    7c90:	2a00798a 	bcs	0x262c0
    7c94:	2201d10d 	andcs	sp, r1, #1073741827	; 0x40000003
    7c98:	7172700a 	cmnvc	r2, sl
    7c9c:	54684944 	strplbt	r4, [r8], #-2372
    7ca0:	fe16f008 	wxornv	wr15, wr6, wr8
    7ca4:	48432102 	stmmida	r3, {r1, r8, sp}^
    7ca8:	f0081828 	andnv	r1, r8, r8, lsr #16
    7cac:	e7e2fe03 	strb	pc, [r2, r3, lsl #28]!
    7cb0:	f7fe7030 	undefined
    7cb4:	46c0fc8b 	strmib	pc, [r0], fp, lsl #25
    7cb8:	00000bb7 	streqh	r0, [r0], -r7
    7cbc:	1c04b5f1 	cfstr32ne	mvfx11, [r4], {241}
    7cc0:	48354d55 	ldmmida	r5!, {r0, r2, r4, r6, r8, sl, fp, lr}
    7cc4:	90001828 	andls	r1, r0, r8, lsr #16
    7cc8:	202f7801 	eorcs	r7, pc, r1, lsl #16
    7ccc:	182e4348 	stmneda	lr!, {r3, r6, r8, r9, lr}
    7cd0:	18284832 	stmneda	r8!, {r1, r4, r5, fp, lr}
    7cd4:	18af4a34 	stmneia	pc!, {r2, r4, r5, r9, fp, lr}
    7cd8:	2a04793a 	bcs	0x1261c8
    7cdc:	a301d856 	tstge	r1, #5636096	; 0x560000
    7ce0:	449f5c9b 	ldrmi	r5, [pc], #3227	; 0x7ce8
    7ce4:	4c464004 	mcrrmi	0, 0, r4, r6, cr4
    7ce8:	20110068 	andcss	r0, r1, r8, rrx
    7cec:	d2172904 	andles	r2, r7, #65536	; 0x10000
    7cf0:	5c7149b1 	ldcpll	9, cr4, [r1], #-708
    7cf4:	d00a2900 	andle	r2, sl, r0, lsl #18
    7cf8:	183048ac 	ldmneda	r0!, {r2, r3, r5, r7, fp, lr}
    7cfc:	28017840 	stmcsda	r1, {r6, fp, ip, sp, lr}
    7d00:	7820d103 	stmvcda	r0!, {r0, r1, r8, ip, lr, pc}
    7d04:	70201c40 	eorvc	r1, r0, r0, asr #24
    7d08:	2001e042 	andcs	lr, r1, r2, asr #32
    7d0c:	68f9e03f 	ldmvsia	r9!, {r0, r1, r2, r3, r4, r5, sp, lr, pc}^
    7d10:	800a4a23 	andhi	r4, sl, r3, lsr #20
    7d14:	20007038 	andcs	r7, r0, r8, lsr r0
    7d18:	60787078 	rsbvss	r7, r8, r8, ror r0
    7d1c:	e03770f8 	ldrsh	r7, [r7], -r8
    7d20:	4a2068f9 	bmi	0x82210c
    7d24:	f7ffe7f5 	undefined
    7d28:	e031ff8d 	eors	pc, r1, sp, lsl #31
    7d2c:	f846f000 	stmnvda	r6, {ip, sp, lr, pc}^
    7d30:	2004e02e 	andcs	lr, r4, lr, lsr #32
    7d34:	22007138 	andcs	r7, r0, #14	; 0xe
    7d38:	20002100 	andcs	r2, r0, r0, lsl #2
    7d3c:	2300b407 	tstcs	r0, #117440512	; 0x7000000
    7d40:	5c31489a 	ldcpl	8, cr4, [r1], #-616
    7d44:	f008200b 	andnv	r2, r8, fp
    7d48:	b003ff4d 	andlt	pc, r3, sp, asr #30
    7d4c:	4817e020 	ldmmida	r7, {r5, sp, lr, pc}
    7d50:	79811828 	stmvcib	r1, {r3, r5, fp, ip}
    7d54:	d01b2900 	andles	r2, fp, r0, lsl #18
    7d58:	22004915 	andcs	r4, r0, #344064	; 0x54000
    7d5c:	2102546a 	tstcs	r2, sl, ror #8
    7d60:	72397001 	eorvcs	r7, r9, #1	; 0x1
    7d64:	ff36f008 	swinv	0x0036f008
    7d68:	fdaef008 	stc2	0, cr15, [lr, #32]!
    7d6c:	48112101 	ldmmida	r1, {r0, r8, sp}
    7d70:	f0081828 	andnv	r1, r8, r8, lsr #16
    7d74:	4810fd9f 	ldmmida	r0, {r0, r1, r2, r3, r4, r7, r8, sl, fp, ip, sp, lr, pc}
    7d78:	78099900 	stmvcda	r9, {r8, fp, ip, pc}
    7d7c:	4351222f 	cmpmi	r1, #-268435454	; 0xf0000002
    7d80:	22011869 	andcs	r1, r1, #6881280	; 0x690000
    7d84:	2000540a 	andcs	r5, r0, sl, lsl #8
    7d88:	e7ba7138 	undefined
    7d8c:	71382000 	teqvc	r8, r0
    7d90:	bc01bcf8 	stclt	12, cr11, [r1], {248}
    7d94:	46c04700 	strmib	r4, [r0], r0, lsl #14
    7d98:	00000977 	andeq	r0, r0, r7, ror r9
    7d9c:	00000bb8 	streqh	r0, [r0], -r8
    7da0:	0000ffe0 	andeq	pc, r0, r0, ror #31
    7da4:	0000ffdf 	ldreqd	pc, [r0], -pc
    7da8:	00000bb4 	streqh	r0, [r0], -r4
    7dac:	00000763 	andeq	r0, r0, r3, ror #14
    7db0:	00000505 	andeq	r0, r0, r5, lsl #10
    7db4:	0000076e 	andeq	r0, r0, lr, ror #14
    7db8:	000003d6 	ldreqd	r0, [r0], -r6
    7dbc:	4c16b510 	cfldr32mi	mvfx11, [r6], {16}
    7dc0:	18614914 	stmneda	r1!, {r2, r4, r8, fp, lr}^
    7dc4:	2a00780a 	bcs	0x25df4
    7dc8:	2a01d002 	bcs	0x7bdd8
    7dcc:	e01cd016 	ands	sp, ip, r6, lsl r0
    7dd0:	5ca24a79 	fstmiaspl	r2!, {s8-s128}
    7dd4:	d00d2a00 	andle	r2, sp, r0, lsl #20
    7dd8:	70082001 	andvc	r2, r8, r1
    7ddc:	21002200 	tstcs	r0, r0, lsl #4
    7de0:	b4072000 	strlt	r2, [r7]
    7de4:	48712300 	ldmmida	r1!, {r8, r9, sp}^
    7de8:	20085c21 	andcs	r5, r8, r1, lsr #24
    7dec:	fefaf008 	cdp2	0, 15, cr15, cr10, cr8, {0}
    7df0:	e00cb003 	and	fp, ip, r3
    7df4:	1c497801 	mcrrne	8, 0, r7, r9, cr1
    7df8:	e0087001 	and	r7, r8, r1
    7dfc:	5ca24a69 	fstmiaspl	r2!, {s8-s112}
    7e00:	d1042a1a 	tstle	r4, sl, lsl sl
    7e04:	700a2200 	andvc	r2, sl, r0, lsl #4
    7e08:	2000e7f4 	strcsd	lr, [r0], -r4
    7e0c:	bc107008 	ldclt	0, cr7, [r0], {8}
    7e10:	4700bc01 	strmi	fp, [r0, -r1, lsl #24]
    7e14:	00000bb9 	streqh	r0, [r0], -r9
    7e18:	00008a54 	andeq	r8, r0, r4, asr sl
    7e1c:	4c64b5f0 	cfstr64mi	mvdx11, [r4], #-960
    7e20:	1865491f 	stmneda	r5!, {r0, r1, r2, r3, r4, r8, fp, lr}^
    7e24:	4a1f7829 	bmi	0x7e5ed0
    7e28:	290018a6 	stmcsdb	r0, {r1, r2, r5, r7, fp, ip}
    7e2c:	2901d004 	stmcsdb	r1, {r2, ip, lr, pc}
    7e30:	2902d008 	stmcsdb	r2, {r3, ip, lr, pc}
    7e34:	e030d02b 	eors	sp, r0, fp, lsr #32
    7e38:	70302000 	eorvcs	r2, r0, r0
    7e3c:	e02b1c49 	eor	r1, fp, r9, asr #24
    7e40:	70311c49 	eorvcs	r1, r1, r9, asr #24
    7e44:	272f7831 	undefined
    7e48:	4a5b434f 	bmi	0x16d8b8c
    7e4c:	5dd218a2 	ldcpll	8, cr1, [r2, #648]
    7e50:	d1012a00 	tstle	r1, r0, lsl #20
    7e54:	d3f32904 	mvnles	r2, #65536	; 0x10000
    7e58:	d2122904 	andles	r2, r2, #65536	; 0x10000
    7e5c:	21002200 	tstcs	r0, r0, lsl #4
    7e60:	b4072000 	strlt	r2, [r7]
    7e64:	48512300 	ldmmida	r1, {r8, r9, sp}^
    7e68:	5c0919e1 	stcpl	9, cr1, [r9], {225}
    7e6c:	f0082008 	andnv	r2, r8, r8
    7e70:	7830feb9 	ldmvcda	r0!, {r0, r3, r4, r5, r7, r9, sl, fp, ip, sp, lr, pc}
    7e74:	70301c40 	eorvcs	r1, r0, r0, asr #24
    7e78:	1c407828 	mcrrne	8, 2, r7, r0, cr8
    7e7c:	b0037028 	andlt	r7, r3, r8, lsr #32
    7e80:	2100e00b 	tstcs	r0, fp
    7e84:	78017029 	stmvcda	r1, {r0, r3, r5, ip, sp, lr}
    7e88:	70011c49 	andvc	r1, r1, r9, asr #24
    7e8c:	4845e005 	stmmida	r5, {r0, r2, sp, lr, pc}^
    7e90:	281a5c20 	ldmcsda	sl, {r5, sl, fp, ip, lr}
    7e94:	1e49d101 	sqtnee	f5, f1
    7e98:	f7fe7029 	ldrnvb	r7, [lr, r9, lsr #32]!
    7e9c:	46c0fb97 	undefined
    7ea0:	00000bba 	streqh	r0, [r0], -sl
    7ea4:	00000976 	andeq	r0, r0, r6, ror r9
    7ea8:	4941b5f0 	stmmidb	r1, {r4, r5, r6, r7, r8, sl, ip, sp, pc}^
    7eac:	188d4a3b 	stmneia	sp, {r0, r1, r3, r4, r5, r9, fp, lr}
    7eb0:	188a3a09 	stmneia	sl, {r0, r3, r9, fp, ip, sp}
    7eb4:	18cc4b38 	stmneia	ip, {r3, r4, r5, r8, r9, fp, lr}^
    7eb8:	2b037823 	blcs	0xe5f4c
    7ebc:	a601d86a 	strge	sp, [r1], -sl, ror #16
    7ec0:	44b75cf6 	ldrmit	r5, [r7], #3318
    7ec4:	c22c1002 	eorgt	r1, ip, #2	; 0x2
    7ec8:	71d02000 	bicvcs	r2, r0, r0
    7ecc:	70202001 	eorvc	r2, r0, r1
    7ed0:	fce2f008 	stc2l	0, cr15, [r2], #32
    7ed4:	79d0e05e 	ldmvcib	r0, {r1, r2, r3, r4, r6, sp, lr, pc}^
    7ed8:	71d01c40 	bicvcs	r1, r0, r0, asr #24
    7edc:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    7ee0:	d3572865 	cmple	r7, #6619136	; 0x650000
    7ee4:	fcdaf008 	ldc2l	0, cr15, [sl], {8}
    7ee8:	80282000 	eorhi	r2, r8, r0
    7eec:	70202002 	eorvc	r2, r0, r2
    7ef0:	8828e050 	stmhida	r8!, {r4, r6, sp, lr, pc}
    7ef4:	80281c40 	eorhi	r1, r8, r0, asr #24
    7ef8:	04004a29 	streq	r4, [r0], #-2601
    7efc:	42900c00 	addmis	r0, r0, #0	; 0x0
    7f00:	4828d203 	stmmida	r8!, {r0, r1, r9, ip, lr, pc}
    7f04:	28145c08 	ldmcsda	r4, {r3, sl, fp, ip, lr}
    7f08:	4827d144 	stmmida	r7!, {r2, r6, r8, ip, lr, pc}
    7f0c:	4b282200 	blmi	0xa10714
    7f10:	1e803308 	cdpne	3, 8, cr3, cr0, cr8, {0}
    7f14:	d1fc521a 	mvnles	r5, sl, lsl r2
    7f18:	4a242000 	bmi	0x90ff20
    7f1c:	25001889 	strcs	r1, [r0, #-2185]
    7f20:	23074f23 	tstcs	r7, #140	; 0x8c
    7f24:	4342222f 	cmpmi	r2, #-268435454	; 0xf0000002
    7f28:	19be4e22 	ldmneib	lr!, {r1, r5, r9, sl, fp, lr}
    7f2c:	1e5b18b2 	mrcne	8, 2, r1, cr11, cr2, {5}
    7f30:	d1fc54d5 	ldrlesb	r5, [ip, #69]!
    7f34:	222f2310 	eorcs	r2, pc, #1073741824	; 0x40000000
    7f38:	4e1f4342 	cdpmi	3, 1, cr4, cr15, cr2, {2}
    7f3c:	18b219be 	ldmneia	r2!, {r1, r2, r3, r4, r5, r7, r8, fp, ip}
    7f40:	54d51e5b 	ldrplb	r1, [r5], #3675
    7f44:	2304d1fc 	tstcs	r4, #63	; 0x3f
    7f48:	4342222f 	cmpmi	r2, #-268435454	; 0xf0000002
    7f4c:	19be4e1b 	ldmneib	lr!, {r0, r1, r3, r4, r9, sl, fp, lr}
    7f50:	1e5b18b2 	mrcne	8, 2, r1, cr11, cr2, {5}
    7f54:	d1fc54d5 	ldrlesb	r5, [ip, #69]!
    7f58:	222f2310 	eorcs	r2, pc, #1073741824	; 0x40000000
    7f5c:	4e184342 	cdpmi	3, 1, cr4, cr8, cr2, {2}
    7f60:	18b219be 	ldmneia	r2!, {r1, r2, r3, r4, r5, r7, r8, fp, ip}
    7f64:	54d51e5b 	ldrplb	r1, [r5], #3675
    7f68:	222fd1fc 	eorcs	sp, pc, #63	; 0x3f
    7f6c:	23ff4342 	mvncss	r4, #134217729	; 0x8000001
    7f70:	1c4b548b 	cfstrdne	mvd5, [fp], {139}
    7f74:	1c8b549d 	cfstrsne	mvf5, [fp], {157}
    7f78:	1c40549d 	cfstrdne	mvd5, [r0], {157}
    7f7c:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    7f80:	d3ce2804 	bicle	r2, lr, #262144	; 0x40000
    7f84:	e7b22003 	ldr	r2, [r2, r3]!
    7f88:	70112101 	andvcs	r2, r1, r1, lsl #2
    7f8c:	78017061 	stmvcda	r1, {r0, r5, r6, ip, sp, lr}
    7f90:	70011c49 	andvc	r1, r1, r9, asr #24
    7f94:	fb1af7fe 	blx	0x6c5f96
    7f98:	00000bbb 	streqh	r0, [r0], -fp
    7f9c:	0000076c 	andeq	r0, r0, ip, ror #14
    7fa0:	000007d1 	ldreqd	r0, [r0], -r1
    7fa4:	00000486 	andeq	r0, r0, r6, lsl #9
    7fa8:	000003a2 	andeq	r0, r0, r2, lsr #7
    7fac:	000003d5 	ldreqd	r0, [r0], -r5
    7fb0:	00008a54 	andeq	r8, r0, r4, asr sl
    7fb4:	000003ce 	andeq	r0, r0, lr, asr #7
    7fb8:	000003aa 	andeq	r0, r0, sl, lsr #7
    7fbc:	000003ba 	streqh	r0, [r0], -sl
    7fc0:	000003be 	streqh	r0, [r0], -lr
    7fc4:	b084b5fc 	strltd	fp, [r4], ip
    7fc8:	990c1c0c 	stmlsdb	ip, {r2, r3, sl, fp, ip}
    7fcc:	02122294 	andeqs	r2, r2, #1073741833	; 0x40000009
    7fd0:	801a466b 	andhis	r4, sl, fp, ror #12
    7fd4:	4a5c800a 	bmi	0x1728004
    7fd8:	189d4b62 	ldmneia	sp, {r1, r5, r6, r8, r9, fp, lr}
    7fdc:	2b117c2b 	blcs	0x467090
    7fe0:	2b0ad003 	blcs	0x2bbff4
    7fe4:	2802d145 	stmcsda	r2, {r0, r2, r6, r8, ip, lr, pc}
    7fe8:	466ad143 	strmibt	sp, [sl], -r3, asr #2
    7fec:	80162600 	andhis	r2, r6, r0, lsl #12
    7ff0:	800a2201 	andhi	r2, sl, r1, lsl #4
    7ff4:	4a5561e9 	bmi	0x15607a0
    7ff8:	92026812 	andls	r6, r2, #1179648	; 0x120000
    7ffc:	4e594a54 	mrcmi	10, 2, r4, cr9, cr4, {2}
