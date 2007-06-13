
samba.fw:     file format binary

Disassembly of section .data:

00000000 <.data>:
       0:	ea000013 	b	0x54
       4:	eafffffe 	b	0x4
       8:	ea000054 	b	0x160
       c:	eafffffe 	b	0xc
      10:	eafffffe 	b	0x10
      14:	eafffffe 	b	0x14
      18:	eafffffe 	b	0x18
      1c:	e599820c 	ldr	v5, [v6, #524]
      20:	e3a0d004 	mov	SP, #4	; 0x4
      24:	e58bd128 	str	SP, [v8, #296]
      28:	e59ad04c 	ldr	SP, [v7, #76]
      2c:	e59cd004 	ldr	SP, [IP, #4]
      30:	e21dd001 	ands	SP, SP, #1	; 0x1
      34:	125ef004 	subnes	PC, LR, #4	; 0x4
      38:	e59ad03c 	ldr	SP, [v7, #60]
      3c:	e21ddf80 	ands	SP, SP, #512	; 0x200
      40:	01cc80b0 	streqh	v5, [IP]
      44:	11cc80b2 	strneh	v5, [IP, #2]
      48:	13a0d001 	movne	SP, #1	; 0x1
      4c:	158cd004 	strne	SP, [IP, #4]
      50:	e25ef004 	subs	PC, LR, #4	; 0x4
      54:	e10f0000 	mrs	a1, CPSR
      58:	e321f0d1 	msr	CPSR_c, #209	; 0xd1
      5c:	e28f200c 	add	a3, PC, #12	; 0xc
      60:	e8921e00 	ldmia	a3, {v6, v7, v8, IP}
      64:	e3c00040 	bic	a1, a1, #64	; 0x40
      68:	e121f000 	msr	CPSR_c, a1
      6c:	ea000003 	b	0x80
      70:	fffcc000 	swinv	0x00fcc000
      74:	fffff400 	swinv	0x00fff400
      78:	fffff000 	swinv	0x00fff000
      7c:	00200f44 	eoreq	a1, a1, v1, asr #30
      80:	e59fd0f4 	ldr	SP, [pc, #244]	; 0x17c
      84:	e3e010ff 	mvn	a2, #255	; 0xff
      88:	e59f00f0 	ldr	a1, [pc, #240]	; 0x180
      8c:	e5810060 	str	a1, [a2, #96]
      90:	e59f10ec 	ldr	a2, [pc, #236]	; 0x184
      94:	e3a00002 	mov	a1, #2	; 0x2
      98:	e5810020 	str	a1, [a2, #32]
      9c:	e3a0002d 	mov	a1, #45	; 0x2d
      a0:	e2500001 	subs	a1, a1, #1	; 0x1
      a4:	8afffffd 	bhi	0xa0
      a8:	e3a04b40 	mov	v1, #65536	; 0x10000
      ac:	e5913024 	ldr	a4, [a2, #36]
      b0:	e0043003 	and	a4, v1, a4
      b4:	e3530b40 	cmp	a4, #65536	; 0x10000
      b8:	0a000006 	beq	0xd8
      bc:	e59f00c4 	ldr	a1, [pc, #196]	; 0x188
      c0:	e5810020 	str	a1, [a2, #32]
      c4:	e3a04001 	mov	v1, #1	; 0x1
      c8:	e5913068 	ldr	a4, [a2, #104]
      cc:	e0043003 	and	a4, v1, a4
      d0:	e3530001 	cmp	a4, #1	; 0x1
      d4:	1afffffb 	bne	0xc8
      d8:	e3a00001 	mov	a1, #1	; 0x1
      dc:	e5810030 	str	a1, [a2, #48]
      e0:	e3a04008 	mov	v1, #8	; 0x8
      e4:	e5913068 	ldr	a4, [a2, #104]
      e8:	e0043003 	and	a4, v1, a4
      ec:	e3530008 	cmp	a4, #8	; 0x8
      f0:	1afffffb 	bne	0xe4
      f4:	e3a00000 	mov	a1, #0	; 0x0
      f8:	e3a01d50 	mov	a2, #5120	; 0x1400
      fc:	e3a02980 	mov	a3, #2097152	; 0x200000
     100:	e490a004 	ldr	v7, [a1], #4
     104:	e482a004 	str	v7, [a3], #4
     108:	e1500001 	cmp	a1, a2
     10c:	3afffffb 	bcc	0x100
     110:	e28f202c 	add	a3, PC, #44	; 0x2c
     114:	e892001b 	ldmia	a3, {a1, a2, a4, v1}
     118:	e1500001 	cmp	a1, a2
     11c:	0a000003 	beq	0x130
     120:	e1510003 	cmp	a2, a4
     124:	34902004 	ldrcc	a3, [a1], #4
     128:	34812004 	strcc	a3, [a2], #4
     12c:	3afffffb 	bcc	0x120
     130:	e3a02000 	mov	a3, #0	; 0x0
     134:	e1530004 	cmp	a4, v1
     138:	34832004 	strcc	a3, [a4], #4
     13c:	3afffffc 	bcc	0x134
     140:	ea000003 	b	0x154
     144:	00200f2c 	eoreq	a1, a1, IP, lsr #30
     148:	00200f2c 	eoreq	a1, a1, IP, lsr #30
     14c:	00200f3c 	eoreq	a1, a1, IP, lsr PC
     150:	00200f84 	eoreq	a1, a1, v1, lsl #31
     154:	e59f0030 	ldr	a1, [pc, #48]	; 0x18c
     158:	e1a0e00f 	mov	LR, PC
     15c:	e12fff10 	bx	a1
     160:	e59f0028 	ldr	a1, [pc, #40]	; 0x190
     164:	e1a0e00f 	mov	LR, PC
     168:	e12fff10 	bx	a1
     16c:	eafffffe 	b	0x16c
     170:	e59fe01c 	ldr	LR, [pc, #28]	; 0x194
     174:	e12fff10 	bx	a1
     178:	eafffffe 	b	0x178
     17c:	00202000 	eoreq	a3, a1, a1
     180:	00340100 	eoreqs	a1, v1, a1, lsl #2
     184:	fffffc00 	swinv	0x00fffc00
     188:	00004001 	andeq	v1, a1, a2
     18c:	0020038d 	eoreq	a1, a1, SP, lsl #7
     190:	00200c9b 	mlaeq	a1, v8, IP, a1
     194:	00200160 	eoreq	a1, a1, a1, ror #2
     198:	b4104998 	ldrlt	v1, [a1], #-2456
     19c:	60882001 	addvs	a3, v5, a2
     1a0:	22004897 	andcs	v1, a1, #9895936	; 0x970000
     1a4:	20016082 	andcs	v3, a2, a3, lsl #1
     1a8:	42430280 	submi	a1, a4, #8	; 0x8
     1ac:	48956158 	ldmmiia	v2, {a4, v1, v3, v5, SP, LR}
     1b0:	62812104 	addvs	a3, a2, #1	; 0x1
     1b4:	68446804 	stmvsda	v1, {a3, v8, SP, LR}^
     1b8:	009c6302 	addeqs	v3, IP, a3, lsl #6
     1bc:	4a9160a2 	bmi	0xfe45844c
     1c0:	60513240 	subvss	a4, a2, a1, asr #4
     1c4:	4a906241 	bmi	0xfe418ad0
     1c8:	605001c8 	subvss	a1, a1, v5, asr #3
     1cc:	bc106159 	ldflts	f6, [a1], {89}
     1d0:	b4f04770 	ldrltbt	v1, [a1], #1904
     1d4:	6843488d 	stmvsda	a4, {a1, a3, a4, v4, v8, LR}^
     1d8:	2504488b 	strcs	v1, [v1, #-2187]
     1dc:	3c401c04 	mcrrcc	12, 0, a2, a1, cr4
     1e0:	2b002201 	blcs	0x89ec
     1e4:	d11d498a 	tstle	SP, v7, lsl #19
     1e8:	610b424b 	tstvs	v8, v8, asr #4
     1ec:	0c034e84 	stceq	14, cr4, [a4], {132}
     1f0:	4b8260b3 	blmi	0xfe0984c4
     1f4:	1c0b605a 	stcne	0, cr6, [v8], {90}
     1f8:	0253611d 	subeqs	v3, a4, #1073741831	; 0x40000007
     1fc:	60236163 	eorvs	v3, a4, a4, ror #2
     200:	6306424e 	tstvs	v3, #-536870908	; 0xe0000004
     204:	4f836066 	swimi	0x00836066
     208:	60fe1306 	rscvss	a2, LR, v3, lsl #6
     20c:	008f2620 	addeq	a3, PC, a1, lsr #12
     210:	4e7c60be 	mrcmi	0, 3, v3, cr12, cr14, {5}
     214:	60353640 	eorvss	a4, v2, a1, asr #12
     218:	62354e7a 	eorvss	v1, v2, #1952	; 0x7a0
     21c:	600368c6 	andvs	v3, a4, v3, asr #17
     220:	605a4b7a 	subvss	v1, v7, v7, ror v8
     224:	685e4b79 	ldmvsda	LR, {a1, a4, v1, v2, v3, v5, v6, v8, LR}^
     228:	37084f78 	smlsdxcc	v5, v5, PC, v1
     22c:	d1692e01 	cmnle	v6, a2, lsl #28
     230:	1c3c6878 	ldcne	8, cr6, [IP], #-480
     234:	d0642800 	rsble	a3, v1, a1, lsl #16
     238:	1c3d8860 	ldcne	8, cr8, [SP], #-384
     23c:	1b40882d 	blne	0x10222f8
     240:	4d730400 	cfldrdmi	mvd0, [a4]
     244:	27ad0c00 	strcs	a1, [SP, a1, lsl #24]!
     248:	354000ff 	strccb	a1, [a1, #-255]
     24c:	801842b8 	ldrhih	v1, [v5], -v5
     250:	d2464e71 	suble	v1, v3, #1808	; 0x710
     254:	d2012888 	andle	a3, a2, #8912896	; 0x880000
     258:	e0234870 	eor	v1, a4, a1, ror v5
     25c:	3a881c02 	bcc	0xfe20726c
     260:	d2012a48 	andle	a3, a2, #294912	; 0x48000
     264:	e01d486e 	ands	v1, SP, LR, ror #16
     268:	3ad01c02 	bcc	0xff407278
     26c:	d2012ad0 	andle	a3, a2, #851968	; 0xd0000
     270:	e017486c 	ands	v1, v4, IP, ror #16
     274:	3aff1c02 	bcc	0xfffc7284
     278:	2a883aa1 	bcs	0xfe20ed04
     27c:	486ad201 	stmmida	v7!, {a1, v6, IP, LR, PC}^
     280:	2245e010 	subcs	LR, v2, #16	; 0x10
     284:	27ff00d2 	undefined
     288:	1a8237e9 	bne	0xfe08e234
     28c:	d20142ba 	andle	v1, a2, #-1610612725	; 0xa000000b
     290:	e0074866 	and	v1, v4, v3, ror #16
     294:	01122241 	tsteq	a3, a2, asr #4
     298:	22ff1a80 	rsccss	a2, PC, #524288	; 0x80000
     29c:	42903259 	addmis	a4, a1, #-1879048187	; 0x90000005
     2a0:	4863d201 	stmmida	a4!, {a1, v6, IP, LR, PC}^
     2a4:	200062c8 	andcs	v3, a1, v5, asr #5
     2a8:	07526aaa 	ldreqb	v3, [a3, -v7, lsr #21]
     2ac:	1c02d403 	cfstrsne	mvf13, [a3], {3}
     2b0:	42b23001 	adcmis	a4, a3, #1	; 0x1
     2b4:	2009d3f8 	strcsd	SP, [v6], -v5
     2b8:	20006308 	andcs	v3, a1, v5, lsl #6
     2bc:	07126aaa 	ldreq	v3, [a3, -v7, lsr #21]
     2c0:	1c02d403 	cfstrsne	mvf13, [a3], {3}
     2c4:	42b23001 	adcmis	a4, a3, #1	; 0x1
     2c8:	200bd3f8 	strcsd	SP, [v8], -v5
     2cc:	20006308 	andcs	v3, a1, v5, lsl #6
     2d0:	07096aa9 	streq	v3, [v6, -v6, lsr #21]
     2d4:	1c01d403 	cfstrsne	mvf13, [a2], {3}
     2d8:	42b13001 	adcmis	a4, a2, #1	; 0x1
     2dc:	2002d3f8 	strcsd	SP, [a3], -v5
     2e0:	630ae00c 	tstvs	v7, #12	; 0xc
     2e4:	6aaa2000 	bvs	0xfea882ec
     2e8:	d4030712 	strle	a1, [a4], #-1810
     2ec:	30011c02 	andcc	a2, a2, a3, lsl #24
     2f0:	d3f842b2 	mvnles	v1, #536870923	; 0x2000000b
     2f4:	0200203f 	andeq	a3, a1, #63	; 0x3f
     2f8:	200362c8 	andcs	v3, a4, v5, asr #5
     2fc:	20006058 	andcs	v3, a1, v5, asr a1
     300:	e0406060 	sub	v3, a1, a1, rrx
     304:	6859e7ff 	ldmvsda	v6, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, SP, LR, PC}^
     308:	d10a2902 	tstle	v7, a3, lsl #18
     30c:	28006878 	stmcsda	a1, {a4, v1, v2, v3, v8, SP, LR}
     310:	8878d039 	ldmhida	v5!, {a1, a4, v1, v2, IP, LR, PC}^
     314:	1a408839 	bne	0x1022400
     318:	20008018 	andcs	v5, a1, v5, lsl a1
     31c:	20036078 	andcs	v3, a4, v5, ror a1
     320:	6859e02c 	ldmvsda	v6, {a3, a4, v2, SP, LR, PC}^
     324:	d1102903 	tstle	a1, a4, lsl #18
     328:	63010249 	tstvs	a2, #-1879048188	; 0x90000004
     32c:	48396061 	ldmmida	v6!, {a1, v2, v3, SP, LR}
     330:	600121ac 	andvs	a3, a2, IP, lsr #3
     334:	31408819 	cmpcc	a1, v6, lsl v5
     338:	620109c9 	andvs	a1, a2, #3293184	; 0x324000
     33c:	01892123 	orreq	a3, v6, a4, lsr #2
     340:	21506041 	cmpcs	a1, a2, asr #32
     344:	605d6001 	subvss	v3, SP, a2
     348:	6858e01d 	ldmvsda	v5, {a1, a3, a4, v1, SP, LR, PC}^
     34c:	d11a2804 	tstle	v7, v1, lsl #16
     350:	69484930 	stmvsdb	v5, {v1, v2, v5, v8, LR}^
     354:	0f400600 	swieq	0x00400600
     358:	6988d004 	stmvsib	v5, {a3, IP, LR, PC}
     35c:	300120ff 	strccd	a3, [a2], -PC
     360:	e00f6008 	and	v3, PC, v5
     364:	07c06948 	streqb	v3, [a1, v5, asr #18]
     368:	6988d50d 	stmvsib	v5, {a1, a3, a4, v5, v7, IP, LR, PC}
     36c:	d1072823 	tstle	v4, a4, lsr #16
     370:	07806948 	streq	v3, [a1, v5, asr #18]
     374:	203ed5fc 	ldrcssh	SP, [LR], -IP
     378:	200561c8 	andcs	v3, v2, v5, asr #3
     37c:	e0026058 	and	v3, a3, v5, asr a1
     380:	d0002880 	andle	a3, a1, a1, lsl #17
     384:	6858605a 	ldmvsda	v5, {a2, a4, v1, v3, SP, LR}^
     388:	4770bcf0 	undefined
     38c:	4829b510 	stmmida	v6!, {v1, v5, v7, IP, SP, PC}
     390:	2400491f 	strcs	v1, [a1], #-2335
     394:	4a1e62c8 	bmi	0x798ebc
     398:	32404b1f 	subcc	v1, a1, #31744	; 0x7c00
     39c:	07406a90 	undefined
     3a0:	1c20d403 	cfstrsne	mvf13, [a1], #-12
     3a4:	42983401 	addmis	a4, v5, #16777216	; 0x1000000
     3a8:	2001d3f8 	strcsd	SP, [a2], -v5
     3ac:	03c04a22 	biceq	v1, a1, #139264	; 0x22000
     3b0:	4a216050 	bmi	0x8584f8
     3b4:	3a404821 	bcc	0x1012440
     3b8:	48166090 	ldmmida	v3, {v1, v4, SP, LR}
     3bc:	68003040 	stmvsda	a1, {v3, IP, SP}
     3c0:	42904a1f 	addmis	v1, a1, #126976	; 0x1f000
     3c4:	2080d009 	addcs	SP, a1, v6
     3c8:	01006008 	tsteq	a1, v5
     3cc:	490e6108 	stmmidb	LR, {a4, v5, SP, LR}
     3d0:	39400140 	stmccdb	a1, {v3, v5}^
     3d4:	61086008 	tstvs	v5, v5
     3d8:	490c6348 	stmmidb	IP, {a4, v3, v5, v6, SP, LR}
     3dc:	31082000 	tstcc	v5, a1
     3e0:	80488008 	subhi	v5, v5, v5
     3e4:	48176048 	ldmmida	v4, {a4, v3, SP, LR}
     3e8:	f92bf000 	stmnvdb	v8!, {IP, SP, LR, PC}
     3ec:	48174916 	ldmmida	v4, {a2, a3, v1, v5, v8, LR}
     3f0:	fb2bf000 	blx	0xafc3fa
     3f4:	bc08bc10 	stclt	12, cr11, [v5], {16}
     3f8:	00004718 	andeq	v1, a1, v5, lsl v4
     3fc:	fffcc000 	swinv	0x00fcc000
     400:	fffcc200 	swinv	0x00fcc200
     404:	fffff100 	swinv	0x00fff100
     408:	fffff440 	swinv	0x00fff440
     40c:	00200f3c 	eoreq	a1, a1, IP, lsr PC
     410:	fffffc00 	swinv	0x00fffc00
     414:	fffff200 	swinv	0x00fff200
     418:	000f4240 	andeq	v1, PC, a1, asr #4
     41c:	004f3f01 	subeq	a4, PC, a2, lsl #30
     420:	00273f01 	eoreq	a4, v4, a2, lsl #30
     424:	001a3f01 	andeqs	a4, v7, a2, lsl #30
     428:	001abf01 	andeqs	v8, v7, a2, lsl #30
     42c:	00093f01 	andeq	a4, v6, a2, lsl #30
     430:	0009bf01 	andeq	v8, v6, a2, lsl #30
     434:	10483f0e 	subne	a4, v5, LR, lsl #30
     438:	fffffd40 	swinv	0x00fffd40
     43c:	a5000401 	strge	a1, [a1, #-1025]
     440:	27080340 	strcs	a1, [v5, -a1, asr #6]
     444:	00200f64 	eoreq	a1, a1, v1, ror #30
     448:	fffb0000 	swinv	0x00fb0000
     44c:	00200f6c 	eoreq	a1, a1, IP, ror #30
     450:	40480200 	submi	a1, v5, a1, lsl #4
     454:	21004ab3 	strcsh	v1, [a1, -a4]
     458:	d5020403 	strle	a1, [a3, #-1027]
     45c:	40500040 	submis	a1, a1, a1, asr #32
     460:	0040e000 	subeq	LR, a1, a1
     464:	04093101 	streq	a4, [v6], #-257
     468:	0c000400 	cfstrseq	mvf0, [a1], {0}
     46c:	29080c09 	stmcsdb	v5, {a1, a4, v7, v8}
     470:	4770d3f2 	undefined
     474:	694a49ac 	stmvsdb	v7, {a3, a4, v2, v4, v5, v8, LR}^
     478:	d5fc0792 	ldrleb	a1, [IP, #1938]!
     47c:	477061c8 	ldrmib	v3, [a1, -v5, asr #3]!
     480:	49a948aa 	stmmiib	v6!, {a2, a4, v2, v4, v8, LR}
     484:	3801e000 	stmccda	a2, {SP, LR, PC}
     488:	07d2694a 	ldreqb	v3, [a3, v7, asr #18]
     48c:	2800d402 	stmcsda	a1, {a2, v7, IP, LR, PC}
     490:	e005d1f9 	strd	SP, [v2], -v6
     494:	d0032800 	andle	a3, a4, a1, lsl #16
     498:	06006988 	streq	v3, [a1], -v5, lsl #19
     49c:	47700e00 	ldrmib	a1, [a1, -a1, lsl #28]!
     4a0:	200149a3 	andcs	v1, a2, a4, lsr #19
     4a4:	20ff7048 	rsccss	v4, PC, v5, asr #32
     4a8:	b5f34770 	ldrltb	v1, [a4, #1904]!
     4ac:	26001c0f 	strcs	a2, [a1], -PC, lsl #24
     4b0:	e01e2400 	ands	a3, LR, a1, lsl #8
     4b4:	ffe4f7ff 	swinv	0x00e4f7ff
     4b8:	1c054a9d 	stcne	10, cr4, [v2], {157}
     4bc:	28007850 	stmcsda	a1, {v1, v3, v8, IP, SP, LR}
     4c0:	2001d003 	andcs	SP, a2, a4
     4c4:	bc08bcfc 	stclt	12, cr11, [v5], {252}
     4c8:	1c314718 	ldcne	7, cr4, [a2], #-96
     4cc:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
     4d0:	4a97ffbf 	bmi	0xfe6003d4
     4d4:	78111c06 	ldmvcda	a2, {a2, a3, v7, v8, IP}
     4d8:	43086850 	tstmi	v5, #5242880	; 0x500000
     4dc:	9800d008 	stmlsda	a1, {a4, IP, LR, PC}
     4e0:	30017005 	andcc	v4, a2, v2
     4e4:	2f809000 	swics	0x00809000
     4e8:	6850d102 	ldmvsda	a1, {a2, v5, IP, LR, PC}^
     4ec:	60503801 	subvss	a4, a1, a2, lsl #16
     4f0:	42bc3401 	adcmis	a4, IP, #16777216	; 0x1000000
     4f4:	1c30d3de 	ldcne	3, cr13, [a1], #-888
     4f8:	b5f8e7e4 	ldrltb	LR, [v5, #2020]!
     4fc:	20001c06 	andcs	a2, a1, v3, lsl #24
     500:	1c0c4f8b 	stcne	15, cr4, [IP], {139}
     504:	70782900 	rsbvcs	a3, v5, a1, lsl #18
     508:	2101d102 	tstcs	a2, a3, lsl #2
     50c:	e0017039 	and	v4, a2, v6, lsr a1
     510:	7038607c 	eorvcs	v3, v5, IP, ror a1
     514:	d0030661 	andle	a1, a4, a2, ror #12
     518:	31801c21 	orrcc	a2, a1, a2, lsr #24
     51c:	01e409cc 	mvneq	a1, IP, asr #19
     520:	f7ff2500 	ldrnvb	a3, [PC, a1, lsl #10]!
     524:	4f82ffad 	swimi	0x0082ffad
     528:	29007879 	stmcsdb	a1, {a1, a4, v1, v2, v3, v8, IP, SP, LR}
     52c:	2000d00b 	andcs	SP, a1, v8
     530:	f7ff7078 	undefined
     534:	7879ffa5 	ldmvcda	v6!, {a1, a3, v2, v4, v5, v6, v7, v8, IP, SP, LR, PC}^
     538:	d0042900 	andle	a3, v1, a1, lsl #18
     53c:	70782000 	rsbvcs	a3, v5, a1
     540:	bc08bcf8 	stclt	12, cr11, [v5], {248}
     544:	28154718 	ldmcsda	v2, {a4, v1, v5, v6, v7, LR}
     548:	2843d005 	stmcsda	a4, {a1, a3, IP, LR, PC}^
     54c:	2871d003 	ldmcsda	a2!, {a1, a2, IP, LR, PC}^
     550:	2d00d0f6 	stccs	0, cr13, [a1, #-984]
     554:	2700d0e5 	strcs	SP, [a1, -v2, ror #1]
     558:	1c292501 	cfstr32ne	mvfx2, [v6], #-4
     55c:	f0001c30 	andnv	a2, a1, a1, lsr IP
     560:	4973f878 	ldmmidb	a4!, {a4, v1, v2, v3, v8, IP, SP, LR, PC}^
     564:	78490600 	stmvcda	v6, {v6, v7}^
     568:	29000e00 	stmcsdb	a1, {v6, v7, v8}
     56c:	4970d003 	ldmmidb	a1!, {a1, a2, IP, LR, PC}^
     570:	70482000 	subvc	a3, v5, a1
     574:	2804e7e4 	stmcsda	v1, {a3, v2, v3, v4, v5, v6, v7, SP, LR, PC}
     578:	2806d003 	stmcsda	v3, {a1, a2, IP, LR, PC}
     57c:	2815d00b 	ldmcsda	v2, {a1, a2, a4, IP, LR, PC}
     580:	2700d001 	strcs	SP, [a1, -a2]
     584:	2c0043ff 	stccs	3, cr4, [a1], {255}
     588:	2004d10b 	andcs	SP, v1, v8, lsl #2
     58c:	ff72f7ff 	swinv	0x0072f7ff
     590:	ff76f7ff 	swinv	0x0076f7ff
     594:	3501e007 	strcc	LR, [a2, #-7]
     598:	0e2d062d 	cfmadda32eq	mvax1, mvax0, mvfx13, mvfx13
     59c:	36803c80 	strcc	a4, [a1], a1, lsl #25
     5a0:	2f00e7f1 	swics	0x0000e7f1
     5a4:	4962d0d9 	stmmidb	a3!, {a1, a4, v1, v3, v4, IP, LR, PC}^
     5a8:	70082000 	andvc	a3, v5, a1
     5ac:	b5f8e7c8 	ldrltb	LR, [v5, #1992]!
     5b0:	485e1c06 	ldmmida	LR, {a2, a3, v7, v8, IP}^
     5b4:	90004a5e 	andls	v1, a1, LR, asr v7
     5b8:	27642000 	strcsb	a3, [v1, -a1]!
     5bc:	24002501 	strcs	a3, [a1], #-1281
     5c0:	70502900 	subvcs	a3, a1, a1, lsl #18
     5c4:	2001d101 	andcs	SP, a2, a2, lsl #2
     5c8:	4a59e002 	bmi	0x16785d8
     5cc:	60512000 	subvss	a3, a2, a1
     5d0:	20437010 	subcs	v4, a4, a1, lsl a1
     5d4:	ff4ef7ff 	swinv	0x004ef7ff
     5d8:	98004a53 	stmlsda	a1, {a1, a2, v1, v3, v6, v8, LR}
     5dc:	3801e000 	stmccda	a2, {SP, LR, PC}
     5e0:	07c96951 	undefined
     5e4:	2800d402 	stmcsda	a1, {a2, v7, IP, LR, PC}
     5e8:	e001d1f9 	strd	SP, [a2], -v6
     5ec:	d1042800 	tstle	v1, a1, lsl #16
     5f0:	d1ee3f01 	mvnle	a4, a2, lsl #30
     5f4:	bc08bcf8 	stclt	12, cr11, [v5], {248}
     5f8:	4f4d4718 	swimi	0x004d4718
     5fc:	ff40f7ff 	swinv	0x0040f7ff
     600:	29007879 	stmcsdb	a1, {a1, a4, v1, v2, v3, v8, IP, SP, LR}
     604:	2801d112 	stmcsda	a2, {a2, v1, v5, IP, LR, PC}
     608:	2804d009 	stmcsda	v1, {a1, a4, IP, LR, PC}
     60c:	2006d104 	andcs	SP, v3, v1, lsl #2
     610:	ff30f7ff 	swinv	0x0030f7ff
     614:	d0f12c00 	rscles	a3, a2, a1, lsl #24
     618:	70382000 	eorvcs	a3, v5, a1
     61c:	1c29e7ea 	stcne	7, cr14, [v6], #-936
     620:	f0001c30 	andnv	a2, a1, a1, lsr IP
     624:	7879f848 	ldmvcda	v6!, {a4, v3, v8, IP, SP, LR, PC}^
     628:	d0022900 	andle	a3, a3, a1, lsl #18
     62c:	70782000 	rsbvcs	a3, v5, a1
     630:	2800e7e0 	stmcsda	a1, {v2, v3, v4, v5, v6, v7, SP, LR, PC}
     634:	3501d1f0 	strcc	SP, [a2, #-496]
     638:	0e2d062d 	cfmadda32eq	mvax1, mvax0, mvfx13, mvfx13
     63c:	34803680 	strcc	a4, [a1], #1664
     640:	493ce7dc 	ldmmidb	IP!, {a3, a4, v1, v3, v4, v5, v6, v7, SP, LR, PC}
     644:	60014a3a 	andvs	v1, a2, v7, lsr v7
     648:	6041493b 	subvs	v1, a2, v8, lsr v6
     64c:	70512100 	subvcs	a3, a2, a1, lsl #2
     650:	b5f04770 	ldrltb	v1, [a1, #1904]!
     654:	1c0c1c07 	stcne	12, cr1, [IP], {7}
     658:	20012600 	andcs	a3, a2, a1, lsl #12
     65c:	ff0af7ff 	swinv	0x000af7ff
     660:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
     664:	43e0ff07 	mvnmi	PC, #28	; 0x1c
     668:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
     66c:	ff02f7ff 	swinv	0x0002f7ff
     670:	492f2500 	stmmidb	PC!, {v5, v7, SP}
     674:	6848780a 	stmvsda	v5, {a2, a4, v8, IP, SP, LR}^
     678:	d0044302 	andle	v1, v1, a3, lsl #6
     67c:	3701783c 	smladxcc	a2, IP, v5, v4
     680:	60483801 	subvs	a4, v5, a2, lsl #16
     684:	2400e000 	strcs	LR, [a1]
     688:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
     68c:	1c31fef3 	ldcne	14, cr15, [a2], #-972
     690:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
     694:	1c06fedd 	stcne	14, cr15, [v3], {221}
     698:	2d803501 	cfstr32cs	mvfx3, [a1, #4]
     69c:	0a30dbe9 	beq	0xc37648
     6a0:	fee8f7ff 	mcr2	7, 7, PC, cr8, cr15, {7}
     6a4:	0e000630 	cfmadd32eq	mvax1, mvfx0, mvfx0, mvfx0
     6a8:	fee4f7ff 	mcr2	7, 7, PC, cr4, cr15, {7}
     6ac:	fee8f7ff 	mcr2	7, 7, PC, cr8, cr15, {7}
     6b0:	bc08bcf0 	stclt	12, cr11, [v5], {240}
     6b4:	b5f84718 	ldrltb	v1, [v5, #1816]!
     6b8:	1c0c1c05 	stcne	12, cr1, [IP], {5}
     6bc:	46682102 	strmibt	a3, [v5], -a3, lsl #2
     6c0:	fef3f7ff 	mrc2	7, 7, PC, cr3, cr15, {7}
     6c4:	1c282180 	stfnes	f2, [v5], #-512
     6c8:	feeff7ff 	mcr2	7, 7, PC, cr15, cr15, {7}
     6cc:	1c064918 	stcne	9, cr4, [v3], {24}
     6d0:	25007848 	strcs	v4, [a1, #-2120]
     6d4:	280043ed 	stmcsda	a1, {a1, a3, a4, v2, v3, v4, v5, v6, LR}
     6d8:	f7ffd10b 	ldrnvb	SP, [PC, v8, lsl #2]!
     6dc:	0207fed1 	andeq	PC, v4, #3344	; 0xd10
     6e0:	fecef7ff 	mcr2	7, 6, PC, cr14, cr15, {7}
     6e4:	19c04912 	stmneib	a1, {a2, v1, v5, v8, LR}^
     6e8:	04007849 	streq	v4, [a1], #-2121
     6ec:	29010c00 	stmcsdb	a2, {v7, v8}
     6f0:	1c28d103 	stfned	f5, [v5], #-12
     6f4:	bc08bcf8 	stclt	12, cr11, [v5], {248}
     6f8:	42b04718 	adcmis	v1, a1, #6291456	; 0x600000
     6fc:	ab00d109 	blge	0x34b28
     700:	42a07818 	adcmi	v4, a1, #1572864	; 0x180000
     704:	7858d105 	ldmvcda	v5, {a1, a3, v5, IP, LR, PC}^
     708:	060943e1 	streq	v1, [v6], -a2, ror #7
     70c:	42880e09 	addmi	a1, v5, #144	; 0x90
     710:	2018d003 	andcss	SP, v5, a4
     714:	feaef7ff 	mcr2	7, 5, PC, cr14, cr15, {7}
     718:	2006e7eb 	andcs	LR, v3, v8, ror #15
     71c:	feaaf7ff 	mcr2	7, 5, PC, cr10, cr15, {7}
     720:	e7e72000 	strb	a3, [v4, a1]!
     724:	00001021 	andeq	a2, a1, a2, lsr #32
     728:	fffff200 	swinv	0x00fff200
     72c:	00186a00 	andeqs	v3, v5, a1, lsl #20
     730:	00200f4c 	eoreq	a1, a1, IP, asr #30
     734:	002004fb 	streqd	a1, [a1], -v8
     738:	002005af 	eoreq	a1, a1, PC, lsr #11
     73c:	22206b01 	eorcs	v3, a1, #1024	; 0x400
     740:	63014311 	tstvs	a2, #1140850688	; 0x44000000
     744:	07096b01 	streq	v3, [v6, -a2, lsl #22]
     748:	6b01d5fc 	blvs	0x75f40
     74c:	43912228 	orrmis	a3, a2, #-2147483646	; 0x80000002
     750:	6b016301 	blvs	0x5935c
     754:	d1fc4011 	mvnles	v1, a2, lsl a1
     758:	6b014770 	blvs	0x52520
     75c:	43112210 	tstmi	a2, #1	; 0x1
     760:	6b016301 	blvs	0x5936c
     764:	d5fc07c9 	ldrleb	a1, [IP, #1993]!
     768:	08496b01 	stmeqda	v6, {a1, v5, v6, v8, SP, LR}^
     76c:	63010049 	tstvs	a2, #73	; 0x49
     770:	07c96b01 	streqb	v3, [v6, a2, lsl #22]
     774:	4770d4fc 	undefined
     778:	2508b470 	strcs	v8, [v5, #-1136]
     77c:	1c2c2610 	stcne	6, cr2, [IP], #-64
     780:	d2002a08 	andle	a3, a1, #32768	; 0x8000
     784:	1b121c14 	blne	0x4877dc
     788:	780be002 	stmvcda	v8, {a2, SP, LR, PC}
     78c:	65033101 	strvs	a4, [a4, #-257]
     790:	d2fa3c01 	rscles	a4, v7, #256	; 0x100
     794:	07db6b03 	ldreqb	v3, [v8, a4, lsl #22]
     798:	6b03d506 	blvs	0xf5bb8
     79c:	005b085b 	subeqs	a1, v8, v8, asr v5
     7a0:	6b036303 	blvs	0xd93b4
     7a4:	d4fc07db 	ldrlebt	a1, [IP], #2011
     7a8:	43336b03 	teqmi	a4, #3072	; 0xc00
     7ac:	6b036303 	blvs	0xd93c0
     7b0:	d505079c 	strle	a1, [v2, #-1948]
     7b4:	22026b01 	andcs	v3, a3, #1024	; 0x400
     7b8:	63014391 	tstvs	a2, #1140850690	; 0x44000002
     7bc:	4770bc70 	undefined
     7c0:	d5f407db 	ldrleb	a1, [v1, #2011]!
     7c4:	d1da2a00 	bicles	a3, v7, a1, lsl #20
     7c8:	07c96b01 	streqb	v3, [v6, a2, lsl #22]
     7cc:	6b01d5f6 	blvs	0x75fac
     7d0:	00490849 	subeq	a1, v6, v6, asr #16
     7d4:	6b016301 	blvs	0x593e0
     7d8:	d4fc07c9 	ldrlebt	a1, [IP], #1993
     7dc:	b5f8e7ee 	ldrltb	LR, [v5, #2030]!
     7e0:	6b216804 	blvs	0x85a7f8
     7e4:	d56f0749 	strleb	a1, [pc, #-1865]!	; 0xa3
     7e8:	060a6d21 	streq	v3, [v7], -a2, lsr #26
     7ec:	0e126d21 	cdpeq	13, 1, cr6, cr2, cr1, {1}
     7f0:	0e1b060b 	cfmsub32eq	mvax0, mvfx0, mvfx11, mvfx11
     7f4:	469c6d21 	ldrmi	v3, [IP], a2, lsr #26
     7f8:	6d230609 	stcvs	6, cr0, [a4, #-36]!
     7fc:	021b0e09 	andeqs	a1, v8, #144	; 0x90
     800:	040d4319 	streq	v1, [SP], #-793
     804:	0c2d6d21 	stceq	13, cr6, [SP], #-132
     808:	6d230609 	stcvs	6, cr0, [a4, #-36]!
     80c:	021b0e09 	andeqs	a1, v8, #144	; 0x90
     810:	040e4319 	streq	v1, [LR], #-793
     814:	0c366d21 	ldceq	13, cr6, [v3], #-132
     818:	6d230609 	stcvs	6, cr0, [a4, #-36]!
     81c:	021b0e09 	andeqs	a1, v8, #144	; 0x90
     820:	04094319 	streq	v1, [v6], #-793
     824:	06130c09 	ldreq	a1, [a4], -v6, lsl #24
     828:	6b23d506 	blvs	0x8f5c48
     82c:	433b2780 	teqmi	v8, #33554432	; 0x2000000
     830:	6b236323 	blvs	0x8d94c4
     834:	d5fc061b 	ldrleb	a1, [IP, #1563]!
     838:	27046b23 	strcs	v3, [v1, -a4, lsr #22]
     83c:	632343bb 	teqvs	a4, #-335544318	; 0xec000002
     840:	075b6b23 	ldreqb	v3, [v8, -a4, lsr #22]
     844:	4663d4fc 	undefined
     848:	431a021b 	tstmi	v7, #-1342177279	; 0xb0000001
     84c:	27004bc1 	strcs	v1, [a1, -a2, asr #23]
     850:	d06a429a 	strleb	v1, [v7], #-42
     854:	23ffdc23 	mvncss	SP, #8960	; 0x2300
     858:	429a3302 	addmis	a4, v7, #134217728	; 0x8000000
     85c:	dc12d040 	ldcle	0, cr13, [a3], {64}
     860:	d0632a80 	rsble	a3, a4, a1, lsl #21
     864:	d0612a81 	rsble	a3, a2, a2, lsl #21
     868:	d1712a82 	cmnle	a2, a3, lsl #21
     86c:	801fab00 	andhis	v7, PC, a1, lsl #22
     870:	07306861 	ldreq	v3, [a1, -a2, ror #16]!
     874:	07890f00 	streq	a1, [v6, a1, lsl #30]
     878:	2803d56b 	stmcsda	a4, {a1, a2, a4, v2, v3, v5, v7, IP, LR, PC}
     87c:	0080d869 	addeq	SP, a1, v6, ror #16
     880:	6b001900 	blvs	0x6c88
     884:	23ffe07b 	mvncss	LR, #123	; 0x7b
     888:	429a3303 	addmis	a4, v7, #201326592	; 0xc000000
     88c:	2303d06d 	tstcs	a4, #109	; 0x6d
     890:	429a021b 	addmis	a1, v7, #-1342177279	; 0xb0000001
     894:	3301d05c 	tstcc	a2, #92	; 0x5c
     898:	d021429a 	mlale	a2, v7, a3, v1
     89c:	2309e058 	tstcs	v6, #88	; 0x58
     8a0:	2602021b 	undefined
     8a4:	d042429a 	umaalle	v1, a3, v7, a3
     8a8:	2305dc0f 	tstcs	v2, #3840	; 0xf00
     8ac:	429a021b 	addmis	a1, v7, #-1342177279	; 0xb0000001
     8b0:	230dd02c 	tstcs	SP, #44	; 0x2c
     8b4:	429a01db 	addmis	a1, v7, #-1073741770	; 0xc0000036
     8b8:	2311d013 	tstcs	a2, #19	; 0x13
     8bc:	429a01db 	addmis	a1, v7, #-1073741770	; 0xc0000036
     8c0:	2201d146 	andcs	SP, a2, #-2147483631	; 0x80000011
     8c4:	e0991d01 	adds	a2, v6, a2, lsl #26
     8c8:	4ba3e02c 	blmi	0xfe8f8980
     8cc:	d06a429a 	strleb	v1, [v7], #-42
     8d0:	429a4ba2 	addmis	v1, v7, #165888	; 0x28800
     8d4:	4ba1d068 	blmi	0xfe874a7c
     8d8:	429a3380 	addmis	a4, v7, #2	; 0x2
     8dc:	7145d138 	cmpvc	v2, v5, lsr a2
     8e0:	1c28e083 	stcne	0, cr14, [v5], #-524
     8e4:	380138ff 	stmccda	a2, {a1, a2, a3, a4, v1, v2, v3, v4, v8, IP, SP}
     8e8:	2212d105 	andcss	SP, a3, #1073741825	; 0x40000001
     8ec:	d8002912 	stmleda	a1, {a2, v1, v5, v8, SP}
     8f0:	499b1c0a 	ldmmiib	v8, {a2, a4, v7, v8, IP}
     8f4:	2001e082 	andcs	LR, a2, a3, lsl #1
     8f8:	42850240 	addmi	a1, v2, #4	; 0x4
     8fc:	2243d128 	subcs	SP, a4, #10	; 0xa
     900:	d8002943 	stmleda	a1, {a1, a2, v3, v5, v8, SP}
     904:	49961c0a 	ldmmiib	v3, {a2, a4, v7, v8, IP}
     908:	e0773112 	rsbs	a4, v4, a3, lsl a2
     90c:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
     910:	20ffff24 	rsccss	PC, PC, v1, lsr #30
     914:	43283001 	teqmi	v5, #1	; 0x1
     918:	200160a0 	andcs	v3, a2, a1, lsr #1
     91c:	d1002d00 	tstle	a1, a1, lsl #26
     920:	60602000 	rsbvs	a3, a1, a1
     924:	bc08bcf8 	stclt	12, cr11, [v5], {248}
     928:	e0304718 	eors	v1, a1, v5, lsl v4
     92c:	7105e01e 	tstvc	v2, LR, lsl a1
     930:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
     934:	2d00ff12 	stccs	15, cr15, [a1, #-72]
     938:	2601d100 	strcs	SP, [a2], -a1, lsl #2
     93c:	20416066 	subcs	v3, a2, v3, rrx
     940:	2d000240 	sfmcs	f0, 4, [a1, #-256]
     944:	2000d100 	andcs	SP, a1, a1, lsl #2
     948:	20436360 	subcs	v3, a4, a1, ror #6
     94c:	e0010240 	and	a1, a2, a1, asr #4
     950:	e00ee058 	and	LR, LR, v5, asr a1
     954:	d1002d00 	tstle	a1, a1, lsl #26
     958:	63a02000 	movvs	a3, #0	; 0x0
     95c:	02002085 	andeq	a3, a1, #133	; 0x85
     960:	d1002d00 	tstle	a1, a1, lsl #26
     964:	63e02000 	mvnvs	a3, #0	; 0x0
     968:	e01ee7dc 	ldrsb	LR, [LR], -IP
     96c:	801fab00 	andhis	v7, PC, a1, lsl #22
     970:	6861e00a 	stmvsda	a2!, {a2, a4, SP, LR, PC}^
     974:	d54507c9 	strleb	a1, [v2, #-1993]
     978:	d1432800 	cmple	a4, a1, lsl #16
     97c:	04006b20 	streq	v3, [a1], #-2848
     980:	300117c0 	andcc	a2, a2, a1, asr #15
     984:	8018ab00 	andhis	v7, v5, a1, lsl #22
     988:	46692202 	strmibt	a3, [v6], -a3, lsl #4
     98c:	0730e036 	undefined
     990:	2d000f00 	stccs	15, cr0, [a1]
     994:	2800d136 	stmcsda	a1, {a2, a3, v1, v2, v5, IP, LR, PC}
     998:	2803d034 	stmcsda	a4, {a3, v1, v2, IP, LR, PC}
     99c:	0080d832 	addeq	SP, a1, a3, lsr v5
     9a0:	63071900 	tstvs	v4, #0	; 0x0
     9a4:	e01ae021 	ands	LR, v7, a2, lsr #32
     9a8:	0730e023 	ldreq	LR, [a1, -a4, lsr #32]!
     9ac:	2d000f00 	stccs	15, cr0, [a1]
     9b0:	2800d128 	stmcsda	a1, {a4, v2, v5, IP, LR, PC}
     9b4:	2803d026 	stmcsda	a4, {a2, a3, v2, IP, LR, PC}
     9b8:	2801d824 	stmcsda	a2, {a3, v2, v8, IP, LR, PC}
     9bc:	2041d103 	subcs	SP, a2, a4, lsl #2
     9c0:	63600240 	cmnvs	a1, #4	; 0x4
     9c4:	2802e011 	stmcsda	a3, {a1, v1, SP, LR, PC}
     9c8:	2043d103 	subcs	SP, a4, a4, lsl #2
     9cc:	63a00240 	movvs	a1, #4	; 0x4
     9d0:	2803e00b 	stmcsda	a4, {a1, a2, a4, SP, LR, PC}
     9d4:	2085d109 	addcs	SP, v2, v6, lsl #2
     9d8:	63e00200 	mvnvs	a1, #0	; 0x0
     9dc:	6b20e005 	blvs	0x8389f8
     9e0:	d5fc0780 	ldrleb	a1, [IP, #1920]!
     9e4:	43b06b20 	movmis	v3, #32768	; 0x8000
     9e8:	1c206320 	stcne	3, cr6, [a1], #-128
     9ec:	feb5f7ff 	mrc2	7, 5, PC, cr5, cr15, {7}
     9f0:	2208e798 	andcs	LR, v5, #39845888	; 0x2600000
     9f4:	d8002908 	stmleda	a1, {a4, v5, v8, SP}
     9f8:	495a1c0a 	ldmmidb	v7, {a2, a4, v7, v8, IP}^
     9fc:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
     a00:	e78ffebb 	undefined
     a04:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
     a08:	e78bfe99 	undefined
     a0c:	1c04b510 	cfstr32ne	mvfx11, [v1], {16}
     a10:	69c16800 	stmvsib	a2, {v8, SP, LR}^
     a14:	d50d04ca 	strle	a1, [SP, #-1226]
     a18:	03092101 	tsteq	v6, #1073741824	; 0x40000000
     a1c:	21006201 	tstcs	a1, a2, lsl #4
     a20:	628143c9 	addvs	v1, a2, #603979779	; 0x24000003
     a24:	62812100 	addvs	a3, a2, #0	; 0x0
     a28:	310121ff 	strccd	a3, [a2, -PC]
     a2c:	01c96081 	biceq	v3, v6, a2, lsl #1
     a30:	e0066301 	and	v3, v3, a2, lsl #6
     a34:	d50407c9 	strle	a1, [v1, #-1993]
     a38:	62012101 	andvs	a3, a2, #1073741824	; 0x40000000
     a3c:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
     a40:	7920fece 	stmvcdb	a1!, {a2, a3, a4, v3, v4, v6, v7, v8, IP, SP, LR, PC}
     a44:	bc08bc10 	stclt	12, cr11, [v5], {16}
     a48:	60014718 	andvs	v1, a2, v5, lsl v4
     a4c:	71012100 	tstvc	a2, a1, lsl #2
     a50:	21027141 	tstcs	a3, a2, asr #2
     a54:	49446081 	stmmidb	v1, {a1, v4, SP, LR}^
     a58:	494460c1 	stmmidb	v1, {a1, v3, v4, SP, LR}^
     a5c:	49446101 	stmmidb	v1, {a1, v5, SP, LR}^
     a60:	47706141 	ldrmib	v3, [a1, -a2, asr #2]!
     a64:	6804b5f7 	stmvsda	v1, {a1, a2, a3, v1, v2, v3, v4, v5, v7, IP, SP, PC}
     a68:	1c076885 	stcne	8, cr6, [v4], {133}
     a6c:	1c382600 	ldcne	6, cr2, [v5]
     a70:	ffccf7ff 	swinv	0x00ccf7ff
     a74:	d01d2800 	andles	a3, SP, a1, lsl #16
     a78:	40286b60 	eormi	v3, v5, a1, ror #22
     a7c:	6b60d018 	blvs	0x1834ae4
     a80:	0c009902 	stceq	9, cr9, [a1], {2}
     a84:	d2024288 	andle	v1, a3, #-2147483640	; 0x80000008
     a88:	0c006b60 	stceq	11, cr6, [a1], {96}
     a8c:	9802e006 	stmlsda	a3, {a2, a3, SP, LR, PC}
     a90:	6d62e004 	stcvsl	0, cr14, [a3, #-16]!
     a94:	9b011c31 	blls	0x47b60
     a98:	545a3601 	ldrplb	a4, [v7], #-1537
     a9c:	d2f83801 	rscles	a4, v5, #65536	; 0x10000
     aa0:	43a86b60 	movmi	v3, #98304	; 0x18000
     aa4:	2d026360 	stccs	3, cr6, [a3, #-384]
     aa8:	2540d101 	strcsb	SP, [a1, #-257]
     aac:	2502e000 	strcs	LR, [a3]
     ab0:	d0dc2e00 	sbcles	a3, IP, a1, lsl #28
     ab4:	60bd1c30 	adcvss	a2, SP, a1, lsr IP
     ab8:	bc08bcfe 	stclt	12, cr11, [v5], {254}
     abc:	b5f04718 	ldrltb	v1, [a1, #1816]!
     ac0:	21401c0e 	cmpcs	a1, LR, lsl #24
     ac4:	1c076804 	stcne	8, cr6, [v4], {4}
     ac8:	2a401c08 	bcs	0x1007af0
     acc:	1c10d200 	lfmne	f5, 1, [a1], {0}
     ad0:	e0021a15 	and	a2, a3, v2, lsl v7
     ad4:	36017832 	undefined
     ad8:	380165a2 	stmccda	a2, {a2, v2, v4, v5, v7, SP, LR}
     adc:	6ba2d2fa 	blvs	0xfe8b56cc
     ae0:	43022010 	tstmi	a3, #16	; 0x10
     ae4:	e01e63a2 	ands	v3, LR, a3, lsr #7
     ae8:	2d402040 	stccsl	0, cr2, [a1, #-256]
     aec:	1c28d200 	sfmne	f5, 1, [v5]
     af0:	e0021a2d 	and	a2, a3, SP, lsr #20
     af4:	36017831 	undefined
     af8:	380165a1 	stmccda	a2, {a1, v2, v4, v5, v7, SP, LR}
     afc:	e004d2fa 	strd	SP, [v1], -v7
     b00:	f7ff1c38 	undefined
     b04:	2800ff83 	stmcsda	a1, {a1, a2, v4, v5, v6, v7, v8, IP, SP, LR, PC}
     b08:	6ba0d01f 	blvs	0xfe834b8c
     b0c:	d5f707c0 	ldrleb	a1, [v4, #1984]!
     b10:	08406ba0 	stmeqda	a1, {v2, v4, v5, v6, v8, SP, LR}^
     b14:	63a00040 	movvs	a1, #64	; 0x40
     b18:	07c06ba0 	streqb	v3, [a1, a1, lsr #23]
     b1c:	6ba0d4fc 	blvs	0xfe835f14
     b20:	43082110 	tstmi	v5, #4	; 0x4
     b24:	2d0063a0 	stccs	3, cr6, [a1, #-640]
     b28:	e004d1de 	ldrd	SP, [v1], -LR
     b2c:	f7ff1c38 	undefined
     b30:	2800ff6d 	stmcsda	a1, {a1, a3, a4, v2, v3, v5, v6, v7, v8, IP, SP, LR, PC}
     b34:	6ba0d009 	blvs	0xfe834b60
     b38:	d5f707c0 	ldrleb	a1, [v4, #1984]!
     b3c:	08406ba0 	stmeqda	a1, {v2, v4, v5, v6, v8, SP, LR}^
     b40:	63a00040 	movvs	a1, #64	; 0x40
     b44:	07c06ba0 	streqb	v3, [a1, a1, lsr #23]
     b48:	1c28d4fc 	cfstrsne	mvf13, [v5], #-1008
     b4c:	bc08bcf0 	stclt	12, cr11, [v5], {240}
     b50:	00004718 	andeq	v1, a1, v5, lsl v4
     b54:	00000302 	andeq	a1, a1, a3, lsl #6
     b58:	00002021 	andeq	a3, a1, a2, lsr #32
     b5c:	000021a1 	andeq	a3, a1, a2, lsr #3
     b60:	00200ed0 	ldreqd	a1, [a1], -a1
     b64:	00200f2c 	eoreq	a1, a1, IP, lsr #30
     b68:	00200a0d 	eoreq	a1, a1, SP, lsl #20
     b6c:	00200abf 	streqh	a1, [a1], -PC
     b70:	00200a65 	eoreq	a1, a1, v2, ror #20
     b74:	4abfb5fe 	bmi	0xfefee374
     b78:	4abf7813 	bmi	0xfefdebcc
     b7c:	d0312b00 	eorles	a3, a2, a1, lsl #22
     b80:	d1012904 	tstle	a2, v1, lsl #18
     b84:	e0066803 	and	v3, v3, a4, lsl #16
     b88:	d1032902 	tstle	a4, a3, lsl #18
     b8c:	5ec02300 	cdppl	3, 12, cr2, cr0, cr0, {0}
     b90:	e0001c03 	and	a2, a1, a4, lsl #24
     b94:	ac007803 	stcge	8, cr7, [a1], {3}
     b98:	00483402 	subeq	a4, v5, a3, lsl #8
     b9c:	39011901 	stmccdb	a2, {a1, v5, v8, IP}
     ba0:	26302500 	ldrcst	a3, [a1], -a1, lsl #10
     ba4:	071ce00a 	ldreq	LR, [IP, -v7]
     ba8:	2c090f24 	stccs	15, cr0, [v6], {36}
     bac:	4334d801 	teqmi	v1, #65536	; 0x10000
     bb0:	3437e000 	ldrcct	LR, [v4]
     bb4:	3901700c 	stmccdb	a2, {a3, a4, IP, SP, LR}
     bb8:	3501111b 	strcc	a2, [a2, #-283]
     bbc:	d8f242a8 	ldmleia	a3!, {a4, v2, v4, v6, LR}^
     bc0:	701eab00 	andvcs	v7, LR, a1, lsl #22
     bc4:	70592178 	subvcs	a3, v6, v5, ror a2
     bc8:	44691c01 	strmibt	a2, [v6], #-3073
     bcc:	708b230a 	addvc	a3, v8, v7, lsl #6
     bd0:	70cb230d 	sbcvc	a3, v8, SP, lsl #6
     bd4:	46681d01 	strmibt	a2, [v5], -a2, lsl #26
     bd8:	f0006892 	mulnv	a1, a3, v5
     bdc:	bcfef96f 	ldcltl	9, cr15, [LR], #444
     be0:	4718bc08 	ldrmi	v8, [v5, -v5, lsl #24]
     be4:	f0006892 	mulnv	a1, a3, v5
     be8:	e7f8f969 	ldrb	PC, [v5, v6, ror #18]!
     bec:	1c04b510 	cfstr32ne	mvfx11, [v1], {16}
     bf0:	fc46f7ff 	mcrr2	7, 15, PC, v3, cr15
     bf4:	bc107020 	ldclt	0, cr7, [a1], {32}
     bf8:	2001bc08 	andcs	v8, a2, v5, lsl #24
     bfc:	b5704718 	ldrltb	v1, [a1, #-1816]!
     c00:	1c0e1c05 	stcne	12, cr1, [LR], {5}
     c04:	e0042400 	and	a3, v1, a1, lsl #8
     c08:	35017828 	strcc	v4, [a2, #-2088]
     c0c:	fc32f7ff 	ldc2	7, cr15, [a3], #-1020
     c10:	42b43401 	adcmis	a4, v1, #16777216	; 0x1000000
     c14:	bc70d3f8 	ldcltl	3, cr13, [a1], #-992
     c18:	4718bc08 	ldrmi	v8, [v5, -v5, lsl #24]
     c1c:	4c96b510 	cfldr32mi	mvfx11, [v3], {16}
     c20:	34181c0a 	ldrcc	a2, [v5], #-3082
     c24:	1c201c01 	stcne	12, cr1, [a1], #-4
     c28:	f0006923 	andnv	v3, a1, a4, lsr #18
     c2c:	bc10f948 	ldclt	9, cr15, [a1], {72}
     c30:	4718bc08 	ldrmi	v8, [v5, -v5, lsl #24]
     c34:	4c90b510 	cfldr32mi	mvfx11, [a1], {16}
     c38:	34181c0a 	ldrcc	a2, [v5], #-3082
     c3c:	1c201c01 	stcne	12, cr1, [a1], #-4
     c40:	f0006963 	andnv	v3, a1, a4, ror #18
     c44:	bc10f93c 	ldclt	9, cr15, [a1], {60}
     c48:	4718bc08 	ldrmi	v8, [v5, -v5, lsl #24]
     c4c:	1c06b5f8 	cfstr32ne	mvfx11, [v3], {248}
     c50:	27401c0c 	strcsb	a2, [a1, -IP, lsl #24]
     c54:	1c3de009 	ldcne	0, cr14, [SP], #-36
     c58:	d2002c40 	andle	a3, a1, #16384	; 0x4000
     c5c:	1c291c25 	stcne	12, cr1, [v6], #-148
     c60:	f7ff1c30 	undefined
     c64:	1b64ffdb 	blne	0x1940bd8
     c68:	2c001976 	stccs	9, cr1, [a1], {118}
     c6c:	bcf8d1f3 	ldfltp	f5, [v5], #972
     c70:	4718bc08 	ldrmi	v8, [v5, -v5, lsl #24]
     c74:	1c05b570 	cfstr32ne	mvfx11, [v2], {112}
     c78:	26401c0c 	strcsb	a2, [a1], -IP, lsl #24
     c7c:	1c31e008 	ldcne	0, cr14, [a2], #-32
     c80:	d2002c40 	andle	a3, a1, #16384	; 0x4000
     c84:	1c281c21 	stcne	12, cr1, [v5], #-132
     c88:	ffd4f7ff 	swinv	0x00d4f7ff
     c8c:	182d1a24 	stmneda	SP!, {a3, v2, v6, v8, IP}
     c90:	d1f42c00 	mvnles	a3, a1, lsl #24
     c94:	bc08bc70 	stclt	12, cr11, [v5], {112}
     c98:	b5f04718 	ldrltb	v1, [a1, #1816]!
     c9c:	4d764f76 	ldcmil	15, cr4, [v3, #-472]!
     ca0:	3718b093 	undefined
     ca4:	68f91c38 	ldmvsia	v6!, {a4, v1, v2, v7, v8, IP}^
     ca8:	f907f000 	stmnvdb	v4, {IP, SP, LR, PC}
     cac:	d0072800 	andle	a3, v4, a1, lsl #16
     cb0:	60284872 	eorvs	v1, v5, a3, ror v5
     cb4:	60684872 	rsbvs	v1, v5, a3, ror v5
     cb8:	60a84872 	adcvs	v1, v5, a3, ror v5
     cbc:	e00c4872 	and	v1, IP, a3, ror v5
     cc0:	fa87f7ff 	blx	0xfe1fecc4
     cc4:	d1ed2805 	mvnle	a3, v2, lsl #16
     cc8:	3110496b 	tstcc	a1, v8, ror #18
     ccc:	60286808 	eorvs	v3, v5, v5, lsl #16
     cd0:	60686848 	rsbvs	v3, v5, v5, asr #16
     cd4:	60a8486d 	adcvs	v1, v5, SP, ror #16
     cd8:	60e8486d 	rscvs	v1, v5, SP, ror #16
     cdc:	fa5cf7ff 	blx	0x173ece0
     ce0:	21404a65 	cmpcs	a1, v2, ror #20
     ce4:	68d2a801 	ldmvsia	a3, {a1, v8, SP, PC}^
     ce8:	f8e8f000 	stmnvia	v5!, {IP, SP, LR, PC}^
     cec:	af019011 	swige	0x00019011
     cf0:	e0ba2500 	adcs	a3, v7, a1, lsl #10
     cf4:	28ff7838 	ldmcsia	PC!, {a4, v1, v2, v8, IP, SP, LR}^
     cf8:	2823d066 	stmcsda	a4!, {a2, a3, v2, v3, IP, LR, PC}
     cfc:	485dd165 	ldmmida	SP, {a1, a3, v2, v3, v5, IP, LR, PC}^
     d00:	28007800 	stmcsda	a1, {v8, IP, SP, LR}
     d04:	4a5cd005 	bmi	0x1734d20
     d08:	a0622102 	rsbge	a3, a3, a3, lsl #2
     d0c:	f0006892 	mulnv	a1, a3, v5
     d10:	2c53f8d5 	mrrccs	8, 13, PC, a4, cr5
     d14:	4a58d106 	bmi	0x1635134
     d18:	68529912 	ldmvsda	a3, {a2, v1, v5, v8, IP, PC}^
     d1c:	f0001c30 	andnv	a2, a1, a1, lsr IP
     d20:	e072f8cd 	rsbs	PC, a3, SP, asr #17
     d24:	d1062c52 	tstle	v3, a3, asr IP
     d28:	99124a53 	ldmlsdb	a3, {a1, a2, v1, v3, v6, v8, LR}
     d2c:	1c306812 	ldcne	8, cr6, [a1], #-72
     d30:	f8c4f000 	stmnvia	v1, {IP, SP, LR, PC}^
     d34:	2c4fe069 	mcrrcs	0, 6, LR, PC, cr9
     d38:	9812d102 	ldmlsda	a3, {a2, v5, IP, LR, PC}
     d3c:	e0647030 	rsb	v4, v1, a1, lsr a1
     d40:	d1022c48 	tstle	a3, v5, asr #24
     d44:	80309812 	eorhis	v6, a1, a3, lsl v5
     d48:	2c57e05f 	mrrccs	0, 5, LR, v4, cr15
     d4c:	9812d102 	ldmlsda	a3, {a2, v5, IP, LR, PC}
     d50:	e05a6030 	subs	v3, v7, a1, lsr a1
     d54:	d1022c6f 	tstle	a3, PC, ror #24
     d58:	1c302101 	ldfnes	f2, [a1], #-4
     d5c:	2c68e00c 	stccsl	0, cr14, [v5], #-48
     d60:	2300d104 	tstcs	a1, #1	; 0x1
     d64:	21025ef0 	strcsd	v2, [a3, -a1]
     d68:	e0049012 	and	v6, v1, a3, lsl a1
     d6c:	d1062c77 	tstle	v3, v4, ror IP
     d70:	21046830 	tstcs	v1, a1, lsr v5
     d74:	a8129012 	ldmgeda	a3, {a2, v1, IP, PC}
     d78:	fefcf7ff 	mrc2	7, 7, PC, cr12, cr15, {7}
     d7c:	2c47e045 	mcrrcs	0, 4, LR, v4, cr5
     d80:	9812d103 	ldmlsda	a3, {a1, a2, v5, IP, LR, PC}
     d84:	f8a0f000 	stmnvia	a1!, {IP, SP, LR, PC}
     d88:	2c54e03f 	mrrccs	0, 3, LR, v1, cr15
     d8c:	4939d109 	ldmmidb	v6!, {a1, a4, v5, IP, LR, PC}
     d90:	70082001 	andvc	a3, v5, a2
     d94:	21024a38 	tstcs	a3, v5, lsr v7
     d98:	6892a03e 	ldmvsia	a3, {a2, a3, a4, v1, v2, SP, PC}
     d9c:	f88ef000 	stmnvia	LR, {IP, SP, LR, PC}
     da0:	2c4ee033 	mcrrcs	0, 3, LR, LR, cr3
     da4:	4933d103 	ldmmidb	a4!, {a1, a2, v5, IP, LR, PC}
     da8:	70082000 	andvc	a3, v5, a1
     dac:	2c56e02d 	mrrccs	0, 2, LR, v3, cr13
     db0:	4830d12b 	ldmmida	a1!, {a1, a2, a4, v2, v5, IP, LR, PC}
     db4:	68404c30 	stmvsda	a1, {v1, v2, v7, v8, LR}^
     db8:	210568a2 	smlatbcs	v2, a3, v5, v3
     dbc:	f87ef000 	ldmnvda	LR!, {IP, SP, LR, PC}^
     dc0:	1c292500 	cfstr32ne	mvfx2, [v6]
     dc4:	e002a034 	and	v7, a3, v1, lsr a1
     dc8:	e02ce04d 	eor	LR, IP, SP, asr #32
     dcc:	78023101 	stmvcda	a3, {a1, v5, IP, SP}
     dd0:	2a003001 	bcs	0xcddc
     dd4:	a030d1fa 	ldrgesh	SP, [a1], -v7
     dd8:	f00068a2 	andnv	v3, a1, a3, lsr #17
     ddc:	2101f86f 	tstcsp	a2, PC, ror #16
     de0:	68a2a030 	stmvsia	a3!, {v1, v2, SP, PC}
     de4:	f86af000 	stmnvda	v7!, {IP, SP, LR, PC}^
     de8:	e000a72f 	and	v7, a1, PC, lsr #14
     dec:	78383501 	ldmvcda	v5!, {a1, v5, v7, IP, SP}
     df0:	28003701 	stmcsda	a1, {a1, v5, v6, v7, IP, SP}
     df4:	1c29d1fa 	stfned	f5, [v6], #-1000
     df8:	68a2a02b 	stmvsia	a3!, {a1, a2, a4, v2, SP, PC}
     dfc:	f85ef000 	ldmnvda	LR, {IP, SP, LR, PC}^
     e00:	a0242102 	eorge	a3, v1, a3, lsl #2
     e04:	f00068a2 	andnv	v3, a1, a3, lsr #17
     e08:	2000f859 	andcs	PC, a1, v6, asr v5
     e0c:	48199012 	ldmmida	v6, {a2, v1, IP, PC}
     e10:	7800247a 	stmvcda	a1, {a2, a4, v1, v2, v3, v7, SP}
     e14:	d0262800 	eorle	a3, v3, a1, lsl #16
     e18:	21014a17 	tstcs	a2, v4, lsl v7
     e1c:	6892a025 	ldmvsia	a3, {a1, a3, v2, SP, PC}
     e20:	f84cf000 	stmnvda	IP, {IP, SP, LR, PC}^
     e24:	1c01e01f 	stcne	0, cr14, [a2], {31}
     e28:	29093930 	stmcsdb	v6, {v1, v2, v5, v8, IP, SP}
     e2c:	9812d803 	ldmlsda	a3, {a1, a2, v8, IP, LR, PC}
     e30:	43080100 	tstmi	v5, #0	; 0x0
     e34:	1c01e016 	stcne	0, cr14, [a2], {22}
     e38:	29053941 	stmcsdb	v2, {a1, v3, v5, v8, IP, SP}
     e3c:	9912d803 	ldmlsdb	a3, {a1, a2, v8, IP, LR, PC}
     e40:	38370109 	ldmccda	v4!, {a1, a4, v5}
     e44:	1c01e006 	stcne	0, cr14, [a2], {6}
     e48:	29053961 	stmcsdb	v2, {a1, v2, v3, v5, v8, IP, SP}
     e4c:	9912d804 	ldmlsdb	a3, {a3, v8, IP, LR, PC}
     e50:	38570109 	ldmccda	v4, {a1, a4, v5}^
     e54:	e0054308 	and	v1, v2, v5, lsl #6
     e58:	d101282c 	tstle	a2, IP, lsr #16
     e5c:	e0009e12 	and	v6, a1, a3, lsl LR
     e60:	20001c04 	andcs	a2, a1, v1, lsl #24
     e64:	37019012 	smladcc	a2, a3, a1, v6
     e68:	98113501 	ldmlsda	a2, {a1, v5, v7, IP, SP}
     e6c:	da004285 	ble	0x11888
     e70:	e735e740 	ldr	LR, [v2, -a1, asr #14]!
     e74:	00200f34 	eoreq	a1, a1, v1, lsr PC
     e78:	00200f54 	eoreq	a1, a1, v1, asr PC
     e7c:	00200c4d 	eoreq	a1, a1, SP, asr #24
     e80:	00200c75 	eoreq	a1, a1, v2, ror IP
     e84:	00200c1d 	eoreq	a1, a1, SP, lsl IP
     e88:	00200c35 	eoreq	a1, a1, v2, lsr IP
     e8c:	00200bff 	streqd	a1, [a1], -PC
     e90:	00200bed 	eoreq	a1, a1, SP, ror #23
     e94:	00000d0a 	andeq	a1, a1, v7, lsl #26
     e98:	20766f4e 	rsbcss	v3, v3, LR, asr #30
     e9c:	32203031 	eorcc	a4, a1, #49	; 0x31
     ea0:	00343030 	eoreqs	a4, v1, a1, lsr a1
     ea4:	00000020 	andeq	a1, a1, a1, lsr #32
     ea8:	343a3431 	ldrcct	a4, [v7], #-1073
     eac:	33333a39 	teqcc	a4, #233472	; 0x39000
     eb0:	00000000 	andeq	a1, a1, a1
     eb4:	0000003e 	andeq	a1, a1, LR, lsr a1
     eb8:	47084700 	strmi	v1, [v5, -a1, lsl #14]
     ebc:	47184710 	undefined
     ec0:	47284720 	strmi	v1, [v5, -a1, lsr #14]!
     ec4:	47384730 	undefined
     ec8:	46c04778 	undefined
     ecc:	eafffca7 	b	0x170
     ed0:	01100112 	tsteq	a1, a3, lsl a2
     ed4:	08000002 	stmeqda	a1, {a2}
     ed8:	612403eb 	smulwtvs	v1, v8, a4
     edc:	00000110 	andeq	a1, a1, a1, lsl a2
     ee0:	02090100 	andeq	a1, v6, #0	; 0x0
     ee4:	01020043 	tsteq	a3, a4, asr #32
     ee8:	0900c000 	stmeqdb	a1, {LR, PC}
     eec:	01000004 	tsteq	a1, v1
     ef0:	00000202 	andeq	a1, a1, a3, lsl #4
     ef4:	10002405 	andne	a3, a1, v2, lsl #8
     ef8:	02240401 	eoreq	a1, v1, #16777216	; 0x1000000
     efc:	06240500 	streqt	a1, [v1], -a1, lsl #10
     f00:	24050100 	strcs	a1, [v2], #-256
     f04:	07010001 	streq	a1, [a2, -a2]
     f08:	08038305 	stmeqda	a4, {a1, a3, v5, v6, PC}
     f0c:	0409ff00 	streq	PC, [v6], #-3840
     f10:	0a020001 	beq	0x80f1c
     f14:	07000000 	streq	a1, [a1, -a1]
     f18:	40020105 	andmi	a1, a3, v2, lsl #2
     f1c:	05070000 	streq	a1, [v4]
     f20:	00400282 	subeq	a1, a1, a3, lsl #5
     f24:	2e317600 	cfmsuba32cs	mvax0, mvax7, mvfx1, mvfx0
     f28:	00002034 	andeq	a3, a1, v1, lsr a1
     f2c:	0001c200 	andeq	IP, a2, a1, lsl #4
     f30:	00080000 	andeq	a1, v5, a1
     f34:	00000001 	andeq	a1, a1, a2
     f38:	00200f25 	eoreq	a1, a1, v2, lsr #30
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
    1200:	22407c80 	subcs	v4, a1, #32768	; 0x8000
    1204:	748a4302 	strvc	v1, [v7], #770
    1208:	1809e123 	stmneda	v6, {a1, a2, v2, v5, SP, LR, PC}
    120c:	6a5269ba 	bvs	0x149b8fc
    1210:	7c801810 	stcvc	8, cr1, [a1], {16}
    1214:	e7f52220 	ldrb	a3, [v2, a1, lsr #4]!
    1218:	28019802 	stmcsda	a2, {a2, v8, IP, PC}
    121c:	4975d1f4 	ldmmidb	v2!, {a3, v1, v2, v3, v4, v5, IP, LR, PC}^
    1220:	6a896909 	bvs	0xfe25b64c
    1224:	1d096a49 	fstsne	s12, [v6, #-292]
    1228:	780b1c62 	stmvcda	v8, {a2, v2, v3, v7, v8, IP}
    122c:	784b7013 	stmvcda	v8, {a1, a2, v1, IP, SP, LR}^
    1230:	20037053 	andcs	v4, a4, a4, asr a1
    1234:	69f8e751 	ldmvsib	v5!, {a1, v1, v3, v5, v6, v7, SP, LR, PC}^
    1238:	21046a40 	tstcs	v1, a1, asr #20
    123c:	e10876c1 	smlabt	v5, a2, v3, v4
    1240:	6a406ab8 	bvs	0x101bd28
    1244:	6a496ab9 	bvs	0x125bd30
    1248:	22107e89 	andcss	v4, a1, #2192	; 0x890
    124c:	7682430a 	strvc	v1, [a3], v7, lsl #6
    1250:	28019802 	stmcsda	a2, {a2, v8, IP, PC}
    1254:	6ab8d1f3 	bvs	0xfee35a28
    1258:	30216a40 	eorcc	v3, a2, a1, asr #20
    125c:	49847800 	stmmiib	v1, {v8, IP, SP, LR}
    1260:	90004348 	andls	v1, a1, v5, asr #6
    1264:	1c624669 	stcnel	6, cr4, [a3], #-420
    1268:	1e402004 	cdpne	0, 4, cr2, cr0, cr4, {0}
    126c:	54135c0b 	ldrpl	v2, [a4], #-3083
    1270:	2005d1fb 	strcsd	SP, [v2], -v8
    1274:	9802e6b3 	stmlsda	a3, {a1, a2, v1, v2, v4, v6, v7, SP, LR, PC}
    1278:	d1e02801 	mvnle	a3, a2, lsl #16
    127c:	90007870 	andls	v4, a1, a1, ror v5
    1280:	d3022804 	tstle	a3, #262144	; 0x40000
    1284:	43ed253f 	mvnmi	a3, #264241152	; 0xfc00000
    1288:	9800e0e6 	stmlsda	a1, {a2, a3, v2, v3, v4, SP, LR, PC}
    128c:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    1290:	fb74f003 	blx	0x1d3d2a6
    1294:	98001c05 	stmlsda	a1, {a1, a3, v7, v8, IP}
    1298:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    129c:	fb96f003 	blx	0xfe5bd2b2
    12a0:	20027060 	andcs	v4, a3, a1, rrx
    12a4:	7870e69b 	ldmvcda	a1!, {a1, a2, a4, v1, v4, v6, v7, SP, LR, PC}^
    12a8:	46689000 	strmibt	v6, [v5], -a1
    12ac:	808178b1 	strhih	v4, [a2], a2
    12b0:	28049800 	stmcsda	v1, {v8, IP, PC}
    12b4:	253fd301 	ldrcs	SP, [pc, #-769]!	; 0xfbb
    12b8:	78f3e594 	ldmvcia	a4!, {a3, v1, v4, v5, v7, SP, LR, PC}^
    12bc:	1c321d36 	ldcne	13, cr1, [a3], #-216
    12c0:	88814668 	stmhiia	a2, {a4, v2, v3, v6, v7, LR}
    12c4:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    12c8:	06009800 	streq	v6, [a1], -a1, lsl #16
    12cc:	f0030e00 	andnv	a1, a4, a1, lsl #28
    12d0:	1c05fb9f 	stcne	11, cr15, [v2], {159}
    12d4:	9802e0bd 	stmlsda	a3, {a1, a3, a4, v1, v2, v4, SP, LR, PC}
    12d8:	d1fb2801 	mvnles	a3, a2, lsl #16
    12dc:	90007870 	andls	v4, a1, a1, ror v5
    12e0:	d2cf2804 	sbcle	a3, PC, #262144	; 0x40000
    12e4:	06009800 	streq	v6, [a1], -a1, lsl #16
    12e8:	f0030e00 	andnv	a1, a4, a1, lsl #28
    12ec:	1c05fb47 	stcne	11, cr15, [v2], {71}
    12f0:	06009800 	streq	v6, [a1], -a1, lsl #16
    12f4:	f0030e00 	andnv	a1, a4, a1, lsl #28
    12f8:	4669fb69 	strmibt	PC, [v6], -v6, ror #22
    12fc:	46688088 	strmibt	v5, [v5], -v5, lsl #1
    1300:	70608880 	rsbvc	v5, a1, a1, lsl #17
    1304:	2d002002 	stccs	0, cr2, [a1, #-8]
    1308:	8889db10 	stmhiia	v6, {v1, v5, v6, v8, IP, LR, PC}
    130c:	d00d2900 	andle	a3, SP, a1, lsl #18
    1310:	46681ca2 	strmibt	a2, [v5], -a3, lsr #25
    1314:	06098881 	streq	v5, [v6], -a2, lsl #17
    1318:	98000e09 	stmlsda	a1, {a1, a4, v6, v7, v8}
    131c:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    1320:	fbecf003 	blx	0xffb3d336
    1324:	46681c05 	strmibt	a2, [v5], -v2, lsl #24
    1328:	1c808880 	stcne	8, cr8, [a1], {128}
    132c:	22104669 	andcss	v1, a1, #110100480	; 0x6900000
    1330:	889b466b 	ldmhiia	v8, {a1, a2, a4, v2, v3, v6, v7, LR}
    1334:	808a1ad2 	ldrhid	a2, [v7], a3
    1338:	22008889 	andcs	v5, a1, #8978432	; 0x890000
    133c:	29001823 	stmcsdb	a1, {a1, a2, v2, v8, IP}
    1340:	1e49d002 	cdpne	0, 4, cr13, cr9, cr2, {0}
    1344:	d1fc545a 	mvnles	v2, v7, asr v1
    1348:	88894669 	stmhiia	v6, {a1, a4, v2, v3, v6, v7, LR}
    134c:	e6461840 	strb	a2, [v3], -a1, asr #16
    1350:	28019802 	stmcsda	a2, {a2, v8, IP, PC}
    1354:	29ffd114 	ldmcsib	PC!, {a3, v1, v5, IP, LR, PC}^
    1358:	2513d108 	ldrcs	SP, [a4, #-264]
    135c:	201443ed 	andcss	v1, v1, SP, ror #7
    1360:	1c622100 	stfnee	f2, [a3]
    1364:	54111e40 	ldrpl	a2, [a2], #-3648
    1368:	e005d1fc 	strd	SP, [v2], -IP
    136c:	49b12214 	ldmmiib	a2!, {a3, v1, v6, SP}
    1370:	1c603136 	stfnee	f3, [a1], #-216
    1374:	feeef013 	mcr2	0, 7, PC, cr14, cr3, {0}
    1378:	e6ae2015 	ssat	a3, #15, v2
    137c:	28019802 	stmcsda	a2, {a2, v8, IP, PC}
    1380:	4668d167 	strmibt	SP, [v5], -v4, ror #2
    1384:	80c17871 	sbchi	v4, a2, a2, ror v5
    1388:	706078b0 	strvch	v4, [a1], #-128
    138c:	4668a901 	strmibt	v7, [v5], -a2, lsl #18
    1390:	f00188c0 	andnv	v5, a2, a1, asr #17
    1394:	1c05f9c5 	stcne	9, cr15, [v2], {197}
    1398:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    139c:	270370a0 	strcs	v4, [a4, -a1, lsr #1]
    13a0:	db132d00 	blle	0x4cc7a8
    13a4:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    13a8:	d00f2800 	andle	a3, PC, a1, lsl #16
    13ac:	466878f3 	undefined
    13b0:	1ce18882 	stcnel	8, cr8, [a2], #520
    13b4:	f00188c0 	andnv	v5, a2, a1, asr #17
    13b8:	1c05f9e7 	stcne	9, cr15, [v2], {231}
    13bc:	46682800 	strmibt	a3, [v5], -a1, lsl #16
    13c0:	2100da02 	tstcs	a1, a3, lsl #20
    13c4:	e0018081 	and	v5, a2, a2, lsl #1
    13c8:	1cff8887 	ldcnel	8, cr8, [PC], #540
    13cc:	213b4668 	teqcs	v8, v5, ror #12
    13d0:	8892466a 	ldmhiia	a3, {a2, a4, v2, v3, v6, v7, LR}
    13d4:	80811a89 	addhi	a2, a2, v6, lsl #21
    13d8:	21008880 	smlabbcs	a1, a1, v5, v5
    13dc:	280019e2 	stmcsda	a1, {a2, v2, v3, v4, v5, v8, IP}
    13e0:	1e40d002 	cdpne	0, 4, cr13, cr0, cr2, {0}
    13e4:	d1fc5411 	mvnles	v2, a2, lsl v1
    13e8:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    13ec:	e5f61838 	ldrb	a2, [v3, #2104]!
    13f0:	e4f72541 	ldrbt	a3, [v4], #1345
    13f4:	0000015c 	andeq	a1, a1, IP, asr a2
    13f8:	28137830 	ldmcsda	a4, {v1, v2, v8, IP, SP, LR}
    13fc:	4668d129 	strmibt	SP, [v5], -v6, lsr #2
    1400:	80c178b1 	strhih	v4, [a2], #129
    1404:	808178f1 	strhid	v4, [a2], a2
    1408:	78701d31 	ldmvcda	a1!, {a1, v1, v2, v5, v7, v8, IP}^
    140c:	16000600 	strne	a1, [a1], -a1, lsl #12
    1410:	db1e2800 	blle	0x78b418
    1414:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    1418:	d01a2800 	andles	a3, v7, a1, lsl #16
    141c:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    1420:	d216283c 	andles	a3, v3, #3932160	; 0x3c0000
    1424:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    1428:	1e401808 	cdpne	8, 4, cr1, cr0, cr8, {0}
    142c:	28007800 	stmcsda	a1, {v8, IP, SP, LR}
    1430:	4668d10f 	strmibt	SP, [v5], -PC, lsl #2
    1434:	88c08882 	stmhiia	a1, {a2, v4, v8, PC}^
    1438:	f908f001 	stmnvdb	v5, {a1, IP, SP, LR, PC}
    143c:	20041c05 	andcs	a2, v1, v2, lsl #24
    1440:	428543c0 	addmi	v1, v2, #3	; 0x3
    1444:	9805d105 	stmlsda	v2, {a1, a3, v5, IP, LR, PC}
    1448:	78099905 	stmvcda	v6, {a1, a3, v5, v8, IP, PC}
    144c:	430a2201 	tstmi	v7, #268435456	; 0x10000000
    1450:	98027002 	stmlsda	a3, {a2, IP, SP, LR}
    1454:	d1042801 	tstle	v1, a2, lsl #16
    1458:	99039806 	stmlsdb	a4, {a2, a3, v8, IP, PC}
    145c:	70257001 	eorvc	v4, v2, a2
    1460:	9806e002 	stmlsda	v3, {a2, SP, LR, PC}
    1464:	70012100 	andvc	a3, a2, a1, lsl #2
    1468:	b0072000 	andlt	a3, v4, a1
    146c:	ff61f000 	swinv	0x0061f000
    1470:	0000ea60 	andeq	LR, a1, a1, ror #20
    1474:	496eb5f0 	stmmidb	LR!, {v1, v2, v3, v4, v5, v7, IP, SP, PC}^
    1478:	4c726108 	ldfmie	f6, [a3], #-32
    147c:	61204869 	teqvs	a1, v6, ror #16
    1480:	4a692100 	bmi	0x1a49888
    1484:	486a014e 	stmmida	v7!, {a2, a3, a4, v3, v5}^
    1488:	203c6903 	eorcss	v3, IP, a4, lsl #18
    148c:	699d4348 	ldmvsib	SP, {a4, v3, v5, v6, LR}
    1490:	19ad6a6d 	stmneib	SP!, {a1, a3, a4, v2, v3, v6, v8, SP, LR}
    1494:	50153512 	andpls	a4, v2, a3, lsl v2
    1498:	4348200f 	cmpmi	v5, #15	; 0xf
    149c:	1d150080 	ldcne	0, cr0, [v2, #-512]
    14a0:	6a7f699f 	bvs	0x1fdbb24
    14a4:	371319bf 	undefined
    14a8:	1c15502f 	ldcne	0, cr5, [v2], {47}
    14ac:	699f3508 	ldmvsib	PC, {a4, v5, v7, IP, SP}
    14b0:	19bf6a7f 	ldmneib	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    14b4:	502f3714 	eorpl	a4, PC, v1, lsl v4
    14b8:	350c1c15 	strcc	a2, [IP, #-3093]
    14bc:	6a7f699f 	bvs	0x1fdbb40
    14c0:	371519bf 	undefined
    14c4:	1c15502f 	ldcne	0, cr5, [v2], {47}
    14c8:	699f3510 	ldmvsib	PC, {v1, v5, v7, IP, SP}
    14cc:	19bf6a7f 	ldmneib	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    14d0:	1c15502f 	ldcne	0, cr5, [v2], {47}
    14d4:	699f3514 	ldmvsib	PC, {a3, v1, v5, v7, IP, SP}
    14d8:	19bf6a7f 	ldmneib	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    14dc:	502f370c 	eorpl	a4, PC, IP, lsl #14
    14e0:	35181c15 	ldrcc	a2, [v5, #-3093]
    14e4:	6a7f699f 	bvs	0x1fdbb68
    14e8:	371919bf 	undefined
    14ec:	1c15502f 	ldcne	0, cr5, [v2], {47}
    14f0:	699f351c 	ldmvsib	PC, {a3, a4, v1, v5, v7, IP, SP}
    14f4:	19bf6a7f 	ldmneib	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    14f8:	502f371c 	eorpl	a4, PC, IP, lsl v4
    14fc:	35201c15 	strcc	a2, [a1, #-3093]!
    1500:	6a7f699f 	bvs	0x1fdbb84
    1504:	371a19bf 	undefined
    1508:	1c15502f 	ldcne	0, cr5, [v2], {47}
    150c:	699f3524 	ldmvsib	PC, {a3, v2, v5, v7, IP, SP}
    1510:	19bf6a7f 	ldmneib	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    1514:	502f371b 	eorpl	a4, PC, v8, lsl v4
    1518:	35281c15 	strcc	a2, [v5, #-3093]!
    151c:	6a7f699f 	bvs	0x1fdbba0
    1520:	371619bf 	undefined
    1524:	1c15502f 	ldcne	0, cr5, [v2], {47}
    1528:	699f352c 	ldmvsib	PC, {a3, a4, v2, v5, v7, IP, SP}
    152c:	19bf6a7f 	ldmneib	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    1530:	502f3717 	eorpl	a4, PC, v4, lsl v4
    1534:	35301c15 	ldrcc	a2, [a1, #-3093]!
    1538:	6a7f699f 	bvs	0x1fdbbbc
    153c:	371819bf 	undefined
    1540:	1c15502f 	ldcne	0, cr5, [v2], {47}
    1544:	699f3534 	ldmvsib	PC, {a3, v1, v2, v5, v7, IP, SP}
    1548:	19bf6a7f 	ldmneib	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    154c:	502f1d3f 	eorpl	a2, PC, PC, lsr SP
    1550:	35381c15 	ldrcc	a2, [v5, #-3093]!
    1554:	6a7f699f 	bvs	0x1fdbbd8
    1558:	360819be 	undefined
    155c:	1c49502e 	mcrrne	0, 2, v2, v6, cr14
    1560:	d38f2903 	orrle	a3, PC, #49152	; 0xc000
    1564:	4a312100 	bmi	0xc4996c
    1568:	434e2614 	cmpmi	LR, #20971520	; 0x1400000
    156c:	43482018 	cmpmi	v5, #24	; 0x18
    1570:	6a6d685d 	bvs	0x1b5b6ec
    1574:	350819ad 	strcc	a2, [v5, #-2477]
    1578:	20065015 	andcs	v2, v3, v2, lsl a1
    157c:	00804348 	addeq	v1, a1, v5, asr #6
    1580:	685f1d15 	ldmvsda	PC, {a1, a3, v1, v5, v7, v8, IP}^
    1584:	19bf6a7f 	ldmneib	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    1588:	502f3709 	eorpl	a4, PC, v6, lsl #14
    158c:	35081c15 	strcc	a2, [v5, #-3093]
    1590:	6a7f685f 	bvs	0x1fdb714
    1594:	1cbf19bf 	ldcne	9, cr1, [PC], #764
    1598:	1c15502f 	ldcne	0, cr5, [v2], {47}
    159c:	685f350c 	ldmvsda	PC, {a3, a4, v5, v7, IP, SP}^
    15a0:	19bf6a7f 	ldmneib	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    15a4:	502f1d3f 	eorpl	a2, PC, PC, lsr SP
    15a8:	35101c15 	ldrcc	a2, [a1, #-3093]
    15ac:	6a7f685f 	bvs	0x1fdb730
    15b0:	1dbf19bf 	ldcne	9, cr1, [PC, #764]!
    15b4:	1c15502f 	ldcne	0, cr5, [v2], {47}
    15b8:	685f3514 	ldmvsda	PC, {a3, v1, v5, v7, IP, SP}^
    15bc:	19be6a7f 	ldmneib	LR!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    15c0:	502e3610 	eorpl	a4, LR, a1, lsl v3
    15c4:	29041c49 	stmcsdb	v1, {a1, a4, v3, v7, v8, IP}
    15c8:	f000d3ce 	andnv	SP, a1, LR, asr #7
    15cc:	f000fcd1 	ldrnvd	PC, [a1], -a2
    15d0:	4818fb53 	ldmmida	v5, {a1, a2, v1, v3, v5, v6, v8, IP, SP, LR, PC}
    15d4:	18414918 	stmneda	a2, {a4, v1, v5, v8, LR}^
    15d8:	800a2200 	andhi	a3, v7, a1, lsl #4
    15dc:	804a4a92 	umaalhi	v1, v7, a3, v7
    15e0:	710a2201 	tstvc	v7, a2, lsl #4
    15e4:	714a2200 	cmpvc	v7, a1, lsl #4
    15e8:	302280ca 	eorcc	v5, a3, v7, asr #1
    15ec:	77227002 	strvc	v4, [a3, -a3]!
    15f0:	200177a2 	andcs	v4, a2, a3, lsr #15
    15f4:	48117760 	ldmmida	a2, {v2, v3, v5, v6, v7, IP, SP, LR}
    15f8:	83208360 	teqhi	a1, #-2147483647	; 0x80000001
    15fc:	49102210 	ldmmidb	a1, {v1, v6, SP}
    1600:	f0131c20 	andnvs	a2, a4, a1, lsr #24
    1604:	2014fda7 	andcss	PC, v1, v4, lsr #27
    1608:	4a0e2100 	bmi	0x389a10
    160c:	1f003220 	swine	0x00003220
    1610:	d1fc5011 	mvnles	v2, a2, lsl a1
    1614:	fffcf012 	swinv	0x00fcf012
    1618:	f804f013 	stmnvda	v1, {a1, a2, v1, IP, SP, LR, PC}
    161c:	f7ff6160 	ldrnvb	v3, [PC, a1, ror #2]!
    1620:	46c0f9bf 	undefined
    1624:	00100d3d 	andeqs	a1, a1, SP, lsr SP
    1628:	000089a0 	andeq	v5, a1, a1, lsr #19
    162c:	00008940 	andeq	v5, a1, a1, asr #18
    1630:	0000015c 	andeq	a1, a1, IP, asr a2
    1634:	00008680 	andeq	v5, a1, a1, lsl #13
    1638:	000002b2 	streqh	a1, [a1], -a3
    163c:	0000ffff 	streqd	PC, [a1], -PC
    1640:	00118d48 	andeqs	v5, a2, v5, asr #26
    1644:	0000064c 	andeq	a1, a1, IP, asr #12
    1648:	2700b5f3 	undefined
    164c:	69004875 	stmvsdb	a1, {a1, a3, v1, v2, v3, v8, LR}
    1650:	20ad9000 	adccs	v6, SP, a1
    1654:	49750080 	ldmmidb	v2!, {v4}^
    1658:	4e74180d 	cdpmi	8, 7, cr1, cr4, cr13, {0}
    165c:	4c701d36 	ldcmil	13, cr1, [a1], #-216
    1660:	28007fb0 	stmcsda	a1, {v1, v2, v4, v5, v6, v7, v8, IP, SP, LR}
    1664:	1e40d007 	cdpne	0, 4, cr13, cr0, cr7, {0}
    1668:	d9672801 	stmledb	v4!, {a1, v8, SP}^
    166c:	d0231ec0 	eorle	a2, a4, a1, asr #29
    1670:	d0431e40 	suble	a2, a4, a1, asr #28
    1674:	7fa0e0ca 	swivc	0x00a0e0ca
    1678:	d1fb2801 	mvnles	a3, a2, lsl #16
    167c:	1c2077a7 	stcne	7, cr7, [a1], #-668
    1680:	f0003020 	andnv	a4, a1, a1, lsr #32
    1684:	2800f9eb 	stmcsda	a1, {a1, a2, a4, v2, v3, v4, v5, v8, IP, SP, LR, PC}
    1688:	2003da03 	andcs	SP, a4, a4, lsl #20
    168c:	20047720 	andcs	v4, v1, a1, lsr #14
    1690:	2001e0bb 	strcsh	LR, [a2], -v8
    1694:	200277b0 	strcsh	v4, [a3], -a1
    1698:	69607720 	stmvsdb	a1!, {v2, v5, v6, v7, IP, SP, LR}^
    169c:	f00060a8 	andnv	v3, a1, v5, lsr #1
    16a0:	4860fb43 	stmmida	a1!, {a1, a2, v3, v5, v6, v8, IP, SP, LR, PC}^
    16a4:	6a816900 	bvs	0xfe05baac
    16a8:	6a806a49 	bvs	0xfe01bfd4
    16ac:	7e806a40 	cdpvc	10, 8, cr6, cr0, cr0, {2}
    16b0:	43022206 	tstmi	a3, #1610612736	; 0x60000000
    16b4:	e0a9768a 	adc	v4, v6, v7, lsl #13
    16b8:	28047f20 	stmcsda	v1, {v2, v5, v6, v7, v8, IP, SP, LR}
    16bc:	f000d101 	andnv	SP, a1, a2, lsl #2
    16c0:	4858fb33 	ldmmida	v5, {a1, a2, v1, v2, v5, v6, v8, IP, SP, LR, PC}^
    16c4:	6a806900 	bvs	0xfe01bacc
    16c8:	7e816a40 	cdpvc	10, 8, cr6, cr1, cr0, {2}
    16cc:	400a22f9 	strmid	a3, [v7], -v6
    16d0:	f0007682 	andnv	v4, a1, a3, lsl #13
    16d4:	f7fffad1 	undefined
    16d8:	4852fa6d 	ldmmida	a3, {a1, a3, a4, v2, v3, v6, v8, IP, SP, LR, PC}^
    16dc:	69c16900 	stmvsib	a2, {v5, v8, SP, LR}^
    16e0:	22046a49 	andcs	v3, v1, #299008	; 0x49000
    16e4:	69c176ca 	stmvsib	a2, {a2, a4, v3, v4, v6, v7, IP, SP, LR}^
    16e8:	6a806a49 	bvs	0xfe01c014
    16ec:	30246a40 	eorcc	v3, v1, a1, asr #20
    16f0:	77487800 	strvcb	v4, [v5, -a1, lsl #16]
    16f4:	8028484c 	eorhi	v1, v5, IP, asr #16
    16f8:	e0862005 	add	a3, v3, v2
    16fc:	5e282000 	cdppl	0, 2, cr2, cr8, cr0, {0}
    1700:	42884949 	addmi	v1, v5, #1196032	; 0x124000
    1704:	78e8d110 	stmvcia	v5!, {v1, v5, IP, LR, PC}^
    1708:	d10d2801 	tstle	SP, a2, lsl #16
    170c:	20001c29 	andcs	a2, a1, v6, lsr #24
    1710:	2300b403 	tstcs	a1, #50331648	; 0x3000000
    1714:	21002200 	tstcs	a1, a1, lsl #4
    1718:	9f022008 	swils	0x00022008
    171c:	6a7f683f 	bvs	0x1fdb820
    1720:	f015683f 	andnvs	v3, v2, PC, lsr v5
    1724:	b002fd67 	andlt	PC, a3, v4, ror #26
    1728:	28057f20 	stmcsda	v2, {v2, v5, v6, v7, v8, IP, SP, LR}
    172c:	f000d16e 	andnv	SP, a1, LR, ror #2
    1730:	2000fafb 	strcsd	PC, [a1], -v8
    1734:	77b070e8 	ldrvc	v4, [a1, v5, ror #1]!
    1738:	e0677720 	rsb	v4, v4, a1, lsr #14
    173c:	28017fe0 	stmcsda	a2, {v2, v3, v4, v5, v6, v7, v8, IP, SP, LR}
    1740:	9800d006 	stmlsda	a1, {a2, a3, IP, LR, PC}
    1744:	6a406880 	bvs	0x101b94c
    1748:	78003020 	stmvcda	a1, {v2, IP, SP}
    174c:	d50c07c0 	strle	a1, [IP, #-1984]
    1750:	980077e7 	stmlsda	a1, {a1, a2, a3, v2, v3, v4, v5, v6, v7, IP, SP, LR}
    1754:	6a406880 	bvs	0x101b95c
    1758:	1c022120 	stfnes	f2, [a3], {32}
    175c:	78123220 	ldmvcda	a3, {v2, v6, IP, SP}
    1760:	401323fe 	ldrmish	a3, [a4], -LR
    1764:	20045443 	andcs	v2, v1, a4, asr #8
    1768:	7968e7e5 	stmvcdb	v5!, {a1, a3, v2, v3, v4, v5, v6, v7, SP, LR, PC}^
    176c:	d0082800 	andle	a3, v5, a1, lsl #16
    1770:	fef4f000 	cdp2	0, 15, cr15, cr4, cr0, {0}
    1774:	e004716f 	and	v4, v1, PC, ror #2
    1778:	ff54f012 	swinv	0x0054f012
    177c:	42816961 	addmi	v3, a2, #1589248	; 0x184000
    1780:	482ad144 	stmmida	v7!, {a3, v3, v5, IP, LR, PC}
    1784:	78053030 	stmvcda	v2, {v1, v2, IP, SP}
    1788:	f0001c28 	andnv	a2, a1, v5, lsr #24
    178c:	2800fbe9 	stmcsda	a1, {a1, a4, v2, v3, v4, v5, v6, v8, IP, SP, LR, PC}
    1790:	4668d022 	strmibt	SP, [v5], -a3, lsr #32
    1794:	25007105 	strcs	v4, [a1, #-261]
    1798:	79004668 	stmvcdb	a1, {a4, v2, v3, v6, v7, LR}
    179c:	fc98f001 	ldc2	0, cr15, [v5], {1}
    17a0:	28001c07 	stmcsda	a1, {a1, a2, a3, v7, v8, IP}
    17a4:	2f01db18 	swics	0x0001db18
    17a8:	2f02d01c 	swics	0x0002d01c
    17ac:	2f04d01a 	swics	0x0004d01a
    17b0:	2f05d018 	swics	0x0005d018
    17b4:	1c6dd00c 	stcnel	0, cr13, [SP], #-48
    17b8:	28017fb0 	stmcsda	a2, {v1, v2, v4, v5, v6, v7, v8, IP, SP, LR}
    17bc:	4668d108 	strmibt	SP, [v5], -v5, lsl #2
    17c0:	21147900 	tstcs	v1, a1, lsl #18
    17c4:	68314348 	ldmvsda	a2!, {a4, v3, v5, v6, LR}
    17c8:	7a401808 	bvc	0x10077f0
    17cc:	d3e34285 	mvnle	v1, #1342177288	; 0x50000008
    17d0:	30304816 	eorccs	v1, a1, v3, lsl v5
    17d4:	fb4ef000 	blx	0x13bd7de
    17d8:	da032f00 	ble	0xcd3e0
    17dc:	77b02004 	ldrvc	a3, [a1, v1]!
    17e0:	e7a92003 	str	a3, [v6, a4]!
    17e4:	d0112f04 	andles	a3, a2, v1, lsl #30
    17e8:	30304810 	eorccs	v1, a1, a1, lsl v5
    17ec:	f0007800 	andnv	v4, a1, a1, lsl #16
    17f0:	2800fbb7 	stmcsda	a1, {a1, a2, a3, v1, v2, v4, v5, v6, v8, IP, SP, LR, PC}
    17f4:	2f05d001 	swics	0x0005d001
    17f8:	2004d103 	andcs	SP, v1, a4, lsl #2
    17fc:	200177b0 	strcsh	v4, [a2], -a1
    1800:	7fb0e79a 	swivc	0x00b0e79a
    1804:	d0b72801 	adcles	a3, v4, a2, lsl #16
    1808:	77b02003 	ldrvc	a3, [a1, a4]!
    180c:	ff0af012 	swinv	0x000af012
    1810:	42816961 	addmi	v3, a2, #1589248	; 0x184000
    1814:	f012d0fa 	ldrnvsh	SP, [a3], -v7
    1818:	6160ff05 	msrvs	SPSR_, v2, lsl #30
    181c:	0000e326 	andeq	LR, a1, v3, lsr #6
    1820:	0000064c 	andeq	a1, a1, IP, asr #12
    1824:	0000015c 	andeq	a1, a1, IP, asr a2
    1828:	ffff9400 	swinv	0x00ff9400
    182c:	00008680 	andeq	v5, a1, a1, lsl #13
    1830:	f012b500 	andnvs	v8, a3, a1, lsl #10
    1834:	bc01ff17 	stclt	15, cr15, [a2], {23}
    1838:	00004700 	andeq	v1, a1, a1, lsl #14
    183c:	1c04b5f7 	cfstr32ne	mvfx11, [v1], {247}
    1840:	330e1c03 	tstcc	LR, #768	; 0x300
    1844:	785e781d 	ldmvcda	LR, {a1, a3, a4, v1, v8, IP, SP, LR}^
    1848:	49532210 	ldmmidb	a4, {v1, v6, SP}^
    184c:	fc68f013 	stc2l	0, cr15, [v5], #-76
    1850:	d1032800 	tstle	a4, a1, lsl #16
    1854:	d3012e04 	tstle	a2, #64	; 0x40
    1858:	d3022d02 	tstle	a3, #128	; 0x80
    185c:	43c02003 	bicmi	a3, a1, #3	; 0x3
    1860:	497de094 	ldmmidb	SP!, {a3, v1, v4, SP, LR, PC}^
    1864:	83888a20 	orrhi	v5, v5, #131072	; 0x20000
    1868:	83c88a60 	bichi	v5, v5, #393216	; 0x60000
    186c:	84088aa0 	strhi	v5, [v5], #-2720
    1870:	8ae29802 	bhi	0xff8a7880
    1874:	98028082 	stmlsda	a3, {a2, v4, PC}
    1878:	80c28b22 	sbchi	v5, a3, a3, lsr #22
    187c:	8b629802 	blhi	0x18a788c
    1880:	8ba08102 	blhi	0xfe821c90
    1884:	8be08488 	blhi	0xff822aac
    1888:	8c2284c8 	cfstrshi	mvf8, [a3], #-800
    188c:	20028c63 	andcs	v5, a3, a4, ror #24
    1890:	2b0043c0 	blcs	0x12798
    1894:	2bffd07a 	blcs	0xffff5a84
    1898:	768bd278 	undefined
    189c:	830b8ca3 	tsthi	v8, #41728	; 0xa300
    18a0:	d0732b00 	rsbles	a3, a4, a1, lsl #22
    18a4:	25269b02 	strcs	v6, [v3, #-2818]!
    18a8:	8b8b801d 	blhi	0xfe2e1924
    18ac:	3526009d 	strcc	a1, [v3, #-157]!
    18b0:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    18b4:	4e36006b 	cdpmi	0, 3, cr0, cr6, cr11, {3}
    18b8:	1b9b402e 	blne	0xfe6d1978
    18bc:	806b9d02 	rsbhi	v6, v8, a3, lsl #26
    18c0:	88ad9d02 	stmhiia	SP!, {a2, v5, v7, v8, IP, PC}
    18c4:	042d195d 	streqt	a2, [SP], #-2397
    18c8:	006b0c2d 	rsbeq	a1, v8, SP, lsr #24
    18cc:	402e4e30 	eormi	v1, LR, a1, lsr LR
    18d0:	9b021b9d 	blls	0x8874c
    18d4:	042d815d 	streqt	v5, [SP], #-349
    18d8:	19630c2d 	stmnedb	a4!, {a1, a3, a4, v2, v7, v8}^
    18dc:	7e8f466e 	cdpvc	6, 8, cr4, cr15, cr14, {3}
    18e0:	78367037 	ldmvcda	v3!, {a1, a2, a3, v1, v2, IP, SP, LR}
    18e4:	19ad00b6 	stmneib	SP!, {a2, a3, v1, v2, v4}
    18e8:	e0032600 	and	a3, a4, a1, lsl #12
    18ec:	19ed785f 	stmneib	SP!, {a1, a2, a3, a4, v1, v3, v8, IP, SP, LR}^
    18f0:	1c761d1b 	ldcnel	13, cr1, [v3], #-108
    18f4:	783f466f 	ldmvcda	PC!, {a1, a2, a3, a4, v2, v3, v6, v7, LR}
    18f8:	d3f742be 	mvnles	v1, #-536870901	; 0xe000000b
    18fc:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    1900:	4e23006b 	cdpmi	0, 2, cr0, cr3, cr11, {3}
    1904:	1b9b402e 	blne	0xfe6d19c4
    1908:	81ab9d02 	movhi	v6, a3, lsl #26
    190c:	0c1b041b 	cfldrseq	mvf0, [v8], {27}
    1910:	8b0e9d01 	blhi	0x3a8d1c
    1914:	1bad0076 	blne	0xfeb41af4
    1918:	d13742ab 	teqle	v4, v8, lsr #5
    191c:	33301c0b 	teqcc	a1, #2816	; 0xb00
    1920:	701d25ff 	ldrvcsh	a3, [SP], -PC
    1924:	9b02705d 	blls	0x9daa0
    1928:	18e3899b 	stmneia	a4!, {a1, a2, a4, v1, v4, v5, v8, PC}^
    192c:	694b600b 	stmvsdb	v8, {a1, a2, a4, SP, LR}^
    1930:	18eb690d 	stmneia	v8!, {a1, a3, a4, v5, v8, SP, LR}^
    1934:	694b604b 	stmvsdb	v8, {a1, a2, a4, v3, SP, LR}^
    1938:	26147e8d 	ldrcs	v4, [v1], -SP, lsl #29
    193c:	195b4375 	ldmnedb	v8, {a1, a3, v1, v2, v3, v5, v6, LR}^
    1940:	9b02614b 	blls	0x99e74
    1944:	18e3881b 	stmneia	a4!, {a1, a2, a4, v1, v8, PC}^
    1948:	694b608b 	stmvsdb	v8, {a1, a2, a4, v4, SP, LR}^
    194c:	25031c1c 	strcs	a2, [a4, #-3100]
    1950:	d004422b 	andle	v1, v1, v8, lsr #4
    1954:	079b1d24 	ldreq	a2, [v8, v1, lsr #26]
    1958:	1ae30f9b 	bne	0xff8c57cc
    195c:	694b614b 	stmvsdb	v8, {a1, a2, a4, v3, v5, SP, LR}^
    1960:	18e5690c 	stmneia	v2!, {a3, a4, v5, v8, SP, LR}^
    1964:	4b0d60cd 	blmi	0x359ca0
    1968:	831d1aed 	tsthi	SP, #970752	; 0xed000
    196c:	8bce694d 	blhi	0xff39bea8
    1970:	614d19ad 	smlaltbvs	a2, SP, SP, v6
    1974:	18aa68cd 	stmneia	v7!, {a1, a3, a4, v3, v4, v8, SP, LR}
    1978:	1ad262ca 	bne	0xff49a4a8
    197c:	0c02835a 	stceq	3, cr8, [a3], {90}
    1980:	6949850a 	stmvsdb	v6, {a2, a4, v5, v7, PC}^
    1984:	42914a03 	addmis	v1, a2, #12288	; 0x3000
    1988:	2000d200 	andcs	SP, a1, a1, lsl #4
    198c:	fc28f000 	stc2	0, cr15, [v5]
    1990:	0000fffe 	streqd	PC, [a1], -LR
    1994:	00008001 	andeq	v5, a1, a2
    1998:	00118d48 	andeqs	v5, a2, v5, asr #26
    199c:	0000064c 	andeq	a1, a1, IP, asr #12
    19a0:	1c17b5f3 	cfldr32ne	mvfx11, [v4], {243}
    19a4:	1c102400 	cfldrsne	mvf2, [a1], {0}
    19a8:	ff54f000 	swinv	0x0054f000
    19ac:	28081c05 	stmcsda	v5, {a1, a3, v7, v8, IP}
    19b0:	1c38d11b 	ldfned	f5, [v5], #-108
    19b4:	f9c4f001 	stmnvib	v1, {a1, IP, SP, LR, PC}^
    19b8:	1c7f1c05 	ldcnel	12, cr1, [PC], #-20
    19bc:	e0052600 	and	a3, v2, a1, lsl #12
    19c0:	0c000438 	cfstrseq	mvf0, [a1], {56}
    19c4:	fff8f000 	swinv	0x00f8f000
    19c8:	1c761c07 	ldcnel	12, cr1, [v3], #-28
    19cc:	0c360436 	cfldrseq	mvf0, [v3], #-216
    19d0:	d20842ae 	andle	v1, v5, #-536870902	; 0xe000000a
    19d4:	0c12043a 	cfldrseq	mvf0, [a3], {58}
    19d8:	98009901 	stmlsda	a1, {a1, v5, v8, IP, PC}
    19dc:	ffe0f7ff 	swinv	0x00e0f7ff
    19e0:	28001c04 	stmcsda	a1, {a3, v7, v8, IP}
    19e4:	1c20daec 	stcne	10, cr13, [a1], #-944
    19e8:	00bee322 	adceqs	LR, LR, a3, lsr #6
    19ec:	d1082d07 	tstle	v5, v4, lsl #26
    19f0:	49192002 	ldmmidb	v6, {a2, SP}
    19f4:	19896889 	stmneib	v6, {a1, a4, v4, v8, SP, LR}
    19f8:	49175e08 	ldmmidb	v4, {a4, v6, v7, v8, IP, LR}
    19fc:	180f68c9 	stmneda	PC, {a1, a4, v3, v4, v8, SP, LR}
    1a00:	2200e005 	andcs	LR, a1, #5	; 0x5
    1a04:	1c382100 	ldfnes	f2, [v5]
    1a08:	ff2af000 	swinv	0x002af000
    1a0c:	48121c07 	ldmmida	a3, {a1, a2, a3, v7, v8, IP}
    1a10:	19806880 	stmneib	a1, {v4, v8, SP, LR}
    1a14:	28007840 	stmcsda	a1, {v3, v8, IP, SP, LR}
    1a18:	1c28d009 	stcne	0, cr13, [v5], #-36
    1a1c:	ff7ef000 	swinv	0x007ef000
    1a20:	28002100 	stmcsda	a1, {v5, SP}
    1a24:	1e40d0df 	mcrne	0, 2, SP, cr0, cr15, {6}
    1a28:	d1fc5439 	mvnles	v2, v6, lsr v1
    1a2c:	1c28e7db 	stcne	7, cr14, [v5], #-876
    1a30:	ff74f000 	swinv	0x0074f000
    1a34:	98011c02 	stmlsda	a2, {a2, v7, v8, IP}
    1a38:	99008800 	stmlsdb	a1, {v8, PC}
    1a3c:	1c381809 	ldcne	8, cr1, [v5], #-36
    1a40:	faaaf013 	blx	0xfeabda94
    1a44:	88069801 	stmhida	v3, {a1, v8, IP, PC}
    1a48:	f0001c28 	andnv	a2, a1, v5, lsr #24
    1a4c:	1830ff67 	ldmneda	a1!, {a1, a2, a3, v2, v3, v5, v6, v7, v8, IP, SP, LR, PC}
    1a50:	80089901 	andhi	v6, v5, a2, lsl #18
    1a54:	0000e7c7 	andeq	LR, a1, v4, asr #15
    1a58:	00008680 	andeq	v5, a1, a1, lsl #13
    1a5c:	b08cb5f0 	strltd	v8, [IP], a1
    1a60:	ab021c06 	blge	0x88a80
    1a64:	1c01aa05 	stcne	10, cr10, [a2], {5}
    1a68:	4cad208a 	stcmi	0, cr2, [SP], #552
    1a6c:	69246924 	stmvsdb	v1!, {a3, v2, v5, v8, SP, LR}
    1a70:	68246a64 	stmvsda	v1!, {a3, v2, v3, v6, v8, SP, LR}
    1a74:	fbc4f015 	blx	0xff13dad2
    1a78:	98051c07 	stmlsda	v2, {a1, a2, a3, v7, v8, IP}
    1a7c:	24029000 	strcs	v6, [a3]
    1a80:	20ff43e4 	rsccss	v1, PC, v1, ror #7
    1a84:	42070200 	andmi	a1, v4, #0	; 0x0
    1a88:	9800d105 	stmlsda	a1, {a1, a3, v5, IP, LR, PC}
    1a8c:	d0022800 	andle	a3, a3, a1, lsl #16
    1a90:	28009802 	stmcsda	a1, {a2, v8, IP, PC}
    1a94:	1c20d101 	stfned	f5, [a1], #-4
    1a98:	f000e0ec 	andnv	LR, a1, IP, ror #1
    1a9c:	f000f8ed 	andnv	PC, a1, SP, ror #17
    1aa0:	4da0fa67 	stcmi	10, cr15, [a1, #412]!
    1aa4:	30301c28 	eorccs	a2, a1, v5, lsr #24
    1aa8:	71479003 	cmpvc	v4, a4
    1aac:	1c312214 	lfmne	f2, 4, [a2], #-80
    1ab0:	30361c28 	eorccs	a2, v3, v5, lsr #24
    1ab4:	fb4ef013 	blx	0x13bdb0a
    1ab8:	9902aa06 	stmlsdb	a3, {a2, a3, v6, v8, SP, PC}
    1abc:	f7ff9800 	ldrnvb	v6, [PC, a1, lsl #16]!
    1ac0:	2800febd 	stmcsda	a1, {a1, a3, a4, v1, v2, v4, v6, v7, v8, IP, SP, LR, PC}
    1ac4:	6828dbe8 	stmvsda	v5!, {a4, v2, v3, v4, v5, v6, v8, IP, LR, PC}
    1ac8:	42889900 	addmi	v6, v5, #0	; 0x0
    1acc:	9902d3e3 	stmlsdb	a3, {a1, a2, v2, v3, v4, v5, v6, IP, LR, PC}
    1ad0:	18519a00 	ldmneda	a2, {v6, v8, IP, PC}^
    1ad4:	d2de4288 	sbcles	v1, LR, #-2147483640	; 0x80000008
    1ad8:	68696928 	stmvsda	v6!, {a4, v2, v5, v8, SP, LR}^
    1adc:	d3da4281 	bicles	v1, v7, #268435464	; 0x10000008
    1ae0:	1882696a 	stmneia	a3, {a2, a4, v2, v3, v5, v8, SP, LR}
    1ae4:	d2d64291 	sbcles	v1, v3, #268435465	; 0x10000009
    1ae8:	428168e9 	addmi	v3, a2, #15269888	; 0xe90000
    1aec:	4291d3d3 	addmis	SP, a2, #1275068419	; 0x4c000003
    1af0:	8be8d2d1 	blhi	0xffa3663c
    1af4:	d0ce2800 	sbcle	a3, LR, a1, lsl #16
    1af8:	8940a806 	stmhidb	a1, {a2, a3, v8, SP, PC}^
    1afc:	180e9900 	stmneda	LR, {v5, v8, IP, PC}
    1b00:	e02a2700 	eor	a3, v7, a1, lsl #14
    1b04:	00b91c38 	adceqs	a2, v6, v5, lsr IP
    1b08:	22141871 	andcss	a2, v1, #7405568	; 0x710000
    1b0c:	686a4350 	stmvsda	v7!, {v1, v3, v5, v6, LR}^
    1b10:	780b1812 	stmvcda	v8, {a2, v1, v8, IP}
    1b14:	686a7193 	stmvsda	v7!, {a1, a2, v1, v4, v5, IP, SP, LR}^
    1b18:	784b1812 	stmvcda	v8, {a2, v1, v8, IP}^
    1b1c:	686a7413 	stmvsda	v7!, {a1, a2, v1, v7, IP, SP, LR}^
    1b20:	52118849 	andpls	v5, a2, #4784128	; 0x490000
    1b24:	18096869 	stmneda	v6, {a1, a4, v2, v3, v8, SP, LR}
    1b28:	808a2200 	addhi	a3, v7, a1, lsl #4
    1b2c:	18096869 	stmneda	v6, {a1, a4, v2, v3, v8, SP, LR}
    1b30:	724a2214 	subvc	a3, v7, #1073741825	; 0x40000001
    1b34:	18096869 	stmneda	v6, {a1, a4, v2, v3, v8, SP, LR}
    1b38:	720a22ff 	andvc	a3, v7, #-268435441	; 0xf000000f
    1b3c:	18096869 	stmneda	v6, {a1, a4, v2, v3, v8, SP, LR}
    1b40:	71ca798a 	bicvc	v4, v7, v7, lsl #19
    1b44:	18086869 	stmneda	v5, {a1, a4, v2, v3, v8, SP, LR}
    1b48:	280079c0 	stmcsda	a1, {v3, v4, v5, v8, IP, SP, LR}
    1b4c:	0639d104 	ldreqt	SP, [v6], -v1, lsl #2
    1b50:	98030e09 	stmlsda	a4, {a1, a4, v6, v7, v8}
    1b54:	f948f000 	stmnvdb	v5, {IP, SP, LR, PC}^
    1b58:	7ea81c7f 	mcrvc	12, 5, a2, cr8, cr15, {3}
    1b5c:	0c3f043f 	cfldrseq	mvf0, [PC], #-252
    1b60:	d3cf4287 	bicle	v1, PC, #1879048200	; 0x70000008
    1b64:	18300080 	ldmneda	a1!, {v4}
    1b68:	e0032600 	and	a3, a4, a1, lsl #12
    1b6c:	1e498b29 	cdpne	11, 4, cr8, cr9, cr9, {1}
    1b70:	1c768051 	ldcnel	0, cr8, [v3], #-324
    1b74:	04367ea9 	ldreqt	v4, [v3], #-3753
    1b78:	428e0c36 	addmi	a1, LR, #13824	; 0x3600
    1b7c:	1c31d217 	lfmne	f5, 1, [a2], #-92
    1b80:	43722214 	cmnmi	a3, #1073741825	; 0x40000001
    1b84:	189b686b 	ldmneia	v8, {a1, a2, a4, v2, v3, v8, SP, LR}
    1b88:	2f007c1f 	swics	0x00007c1f
    1b8c:	60d8d005 	sbcvss	SP, v5, v2
    1b90:	189b686b 	ldmneia	v8, {a1, a2, a4, v2, v3, v8, SP, LR}
    1b94:	18c07c1b 	stmneia	a1, {a1, a2, a4, v1, v7, v8, IP, SP, LR}^
    1b98:	2700e001 	strcs	LR, [a1, -a2]
    1b9c:	686b60df 	stmvsda	v8!, {a1, a2, a3, a4, v1, v3, v4, SP, LR}^
    1ba0:	7eab189a 	mcrvc	8, 5, a2, cr11, cr10, {4}
    1ba4:	42991e5b 	addmis	a2, v6, #1456	; 0x5b0
    1ba8:	8a91dae0 	bhi	0xfe478730
    1bac:	9803e7df 	stmlsda	a4, {a1, a2, a3, a4, v1, v3, v4, v5, v6, v7, SP, LR, PC}
    1bb0:	28ff7800 	ldmcsia	PC!, {v8, IP, SP, LR}^
    1bb4:	1c20d101 	stfned	f5, [a1], #-4
    1bb8:	4668e05c 	undefined
    1bbc:	80812100 	addhi	a3, a2, a1, lsl #2
    1bc0:	1c322600 	ldcne	6, cr2, [a3]
    1bc4:	a806a901 	stmgeda	v3, {a1, v5, v8, SP, PC}
    1bc8:	9b008840 	blls	0x23cd0
    1bcc:	f7ff1818 	undefined
    1bd0:	1c07fee7 	stcne	14, cr15, [v4], {231}
    1bd4:	db4d2800 	blle	0x134bbdc
    1bd8:	f0001c30 	andnv	a2, a1, a1, lsr IP
    1bdc:	1c06feed 	stcne	14, cr15, [v3], {237}
    1be0:	42860c20 	addmi	a1, v3, #8192	; 0x2000
    1be4:	a806d1ed 	stmgeda	v3, {a1, a3, a4, v2, v3, v4, v5, IP, LR, PC}
    1be8:	466988c0 	strmibt	v5, [v6], -a1, asr #17
    1bec:	42818889 	addmi	v5, a2, #8978432	; 0x890000
    1bf0:	a906d13d 	stmgedb	v3, {a1, a3, a4, v1, v2, v5, IP, LR, PC}
    1bf4:	4669890a 	strmibt	v5, [v6], -v7, lsl #18
    1bf8:	18898889 	stmneia	v6, {a1, a4, v4, v8, PC}
    1bfc:	889bab06 	ldmhiia	v8, {a2, a3, v5, v6, v8, SP, PC}
    1c00:	d1344299 	ldrleb	v1, [v1, -v6]!
    1c04:	8849a906 	stmhida	v6, {a2, a3, v5, v8, SP, PC}^
    1c08:	18599b00 	ldmneda	v6, {v5, v6, v8, IP, PC}^
    1c0c:	8c281809 	stchi	8, cr1, [v5], #-36
    1c10:	181868eb 	ldmneda	v5, {a1, a2, a4, v2, v3, v4, v8, SP, LR}
    1c14:	f9c0f013 	stmnvib	a1, {a1, a2, v1, IP, SP, LR, PC}^
    1c18:	88016ae8 	stmhida	a2, {a4, v2, v3, v4, v6, v8, SP, LR}
    1c1c:	185168ea 	ldmneda	a2, {a2, a4, v2, v3, v4, v8, SP, LR}^
    1c20:	d1c84288 	bicle	v1, v5, v5, lsl #5
    1c24:	20cd2600 	sbccs	a3, SP, a1, lsl #12
    1c28:	18280040 	stmneda	v5!, {v3}
    1c2c:	200e9004 	andcs	v6, LR, v1
    1c30:	90004370 	andls	v1, a1, a1, ror a4
    1c34:	22009904 	andcs	v6, a1, #65536	; 0x10000
    1c38:	9800520a 	stmlsda	a1, {a2, a4, v6, IP, LR}
    1c3c:	1c899904 	stcne	9, cr9, [v6], {4}
    1c40:	2000520a 	andcs	v2, a1, v7, lsl #4
    1c44:	21cf0042 	biccs	a1, PC, a3, asr #32
    1c48:	9b000049 	blls	0x1d74
    1c4c:	185b18eb 	ldmneda	v8, {a1, a2, a4, v2, v3, v4, v8, IP}^
    1c50:	52990c21 	addpls	a1, v6, #8448	; 0x2100
    1c54:	04001c40 	streq	a2, [a1], #-3136
    1c58:	28050c00 	stmcsda	v2, {v7, v8}
    1c5c:	1c76d3f2 	ldcnel	3, cr13, [v3], #-968
    1c60:	0c360436 	cfldrseq	mvf0, [v3], #-216
    1c64:	d3e22e14 	mvnle	a3, #320	; 0x140
    1c68:	fc46f000 	mcrr2	0, 0, PC, v3, cr0
    1c6c:	d0002801 	andle	a3, a1, a2, lsl #16
    1c70:	1c38e711 	ldcne	7, cr14, [v5], #-68
    1c74:	e35cb00c 	cmp	IP, #12	; 0xc
    1c78:	2000b5f1 	strcsd	v8, [a1], -a2
    1c7c:	60084929 	andvs	v1, v5, v6, lsr #18
    1c80:	60488308 	subvs	v5, v5, v5, lsl #6
    1c84:	61c87688 	bicvs	v4, v5, v5, lsl #13
    1c88:	60c86088 	sbcvs	v3, v5, v5, lsl #1
    1c8c:	4a238408 	bmi	0x8e2cb4
    1c90:	84ca848a 	strhib	v5, [v7], #1162
    1c94:	62c8850a 	sbcvs	v5, v5, #41943040	; 0x2800000
    1c98:	34301c0c 	ldrcct	a2, [a1], #-3084
    1c9c:	702525ff 	strvcd	a3, [v2], -PC
    1ca0:	80607065 	rsbhi	v4, a1, v2, rrx
    1ca4:	4e1e7125 	mufmiep	f7, f6, f5
    1ca8:	28ff7960 	ldmcsia	PC!, {v2, v3, v5, v8, IP, SP, LR}^
    1cac:	2300d011 	tstcs	a1, #17	; 0x11
    1cb0:	31352200 	teqcc	v2, a1, lsl #4
    1cb4:	69372084 	ldmvsdb	v4!, {a3, v4, SP}
    1cb8:	6a7f693f 	bvs	0x1fdc1bc
    1cbc:	f015683f 	andnvs	v3, v2, PC, lsr v5
    1cc0:	7165fa99 	strvcb	PC, [v2, #-169]!
    1cc4:	21002014 	tstcs	a1, v1, lsl a1
    1cc8:	32364a16 	eorccs	v1, v3, #90112	; 0x16000
    1ccc:	52111e80 	andpls	a2, a2, #2048	; 0x800
    1cd0:	2500d1fc 	strcs	SP, [a1, #-508]
    1cd4:	70054668 	andvc	v1, v2, v5, ror #12
    1cd8:	43682015 	cmnmi	v5, #21	; 0x15
    1cdc:	311a1c21 	tstcc	v7, a2, lsr #24
    1ce0:	28005c08 	stmcsda	a1, {a4, v7, v8, IP, LR}
    1ce4:	2300d009 	tstcs	a1, #9	; 0x9
    1ce8:	46692200 	strmibt	a3, [v6], -a1, lsl #4
    1cec:	69372084 	ldmvsdb	v4!, {a3, v4, SP}
    1cf0:	6a7f693f 	bvs	0x1fdc1f4
    1cf4:	f015683f 	andnvs	v3, v2, PC, lsr v5
    1cf8:	1c6dfa7d 	stcnel	10, cr15, [SP], #-500
    1cfc:	0e2d062d 	cfmadda32eq	mvax1, mvax0, mvfx13, mvfx13
    1d00:	d3e72d10 	mvnle	a3, #1024	; 0x400
    1d04:	004020a8 	subeq	a3, a1, v5, lsr #1
    1d08:	4a062100 	bmi	0x18a110
    1d0c:	1e80324a 	cdpne	2, 8, cr3, cr0, cr10, {2}
    1d10:	d1fc5211 	mvnles	v2, a2, lsl a3
    1d14:	bc01bcf8 	stclt	12, cr11, [a2], {248}
    1d18:	00004700 	andeq	v1, a1, a1, lsl #14
    1d1c:	0000ffff 	streqd	PC, [a1], -PC
    1d20:	0000015c 	andeq	a1, a1, IP, asr a2
    1d24:	00008680 	andeq	v5, a1, a1, lsl #13
    1d28:	2100b510 	tstcs	a1, a1, lsl v2
    1d2c:	6900482d 	stmvsdb	a1, {a1, a3, a4, v2, v8, LR}
    1d30:	00ca2400 	sbceq	a3, v7, a1, lsl #8
    1d34:	6a5b6883 	bvs	0x16dbf48
    1d38:	711c189b 	ldrvcb	a2, [IP, -v8]
    1d3c:	6a5b6883 	bvs	0x16dbf50
    1d40:	709c189b 	umullvcs	a2, IP, v8, v5
    1d44:	6a5b6883 	bvs	0x16dbf58
    1d48:	70d4189a 	smullvcs	a2, v1, v7, v5
    1d4c:	06091c49 	streq	a2, [v6], -v6, asr #24
    1d50:	29040e09 	stmcsdb	v1, {a1, a4, v6, v7, v8}
    1d54:	2100d3ed 	smlattcs	a1, SP, a4, SP
    1d58:	434a2214 	cmpmi	v7, #1073741825	; 0x40000001
    1d5c:	6a5b6843 	bvs	0x16dbe70
    1d60:	721c189b 	andvcs	a2, IP, #10158080	; 0x9b0000
    1d64:	6a5b6843 	bvs	0x16dbe78
    1d68:	725c189b 	subvcs	a2, IP, #10158080	; 0x9b0000
    1d6c:	6a5b6843 	bvs	0x16dbe80
    1d70:	805c189b 	ldrhib	a2, [IP], #-139
    1d74:	6a5b6843 	bvs	0x16dbe88
    1d78:	809c189b 	umullhis	a2, IP, v8, v5
    1d7c:	6a5b6843 	bvs	0x16dbe90
    1d80:	80dc189b 	smullhis	a2, IP, v8, v5
    1d84:	6a5b6843 	bvs	0x16dbe98
    1d88:	2301189a 	tstcs	a2, #10092544	; 0x9a0000
    1d8c:	1c497413 	cfstrdne	mvd7, [v6], {19}
    1d90:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    1d94:	d3df2904 	bicles	a3, PC, #65536	; 0x10000
    1d98:	014a2100 	cmpeq	v7, a1, lsl #2
    1d9c:	6a5b6983 	bvs	0x16dc3b0
    1da0:	74dc189b 	ldrvcb	a2, [IP], #2203
    1da4:	6a5b6983 	bvs	0x16dc3b8
    1da8:	769c189b 	undefined
    1dac:	6a5b6983 	bvs	0x16dc3c0
    1db0:	765c189b 	undefined
    1db4:	6a5b6983 	bvs	0x16dc3c8
    1db8:	751c189b 	ldrvc	a2, [IP, #-2203]
    1dbc:	6a5b6983 	bvs	0x16dc3d0
    1dc0:	60dc189b 	smullvss	a2, IP, v8, v5
    1dc4:	6a5b6983 	bvs	0x16dc3d8
    1dc8:	771c189b 	undefined
    1dcc:	6a5b6983 	bvs	0x16dc3e0
    1dd0:	236f189a 	cmncs	PC, #10092544	; 0x9a0000
    1dd4:	1c497493 	cfstrdne	mvd7, [v6], {147}
    1dd8:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    1ddc:	d3dc2903 	bicles	a3, IP, #49152	; 0xc000
    1de0:	0000e016 	andeq	LR, a1, v3, lsl a1
    1de4:	0000015c 	andeq	a1, a1, IP, asr a2
    1de8:	4a90b510 	bmi	0xfe42f230
    1dec:	23146852 	tstcs	v1, #5373952	; 0x520000
    1df0:	18d3434b 	ldmneia	a4, {a1, a2, a4, v3, v5, v6, LR}^
    1df4:	721c24ff 	andvcs	a3, IP, #-16777216	; 0xff000000
    1df8:	2bff7803 	blcs	0xfffdfe0c
    1dfc:	7001d101 	andvc	SP, a2, a2, lsl #2
    1e00:	7843e004 	stmvcda	a4, {a3, SP, LR, PC}^
    1e04:	43632414 	cmnmi	a4, #335544320	; 0x14000000
    1e08:	721118d2 	andvcs	a2, a2, #13762560	; 0xd20000
    1e0c:	46c07041 	strmib	v4, [a1], a2, asr #32
    1e10:	bc01bc10 	stclt	12, cr11, [a2], {16}
    1e14:	00004700 	andeq	v1, a1, a1, lsl #14
    1e18:	7802b5f3 	stmvcda	a3, {a1, a2, v1, v2, v3, v4, v5, v7, IP, SP, PC}
    1e1c:	685b4b83 	ldmvsda	v8, {a1, a2, v4, v5, v6, v8, LR}^
    1e20:	23149300 	tstcs	v1, #0	; 0x0
    1e24:	9c00434b 	stcls	3, cr4, [a1], {75}
    1e28:	23ff18e4 	mvncss	a2, #14942208	; 0xe40000
    1e2c:	d107428a 	smlabble	v4, v7, a3, v1
    1e30:	70017a21 	andvc	v4, a2, a2, lsr #20
    1e34:	78017223 	stmvcda	a2, {a1, a2, v2, v6, IP, SP, LR}
    1e38:	d11629ff 	ldrlesh	a3, [v3, -PC]
    1e3c:	e0147043 	ands	v4, v1, a4, asr #32
    1e40:	43552514 	cmpmi	v2, #83886080	; 0x5000000
    1e44:	19759e00 	ldmnedb	v2!, {v6, v7, v8, IP, PC}^
    1e48:	7a2f466e 	bvc	0xbd3808
    1e4c:	7a2e7137 	bvc	0xb9e330
    1e50:	d106428e 	smlabble	v3, LR, a3, v1
    1e54:	722e7a26 	eorvc	v4, LR, #155648	; 0x26000
    1e58:	78457223 	stmvcda	v2, {a1, a2, v2, v6, IP, SP, LR}^
    1e5c:	d10042a9 	smlatble	a1, v6, a3, v1
    1e60:	466a7042 	strmibt	v4, [v7], -a3, asr #32
    1e64:	2aff7912 	bcs	0xfffe02b4
    1e68:	46c0d1ea 	strmib	SP, [a1], v7, ror #3
    1e6c:	bc01bcfc 	stclt	12, cr11, [a2], {252}
    1e70:	00004700 	andeq	v1, a1, a1, lsl #14
    1e74:	7801b510 	stmvcda	a2, {v1, v5, v7, IP, SP, PC}
    1e78:	42917842 	addmis	v4, a2, #4325376	; 0x420000
    1e7c:	4a6bd00e 	bmi	0x1af5ebc
    1e80:	23146852 	tstcs	v1, #5373952	; 0x520000
    1e84:	18d3434b 	ldmneia	a4, {a1, a2, a4, v3, v5, v6, LR}^
    1e88:	70047a1c 	andvc	v4, v1, IP, lsl v7
    1e8c:	721c24ff 	andvcs	a3, IP, #-16777216	; 0xff000000
    1e90:	24147843 	ldrcs	v4, [v1], #-2115
    1e94:	18d24363 	ldmneia	a3, {a1, a2, v2, v3, v5, v6, LR}^
    1e98:	70417211 	subvc	v4, a2, a2, lsl a3
    1e9c:	0000e7b8 	streqh	LR, [a1], -v5
    1ea0:	1c04b530 	cfstr32ne	mvfx11, [v1], {48}
    1ea4:	20001c0d 	andcs	a2, a1, SP, lsl #24
    1ea8:	29ff7821 	ldmcsib	PC!, {a1, v2, v8, IP, SP, LR}^
    1eac:	7025d101 	eorvc	SP, v2, a2, lsl #2
    1eb0:	1c29e00a 	stcne	0, cr14, [v6], #-40
    1eb4:	303048a9 	eorccs	v1, a1, v6, lsr #17
    1eb8:	ffaef7ff 	swinv	0x00aef7ff
    1ebc:	1c641c29 	stcnel	12, cr1, [v1], #-164
    1ec0:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
    1ec4:	2002ff91 	mulcs	a3, a2, PC
    1ec8:	faa3f7fe 	blx	0xfe8ffec8
    1ecc:	1c04b510 	cfstr32ne	mvfx11, [v1], {16}
    1ed0:	70017841 	andvc	v4, a2, a2, asr #16
    1ed4:	d00729ff 	strled	a3, [v4], -PC
    1ed8:	f7ff1c40 	ldrnvb	a2, [PC, a1, asr #24]!
    1edc:	7821ff9d 	stmvcda	a2!, {a1, a3, a4, v1, v4, v5, v6, v7, v8, IP, SP, LR, PC}
    1ee0:	3030489e 	mlaccs	a1, LR, v5, v1
    1ee4:	ff80f7ff 	swinv	0x0080f7ff
    1ee8:	f82cf003 	stmnvda	IP!, {a1, a2, IP, SP, LR, PC}
    1eec:	1c04b5f0 	cfstr32ne	mvfx11, [v1], {240}
    1ef0:	20001c15 	andcs	a2, a1, v2, lsl IP
    1ef4:	428143c0 	addmi	v1, a2, #3	; 0x3
    1ef8:	4285d101 	addmi	SP, v2, #1073741824	; 0x40000000
    1efc:	1c0ed01b 	stcne	0, cr13, [LR], {27}
    1f00:	4896e015 	ldmmiia	v3, {a1, a3, v1, SP, LR, PC}
    1f04:	21146842 	tstcs	v1, a3, asr #16
    1f08:	18514361 	ldmneda	a2, {a1, v2, v3, v5, v6, LR}^
    1f0c:	5d8968c9 	stcpl	8, cr6, [v6, #804]
    1f10:	434b2314 	cmpmi	v8, #1342177280	; 0x50000000
    1f14:	79d718d2 	ldmvcib	v4, {a2, v1, v3, v4, v8, IP}^
    1f18:	71d71e7f 	bicvcs	a2, v4, PC, ror LR
    1f1c:	18d26842 	ldmneia	a3, {a2, v3, v8, SP, LR}^
    1f20:	2a0079d2 	bcs	0x20670
    1f24:	3030d102 	eorccs	SP, a1, a3, lsl #2
    1f28:	ff5ef7ff 	swinv	0x005ef7ff
    1f2c:	04361c76 	ldreqt	a2, [v3], #-3190
    1f30:	42b51436 	adcmis	a2, v2, #905969664	; 0x36000000
    1f34:	e1fbdae5 	mvns	SP, v2, ror #21
    1f38:	2214b510 	andcss	v8, v1, #67108864	; 0x4000000
    1f3c:	4887434a 	stmmiia	v4, {a2, a4, v3, v5, v6, LR}
    1f40:	189b6843 	ldmneia	v8, {a1, a2, v3, v8, SP, LR}
    1f44:	1e6479dc 	mcrne	9, 3, v4, cr4, cr12, {6}
    1f48:	684371dc 	stmvsda	a4, {a3, a4, v1, v3, v4, v5, IP, SP, LR}^
    1f4c:	79d2189a 	ldmvcib	a3, {a2, a4, v1, v4, v8, IP}^
    1f50:	d1022a00 	tstle	a3, a1, lsl #20
    1f54:	f7ff3030 	undefined
    1f58:	f002ff47 	andnv	PC, a3, v4, asr #30
    1f5c:	0000fff3 	streqd	PC, [a1], -a4
    1f60:	487e1c01 	ldmmida	LR!, {a1, v7, v8, IP}^
    1f64:	42917e82 	addmis	v4, a2, #2080	; 0x820
    1f68:	0fc04180 	swieq	0x00c04180
    1f6c:	00004770 	andeq	v1, a1, a1, ror v4
    1f70:	487ab530 	ldmmida	v7!, {v1, v2, v5, v7, IP, SP, PC}^
    1f74:	31344909 	teqcc	v1, v6, lsl #18
    1f78:	21006101 	tstcs	a1, a2, lsl #2
    1f7c:	4d062200 	sfmmi	f2, 4, [v3]
    1f80:	69040093 	stmvsdb	v1, {a1, a2, v1, v4}
    1f84:	1c5250e5 	mrrcne	0, 14, v2, a3, cr5
    1f88:	019b2380 	orreqs	a3, v8, a1, lsl #7
    1f8c:	d3f7429a 	mvnles	v1, #-1610612727	; 0xa0000009
    1f90:	f7fe6141 	ldrnvb	v3, [LR, a2, asr #2]!
    1f94:	46c0fe33 	undefined
    1f98:	deadbeef 	cdple	14, 10, cr11, cr13, cr15, {7}
    1f9c:	0000064c 	andeq	a1, a1, IP, asr #12
    1fa0:	1c04b5f3 	cfstr32ne	mvfx11, [v1], {243}
    1fa4:	f0001c15 	andnv	a2, a1, v2, lsl IP
    1fa8:	210afed5 	ldrcsd	PC, [v7, -v2]
    1fac:	91004341 	tstls	a1, a2, asr #6
    1fb0:	6af24e1e 	bvs	0xffc95830
    1fb4:	888f1851 	stmhiia	PC, {a1, v1, v3, v8, IP}
    1fb8:	f0001c29 	andnv	a2, a1, v6, lsr #24
    1fbc:	2800f83d 	stmcsda	a1, {a1, a3, a4, v1, v2, v8, IP, SP, LR, PC}
    1fc0:	e035da00 	eors	SP, v2, a1, lsl #20
    1fc4:	1c644669 	stcnel	6, cr4, [v1], #-420
    1fc8:	42bd808c 	adcmis	v5, SP, #140	; 0x8c
    1fcc:	1c2cd215 	sfmne	f5, 1, [IP], #-84
    1fd0:	0c240424 	cfstrseq	mvf0, [v1], #-144
    1fd4:	d2f442bc 	rscles	v1, v1, #-1073741813	; 0xc000000b
    1fd8:	6af19800 	bvs	0xffc67fe0
    1fdc:	88011808 	stmhida	a2, {a4, v8, IP}
    1fe0:	43608840 	cmnmi	a1, #4194304	; 0x400000
    1fe4:	04091809 	streq	a2, [v6], #-2057
    1fe8:	46680c09 	strmibt	a1, [v5], -v6, lsl #24
    1fec:	f0008880 	andnv	v5, a1, a1, lsl #17
    1ff0:	2800f8fb 	stmcsda	a1, {a1, a2, a4, v1, v2, v3, v4, v8, IP, SP, LR, PC}
    1ff4:	1c64dbe5 	stcnel	11, cr13, [v1], #-916
    1ff8:	42afe7ea 	adcmi	LR, PC, #61341696	; 0x3a80000
    1ffc:	1c3cd2e1 	lfmne	f5, 1, [IP], #-900
    2000:	0c240424 	cfstrseq	mvf0, [v1], #-144
    2004:	d2dc42ac 	sbcles	v1, IP, #-1073741814	; 0xc000000a
    2008:	6af19800 	bvs	0xffc68010
    200c:	88011808 	stmhida	a2, {a4, v8, IP}
    2010:	43608840 	cmnmi	a1, #4194304	; 0x400000
    2014:	04091809 	streq	a2, [v6], #-2057
    2018:	46680c09 	strmibt	a1, [v5], -v6, lsl #24
    201c:	f0008880 	andnv	v5, a1, a1, lsl #17
    2020:	2800f89f 	stmcsda	a1, {a1, a2, a3, a4, v1, v4, v8, IP, SP, LR, PC}
    2024:	1c64dbcd 	stcnel	11, cr13, [v1], #-820
    2028:	0000e7ea 	andeq	LR, a1, v7, ror #15
    202c:	00008680 	andeq	v5, a1, a1, lsl #13
    2030:	bc02bcfc 	stclt	12, cr11, [a3], {252}
    2034:	00004708 	andeq	v1, a1, v5, lsl #14
    2038:	b081b5f1 	strltd	v8, [a2], a2
    203c:	46681c0c 	strmibt	a2, [v5], -IP, lsl #24
    2040:	200a8885 	andcs	v5, v7, v2, lsl #17
    2044:	4e454345 	cdpmi	3, 4, cr4, cr5, cr5, {2}
    2048:	19416af0 	stmnedb	a2, {v1, v2, v3, v4, v6, v8, SP, LR}^
    204c:	42a2888a 	adcmi	v5, a3, #9043968	; 0x8a0000
    2050:	2000d101 	andcs	SP, a1, a2, lsl #2
    2054:	4294e07e 	addmis	LR, v1, #126	; 0x7e
    2058:	808cd201 	addhi	SP, IP, a2, lsl #4
    205c:	466ae7f9 	undefined
    2060:	4363884b 	cmnmi	a4, #4915200	; 0x4b0000
    2064:	8bf28013 	blhi	0xffca20b8
    2068:	880f4bb4 	stmhida	PC, {a3, v1, v2, v4, v5, v6, v8, LR}
    206c:	d011429f 	mulles	a2, PC, a3
    2070:	429f890f 	addmis	v5, PC, #245760	; 0x3c000
    2074:	890bd006 	stmhidb	v8, {a2, a3, IP, LR, PC}
    2078:	437b270a 	cmnmi	v8, #2621440	; 0x280000
    207c:	880b5ac0 	stmhida	v8, {v3, v4, v6, v8, IP, LR}
    2080:	e0011ac0 	and	a2, a2, a1, asr #21
    2084:	1a108808 	bne	0x4240ac
    2088:	881b466b 	ldmhida	v8, {a1, a2, a4, v2, v3, v6, v7, LR}
    208c:	0c000400 	cfstrseq	mvf0, [a1], {0}
    2090:	d2e24298 	rscle	v1, a3, #-2147483639	; 0x80000009
    2094:	1c036970 	stcne	9, cr6, [a4], {112}
    2098:	42382703 	eormis	a3, v5, #786432	; 0xc0000
    209c:	1d1bd004 	ldcne	0, cr13, [v8, #-16]
    20a0:	0f800780 	swieq	0x00800780
    20a4:	61701a18 	cmnvs	a1, v5, lsl v7
    20a8:	0f801050 	swieq	0x00801050
    20ac:	1c181883 	ldcne	8, cr1, [v5], {131}
    20b0:	1a1043b8 	bne	0x412f98
    20b4:	4828d003 	stmmida	v5!, {a1, a2, IP, LR, PC}
    20b8:	1d004018 	stcne	0, cr4, [a1, #-96]
    20bc:	697083f0 	ldmvsdb	a1!, {v1, v2, v3, v4, v5, v6, PC}^
    20c0:	8812466a 	ldmhida	a3, {a2, a4, v2, v3, v6, v7, LR}
    20c4:	23801882 	orrcs	a2, a1, #8519680	; 0x820000
    20c8:	429a021b 	addmis	a1, v7, #-1342177279	; 0xb0000001
    20cc:	2004d302 	andcs	SP, v1, a3, lsl #6
    20d0:	e03f43c0 	eors	v1, PC, a1, asr #7
    20d4:	181f6933 	ldmneda	PC, {a1, a2, v1, v2, v5, v8, SP, LR}
    20d8:	8bf06172 	blhi	0xffc1a6a8
    20dc:	8812466a 	ldmhida	a3, {a2, a4, v2, v3, v6, v7, LR}
    20e0:	83f01880 	mvnhis	a2, #8388608	; 0x800000
    20e4:	8888884a 	stmhiia	v5, {a2, a4, v3, v8, PC}
    20e8:	04124342 	ldreq	v1, [a3], #-834
    20ec:	88080c12 	stmhida	v5, {a2, v1, v7, v8}
    20f0:	180968f1 	stmneda	v6, {a1, v1, v2, v3, v4, v8, SP, LR}
    20f4:	f0121c38 	andnvs	a2, a3, v5, lsr IP
    20f8:	4668ff4f 	strmibt	PC, [v5], -PC, asr #30
    20fc:	210a8880 	smlabbcs	v7, a1, v5, v5
    2100:	49164348 	ldmmidb	v3, {a4, v3, v5, v6, LR}
    2104:	18086ac9 	stmneda	v5, {a1, a4, v3, v4, v6, v8, SP, LR}
    2108:	46688842 	strmibt	v5, [v5], -a3, asr #16
    210c:	210a8880 	smlabbcs	v7, a1, v5, v5
    2110:	49124348 	ldmmidb	a3, {a4, v3, v5, v6, LR}
    2114:	18086ac9 	stmneda	v5, {a1, a4, v3, v4, v6, v8, SP, LR}
    2118:	43428880 	cmpmi	a3, #8388608	; 0x800000
    211c:	0c120412 	cfldrseq	mvf0, [a3], {18}
    2120:	466920ff 	undefined
    2124:	230a8889 	tstcs	v7, #8978432	; 0x890000
    2128:	4b0c4359 	blmi	0x312e94
    212c:	5a596adb 	bpl	0x165cca0
    2130:	68db4b0a 	ldmvsia	v8, {a2, a4, v5, v6, v8, LR}^
    2134:	2a001859 	bcs	0x82a0
    2138:	1e52d002 	cdpne	0, 5, cr13, cr2, cr2, {0}
    213c:	d1fc5488 	mvnles	v2, v5, lsl #9
    2140:	19406af0 	stmnedb	a1, {v1, v2, v3, v4, v6, v8, SP, LR}^
    2144:	1a7968f1 	bne	0x1e5c510
    2148:	80848001 	addhi	v5, v1, a2
    214c:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    2150:	f99cf000 	ldmnvib	IP, {IP, SP, LR, PC}
    2154:	0000e76c 	andeq	LR, a1, IP, ror #14
    2158:	0000fffc 	streqd	PC, [a1], -IP
    215c:	00008680 	andeq	v5, a1, a1, lsl #13
    2160:	b081b5f3 	strltd	v8, [a2], a4
    2164:	24012700 	strcs	a3, [a2], #-1792
    2168:	e00d2500 	and	a3, SP, a1, lsl #10
    216c:	0c360436 	cfldrseq	mvf0, [v3], #-216
    2170:	68c04871 	stmvsia	a1, {a1, v1, v2, v3, v8, LR}^
    2174:	88094669 	stmhida	v6, {a1, a4, v2, v3, v6, v7, LR}
    2178:	1c6d5381 	stcnel	3, cr5, [SP], #-516
    217c:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    2180:	0c240424 	cfstrseq	mvf0, [v1], #-144
    2184:	d22942a5 	eorle	v1, v6, #1342177290	; 0x5000000a
    2188:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    218c:	04301946 	ldreqt	a2, [a1], #-2374
    2190:	f0000c00 	andnv	a1, a1, a1, lsl #24
    2194:	2808fb5f 	stmcsda	v5, {a1, a2, a3, a4, v1, v3, v5, v6, v8, IP, SP, LR, PC}
    2198:	4668d105 	strmibt	SP, [v5], -v2, lsl #2
    219c:	f0008880 	andnv	v5, a1, a1, lsl #17
    21a0:	1824fdcf 	stmneda	v1!, {a1, a2, a3, a4, v3, v4, v5, v7, v8, IP, SP, LR, PC}
    21a4:	2807e7e9 	stmcsda	v4, {a1, a4, v2, v3, v4, v5, v6, v7, SP, LR, PC}
    21a8:	0430d1e7 	ldreqt	SP, [a1], #-487
    21ac:	f0000c00 	andnv	a1, a1, a1, lsl #24
    21b0:	2102f92f 	tstcsp	a3, PC, lsr #18
    21b4:	8892466a 	ldmhiia	a3, {a2, a4, v2, v3, v6, v7, LR}
    21b8:	00921952 	addeqs	a2, a3, a3, asr v6
    21bc:	689b4b5e 	ldmvsia	v8, {a2, a3, a4, v1, v3, v5, v6, v8, LR}
    21c0:	5e51189a 	mrcpl	8, 2, a2, cr1, cr10, {4}
    21c4:	8912466a 	ldmhidb	a3, {a2, a4, v2, v3, v6, v7, LR}
    21c8:	0432188e 	ldreqt	a2, [a3], #-2190
    21cc:	1c010c12 	stcne	12, cr0, [a2], {18}
    21d0:	f0004668 	andnv	v1, a1, v5, ror #12
    21d4:	1c07f859 	stcne	8, cr15, [v4], {89}
    21d8:	dac72800 	ble	0xff1cc1e0
    21dc:	46c01c38 	undefined
    21e0:	bc02bcfe 	stclt	12, cr11, [a3], {254}
    21e4:	00004708 	andeq	v1, a1, v5, lsl #14
    21e8:	b082b5f2 	strltd	v8, [a3], a3
    21ec:	26001c07 	strcs	a2, [a1], -v4, lsl #24
    21f0:	fb30f000 	blx	0xc3e1fa
    21f4:	1c79466a 	ldcnel	6, cr4, [v6], #-424
    21f8:	25008011 	strcs	v5, [a1, #-17]
    21fc:	d12a2807 	teqle	v7, v4, lsl #16
    2200:	89014668 	stmhidb	a2, {a4, v2, v3, v6, v7, LR}
    2204:	f0001c38 	andnv	a2, a1, v5, lsr IP
    2208:	1c07fda5 	stcne	13, cr15, [v4], {165}
    220c:	4378200a 	cmnmi	v5, #10	; 0xa
    2210:	49499001 	stmmidb	v6, {a1, IP, PC}^
    2214:	18086ac9 	stmneda	v5, {a1, a4, v3, v4, v6, v8, SP, LR}
    2218:	e0008884 	and	v5, a1, v1, lsl #17
    221c:	042d1c6d 	streqt	a2, [SP], #-3181
    2220:	42a50c2d 	adcmi	a1, v2, #11520	; 0x2d00
    2224:	9801d212 	stmlsda	a2, {a2, v1, v6, IP, LR, PC}
    2228:	6ac94943 	bvs	0xff25473c
    222c:	88011808 	stmhida	a2, {a4, v8, IP}
    2230:	43688840 	cmnmi	v5, #4194304	; 0x400000
    2234:	04091809 	streq	a2, [v6], #-2057
    2238:	46680c09 	strmibt	a1, [v5], -v6, lsl #24
    223c:	f7ff8800 	ldrnvb	v5, [PC, a1, lsl #16]!
    2240:	1c06ffd3 	stcne	15, cr15, [v3], {211}
    2244:	dae92800 	ble	0xffa4c24c
    2248:	e7c91c30 	undefined
    224c:	f0001c38 	andnv	a2, a1, v5, lsr IP
    2250:	1c06f84b 	stcne	8, cr15, [v3], {75}
    2254:	2808e7f8 	stmcsda	v5, {a4, v1, v2, v3, v4, v5, v6, v7, SP, LR, PC}
    2258:	1c38d1f6 	ldfned	f5, [v5], #-984
    225c:	fd70f000 	ldc2l	0, cr15, [a1]
    2260:	46681c04 	strmibt	a2, [v5], -v1, lsl #24
    2264:	042d8807 	streqt	v5, [SP], #-2055
    2268:	42a50c2d 	adcmi	a1, v2, #11520	; 0x2d00
    226c:	4668d2ec 	strmibt	SP, [v5], -IP, ror #5
    2270:	19788901 	ldmnedb	v5!, {a1, v5, v8, PC}^
    2274:	0c000400 	cfstrseq	mvf0, [a1], {0}
    2278:	ffb6f7ff 	swinv	0x00b6f7ff
    227c:	28001c06 	stmcsda	a1, {a2, a3, v7, v8, IP}
    2280:	1c6ddbe2 	stcnel	11, cr13, [SP], #-904
    2284:	0000e7ef 	andeq	LR, a1, PC, ror #15
    2288:	1c04b5f2 	cfstr32ne	mvfx11, [v1], {242}
    228c:	4e2b1c15 	mcrmi	12, 1, a2, cr11, cr5, {0}
    2290:	8d384f29 	ldchi	15, cr4, [v5, #-164]!
    2294:	d10542b0 	strleh	v1, [v2, -a1]
    2298:	f0002005 	andnv	a3, a1, v2
    229c:	2800f851 	stmcsda	a1, {a1, v1, v3, v8, IP, SP, LR, PC}
    22a0:	e0b1da00 	adcs	SP, a2, a1, lsl #20
    22a4:	80208d38 	eorhi	v5, a1, v5, lsr SP
    22a8:	4341210a 	cmpmi	a2, #-2147483646	; 0x80000002
    22ac:	18516afa 	ldmneda	a2, {a2, a4, v1, v2, v3, v4, v6, v8, SP, LR}^
    22b0:	85398909 	ldrhi	v5, [v6, #-2313]!
    22b4:	f90ef000 	stmnvdb	LR, {IP, SP, LR, PC}
    22b8:	88226af9 	stmhida	a3!, {a1, a4, v1, v2, v3, v4, v6, v8, SP, LR}
    22bc:	435a230a 	cmpmi	v7, #671088640	; 0x28000000
    22c0:	8822528e 	stmhida	a3!, {a2, a3, a4, v4, v6, IP, LR}
    22c4:	188a435a 	stmneia	v7, {a2, a4, v1, v3, v5, v6, LR}
    22c8:	881b466b 	ldmhida	v8, {a1, a2, a4, v2, v3, v6, v7, LR}
    22cc:	88228053 	stmhida	a3!, {a1, a2, v1, v3, PC}
    22d0:	435a230a 	cmpmi	v7, #671088640	; 0x28000000
    22d4:	2300188a 	tstcs	a1, #9043968	; 0x8a0000
    22d8:	88228093 	stmhida	a3!, {a1, a2, v1, v4, PC}
    22dc:	435a230a 	cmpmi	v7, #671088640	; 0x28000000
    22e0:	80cd1889 	sbchi	a2, SP, v6, lsl #17
    22e4:	0000e7dd 	ldreqd	LR, [a1], -SP
    22e8:	4913b5f0 	ldmmidb	a4, {v1, v2, v3, v4, v5, v7, IP, SP, PC}
    22ec:	230a6aca 	tstcs	v7, #827392	; 0xca000
    22f0:	18d34343 	ldmneia	a4, {a1, a2, v3, v5, v6, LR}^
    22f4:	809c2400 	addhis	a3, IP, a1, lsl #8
    22f8:	4c10805c 	ldcmi	0, cr8, [a1], {92}
    22fc:	80dc801c 	sbchis	v5, IP, IP, lsl a1
    2300:	42a88c8d 	adcmi	v5, v5, #36096	; 0x8d00
    2304:	891ad103 	ldmhidb	v7, {a1, a2, v5, IP, LR, PC}
    2308:	e00e848a 	and	v5, LR, v7, lsl #9
    230c:	42a58935 	adcmi	v5, v2, #868352	; 0xd4000
    2310:	260ad00b 	strcs	SP, [v7], -v8
    2314:	1996436e 	ldmneib	v3, {a2, a3, a4, v2, v3, v5, v6, LR}
    2318:	42878937 	addmi	v5, v4, #901120	; 0xdc000
    231c:	891ad1f6 	ldmhidb	v7, {a2, a3, v1, v2, v3, v4, v5, IP, LR, PC}
    2320:	8cca8132 	stfhip	f0, [v7], {50}
    2324:	d1004290 	strleb	v1, [a1, -a1]
    2328:	8d0a84cd 	cfstrshi	mvf8, [v7, #-820]
    232c:	8508811a 	strhi	v5, [v5, #-282]
    2330:	bcf02000 	ldcltl	0, cr2, [a1]
    2334:	4708bc02 	strmi	v8, [v5, -a3, lsl #24]
    2338:	00008680 	andeq	v5, a1, a1, lsl #13
    233c:	0000ffff 	streqd	PC, [a1], -PC
    2340:	4cbeb5f1 	cfldr32mi	mvfx11, [LR], #964
    2344:	466a6ae1 	strmibt	v3, [v7], -a2, ror #21
    2348:	8013888b 	andhis	v5, a4, v8, lsl #17
    234c:	18158812 	ldmneda	v2, {a2, v1, v8, PC}
    2350:	436a884a 	cmnmi	v7, #4849664	; 0x4a0000
    2354:	1c036960 	stcne	9, cr6, [a4], {96}
    2358:	42302603 	eormis	a3, a1, #3145728	; 0x300000
    235c:	1d1bd004 	ldcne	0, cr13, [v8, #-16]
    2360:	0f800780 	swieq	0x00800780
    2364:	61601a18 	cmnvs	a1, v5, lsl v7
    2368:	10588be3 	subnes	v5, v5, a4, ror #23
    236c:	18c60f80 	stmneia	v3, {v4, v5, v6, v7, v8}^
    2370:	27031c30 	smladxcs	a4, a1, IP, a2
    2374:	1a1843b8 	bne	0x61325c
    2378:	48b2d003 	ldmmiia	a3!, {a1, a2, IP, LR, PC}
    237c:	1d004030 	stcne	0, cr4, [a1, #-192]
    2380:	696383e0 	stmvsdb	a4!, {v2, v3, v4, v5, v6, PC}^
    2384:	0c120412 	cfldrseq	mvf0, [a3], {18}
    2388:	26801898 	pkhbtcs	a2, a1, v5, LSL #17
    238c:	42b00236 	adcmis	a1, a1, #1610612739	; 0x60000003
    2390:	2004d302 	andcs	SP, v1, a3, lsl #6
    2394:	e03743c0 	eors	v1, v4, a1, asr #7
    2398:	18f66926 	ldmneia	v3!, {a2, a3, v2, v5, v8, SP, LR}^
    239c:	8be06160 	blhi	0xff81a924
    23a0:	83e01880 	mvnhi	a2, #8388608	; 0x800000
    23a4:	8888884a 	stmhiia	v5, {a2, a4, v3, v8, PC}
    23a8:	04124342 	ldreq	v1, [a3], #-834
    23ac:	1c300c12 	ldcne	12, cr0, [a1], #-72
    23b0:	fdf2f012 	ldc2l	0, cr15, [a3, #72]!
    23b4:	48a262e6 	stmmiia	a3!, {a2, a3, v2, v3, v4, v6, SP, LR}
    23b8:	83411a31 	cmphi	a2, #200704	; 0x31000
    23bc:	68e16ae0 	stmvsia	a2!, {v2, v3, v4, v6, v8, SP, LR}^
    23c0:	80011a71 	andhi	a2, a2, a2, ror v7
    23c4:	80856ae0 	addhi	v3, v2, a1, ror #21
    23c8:	1829489f 	stmneda	v6!, {a1, a2, a3, a4, v1, v4, v8, LR}
    23cc:	e0122500 	ands	a3, a3, a1, lsl #10
    23d0:	434a220a 	cmpmi	v7, #-1610612736	; 0xa0000000
    23d4:	52986ae3 	addpls	v3, v5, #929792	; 0xe3000
    23d8:	189b6ae3 	ldmneia	v8, {a1, a2, v2, v3, v4, v6, v8, SP, LR}
    23dc:	6ae3805d 	bvs	0xff8e2558
    23e0:	809d189b 	umullhis	a2, SP, v8, v5
    23e4:	189b6ae3 	ldmneia	v8, {a1, a2, v2, v3, v4, v6, v8, SP, LR}
    23e8:	6ae380d8 	bvs	0xff8e2750
    23ec:	8d23189a 	stchi	8, cr1, [a4, #-616]!
    23f0:	85218113 	strhi	v5, [a2, #-275]!
    23f4:	466a1809 	strmibt	a2, [v7], -v6, lsl #16
    23f8:	04098812 	streq	v5, [v6], #-2066
    23fc:	42910c09 	addmis	a1, a2, #2304	; 0x900
    2400:	2000d2e6 	andcs	SP, a1, v3, ror #5
    2404:	f842f000 	stmnvda	a3, {IP, SP, LR, PC}^
    2408:	bc02bcf8 	stclt	12, cr11, [a3], {248}
    240c:	00004708 	andeq	v1, a1, v5, lsl #14
    2410:	2401b5f1 	strcs	v8, [a2], #-1521
    2414:	26002500 	strcs	a3, [a1], -a1, lsl #10
    2418:	1c404669 	mcrrne	6, 6, v1, a1, cr9
    241c:	27008048 	strcs	v5, [a1, -v5, asr #32]
    2420:	46694668 	strmibt	v1, [v6], -v5, ror #12
    2424:	19c98849 	stmneib	v6, {a1, a4, v3, v8, PC}^
    2428:	88008001 	stmhida	a1, {a1, PC}
    242c:	fa12f000 	blx	0x4be434
    2430:	d1052808 	tstle	v2, v5, lsl #16
    2434:	88004668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}
    2438:	fc82f000 	stc2	0, cr15, [a3], {0}
    243c:	e0101824 	ands	a2, a1, v1, lsr #16
    2440:	fa6cf000 	blx	0x1b3e448
    2444:	042d1c02 	streqt	a2, [SP], #-3074
    2448:	1c280c2d 	stcne	12, cr0, [v5], #-180
    244c:	f0151c11 	andnvs	a2, v2, a2, lsl IP
    2450:	2800fa5d 	stmcsda	a1, {a1, a3, a4, v1, v3, v6, v8, IP, SP, LR, PC}
    2454:	18a9d001 	stmneia	v6!, {a1, IP, LR, PC}
    2458:	18ad1a0d 	stmneia	SP!, {a1, a3, a4, v6, v8, IP}
    245c:	d2004296 	andle	v1, a1, #1610612745	; 0x60000009
    2460:	1c7f1c16 	ldcnel	12, cr1, [PC], #-88
    2464:	0c3f043f 	cfldrseq	mvf0, [PC], #-252
    2468:	0c240424 	cfstrseq	mvf0, [v1], #-144
    246c:	d3d742a7 	bicles	v1, v4, #1879048202	; 0x7000000a
    2470:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    2474:	1c311c28 	ldcne	12, cr1, [a2], #-160
    2478:	fa48f015 	blx	0x123e4d4
    247c:	d0012800 	andle	a3, a2, a1, lsl #16
    2480:	1a0d19a9 	bne	0x348b2c
    2484:	0c000428 	cfstrseq	mvf0, [a1], {40}
    2488:	0000e7be 	streqh	LR, [a1], -LR
    248c:	4919b5f0 	ldmmidb	v6, {v1, v2, v3, v4, v5, v7, IP, SP, PC}
    2490:	42908cca 	addmis	v5, a1, #51712	; 0xca00
    2494:	e74bd100 	strb	SP, [v8, -a1, lsl #2]
    2498:	240a6acb 	strcs	v3, [v7], #-2763
    249c:	191c4344 	ldmnedb	IP, {a3, v3, v5, v6, LR}
    24a0:	4d698c8e 	stcmil	12, cr8, [v6, #-568]!
    24a4:	d10342b0 	strleh	v1, [a4, -a1]
    24a8:	848e8926 	strhi	v5, [LR], #2342
    24ac:	8936e00a 	ldmhidb	v3!, {a2, a4, SP, LR, PC}
    24b0:	d00742ae 	andle	v1, v4, LR, lsr #5
    24b4:	437e270a 	cmnmi	LR, #2621440	; 0x280000
    24b8:	8937199e 	ldmhidb	v4!, {a2, a3, a4, v1, v4, v5, v8, IP}
    24bc:	d1f64287 	mvnles	v1, v4, lsl #5
    24c0:	81378927 	teqhi	v4, v4, lsr #18
    24c4:	240a8125 	strcs	v5, [v7], #-293
    24c8:	189a4362 	ldmneia	v7, {a2, v2, v3, v5, v6, LR}
    24cc:	84c88110 	strhib	v5, [v5], #272
    24d0:	0000e7e1 	andeq	LR, a1, a2, ror #15
    24d4:	4907b410 	stmmidb	v4, {v1, v7, IP, SP, PC}
    24d8:	8ccb6aca 	fstmiashi	v8, {s13-s214}
    24dc:	4363240a 	cmnmi	a4, #167772160	; 0xa000000
    24e0:	811818d3 	ldrhisb	a2, [v5, -a4]
    24e4:	436084c8 	cmnmi	a1, #-939524096	; 0xc8000000
    24e8:	49571810 	ldmmidb	v4, {v1, v8, IP}^
    24ec:	20008101 	andcs	v5, a1, a2, lsl #2
    24f0:	4770bc10 	undefined
    24f4:	00008680 	andeq	v5, a1, a1, lsl #13
    24f8:	2400b570 	strcs	v8, [a1], #-1392
    24fc:	484f2200 	stmmida	PC, {v6, SP}^
    2500:	49518c83 	ldmmidb	a2, {a1, a2, v4, v7, v8, PC}^
    2504:	1c52e001 	mrrcne	0, 0, LR, a3, cr1
    2508:	6ac5892b 	bvs	0xff1649bc
    250c:	d011428b 	andles	v1, a2, v8, lsl #5
    2510:	435e260a 	cmpmi	LR, #10485760	; 0xa00000
    2514:	882e19ad 	stmhida	LR!, {a1, a3, a4, v2, v4, v5, v8, IP}
    2518:	d004428e 	andle	v1, v1, LR, lsl #5
    251c:	d20142a6 	andle	v1, a2, #1610612746	; 0x6000000a
    2520:	e0182000 	ands	a3, v5, a1
    2524:	892e1c34 	stmhidb	LR!, {a3, v1, v2, v7, v8, IP}
    2528:	d1ec428e 	mvnle	v1, LR, lsl #5
    252c:	42b38cc6 	adcmis	v5, a4, #50688	; 0xc600
    2530:	e7f5d0e9 	ldrb	SP, [v2, v6, ror #1]!
    2534:	e0048d03 	and	v5, v1, a4, lsl #26
    2538:	200a1c52 	andcs	a2, v7, a3, asr IP
    253c:	18e84343 	stmneia	v5!, {a1, a2, v3, v5, v6, LR}^
    2540:	428b8903 	addmi	v5, v8, #49152	; 0xc000
    2544:	88a8d1f8 	stmhiia	v5!, {a4, v1, v2, v3, v4, v5, IP, LR, PC}
    2548:	0c120412 	cfldrseq	mvf0, [a3], {18}
    254c:	d0014282 	andle	v1, a2, a3, lsl #5
    2550:	e0002000 	and	a3, a1, a1
    2554:	f0022001 	andnv	a3, a3, a2
    2558:	0000fbaf 	andeq	PC, a1, PC, lsr #23
    255c:	4c37b5f1 	cfldr32mi	mvfx11, [v4], #-964
    2560:	8ca68c25 	stchi	12, cr8, [v3], #148
    2564:	8800e020 	stmhida	a1, {v2, SP, LR, PC}
    2568:	88494669 	stmhida	v6, {a1, a4, v2, v3, v6, v7, LR}^
    256c:	0c090409 	cfstrseq	mvf0, [v6], {9}
    2570:	040022ff 	streq	a3, [a1], #-767
    2574:	4b310c00 	blmi	0xc4557c
    2578:	181868db 	ldmneda	v5, {a1, a2, a4, v1, v3, v4, v8, SP, LR}
    257c:	d0022900 	andle	a3, a3, a1, lsl #18
    2580:	54421e49 	strplb	a2, [a3], #-3657
    2584:	2e00d1fc 	mcrcs	1, 0, SP, cr0, cr12, {7}
    2588:	68e0d106 	stmvsia	a1!, {a2, a3, v5, IP, LR, PC}^
    258c:	62e01940 	rscvs	a2, a1, #1048576	; 0x100000
    2590:	6ae1482b 	bvs	0xff854644
    2594:	83411a09 	cmphi	a2, #36864	; 0x9000
    2598:	53c56ae0 	bicpl	v3, v2, #917504	; 0xe0000
    259c:	88404668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}^
    25a0:	6ae0182d 	bvs	0xff80865c
    25a4:	890619c0 	stmhidb	v3, {v3, v4, v5, v8, IP}
    25a8:	42864827 	addmi	v1, v3, #2555904	; 0x270000
    25ac:	042dd03a 	streqt	SP, [SP], #-58
    25b0:	10680c2d 	rsbne	a1, v5, SP, lsr #24
    25b4:	19420f80 	stmnedb	a3, {v4, v5, v6, v7, v8}^
    25b8:	23031c10 	tstcs	a4, #4096	; 0x1000
    25bc:	1a284398 	bne	0xa13424
    25c0:	4d20d002 	stcmi	0, cr13, [a1, #-8]!
    25c4:	1d2d4015 	stcne	0, cr4, [SP, #-84]!
    25c8:	4377270a 	cmnmi	v4, #2621440	; 0x280000
    25cc:	19c06ae0 	stmneib	a1, {v2, v3, v4, v6, v8, SP, LR}^
    25d0:	88024669 	stmhida	a3, {a1, a4, v2, v3, v6, v7, LR}
    25d4:	8809800a 	stmhida	v6, {a2, a4, PC}
    25d8:	42914a1b 	addmis	v1, a2, #110592	; 0x1b000
    25dc:	4669d0e1 	strmibt	SP, [v6], -a2, ror #1
    25e0:	88808842 	stmhiia	a1, {a2, v3, v8, PC}
    25e4:	804a4342 	subhi	v1, v7, a3, asr #6
    25e8:	88004668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}
    25ec:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    25f0:	d0d342a8 	sbcles	v1, a4, v5, lsr #5
    25f4:	884a68e0 	stmhida	v7, {v2, v3, v4, v8, SP, LR}^
    25f8:	18418809 	stmneda	a2, {a1, a4, v8, PC}^
    25fc:	f0121940 	andnvs	a2, a3, a1, asr #18
    2600:	4668fccb 	strmibt	PC, [v5], -v8, asr #25
    2604:	46698800 	strmibt	v5, [v6], -a1, lsl #16
    2608:	18698849 	stmneda	v6!, {a1, a4, v3, v8, PC}^
    260c:	46684288 	strmibt	v1, [v5], -v5, lsl #5
    2610:	8840daa9 	stmhida	a1, {a1, a4, v2, v4, v6, v8, IP, LR, PC}^
    2614:	46691828 	strmibt	a2, [v6], -v5, lsr #16
    2618:	1a098849 	bne	0x264744
    261c:	8812466a 	ldmhida	a3, {a2, a4, v2, v3, v6, v7, LR}
    2620:	e7a31889 	str	a2, [a4, v6, lsl #17]!
    2624:	1b418be0 	blne	0x10655ac
    2628:	04096962 	streq	v3, [v6], #-2402
    262c:	1a520c09 	bne	0x1485658
    2630:	1a406162 	bne	0x101abc0
    2634:	200083e0 	andcs	v5, a1, a1, ror #7
    2638:	0000e6e6 	andeq	LR, a1, v3, ror #13
    263c:	00008680 	andeq	v5, a1, a1, lsl #13
    2640:	0000064c 	andeq	a1, a1, IP, asr #12
    2644:	0000fffc 	streqd	PC, [a1], -IP
    2648:	0000ffff 	streqd	PC, [a1], -PC
    264c:	9900b5f6 	stmlsdb	a1, {a2, a3, v1, v2, v3, v4, v5, v7, IP, SP, PC}
    2650:	d1022900 	tstle	a3, a1, lsl #18
    2654:	43c02000 	bicmi	a3, a1, #0	; 0x0
    2658:	2814e061 	ldmcsda	v1, {a1, v2, v3, SP, LR, PC}
    265c:	2011d301 	andcss	SP, a2, a2, lsl #6
    2660:	4a96e7f9 	bmi	0xfe5bc64c
    2664:	312c1c11 	teqcc	IP, a2, lsl IP
    2668:	2bff7a4b 	blcs	0xfffe0f9c
    266c:	2013d102 	andcss	SP, a4, a3, lsl #2
    2670:	e05443c0 	subs	v1, v1, a1, asr #7
    2674:	889b466b 	ldmhiia	v8, {a1, a2, a4, v2, v3, v6, v7, LR}
    2678:	d3012b3c 	tstle	a2, #61440	; 0xf000
    267c:	e7ea2012 	undefined
    2680:	4358230e 	cmpmi	v5, #939524096	; 0x38000000
    2684:	20cd1814 	sbccs	a2, SP, v1, lsl v5
    2688:	18250040 	stmneda	v2!, {v3}
    268c:	007626cf 	rsbeqs	a3, v3, PC, asr #13
    2690:	00408868 	subeq	v5, a1, v5, ror #16
    2694:	5b801820 	blpl	0xfe00871c
    2698:	d0242800 	eorle	a3, v1, a1, lsl #16
    269c:	00408868 	subeq	v5, a1, v5, ror #16
    26a0:	5b801820 	blpl	0xfe008728
    26a4:	88896809 	stmhiia	v6, {a1, a4, v8, SP, LR}
    26a8:	d21c4288 	andles	v1, IP, #-2147483640	; 0x80000008
    26ac:	1c408828 	mcrrne	8, 2, v5, a1, cr8
    26b0:	f0152105 	andnvs	a3, v2, v2, lsl #2
    26b4:	8028f92b 	eorhi	PC, v5, v8, lsr #18
    26b8:	88814668 	stmhiia	a2, {a4, v2, v3, v6, v7, LR}
    26bc:	00408868 	subeq	v5, a1, v5, ror #16
    26c0:	5b801820 	blpl	0xfe008748
    26c4:	fcb8f7ff 	ldc2	7, cr15, [v5], #1020
    26c8:	28001c07 	stmcsda	a1, {a1, a2, a3, v7, v8, IP}
    26cc:	da158868 	ble	0x564874
    26d0:	18200040 	stmneda	a1!, {v3}
    26d4:	f7ff5b80 	ldrnvb	v2, [PC, a1, lsl #23]!
    26d8:	8868fe07 	stmhida	v5!, {a1, a2, a3, v6, v7, v8, IP, SP, LR, PC}^
    26dc:	18200040 	stmneda	a1!, {v3}
    26e0:	53814957 	orrpl	v1, a2, #1425408	; 0x15c000
    26e4:	4a56e01a 	bmi	0x15ba754
    26e8:	88682101 	stmhida	v5!, {a1, v5, SP}^
    26ec:	18200040 	stmneda	a1!, {v3}
    26f0:	f7ff1980 	ldrnvb	a2, [PC, a1, lsl #19]!
    26f4:	2800fdc9 	stmcsda	a1, {a1, a4, v3, v4, v5, v7, v8, IP, SP, LR, PC}
    26f8:	e010dade 	ldrsb	SP, [a1], -LR
    26fc:	18200040 	stmneda	a1!, {v3}
    2700:	f0005b80 	andnv	v2, a1, a1, lsl #23
    2704:	4669f951 	undefined
    2708:	9900888a 	stmlsdb	a1, {a2, a4, v4, v8, PC}
    270c:	fc44f012 	mcrr2	0, 1, PC, v1, cr2
    2710:	1c408868 	mcrrne	8, 6, v5, a1, cr8
    2714:	f0152105 	andnvs	a3, v2, v2, lsl #2
    2718:	8068f8f9 	strhid	PC, [v5], #-137
    271c:	e4871c38 	str	a2, [v4], #3128
    2720:	2900b510 	stmcsdb	a1, {v1, v5, v7, IP, SP, PC}
    2724:	2000d102 	andcs	SP, a1, a3, lsl #2
    2728:	e02b43c0 	eor	v1, v8, a1, asr #7
    272c:	1c1a4b63 	ldcne	11, cr4, [v7], {99}
    2730:	7a54322c 	bvc	0x150efe8
    2734:	d1032cff 	strled	a3, [a4, -PC]
    2738:	80082000 	andhi	a3, v5, a1
    273c:	e7f32013 	undefined
    2740:	d3042814 	tstle	v1, #1310720	; 0x140000
    2744:	80082000 	andhi	a3, v5, a1
    2748:	43c02011 	bicmi	a3, a1, #17	; 0x11
    274c:	240ee01a 	strcs	LR, [LR], #-26
    2750:	18184360 	ldmneda	v5, {v2, v3, v5, v6, LR}
    2754:	005b23cf 	subeqs	a3, v8, PC, asr #7
    2758:	006424cd 	rsbeq	a3, v1, SP, asr #9
    275c:	00645b04 	rsbeq	v2, v1, v1, lsl #22
    2760:	5ac01900 	bpl	0xff008b68
    2764:	d00a2800 	andle	a3, v7, a1, lsl #16
    2768:	88936812 	ldmhiia	a4, {a2, v1, v8, SP, LR}
    276c:	d2064298 	andle	v1, v3, #-2147483639	; 0x80000009
    2770:	4358230a 	cmpmi	v5, #671088640	; 0x28000000
    2774:	88801810 	stmhiia	a1, {v1, v8, IP}
    2778:	20008008 	andcs	v5, a1, v5
    277c:	2000e002 	andcs	LR, a1, a3
    2780:	20408008 	subcs	v5, a1, v5
    2784:	fbdff002 	blx	0xff7fe796
    2788:	b083b5f2 	strltd	v8, [a4], a3
    278c:	25001c1c 	strcs	a2, [a1, #-3100]
    2790:	29009903 	stmcsdb	a1, {a1, a2, v5, v8, IP, PC}
    2794:	2000d102 	andcs	SP, a1, a3, lsl #2
    2798:	e04f43c0 	sub	v1, PC, a1, asr #7
    279c:	1c194b47 	ldcne	11, cr4, [v6], {71}
    27a0:	7a4e312c 	bvc	0x138ec58
    27a4:	d1012eff 	strled	a3, [a2, -PC]
    27a8:	e7f52013 	undefined
    27ac:	d3022814 	tstle	a3, #1310720	; 0x140000
    27b0:	43c02011 	bicmi	a3, a1, #17	; 0x11
    27b4:	260ee042 	strcs	LR, [LR], -a3, asr #32
    27b8:	18184370 	ldmneda	v5, {v1, v2, v3, v5, v6, LR}
    27bc:	20cd9001 	sbccs	v6, SP, a2
    27c0:	9b010040 	blls	0x428c8
    27c4:	90001818 	andls	a2, a1, v5, lsl v5
    27c8:	007626cf 	rsbeqs	a3, v3, PC, asr #13
    27cc:	00408800 	subeq	v5, a1, a1, lsl #16
    27d0:	18189b01 	ldmneda	v5, {a1, v5, v6, v8, IP, PC}
    27d4:	2f005b87 	swics	0x00005b87
    27d8:	6808d02f 	stmvsda	v5, {a1, a2, a3, a4, v2, IP, LR, PC}
    27dc:	428f8881 	addmi	v5, PC, #8454144	; 0x810000
    27e0:	210ad22b 	tstcs	v7, v8, lsr #4
    27e4:	18404379 	stmneda	a1, {a1, a4, v1, v2, v3, v5, v6, LR}^
    27e8:	88809002 	stmhiia	a1, {a2, IP, PC}
    27ec:	d2014282 	andle	v1, a2, #536870920	; 0x20000008
    27f0:	e7d12012 	undefined
    27f4:	f0001c38 	andnv	a2, a1, v5, lsr IP
    27f8:	9902f8d7 	stmlsdb	a3, {a1, a2, a3, v1, v3, v4, v8, IP, SP, LR, PC}
    27fc:	1c01888a 	stcne	8, cr8, [a2], {138}
    2800:	f0129803 	andnvs	v6, a3, a4, lsl #16
    2804:	2c00fbc9 	stccs	11, cr15, [a1], {201}
    2808:	1c38d005 	ldcne	0, cr13, [v5], #-20
    280c:	fd6cf7ff 	stc2l	7, cr15, [IP, #-1020]!
    2810:	28001c05 	stmcsda	a1, {a1, a3, v7, v8, IP}
    2814:	1c28da01 	stcne	10, cr13, [v5], #-4
    2818:	9800e010 	stmlsda	a1, {v1, SP, LR, PC}
    281c:	00408800 	subeq	v5, a1, a1, lsl #16
    2820:	18089901 	stmneda	v5, {a1, v5, v8, IP, PC}
    2824:	53814906 	orrpl	v1, a2, #98304	; 0x18000
    2828:	98009a00 	stmlsda	a1, {v6, v8, IP, PC}
    282c:	1c408800 	mcrrne	8, 0, v5, a1, cr0
    2830:	f0152105 	andnvs	a3, v2, v2, lsl #2
    2834:	8010f86b 	andhis	PC, a1, v8, ror #16
    2838:	2040e7ed 	subcs	LR, a1, SP, ror #15
    283c:	e578b004 	ldrb	v8, [v5, #-4]!
    2840:	0000ffff 	streqd	PC, [a1], -PC
    2844:	481d1c01 	ldmmida	SP, {a1, v7, v8, IP}
    2848:	42918b82 	addmis	v5, a2, #133120	; 0x20800
    284c:	0fc04180 	swieq	0x00c04180
    2850:	00004770 	andeq	v1, a1, a1, ror v4
    2854:	49190080 	ldmmidb	v6, {v4}
    2858:	5c086889 	stcpl	8, cr6, [v5], {137}
    285c:	00004770 	andeq	v1, a1, a1, ror v4
    2860:	1c05b530 	cfstr32ne	mvfx11, [v2], {48}
    2864:	20001c14 	andcs	a2, a1, v1, lsl IP
    2868:	01d22280 	biceqs	a3, a3, a1, lsl #5
    286c:	d2094295 	andle	v1, v6, #1342177289	; 0x50000009
    2870:	f0001c28 	andnv	a2, a1, v5, lsr #24
    2874:	2c00f869 	stccs	8, cr15, [a1], {105}
    2878:	00a9d01e 	adceq	SP, v6, LR, lsl a1
    287c:	68924a0f 	ldmvsia	a3, {a1, a2, a3, a4, v6, v8, LR}
    2880:	e0185c51 	ands	v2, v5, a2, asr IP
    2884:	020921c0 	andeq	a3, v6, #48	; 0x30
    2888:	d015420d 	andles	v1, v2, SP, lsl #4
    288c:	06c00a68 	streqb	a1, [a1], v5, ror #20
    2890:	05ed0ec0 	streqb	a1, [SP, #3776]!
    2894:	28020ded 	stmcsda	a3, {a1, a3, a4, v2, v3, v4, v5, v7, v8}
    2898:	2d2dd201 	sfmcs	f5, 1, [SP, #-4]!
    289c:	2000d301 	andcs	SP, a1, a2, lsl #6
    28a0:	0081e00a 	addeq	LR, a2, v7
    28a4:	00a84a06 	adceq	v1, v5, v3, lsl #20
    28a8:	689b1853 	ldmvsia	v8, {a1, a2, v1, v3, v8, IP}
    28ac:	2c005818 	stccs	8, cr5, [a1], {24}
    28b0:	5851d002 	ldmplda	a2, {a2, IP, LR, PC}^
    28b4:	70215d49 	eorvc	v2, a2, v6, asr #26
    28b8:	fdabf7fd 	stc2	7, cr15, [v8, #1012]!
    28bc:	00008680 	andeq	v5, a1, a1, lsl #13
    28c0:	00000270 	andeq	a1, a1, a1, ror a3
    28c4:	d00d2800 	andle	a3, SP, a1, lsl #16
    28c8:	29011e49 	stmcsdb	a2, {a1, a4, v3, v6, v7, v8, IP}
    28cc:	1e89d909 	cdpne	9, 8, cr13, cr9, cr9, {0}
    28d0:	d9042901 	stmledb	v1, {a1, v5, v8, SP}
    28d4:	29011e89 	stmcsdb	a2, {a1, a4, v4, v6, v7, v8, IP}
    28d8:	6002d804 	andvs	SP, a3, v1, lsl #16
    28dc:	8002e002 	andhi	LR, a3, a3
    28e0:	7002e000 	andvc	LR, a3, a1
    28e4:	4770b000 	ldrmib	v8, [a1, -a1]!
    28e8:	d0142800 	andles	a3, v1, a1, lsl #16
    28ec:	29051e49 	stmcsdb	v2, {a1, a4, v3, v6, v7, v8, IP}
    28f0:	a201d811 	andge	SP, a2, #1114112	; 0x110000
    28f4:	44975c52 	ldrmi	v2, [v4], #3154
    28f8:	0c081612 	stceq	6, cr1, [v5], {18}
    28fc:	68000404 	stmvsda	a1, {a3, v7}
    2900:	8800e00a 	stmhida	a1, {a2, a4, SP, LR, PC}
    2904:	2100e008 	tstcs	a1, v5
    2908:	e0055e40 	and	v2, v2, a1, asr #28
    290c:	e0037800 	and	v4, a4, a1, lsl #16
    2910:	56402100 	strplb	a3, [a1], -a1, lsl #2
    2914:	2000e000 	andcs	LR, a1, a1
    2918:	4770b000 	ldrmib	v8, [a1, -a1]!
    291c:	28011e40 	stmcsda	a2, {v3, v6, v7, v8, IP}
    2920:	1e80d90d 	cdpne	9, 8, cr13, cr0, cr13, {0}
    2924:	d9082801 	stmledb	v5, {a1, v8, SP}
    2928:	28011e80 	stmcsda	a2, {v4, v6, v7, v8, IP}
    292c:	1e80d903 	cdpne	9, 8, cr13, cr0, cr3, {0}
    2930:	1e80d003 	cdpne	0, 8, cr13, cr0, cr3, {0}
    2934:	2004d105 	andcs	SP, v1, v2, lsl #2
    2938:	2002e004 	andcs	LR, a3, v1
    293c:	2001e002 	andcs	LR, a2, a3
    2940:	2000e000 	andcs	LR, a1, a1
    2944:	4770b000 	ldrmib	v8, [a1, -a1]!
    2948:	1c04b530 	cfstr32ne	mvfx11, [v1], {48}
    294c:	e0001c0d 	and	a2, a1, SP, lsl #24
    2950:	04201c64 	streqt	a2, [a1], #-3172
    2954:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    2958:	2807ff7d 	stmcsda	v4, {a1, a3, a4, v1, v2, v3, v5, v6, v7, v8, IP, SP, LR, PC}
    295c:	1c29d115 	stfned	f5, [v6], #-84
    2960:	0c000420 	cfstrseq	mvf0, [a1], {32}
    2964:	fa02f000 	blx	0xbe96c
    2968:	d1012800 	tstle	a2, a1, lsl #16
    296c:	e0192000 	ands	a3, v6, a1
    2970:	04201c29 	streqt	a2, [a1], #-3113
    2974:	f0000c00 	andnv	a1, a1, a1, lsl #24
    2978:	49b1f9ed 	ldmmiib	a2!, {a1, a3, a4, v2, v3, v4, v5, v8, IP, SP, LR, PC}
    297c:	4350220a 	cmpmi	a1, #-1610612736	; 0xa0000000
    2980:	5a106aca 	bpl	0x41d4b0
    2984:	180868c9 	stmneda	v5, {a1, a4, v3, v4, v8, SP, LR}
    2988:	2808e00c 	stmcsda	v5, {a3, a4, SP, LR, PC}
    298c:	49acd0e0 	stmmiib	IP!, {v2, v3, v4, IP, LR, PC}
    2990:	04242002 	streqt	a3, [v1], #-2
    2994:	00a20c24 	adceq	a1, a3, v1, lsr #24
    2998:	189a688b 	ldmneia	v7, {a1, a2, a4, v4, v8, SP, LR}
    299c:	68c95e10 	stmvsia	v6, {v1, v6, v7, v8, IP, LR}^
    29a0:	19401808 	stmnedb	a1, {a4, v8, IP}^
    29a4:	fd35f7fd 	ldc2	7, cr15, [v2, #-1012]!
    29a8:	220a49a5 	andcs	v1, v7, #2703360	; 0x294000
    29ac:	6aca4350 	bvs	0xff2936f4
    29b0:	68c95a10 	stmvsia	v6, {v1, v6, v8, IP, LR}^
    29b4:	47701808 	ldrmib	a2, [a1, -v5, lsl #16]!
    29b8:	1c04b570 	cfstr32ne	mvfx11, [v1], {112}
    29bc:	1c2ce000 	stcne	0, cr14, [IP]
    29c0:	04281c65 	streqt	a2, [v5], #-3173
    29c4:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    29c8:	2800ff3d 	stmcsda	a1, {a1, a3, a4, v1, v2, v5, v6, v7, v8, IP, SP, LR, PC}
    29cc:	480fd101 	stmmida	PC, {a1, v5, IP, LR, PC}
    29d0:	0420e01a 	streqt	LR, [a1], #-26
    29d4:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    29d8:	2807ff3d 	stmcsda	v4, {a1, a3, a4, v1, v2, v5, v6, v7, v8, IP, SP, LR, PC}
    29dc:	2808d0ef 	stmcsda	v5, {a1, a2, a3, a4, v2, v3, v4, IP, LR, PC}
    29e0:	0420d110 	streqt	SP, [a1], #-272
    29e4:	f0000c00 	andnv	a1, a1, a1, lsl #24
    29e8:	1c04f9ab 	stcne	9, cr15, [v1], {171}
    29ec:	e0052600 	and	a3, v2, a1, lsl #12
    29f0:	0c000428 	cfstrseq	mvf0, [a1], {40}
    29f4:	ffe0f7ff 	swinv	0x00e0f7ff
    29f8:	1c761c05 	ldcnel	12, cr1, [v3], #-20
    29fc:	0c360436 	cfldrseq	mvf0, [v3], #-216
    2a00:	d3f542a6 	mvnles	v1, #1610612746	; 0x6000000a
    2a04:	0c000428 	cfstrseq	mvf0, [a1], {40}
    2a08:	f956f002 	ldmnvdb	v3, {a2, IP, SP, LR, PC}^
    2a0c:	0000ffff 	streqd	PC, [a1], -PC
    2a10:	1c04b5f1 	cfstr32ne	mvfx11, [v1], {241}
    2a14:	f7ff1c0e 	ldrnvb	a2, [PC, LR, lsl #24]!
    2a18:	1c05ff1d 	stcne	15, cr15, [v2], {29}
    2a1c:	f7ff1c30 	undefined
    2a20:	4285ff19 	addmi	PC, v2, #100	; 0x64
    2a24:	2000d001 	andcs	SP, a1, a2
    2a28:	4669e033 	undefined
    2a2c:	80081c60 	andhi	a2, v5, a1, ror #24
    2a30:	2d081c77 	stccs	12, cr1, [v5, #-476]
    2a34:	1c20d122 	stfned	f5, [a1], #-136
    2a38:	f982f000 	stmnvib	a3, {IP, SP, LR, PC}
    2a3c:	1c301c05 	ldcne	12, cr1, [a1], #-20
    2a40:	f97ef000 	ldmnvdb	LR!, {IP, SP, LR, PC}^
    2a44:	d1ee4285 	mvnle	v1, v2, lsl #5
    2a48:	88044668 	stmhida	v1, {a4, v2, v3, v6, v7, LR}
    2a4c:	27001c3e 	smladxcs	a1, LR, IP, a2
    2a50:	0c3f043f 	cfldrseq	mvf0, [PC], #-252
    2a54:	d21b42af 	andles	v1, v8, #-268435446	; 0xf000000a
    2a58:	0c090431 	cfstrseq	mvf0, [v6], {49}
    2a5c:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
    2a60:	2800ffd7 	stmcsda	a1, {a1, a2, a3, v1, v3, v4, v5, v6, v7, v8, IP, SP, LR, PC}
    2a64:	1c20d0df 	stcne	0, cr13, [a1], #-892
    2a68:	ffa6f7ff 	swinv	0x00a6f7ff
    2a6c:	04301c04 	ldreqt	a2, [a1], #-3076
    2a70:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    2a74:	1c06ffa1 	stcne	15, cr15, [v3], {161}
    2a78:	e7e91c7f 	undefined
    2a7c:	d1072d07 	tstle	v4, v4, lsl #26
    2a80:	0c090439 	cfstrseq	mvf0, [v6], {57}
    2a84:	88004668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}
    2a88:	ffc2f7ff 	swinv	0x00c2f7ff
    2a8c:	d0ca2800 	sbcle	a3, v7, a1, lsl #16
    2a90:	e4b92001 	ldrt	a3, [v6], #1
    2a94:	1c05b5f3 	cfstr32ne	mvfx11, [v2], {243}
    2a98:	24002600 	strcs	a3, [a1], #-1536
    2a9c:	fedaf7ff 	mrc2	7, 6, PC, cr10, cr15, {7}
    2aa0:	1c69466a 	stcnel	6, cr4, [v6], #-424
    2aa4:	28078011 	stmcsda	v4, {a1, v1, PC}
    2aa8:	4668d12d 	strmibt	SP, [v5], -SP, lsr #2
    2aac:	1c288881 	stcne	8, cr8, [v5], #-516
    2ab0:	f950f000 	ldmnvdb	a1, {IP, SP, LR, PC}^
    2ab4:	46681c07 	strmibt	a2, [v5], -v4, lsl #24
    2ab8:	1c288805 	stcne	8, cr8, [v5], #-20
    2abc:	fecaf7ff 	mcr2	7, 6, PC, cr10, cr15, {7}
    2ac0:	d00a2807 	andle	a3, v7, v4, lsl #16
    2ac4:	d0082808 	andle	a3, v5, v5, lsl #16
    2ac8:	4347200a 	cmpmi	v4, #10	; 0xa
    2acc:	6ac0481d 	bvs	0xff014b48
    2ad0:	884419c0 	stmhida	v1, {v3, v4, v5, v8, IP}^
    2ad4:	43448880 	cmpmi	v1, #8388608	; 0x800000
    2ad8:	200ae030 	andcs	LR, v7, a1, lsr a1
    2adc:	48194347 	ldmmida	v6, {a1, a2, a3, v3, v5, v6, LR}
    2ae0:	19c06ac0 	stmneib	a1, {v3, v4, v6, v8, SP, LR}^
    2ae4:	04368881 	ldreqt	v5, [v3], #-2177
    2ae8:	428e0c36 	addmi	a1, LR, #13824	; 0x3600
    2aec:	8801d226 	stmhida	a2, {a2, a3, v2, v6, IP, LR, PC}
    2af0:	43708840 	cmnmi	a1, #4194304	; 0x400000
    2af4:	04091809 	streq	a2, [v6], #-2057
    2af8:	1c280c09 	stcne	12, cr0, [v5], #-36
    2afc:	ffcaf7ff 	swinv	0x00caf7ff
    2b00:	1c761824 	ldcnel	8, cr1, [v3], #-144
    2b04:	2808e7eb 	stmcsda	v5, {a1, a2, a4, v2, v3, v4, v5, v6, v7, SP, LR, PC}
    2b08:	1c28d115 	stfned	f5, [v5], #-84
    2b0c:	f918f000 	ldmnvdb	v5, {IP, SP, LR, PC}
    2b10:	46681c07 	strmibt	a2, [v5], -v4, lsl #24
    2b14:	04368805 	ldreqt	v5, [v3], #-2053
    2b18:	42be0c36 	adcmis	a1, LR, #13824	; 0x3600
    2b1c:	4668d20e 	strmibt	SP, [v5], -LR, lsl #4
    2b20:	1c288881 	stcne	8, cr8, [v5], #-516
    2b24:	ffb6f7ff 	swinv	0x00b6f7ff
    2b28:	1c281824 	stcne	8, cr1, [v5], #-144
    2b2c:	ff44f7ff 	swinv	0x0044f7ff
    2b30:	1c761c05 	ldcnel	12, cr1, [v3], #-20
    2b34:	f7ffe7ef 	ldrnvb	LR, [PC, PC, ror #15]!
    2b38:	1c04fef1 	stcne	14, cr15, [v1], {241}
    2b3c:	0c000420 	cfstrseq	mvf0, [a1], {32}
    2b40:	fa76f7ff 	blx	0x1dc0b44
    2b44:	00008680 	andeq	v5, a1, a1, lsl #13
    2b48:	b083b5f9 	strltd	v8, [a4], v6
    2b4c:	1c161c0c 	ldcne	12, cr1, [v3], {12}
    2b50:	f7ff1c10 	undefined
    2b54:	1c07fe7f 	stcne	14, cr15, [v4], {127}
    2b58:	1c704669 	ldcnel	6, cr4, [a1], #-420
    2b5c:	2f078088 	swics	0x00078088
    2b60:	4668d13a 	undefined
    2b64:	1c308a01 	ldcne	10, cr8, [a1], #-4
    2b68:	f8f4f000 	ldmnvia	v1!, {IP, SP, LR, PC}^
    2b6c:	4348210a 	cmpmi	v5, #-2147483646	; 0x80000002
    2b70:	49339002 	ldmmidb	a4!, {a2, IP, PC}
    2b74:	18086ac9 	stmneda	v5, {a1, a4, v3, v4, v6, v8, SP, LR}
    2b78:	88859000 	stmhiia	v2, {IP, PC}
    2b7c:	88864668 	stmhiia	v3, {a4, v2, v3, v6, v7, LR}
    2b80:	f7ff1c30 	undefined
    2b84:	1c07fe67 	stcne	14, cr15, [v4], {103}
    2b88:	d00f2807 	andle	a3, PC, v4, lsl #16
    2b8c:	d00d2f08 	andle	a3, SP, v5, lsl #30
    2b90:	88459800 	stmhida	v2, {v8, IP, PC}^
    2b94:	88809800 	stmhiia	a1, {v8, IP, PC}
    2b98:	042d4345 	streqt	v1, [SP], #-837
    2b9c:	1c2a0c2d 	stcne	12, cr0, [v7], #-180
    2ba0:	88009800 	stmhida	a1, {v8, IP, PC}
    2ba4:	68c94926 	stmvsia	v6, {a2, a3, v2, v5, v8, LR}^
    2ba8:	e03c1809 	eors	a2, IP, v6, lsl #16
    2bac:	043f2700 	ldreqt	a3, [pc], #1792	; 0x2bb4
    2bb0:	42af0c3f 	adcmi	a1, PC, #16128	; 0x3f00
    2bb4:	9802d23f 	stmlsda	a3, {a1, a2, a3, a4, v1, v2, v6, IP, LR, PC}
    2bb8:	6ac94921 	bvs	0xff255044
    2bbc:	88011808 	stmhida	a2, {a4, v8, IP}
    2bc0:	43788840 	cmnmi	v5, #4194304	; 0x400000
    2bc4:	041b180b 	ldreq	a2, [v8], #-2059
    2bc8:	1c320c1b 	ldcne	12, cr0, [a3], #-108
    2bcc:	98031c21 	stmlsda	a4, {a1, v2, v7, v8, IP}
    2bd0:	ffbaf7ff 	swinv	0x00baf7ff
    2bd4:	e7ea1c7f 	undefined
    2bd8:	d1172f08 	tstle	v4, v5, lsl #30
    2bdc:	f0001c30 	andnv	a2, a1, a1, lsr IP
    2be0:	1c05f8af 	stcne	8, cr15, [v2], {175}
    2be4:	88864668 	stmhiia	v3, {a4, v2, v3, v6, v7, LR}
    2be8:	043f2700 	ldreqt	a3, [pc], #1792	; 0x2bf0
    2bec:	42af0c3f 	adcmi	a1, PC, #16128	; 0x3f00
    2bf0:	4668d221 	strmibt	SP, [v5], -a2, lsr #4
    2bf4:	1c328a03 	ldcne	10, cr8, [a3], #-12
    2bf8:	98031c21 	stmlsda	a4, {a1, v2, v7, v8, IP}
    2bfc:	ffa4f7ff 	swinv	0x00a4f7ff
    2c00:	f7ff1c30 	undefined
    2c04:	1c06fed9 	stcne	14, cr15, [v3], {217}
    2c08:	e7ee1c7f 	undefined
    2c0c:	46682200 	strmibt	a3, [v5], -a1, lsl #4
    2c10:	1c308a01 	ldcne	10, cr8, [a1], #-4
    2c14:	fe24f7ff 	mcr2	7, 1, PC, cr4, cr15, {7}
    2c18:	1c381c06 	ldcne	12, cr1, [v5], #-24
    2c1c:	fe7ef7ff 	mrc2	7, 3, PC, cr14, cr15, {7}
    2c20:	1c021c05 	stcne	12, cr1, [a3], {5}
    2c24:	88201c31 	stmhida	a1!, {a1, v1, v2, v7, v8, IP}
    2c28:	18189b03 	ldmneda	v5, {a1, a2, v5, v6, v8, IP, PC}
    2c2c:	f9b4f012 	ldmnvib	v1!, {a2, v1, IP, SP, LR, PC}
    2c30:	19408820 	stmnedb	a1, {v2, v8, PC}^
    2c34:	20008020 	andcs	v5, a1, a1, lsr #32
    2c38:	f7ffb005 	ldrnvb	v8, [PC, v2]!
    2c3c:	0000fb7a 	andeq	PC, a1, v7, ror v8
    2c40:	00008680 	andeq	v5, a1, a1, lsl #13
    2c44:	b083b5f9 	strltd	v8, [a4], v6
    2c48:	1c161c0c 	ldcne	12, cr1, [v3], {12}
    2c4c:	f7ff1c10 	undefined
    2c50:	1c07fe01 	stcne	14, cr15, [v4], {1}
    2c54:	1c704669 	ldcnel	6, cr4, [a1], #-420
    2c58:	2f078088 	swics	0x00078088
    2c5c:	4668d13d 	undefined
    2c60:	1c308a01 	ldcne	10, cr8, [a1], #-4
    2c64:	f876f000 	ldmnvda	v3!, {IP, SP, LR, PC}^
    2c68:	4348210a 	cmpmi	v5, #-2147483646	; 0x80000002
    2c6c:	494e9002 	stmmidb	LR, {a2, IP, PC}^
    2c70:	18086ac9 	stmneda	v5, {a1, a4, v3, v4, v6, v8, SP, LR}
    2c74:	88859000 	stmhiia	v2, {IP, PC}
    2c78:	88864668 	stmhiia	v3, {a4, v2, v3, v6, v7, LR}
    2c7c:	f7ff1c30 	undefined
    2c80:	1c07fde9 	stcne	13, cr15, [v4], {233}
    2c84:	d0122807 	andles	a3, a3, v4, lsl #16
    2c88:	d0102f08 	andles	a3, a1, v5, lsl #30
    2c8c:	88459800 	stmhida	v2, {v8, IP, PC}^
    2c90:	88809800 	stmhiia	a1, {v8, IP, PC}
    2c94:	042d4345 	streqt	v1, [SP], #-837
    2c98:	1c2a0c2d 	stcne	12, cr0, [v7], #-180
    2c9c:	99038820 	stmlsdb	a4, {v2, v8, PC}
    2ca0:	98001809 	stmlsda	a1, {a1, a4, v8, IP}
    2ca4:	4b408800 	blmi	0x1024cac
    2ca8:	181868db 	ldmneda	v5, {a1, a2, a4, v1, v3, v4, v8, SP, LR}
    2cac:	2700e03f 	smladxcs	a1, PC, a1, LR
    2cb0:	0c3f043f 	cfldrseq	mvf0, [PC], #-252
    2cb4:	d23f42af 	eorles	v1, PC, #-268435446	; 0xf000000a
    2cb8:	493b9802 	ldmmidb	v8!, {a2, v8, IP, PC}
    2cbc:	18086ac9 	stmneda	v5, {a1, a4, v3, v4, v6, v8, SP, LR}
    2cc0:	88408801 	stmhida	a1, {a1, v8, PC}^
    2cc4:	180b4378 	stmneda	v8, {a4, v1, v2, v3, v5, v6, LR}
    2cc8:	0c1b041b 	cfldrseq	mvf0, [v8], {27}
    2ccc:	1c211c32 	stcne	12, cr1, [a2], #-200
    2cd0:	f7ff9803 	ldrnvb	v6, [PC, a4, lsl #16]!
    2cd4:	1c7fffb7 	ldcnel	15, cr15, [PC], #-732
    2cd8:	2f08e7ea 	swics	0x0008e7ea
    2cdc:	1c30d117 	ldfned	f5, [a1], #-92
    2ce0:	f82ef000 	stmnvda	LR!, {IP, SP, LR, PC}
    2ce4:	46681c05 	strmibt	a2, [v5], -v2, lsl #24
    2ce8:	27008886 	strcs	v5, [a1, -v3, lsl #17]
    2cec:	0c3f043f 	cfldrseq	mvf0, [PC], #-252
    2cf0:	d22142af 	eorle	v1, a2, #-268435446	; 0xf000000a
    2cf4:	8a034668 	bhi	0xd469c
    2cf8:	1c211c32 	stcne	12, cr1, [a2], #-200
    2cfc:	f7ff9803 	ldrnvb	v6, [PC, a4, lsl #16]!
    2d00:	1c30ffa1 	ldcne	15, cr15, [a1], #-644
    2d04:	fe58f7ff 	mrc2	7, 2, PC, cr8, cr15, {7}
    2d08:	1c7f1c06 	ldcnel	12, cr1, [PC], #-24
    2d0c:	2200e7ee 	andcs	LR, a1, #62390272	; 0x3b80000
    2d10:	8a014668 	bhi	0x546b8
    2d14:	f7ff1c30 	undefined
    2d18:	1c06fda3 	stcne	13, cr15, [v3], {163}
    2d1c:	f7ff1c38 	undefined
    2d20:	1c05fdfd 	stcne	13, cr15, [v2], {253}
    2d24:	88201c02 	stmhida	a1!, {a2, v7, v8, IP}
    2d28:	18099903 	stmneda	v6, {a1, a2, v5, v8, IP, PC}
    2d2c:	f0121c30 	andnvs	a2, a3, a1, lsr IP
    2d30:	8820f933 	stmhida	a1!, {a1, a2, v1, v2, v5, v8, IP, SP, LR, PC}
    2d34:	80201940 	eorhi	a2, a1, a1, asr #18
    2d38:	b0052000 	andlt	a3, v2, a1
    2d3c:	faf9f7ff 	blx	0xffe80d40
    2d40:	00802102 	addeq	a3, a1, a3, lsl #2
    2d44:	68924a18 	ldmvsia	a3, {a4, v1, v6, v8, LR}
    2d48:	5e401810 	mcrpl	8, 2, a2, cr0, cr0, {0}
    2d4c:	0c000400 	cfstrseq	mvf0, [a1], {0}
    2d50:	00004770 	andeq	v1, a1, a1, ror v4
    2d54:	4a14b410 	bmi	0x52fd9c
    2d58:	00802302 	addeq	a3, a1, a3, lsl #6
    2d5c:	18206894 	stmneda	a1!, {a3, v1, v4, v8, SP, LR}
    2d60:	68d25ec0 	ldmvsia	a3, {v3, v4, v6, v7, v8, IP, LR}^
    2d64:	5a401810 	bpl	0x1008dac
    2d68:	4770bc10 	undefined
    2d6c:	f7ffb500 	ldrnvb	v8, [PC, a1, lsl #10]!
    2d70:	210afff1 	strcsd	PC, [v7, -a2]
    2d74:	490c4348 	stmmidb	IP, {a4, v3, v5, v6, LR}
    2d78:	18086ac9 	stmneda	v5, {a1, a4, v3, v4, v6, v8, SP, LR}
    2d7c:	bc028880 	stclt	8, cr8, [a3], {128}
    2d80:	00004708 	andeq	v1, a1, v5, lsl #14
    2d84:	28ff4908 	ldmcsia	PC!, {a4, v5, v8, LR}^
    2d88:	8b08d101 	blhi	0x237194
    2d8c:	2214e009 	andcss	LR, v1, #9	; 0x9
    2d90:	68494350 	stmvsda	v6, {v1, v3, v5, v6, LR}^
    2d94:	88411808 	stmhida	a2, {a4, v8, IP}^
    2d98:	1a088800 	bne	0x224da0
    2d9c:	04001c40 	streq	a2, [a1], #-3136
    2da0:	b0000c00 	andlt	a1, a1, a1, lsl #24
    2da4:	00004770 	andeq	v1, a1, a1, ror v4
    2da8:	00008680 	andeq	v5, a1, a1, lsl #13
    2dac:	1c04b570 	cfstr32ne	mvfx11, [v1], {112}
    2db0:	46681c0d 	strmibt	a2, [v5], -SP, lsl #24
    2db4:	20007c06 	andcs	v4, a1, v3, lsl #24
    2db8:	d0032b02 	andle	a3, a4, a3, lsl #22
    2dbc:	d0012b04 	andle	a3, a2, v1, lsl #22
    2dc0:	d1222b06 	teqle	a3, v3, lsl #22
    2dc4:	d0032e02 	andle	a3, a4, a3, lsl #28
    2dc8:	d0012e04 	andle	a3, a2, v1, lsl #28
    2dcc:	d11c2e06 	tstle	IP, v3, lsl #28
    2dd0:	d1022c00 	tstle	a3, a1, lsl #24
    2dd4:	db164295 	blle	0x593830
    2dd8:	2c01e01b 	stccs	0, cr14, [a2], {27}
    2ddc:	42aad101 	adcmi	SP, v7, #1073741824	; 0x40000000
    2de0:	2c02e7f9 	stccs	7, cr14, [a3], {249}
    2de4:	42aad102 	adcmi	SP, v7, #-2147483648	; 0x80000000
    2de8:	e012da0d 	ands	SP, a3, SP, lsl #20
    2dec:	d1012c03 	tstle	a2, a4, lsl #24
    2df0:	e7f94295 	undefined
    2df4:	d1022c04 	tstle	a3, v1, lsl #24
    2df8:	d0044295 	mulle	v1, v2, a3
    2dfc:	2c05e009 	stccs	0, cr14, [v2], {9}
    2e00:	4295d107 	addmis	SP, v2, #-1073741823	; 0xc0000001
    2e04:	2001d005 	andcs	SP, a2, v2
    2e08:	2c00e003 	stccs	0, cr14, [a1], {3}
    2e0c:	4295d103 	addmis	SP, v2, #-1073741824	; 0xc0000000
    2e10:	f001d3f9 	strnvd	SP, [a2], -v6
    2e14:	2c01ff51 	stccs	15, cr15, [a2], {81}
    2e18:	42aad102 	adcmi	SP, v7, #-2147483648	; 0x80000000
    2e1c:	e7f8d3f3 	undefined
    2e20:	d1022c02 	tstle	a3, a3, lsl #24
    2e24:	d2ee42aa 	rscle	v1, LR, #-1610612726	; 0xa000000a
    2e28:	2c03e7f3 	stccs	7, cr14, [a4], {243}
    2e2c:	4295d101 	addmis	SP, v2, #1073741824	; 0x40000000
    2e30:	2c04e7f9 	stccs	7, cr14, [v1], {249}
    2e34:	4295d102 	addmis	SP, v2, #-2147483648	; 0x80000000
    2e38:	e7ead0e5 	strb	SP, [v7, v2, ror #1]!
    2e3c:	d1e82c05 	mvnle	a3, v2, lsl #24
    2e40:	d0e64295 	smlalle	v1, v3, v2, a3
    2e44:	0000e7df 	ldreqd	LR, [a1], -PC
    2e48:	1c04b5f1 	cfstr32ne	mvfx11, [v1], {241}
    2e4c:	1c161c0d 	ldcne	12, cr1, [v3], {13}
    2e50:	46691c18 	undefined
    2e54:	466a8b09 	strmibt	v5, [v7], -v6, lsl #22
    2e58:	27008b92 	undefined
    2e5c:	701f466b 	andvcs	v1, PC, v8, ror #12
    2e60:	1c33b407 	cfldrsne	mvf11, [a4], #-28
    2e64:	1c29aa03 	stcne	10, cr10, [v6], #-12
    2e68:	f0001c20 	andnv	a2, a1, a1, lsr #24
    2e6c:	a903f80f 	stmgedb	a4, {a1, a2, a3, a4, v8, IP, SP, LR, PC}
    2e70:	b0037809 	andlt	v4, a4, v6, lsl #16
    2e74:	d1072900 	tstle	v4, a1, lsl #18
    2e78:	d0032c04 	andle	a3, a4, v1, lsl #24
    2e7c:	d0012c03 	andle	a3, a2, a4, lsl #24
    2e80:	d1002c02 	tstle	a1, a3, lsl #24
    2e84:	702f2701 	eorvc	a3, PC, a2, lsl #14
    2e88:	fabef7ff 	blx	0xfefc0e8c
    2e8c:	b085b5f3 	strltd	v8, [v2], a4
    2e90:	1c1d1c14 	ldcne	12, cr1, [SP], {20}
    2e94:	8e864668 	cdphi	6, 8, cr4, cr6, cr8, {3}
    2e98:	71012100 	tstvc	a2, a1, lsl #2
    2e9c:	f7ff1c18 	undefined
    2ea0:	4669fcd9 	undefined
    2ea4:	1c307008 	ldcne	0, cr7, [a1], #-32
    2ea8:	fcd4f7ff 	ldc2l	7, cr15, [v1], {255}
    2eac:	70484669 	subvc	v1, v5, v6, ror #12
    2eb0:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    2eb4:	d0032807 	andle	a3, a4, v4, lsl #16
    2eb8:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    2ebc:	d10d2808 	tstle	SP, v5, lsl #16
    2ec0:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    2ec4:	42887849 	addmi	v4, v5, #4784128	; 0x490000
    2ec8:	2000d004 	andcs	SP, a1, v1
    2ecc:	b00743c0 	andlt	v1, v4, a1, asr #7
    2ed0:	fa2ff7ff 	blx	0xc00ed4
    2ed4:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    2ed8:	d03c2807 	eorles	a3, IP, v4, lsl #16
    2edc:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    2ee0:	d0642808 	rsble	a3, v1, v5, lsl #16
    2ee4:	4668466a 	strmibt	v1, [v5], -v7, ror #12
    2ee8:	1c288e01 	stcne	14, cr8, [v5], #-4
    2eec:	fcb8f7ff 	ldc2	7, cr15, [v5], #1020
    2ef0:	aa001c05 	bge	0x9f0c
    2ef4:	46681c52 	undefined
    2ef8:	1c308f01 	ldcne	15, cr8, [a1], #-4
    2efc:	fcb0f7ff 	ldc2	7, cr15, [a1], #1020
    2f00:	46681c06 	strmibt	a2, [v5], -v3, lsl #24
    2f04:	1c287801 	stcne	8, cr7, [v5], #-4
    2f08:	fceef7ff 	stc2l	7, cr15, [LR], #1020
    2f0c:	46681c05 	strmibt	a2, [v5], -v2, lsl #24
    2f10:	1c307841 	ldcne	8, cr7, [a1], #-260
    2f14:	fce8f7ff 	stc2l	7, cr15, [v5], #1020
    2f18:	46681c06 	strmibt	a2, [v5], -v3, lsl #24
    2f1c:	b4017840 	strlt	v4, [a2], #-2112
    2f20:	7803a801 	stmvcda	a4, {a1, v8, SP, PC}
    2f24:	1c291c32 	stcne	12, cr1, [v6], #-200
    2f28:	f7ff2005 	ldrnvb	a3, [PC, v2]!
    2f2c:	7020ff3f 	eorvc	PC, a1, PC, lsr PC
    2f30:	b0017820 	andlt	v4, a2, a1, lsr #16
    2f34:	d00c2800 	andle	a3, IP, a1, lsl #16
    2f38:	78404668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}^
    2f3c:	a801b401 	stmgeda	a2, {a1, v7, IP, SP, PC}
    2f40:	1c327803 	ldcne	8, cr7, [a3], #-12
    2f44:	7d001c29 	stcvc	12, cr1, [a1, #-164]
    2f48:	ff30f7ff 	swinv	0x0030f7ff
    2f4c:	70089907 	andvc	v6, v5, v4, lsl #18
    2f50:	2000b001 	andcs	v8, a1, a2
    2f54:	4668e7bb 	undefined
    2f58:	1c288e01 	stcne	14, cr8, [v5], #-4
    2f5c:	ff06f7ff 	swinv	0x0006f7ff
    2f60:	80484669 	subhi	v1, v5, v6, ror #12
    2f64:	8e014668 	cfmadd32hi	mvax3, mvfx4, mvfx1, mvfx8
    2f68:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    2f6c:	4669fef3 	undefined
    2f70:	485680c8 	ldmmida	v3, {a4, v3, v4, PC}^
    2f74:	90036ac0 	andls	v3, a4, a1, asr #21
    2f78:	88c94668 	stmhiia	v6, {a4, v2, v3, v6, v7, LR}^
    2f7c:	4351220a 	cmpmi	a2, #-1610612736	; 0xa0000000
    2f80:	5a519a03 	bpl	0x1469794
    2f84:	8f018601 	swihi	0x00018601
    2f88:	f7ff1c30 	undefined
    2f8c:	1c07feef 	stcne	14, cr15, [v4], {239}
    2f90:	8f014668 	swihi	0x00014668
    2f94:	f7ff1c30 	undefined
    2f98:	4669fedd 	undefined
    2f9c:	46688108 	strmibt	v5, [v5], -v5, lsl #2
    2fa0:	220a8909 	andcs	v5, v7, #147456	; 0x24000
    2fa4:	9a034351 	bls	0xd3cf0
    2fa8:	87015a51 	smlsdhi	a2, a2, v7, v2
    2fac:	1c28e008 	stcne	0, cr14, [v5], #-32
    2fb0:	fec6f7ff 	mcr2	7, 6, PC, cr6, cr15, {7}
    2fb4:	80484669 	subhi	v1, v5, v6, ror #12
    2fb8:	f7ff1c30 	undefined
    2fbc:	1c07fec1 	stcne	14, cr15, [v4], {193}
    2fc0:	88404668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}^
    2fc4:	d01342b8 	ldrleh	v1, [a4], -v5
    2fc8:	7d004668 	stcvc	6, cr4, [a1, #-416]
    2fcc:	d0032804 	andle	a3, a4, v1, lsl #16
    2fd0:	7d004668 	stcvc	6, cr4, [a1, #-416]
    2fd4:	d10b2805 	tstle	v8, v2, lsl #16
    2fd8:	70202001 	eorvc	a3, a1, a2
    2fdc:	7d004668 	stcvc	6, cr4, [a1, #-416]
    2fe0:	d1012805 	tstle	a2, v2, lsl #16
    2fe4:	e0002001 	and	a3, a1, a2
    2fe8:	99062000 	stmlsdb	v3, {SP}
    2fec:	e7b07008 	ldr	v4, [a1, v5]!
    2ff0:	46694668 	strmibt	v1, [v6], -v5, ror #12
    2ff4:	42b98849 	adcmis	v5, v6, #4784128	; 0x490000
    2ff8:	1c39d900 	ldcne	9, cr13, [v6]
    2ffc:	1c6d8201 	sfmne	f0, 3, [SP], #-4
    3000:	21001c76 	tstcs	a1, v3, ror IP
    3004:	4668e011 	undefined
    3008:	28087800 	stmcsda	v5, {v8, IP, SP, LR}
    300c:	0428d109 	streqt	SP, [v5], #-265
    3010:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    3014:	1c05fcd1 	stcne	12, cr15, [v2], {209}
    3018:	0c000430 	cfstrseq	mvf0, [a1], {48}
    301c:	fcccf7ff 	stc2l	7, cr15, [IP], {255}
    3020:	46681c06 	strmibt	a2, [v5], -v3, lsl #24
    3024:	89494669 	stmhidb	v6, {a1, a4, v2, v3, v6, v7, LR}^
    3028:	81411c49 	cmphi	a2, v6, asr #24
    302c:	46698940 	strmibt	v5, [v6], -a1, asr #18
    3030:	42888a09 	addmi	v5, v5, #36864	; 0x9000
    3034:	d2364668 	eorles	v1, v3, #109051904	; 0x6800000
    3038:	8e008f02 	cdphi	15, 0, cr8, cr0, cr2, {0}
    303c:	0c090431 	cfstrseq	mvf0, [v6], {49}
    3040:	042bb407 	streqt	v8, [v8], #-1031
    3044:	1c220c1b 	stcne	12, cr0, [a3], #-108
    3048:	a8039909 	stmgeda	a4, {a1, a4, v5, v8, IP, PC}
    304c:	f7ff7d00 	ldrnvb	v4, [PC, a1, lsl #26]!
    3050:	a903ff1d 	stmgedb	a4, {a1, a3, a4, v1, v5, v6, v7, v8, IP, SP, LR, PC}
    3054:	78207108 	stmvcda	a1!, {a4, v5, IP, SP, LR}
    3058:	2800b003 	stmcsda	a1, {a1, a2, IP, SP, PC}
    305c:	2004d103 	andcs	SP, v1, a4, lsl #2
    3060:	28005608 	stmcsda	a1, {a4, v6, v7, IP, LR}
    3064:	4669da03 	strmibt	SP, [v6], -a4, lsl #20
    3068:	56082004 	strpl	a3, [v5], -v1
    306c:	4668e72f 	strmibt	LR, [v5], -PC, lsr #14
    3070:	28077800 	stmcsda	v4, {v8, IP, SP, LR}
    3074:	4815d1c7 	ldmmida	v2, {a1, a2, a3, v3, v4, v5, IP, LR, PC}
    3078:	466b6ac0 	strmibt	v3, [v8], -a1, asr #21
    307c:	46948e0a 	ldrmi	v5, [v1], v7, lsl #28
    3080:	210a88ca 	smlabtcs	v7, v7, v5, v5
    3084:	1881434a 	stmneia	a2, {a2, a4, v3, v5, v6, LR}
    3088:	44618849 	strmibt	v5, [a2], #-2121
    308c:	46698619 	undefined
    3090:	468c8f09 	strmi	v5, [IP], v6, lsl #30
    3094:	890a4669 	stmhidb	v7, {a1, a4, v2, v3, v6, v7, LR}
    3098:	434a210a 	cmpmi	v7, #-2147483646	; 0x80000002
    309c:	88401880 	stmhida	a1, {v4, v8, IP}^
    30a0:	87184460 	ldrhi	v1, [v5, -a1, ror #8]
    30a4:	8840e7bd 	stmhida	a1, {a1, a3, a4, v1, v2, v4, v5, v6, v7, SP, LR, PC}^
    30a8:	d0dc42b8 	ldrleh	v1, [IP], #40
    30ac:	70202001 	eorvc	a3, a1, a2
    30b0:	b4012003 	strlt	a3, [a2], #-3
    30b4:	1c3a2303 	ldcne	3, cr2, [v7], #-12
    30b8:	8841a801 	stmhida	a2, {a1, v8, SP, PC}^
    30bc:	f7ff7d00 	ldrnvb	v4, [PC, a1, lsl #26]!
    30c0:	9907fe75 	stmlsdb	v4, {a1, a3, v1, v2, v3, v6, v7, v8, IP, SP, LR, PC}
    30c4:	b0017008 	andlt	v4, a2, v5
    30c8:	0000e7cd 	andeq	LR, a1, SP, asr #15
    30cc:	00008680 	andeq	v5, a1, a1, lsl #13
    30d0:	b081b5f1 	strltd	v8, [a2], a2
    30d4:	79004668 	stmvcdb	a1, {a4, v2, v3, v6, v7, LR}
    30d8:	ff42f7fe 	swinv	0x0042f7fe
    30dc:	d1022800 	tstle	a3, a1, lsl #16
    30e0:	43c02000 	bicmi	a3, a1, #0	; 0x0
    30e4:	4668e083 	strmibt	LR, [v5], -a4, lsl #1
    30e8:	21147900 	tstcs	v1, a1, lsl #18
    30ec:	49924348 	ldmmiib	a3, {a4, v3, v5, v6, LR}
    30f0:	180c6849 	stmneda	IP, {a1, a4, v3, v8, SP, LR}
    30f4:	004888a1 	subeq	v5, v5, a2, lsr #17
    30f8:	00528822 	subeqs	v5, a3, a3, lsr #16
    30fc:	681b4b8e 	ldmvsda	v8, {a2, a3, a4, v4, v5, v6, v8, LR}
    3100:	1815189a 	ldmneda	v2, {a2, a4, v1, v4, v8, IP}
    3104:	5e282000 	cdppl	0, 2, cr2, cr8, cr0, {0}
    3108:	0f060400 	swieq	0x00060400
    310c:	d41907f0 	ldrle	a1, [v6], #-2032
    3110:	882a4888 	stmhida	v7!, {a4, v4, v8, LR}
    3114:	011b2380 	tsteq	v8, a1, lsl #7
    3118:	121a4013 	andnes	v1, v7, #19	; 0x13
    311c:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    3120:	d1092a08 	tstle	v6, v5, lsl #20
    3124:	5eaa2200 	cdppl	2, 10, cr2, cr10, cr0, {0}
    3128:	00db23e0 	sbceqs	a3, v8, a1, ror #7
    312c:	121a4013 	andnes	v1, v7, #19	; 0x13
    3130:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    3134:	e0035c82 	and	v2, a4, a3, lsl #25
    3138:	5eaa2200 	cdppl	2, 10, cr2, cr10, cr0, {0}
    313c:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    3140:	db012a36 	blle	0x4da20
    3144:	e7cc2001 	strb	a3, [IP, a2]
    3148:	19922200 	ldmneib	a3, {v6, SP}
    314c:	1e521052 	mrcne	0, 2, a2, cr2, cr2, {2}
    3150:	2780882b 	strcs	v5, [a1, v8, lsr #16]
    3154:	401f013f 	andmis	a1, PC, PC, lsr a2
    3158:	061b123b 	undefined
    315c:	2b080e1b 	blcs	0x2069d0
    3160:	1c52d100 	ldfnep	f5, [a3], {0}
    3164:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    3168:	d3002a05 	tstle	a1, #20480	; 0x5000
    316c:	2e0e2204 	cdpcs	2, 0, cr2, cr14, cr4, {0}
    3170:	2302d101 	tstcs	a3, #1073741824	; 0x40000000
    3174:	4b705eee 	blmi	0x1c1ad34
    3178:	496f8659 	stmmidb	PC!, {a1, a4, v1, v3, v6, v7, PC}^
    317c:	466b3134 	undefined
    3180:	700b791b 	andvc	v4, v8, v8, lsl v6
    3184:	18400091 	stmneda	a1, {a1, v1, v4}^
    3188:	1c289000 	stcne	0, cr9, [v5]
    318c:	68499900 	stmvsda	v6, {v5, v8, IP, PC}^
    3190:	ff9cf011 	swinv	0x009cf011
    3194:	20041c07 	andcs	a2, v1, v4, lsl #24
    3198:	428743c0 	addmi	v1, v4, #3	; 0x3
    319c:	f7ffd107 	ldrnvb	SP, [PC, v4, lsl #2]!
    31a0:	1c28f9dd 	stcne	9, cr15, [v5], #-884
    31a4:	68499900 	stmvsda	v6, {v5, v8, IP, PC}^
    31a8:	ff90f011 	swinv	0x0090f011
    31ac:	2f001c07 	swics	0x00001c07
    31b0:	2f01db1c 	swics	0x0001db1c
    31b4:	2000d104 	andcs	SP, a1, v1, lsl #2
    31b8:	79a080a0 	stmvcib	a1!, {v2, v4, PC}
    31bc:	e00c71e0 	and	v4, IP, a1, ror #3
    31c0:	d1022f03 	tstle	a3, a4, lsl #30
    31c4:	8e40485c 	mcrhi	8, 2, v1, cr0, cr12, {2}
    31c8:	0636e006 	ldreqt	LR, [v3], -v3
    31cc:	88a00e36 	stmhiia	a1!, {a2, a3, v1, v2, v6, v7, v8}
    31d0:	19892100 	stmneib	v6, {v5, SP}
    31d4:	18401049 	stmneda	a1, {a1, a4, v3, IP}^
    31d8:	466880a0 	strmibt	v5, [v5], -a1, lsr #1
    31dc:	f7ff7900 	ldrnvb	v4, [PC, a1, lsl #18]!
    31e0:	88a1fdd1 	stmhiia	a2!, {a1, v1, v3, v4, v5, v7, v8, IP, SP, LR, PC}
    31e4:	d2014288 	andle	v1, a2, #-2147483640	; 0x80000008
    31e8:	43ff2701 	mvnmis	a3, #262144	; 0x40000
    31ec:	f7fe1c38 	undefined
    31f0:	0000ff1f 	andeq	PC, a1, PC, lsl PC
    31f4:	2400b5f1 	strcs	v8, [a1], #-1521
    31f8:	00c921e0 	sbceq	a3, v6, a1, ror #3
    31fc:	23804a4d 	orrcs	v1, a1, #315392	; 0x4d000
    3200:	8805011b 	stmhida	v2, {a1, a2, a4, v1, v5}
    3204:	122d401d 	eorne	v1, SP, #29	; 0x1d
    3208:	0e2d062d 	cfmadda32eq	mvax1, mvax0, mvfx13, mvfx13
    320c:	d10b2d08 	tstle	v8, v5, lsl #26
    3210:	5ec32300 	cdppl	3, 12, cr2, cr3, cr0, {0}
    3214:	12094019 	andne	v1, v6, #25	; 0x19
    3218:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    321c:	22005c51 	andcs	v2, a1, #20736	; 0x5100
    3220:	06365e86 	ldreqt	v2, [v3], -v3, lsl #29
    3224:	e0121636 	ands	a2, a3, v3, lsr v3
    3228:	402b8805 	eormi	v5, v8, v2, lsl #16
    322c:	061b121b 	undefined
    3230:	2b080e1b 	blcs	0x206aa4
    3234:	2300d107 	tstcs	a1, #-1073741823	; 0xc0000001
    3238:	40195ec3 	andmis	v2, v6, a4, asr #29
    323c:	06091209 	streq	a2, [v6], -v6, lsl #4
    3240:	5c510e09 	mrrcpl	14, 0, a1, a2, cr9
    3244:	2100e001 	tstcs	a1, a2
    3248:	22025e41 	andcs	v2, a3, #1040	; 0x410
    324c:	4f3a5e86 	swimi	0x003a5e86
    3250:	78bd3732 	ldmvcia	SP!, {a2, v1, v2, v5, v6, v7, IP, SP}
    3254:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    3258:	d00c2925 	andle	a3, IP, v2, lsr #18
    325c:	d04e2929 	suble	a3, LR, v6, lsr #18
    3260:	d031292b 	eorles	a3, a2, v8, lsr #18
    3264:	d00b292c 	andle	a3, v8, IP, lsr #18
    3268:	d013292d 	andles	a3, a4, SP, lsr #18
    326c:	d01a292f 	andles	a3, v7, PC, lsr #18
    3270:	d0342935 	eorles	a3, v1, v2, lsr v6
    3274:	8838e058 	ldmhida	v5!, {a4, v1, v3, SP, LR, PC}
    3278:	80381980 	eorhis	a2, v5, a1, lsl #19
    327c:	e0552403 	subs	a3, v2, a4, lsl #8
    3280:	04302100 	ldreqt	a3, [a1], #-256
    3284:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    3288:	1c29fb5f 	stcne	11, cr15, [v6], #-380
    328c:	fe08f7fe 	mcr2	7, 0, PC, cr8, cr14, {7}
    3290:	e04b1c04 	sub	a2, v8, v1, lsl #24
    3294:	04302100 	ldreqt	a3, [a1], #-256
    3298:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    329c:	1c29fb55 	stcne	11, cr15, [v6], #-340
    32a0:	fe14f7fe 	mrc2	7, 0, PC, cr4, cr14, {7}
    32a4:	1c29e7f4 	stcne	7, cr14, [v6], #-976
    32a8:	30304823 	eorccs	v1, a1, a4, lsr #16
    32ac:	fdb4f7fe 	ldc2	7, cr15, [v1, #1016]!
    32b0:	04302100 	ldreqt	a3, [a1], #-256
    32b4:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    32b8:	7801fb47 	stmvcda	a2, {a1, a2, a3, v3, v5, v6, v8, IP, SP, LR, PC}
    32bc:	3030481e 	eorccs	v1, a1, LR, lsl v5
    32c0:	fd92f7fe 	ldc2	7, cr15, [a3, #1016]
    32c4:	e0312401 	eors	a3, a2, a2, lsl #8
    32c8:	481b1c29 	ldmmida	v8, {a1, a4, v2, v7, v8, IP}
    32cc:	f7fe3030 	undefined
    32d0:	0631fda3 	ldreqt	PC, [a2], -a4, lsr #27
    32d4:	78b80e09 	ldmvcia	v5!, {a1, a4, v6, v7, v8}
    32d8:	fe2ef7fe 	mcr2	7, 1, PC, cr14, cr14, {7}
    32dc:	466ae7f2 	undefined
    32e0:	04302100 	ldreqt	a3, [a1], #-256
    32e4:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    32e8:	1c06fabb 	stcne	10, cr15, [v3], {187}
    32ec:	f99af011 	ldmnvib	v7, {a1, v1, IP, SP, LR, PC}
    32f0:	46681c02 	strmibt	a2, [v5], -a3, lsl #24
    32f4:	1c307801 	ldcne	8, cr7, [a1], #-4
    32f8:	fae4f7ff 	blx	0xff9412fc
    32fc:	480fe016 	stmmida	PC, {a2, a3, v1, SP, LR, PC}
    3300:	0c360436 	cfldrseq	mvf0, [v3], #-216
    3304:	d1014286 	smlabble	a2, v3, a3, v1
    3308:	e00f2405 	and	a3, PC, v2, lsl #8
    330c:	2100466a 	tstcs	a1, v7, ror #12
    3310:	f7ff1c30 	undefined
    3314:	1c06faa5 	stcne	10, cr15, [v3], {165}
    3318:	78014668 	stmvcda	a2, {a4, v2, v3, v6, v7, LR}
    331c:	f7ff1c30 	undefined
    3320:	2800fae3 	stmcsda	a1, {a1, a2, v2, v3, v4, v6, v8, IP, SP, LR, PC}
    3324:	e7efd002 	strb	SP, [PC, a3]!
    3328:	43e42401 	mvnmi	a3, #16777216	; 0x1000000
    332c:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
    3330:	0000f86b 	andeq	PC, a1, v8, ror #16
    3334:	00000100 	andeq	a1, a1, a1, lsl #2
    3338:	00008680 	andeq	v5, a1, a1, lsl #13
    333c:	0000ffff 	streqd	PC, [a1], -PC
    3340:	1c06b5ff 	cfstr32ne	mvfx11, [v3], {255}
    3344:	20802400 	addcs	a3, a1, a1, lsl #8
    3348:	88310100 	ldmhida	a2!, {v5}
    334c:	12094001 	andne	v1, v6, #1	; 0x1
    3350:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    3354:	d1122908 	tstle	a3, v5, lsl #18
    3358:	5e302000 	cdppl	0, 3, cr2, cr0, cr0, {0}
    335c:	00c921e0 	sbceq	a3, v6, a1, ror #3
    3360:	12084001 	andne	v1, v5, #1	; 0x1
    3364:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    3368:	5c0949cf 	stcpl	9, cr4, [v6], {207}
    336c:	5e302000 	cdppl	0, 3, cr2, cr0, cr0, {0}
    3370:	16000600 	strne	a1, [a1], -a1, lsl #12
    3374:	5eb22202 	cdppl	2, 11, cr2, cr2, cr2, {0}
    3378:	20021887 	andcs	a2, a3, v4, lsl #17
    337c:	8831e016 	ldmhida	a2!, {a2, a3, v1, SP, LR, PC}
    3380:	12004008 	andne	v1, a1, #8	; 0x8
    3384:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    3388:	d10a2808 	tstle	v7, v5, lsl #16
    338c:	5e302000 	cdppl	0, 3, cr2, cr0, cr0, {0}
    3390:	00c921e0 	sbceq	a3, v6, a1, ror #3
    3394:	12084001 	andne	v1, v5, #1	; 0x1
    3398:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    339c:	5c0949c2 	stcpl	9, cr4, [v6], {194}
    33a0:	2000e001 	andcs	LR, a1, a2
    33a4:	20025e31 	andcs	v2, a3, a2, lsr LR
    33a8:	20045e37 	andcs	v2, v1, v4, lsr LR
    33ac:	06095e35 	undefined
    33b0:	29020e09 	stmcsdb	a3, {a1, a4, v6, v7, v8}
    33b4:	2909d003 	stmcsdb	v6, {a1, a2, IP, LR, PC}
    33b8:	2912d001 	ldmcsdb	a3, {a1, IP, LR, PC}
    33bc:	2000d10d 	andcs	SP, a1, SP, lsl #2
    33c0:	042bb401 	streqt	v8, [v8], #-1025
    33c4:	22000c1b 	andcs	a1, a1, #6912	; 0x1b00
    33c8:	0c090439 	cfstrseq	mvf0, [v6], {57}
    33cc:	f0005e30 	andnv	v2, a1, a1, lsr LR
    33d0:	b001f9f5 	strltd	PC, [a2], -v2
    33d4:	f7feb004 	ldrnvb	v8, [LR, v1]!
    33d8:	4668ffac 	strmibt	PC, [v5], -IP, lsr #31
    33dc:	32344ab3 	eorccs	v1, v1, #733184	; 0xb3000
    33e0:	71027812 	tstvc	a3, a3, lsl v5
    33e4:	1c68466a 	stcnel	6, cr4, [v5], #-424
    33e8:	48b080d0 	ldmmiia	a1!, {v1, v3, v4, PC}
    33ec:	90023008 	andls	a4, a3, v5
    33f0:	d1002917 	tstle	a1, v4, lsl v6
    33f4:	291be0bd 	ldmcsdb	v8, {a1, a3, a4, v1, v2, v4, SP, LR, PC}
    33f8:	291cd019 	ldmcsdb	IP, {a1, a4, v1, IP, LR, PC}
    33fc:	291dd061 	ldmcsdb	SP, {a1, v2, v3, IP, LR, PC}
    3400:	e10cd100 	tst	IP, a1, lsl #2
    3404:	d100291f 	tstle	a1, PC, lsl v6
    3408:	2923e131 	stmcsdb	a4!, {a1, v1, v2, v5, SP, LR, PC}
    340c:	e188d100 	orr	SP, v5, a1, lsl #2
    3410:	d1002924 	tstle	a1, v1, lsr #18
    3414:	2927e1a6 	stmcsdb	v4!, {a2, a3, v2, v4, v5, SP, LR, PC}
    3418:	2928d063 	stmcsdb	v5!, {a1, a2, v2, v3, IP, LR, PC}
    341c:	e0b6d100 	adcs	SP, v3, a1, lsl #2
    3420:	d100292a 	tstle	a1, v7, lsr #18
    3424:	292ee07e 	stmcsdb	LR!, {a2, a3, a4, v1, v2, v3, SP, LR, PC}
    3428:	e08bd100 	add	SP, v8, a1, lsl #2
    342c:	0438e0b3 	ldreqt	LR, [v5], #-179
    3430:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    3434:	2807fa0f 	stmcsda	v4, {a1, a2, a3, a4, v6, v8, IP, SP, LR, PC}
    3438:	1c78d136 	ldfnep	f5, [v5], #-216
    343c:	0c000400 	cfstrseq	mvf0, [a1], {0}
    3440:	fa08f7ff 	blx	0x241444
    3444:	d12f2801 	teqle	PC, a2, lsl #16
    3448:	0c000428 	cfstrseq	mvf0, [a1], {40}
    344c:	fa02f7ff 	blx	0xc1450
    3450:	d1292807 	teqle	v6, v4, lsl #16
    3454:	88c04668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}^
    3458:	f9fcf7ff 	ldmnvib	IP!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    345c:	d1232801 	teqle	a4, a2, lsl #16
    3460:	04282100 	streqt	a3, [v5], #-256
    3464:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    3468:	1c06fc81 	stcne	12, cr15, [v3], {129}
    346c:	21001c02 	tstcs	a1, a3, lsl #24
    3470:	0c000438 	cfstrseq	mvf0, [a1], {56}
    3474:	fd94f7fe 	ldc2	7, cr15, [v1, #1016]
    3478:	28001c04 	stmcsda	a1, {a3, v7, v8, IP}
    347c:	1c20da01 	stcne	10, cr13, [a1], #-4
    3480:	2200e7a8 	andcs	LR, a1, #44040192	; 0x2a00000
    3484:	04382100 	ldreqt	a3, [v5], #-256
    3488:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    348c:	1c07f9e9 	stcne	9, cr15, [v4], {233}
    3490:	21002200 	tstcs	a1, a1, lsl #4
    3494:	0c000428 	cfstrseq	mvf0, [a1], {40}
    3498:	f9e2f7ff 	stmnvib	a3!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    349c:	1c011c32 	stcne	12, cr1, [a2], {50}
    34a0:	f0111c38 	andnvs	a2, a2, v5, lsr IP
    34a4:	e7eafd79 	undefined
    34a8:	b4012000 	strlt	a3, [a2]
    34ac:	0c1b042b 	cfldrseq	mvf0, [v8], {43}
    34b0:	04392200 	ldreqt	a3, [v6], #-512
    34b4:	201b0c09 	andcss	a1, v8, v6, lsl #24
    34b8:	f980f000 	stmnvib	a1, {IP, SP, LR, PC}
    34bc:	b0011c04 	andlt	a2, a2, v1, lsl #24
    34c0:	1c52e7dd 	mrrcne	7, 13, LR, a3, cr13
    34c4:	04382100 	ldreqt	a3, [v5], #-256
    34c8:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    34cc:	1c07f9c9 	stcne	9, cr15, [v4], {201}
    34d0:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    34d4:	46681c2a 	strmibt	a2, [v5], -v7, lsr #24
    34d8:	1c387841 	ldcne	8, cr7, [v5], #-260
    34dc:	f9f2f7ff 	ldmnvib	a3!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    34e0:	2100e7cd 	smlabtcs	a1, SP, v4, LR
    34e4:	0c000428 	cfstrseq	mvf0, [a1], {40}
    34e8:	f9baf7ff 	ldmnvib	v7!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    34ec:	78094669 	stmvcda	v6, {a1, a4, v2, v3, v6, v7, LR}
    34f0:	f9faf7ff 	ldmnvib	v7!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    34f4:	20061c01 	andcs	a2, v3, a2, lsl #24
    34f8:	2306b401 	tstcs	v3, #16777216	; 0x1000000
    34fc:	88302200 	ldmhida	a1!, {v6, SP}
    3500:	00ed25e0 	rsceq	a3, SP, a1, ror #11
    3504:	12284005 	eorne	v1, v5, #5	; 0x5
    3508:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    350c:	fc4ef7ff 	mcrr2	7, 15, PC, LR, cr15
    3510:	2800b001 	stmcsda	a1, {a1, IP, SP, PC}
    3514:	9802d0b3 	stmlsda	a3, {a1, a2, v1, v2, v4, IP, LR, PC}
    3518:	8d499902 	stchil	9, cr9, [v6, #-8]
    351c:	854119c9 	strhib	a2, [a2, #-2505]
    3520:	e7ac2403 	str	a3, [IP, a4, lsl #8]!
    3524:	79014668 	stmvcdb	a2, {a4, v2, v3, v6, v7, LR}
    3528:	30304860 	eorccs	v1, a1, a1, ror #16
    352c:	fc74f7fe 	ldc2l	7, cr15, [v1], #-1016
    3530:	04391c2a 	ldreqt	a2, [v6], #-3114
    3534:	485d1409 	ldmmida	SP, {a1, a4, v7, IP}^
    3538:	78003034 	stmvcda	a1, {a3, v1, v2, IP, SP}
    353c:	fcd6f7fe 	ldc2l	7, cr15, [v3], {254}
    3540:	e79c2401 	ldr	a3, [IP, a2, lsl #8]
    3544:	04282100 	streqt	a3, [v5], #-256
    3548:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    354c:	4669f9fd 	undefined
    3550:	70017909 	andvc	v4, a2, v6, lsl #18
    3554:	30344855 	eorccs	v1, v1, v2, asr v5
    3558:	48547801 	ldmmida	v1, {a1, v8, IP, SP, LR}^
    355c:	f7fe3030 	undefined
    3560:	0639fc5b 	undefined
    3564:	48510e09 	ldmmida	a2, {a1, a4, v6, v7, v8}^
    3568:	f7fe3030 	undefined
    356c:	2402fc3d 	strcs	PC, [a3], #-3133
    3570:	1c52e785 	mrrcne	7, 8, LR, a3, cr5
    3574:	04382100 	ldreqt	a3, [v5], #-256
    3578:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    357c:	1c07f971 	stcne	9, cr15, [v4], {113}
    3580:	04282100 	streqt	a3, [v5], #-256
    3584:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    3588:	1c02fbf1 	stcne	11, cr15, [a3], {241}
    358c:	043fe7a3 	ldreqt	LR, [pc], #1955	; 0x3594
    3590:	2f220c3f 	swics	0x00220c3f
    3594:	2401d302 	strcs	SP, [a2], #-770
    3598:	e77043e4 	ldrb	v1, [a1, -v1, ror #7]!
    359c:	0c000428 	cfstrseq	mvf0, [a1], {40}
    35a0:	fbcef7ff 	blx	0xff3c15a6
    35a4:	28111c04 	ldmcsda	a2, {a3, v7, v8, IP}
    35a8:	2c00d2f5 	sfmcs	f5, 1, [a1], {245}
    35ac:	4668d028 	strmibt	SP, [v5], -v5, lsr #32
    35b0:	260088c5 	strcs	v5, [a1], -v2, asr #17
    35b4:	2100e00e 	tstcs	a1, LR
    35b8:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    35bc:	9903f9c5 	stmlsdb	a4, {a1, a3, v3, v4, v5, v8, IP, SP, LR, PC}
    35c0:	98036188 	stmlsda	a4, {a4, v4, v5, SP, LR}
    35c4:	28006980 	stmcsda	a1, {v4, v5, v8, SP, LR}
    35c8:	1c28d01b 	stcne	0, cr13, [v5], #-108
    35cc:	f9f4f7ff 	ldmnvib	v1!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    35d0:	1c761c05 	ldcnel	12, cr1, [v3], #-20
    35d4:	d21442a6 	andles	v1, v1, #1610612746	; 0x6000000a
    35d8:	493300b0 	ldmmidb	a4!, {v1, v2, v4}
    35dc:	90031808 	andls	a2, a4, v5, lsl #16
    35e0:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    35e4:	2807f937 	stmcsda	v4, {a1, a2, a3, v1, v2, v5, v8, IP, SP, LR, PC}
    35e8:	9903d1e5 	stmlsdb	a4, {a1, a3, v2, v3, v4, v5, IP, LR, PC}
    35ec:	00a82202 	adceq	a3, v5, a3, lsl #4
    35f0:	681b9b02 	ldmvsda	v8, {a2, v5, v6, v8, IP, PC}
    35f4:	5e801818 	mcrpl	8, 4, a2, cr0, cr8, {0}
    35f8:	68529a02 	ldmvsda	a3, {a2, v6, v8, IP, PC}^
    35fc:	e7df1810 	undefined
    3600:	00b02600 	adceqs	a3, a1, a1, lsl #12
    3604:	18084928 	stmneda	v5, {a4, v2, v5, v8, LR}
    3608:	61812100 	orrvs	a3, a2, a1, lsl #2
    360c:	30184826 	andccs	v1, v5, v3, lsr #16
    3610:	4a6700b9 	bmi	0x19c38fc
    3614:	f0115851 	andnvs	v2, a2, a2, asr v5
    3618:	1c04fd59 	stcne	13, cr15, [v1], {89}
    361c:	2100e72f 	tstcs	a1, PC, lsr #14
    3620:	0c000428 	cfstrseq	mvf0, [a1], {40}
    3624:	fa36f7ff 	blx	0xdc1628
    3628:	04321c46 	ldreqt	a2, [a3], #-3142
    362c:	21000c12 	tstcs	a1, a3, lsl IP
    3630:	0c000438 	cfstrseq	mvf0, [a1], {56}
    3634:	fcb4f7fe 	ldc2	7, cr15, [v1], #1016
    3638:	28001c04 	stmcsda	a1, {a3, v7, v8, IP}
    363c:	2200dbee 	andcs	SP, a1, #243712	; 0x3b800
    3640:	04382100 	ldreqt	a3, [v5], #-256
    3644:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    3648:	1c07f90b 	stcne	9, cr15, [v4], {11}
    364c:	21004668 	tstcs	a1, v5, ror #12
    3650:	23008041 	tstcs	a1, #65	; 0x41
    3654:	0c12042a 	cfldrseq	mvf0, [a3], {42}
    3658:	1c89a900 	stcne	9, cr10, [v6], {0}
    365c:	f7ff1c38 	undefined
    3660:	1c04fa73 	stcne	10, cr15, [v1], {115}
    3664:	88404668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}^
    3668:	54392100 	ldrplt	a3, [v6], #-256
    366c:	2100e707 	tstcs	a1, v4, lsl #14
    3670:	0c000428 	cfstrseq	mvf0, [a1], {40}
    3674:	f8f4f7ff 	ldmnvia	v1!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    3678:	78094669 	stmvcda	v6, {a1, a4, v2, v3, v6, v7, LR}
    367c:	f934f7ff 	ldmnvdb	v1!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    3680:	1e461c05 	cdpne	12, 4, cr1, cr6, cr5, {0}
    3684:	0ff641b6 	swieq	0x00f641b6
    3688:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    368c:	d0072806 	andle	a3, v4, v3, lsl #16
    3690:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    3694:	d0032804 	andle	a3, a4, v1, lsl #16
    3698:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    369c:	d10f2802 	tstle	PC, a3, lsl #16
    36a0:	d5051c28 	strle	a2, [v2, #-3112]
    36a4:	e0051c76 	and	a2, v2, v3, ror IP
    36a8:	00000100 	andeq	a1, a1, a1, lsl #2
    36ac:	00008680 	andeq	v5, a1, a1, lsl #13
    36b0:	d00e2800 	andle	a3, LR, a1, lsl #16
    36b4:	f014210a 	andnvs	a3, v1, v7, lsl #2
    36b8:	1c08f929 	stcne	9, cr15, [v5], {41}
    36bc:	e7f71c76 	undefined
    36c0:	e0041c28 	and	a2, v1, v5, lsr #24
    36c4:	f014210a 	andnvs	a3, v1, v7, lsl #2
    36c8:	1c08f919 	stcne	9, cr15, [v5], {25}
    36cc:	28001c76 	stmcsda	a1, {a2, a3, v1, v2, v3, v7, v8, IP}
    36d0:	1c76d1f8 	ldfnep	f5, [v3], #-992
    36d4:	0c120432 	cfldrseq	mvf0, [a3], {50}
    36d8:	04382100 	ldreqt	a3, [v5], #-256
    36dc:	f7fe0c00 	ldrnvb	a1, [LR, a1, lsl #24]!
    36e0:	1c04fc5f 	stcne	12, cr15, [v1], {95}
    36e4:	db182800 	blle	0x60d6ec
    36e8:	1c52aa00 	mrrcne	10, 0, v7, a3, cr0
    36ec:	04382100 	ldreqt	a3, [v5], #-256
    36f0:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    36f4:	1c07f8b5 	stcne	8, cr15, [v4], {181}
    36f8:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    36fc:	d0072806 	andle	a3, v4, v3, lsl #16
    3700:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    3704:	d0032804 	andle	a3, a4, v1, lsl #16
    3708:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    370c:	d1052802 	tstle	v2, a3, lsl #16
    3710:	49291c2a 	stmmidb	v6!, {a2, a4, v2, v7, v8, IP}
    3714:	f0111c38 	andnvs	a2, a2, v5, lsr IP
    3718:	e6b0fc9f 	ssat	PC, #17, PC, LSL #25
    371c:	a1251c2a 	teqge	v2, v7, lsr #24
    3720:	2100e7f8 	strcsd	LR, [a1, -v5]
    3724:	0c000428 	cfstrseq	mvf0, [a1], {40}
    3728:	fb20f7ff 	blx	0x84172e
    372c:	d0f41c06 	rscles	a2, v1, v3, lsl #24
    3730:	04121e72 	ldreq	a2, [a3], #-3698
    3734:	21000c12 	tstcs	a1, a3, lsl IP
    3738:	0c000438 	cfstrseq	mvf0, [a1], {56}
    373c:	fc30f7fe 	ldc2	7, cr15, [a1], #-1016
    3740:	28001c04 	stmcsda	a1, {a3, v7, v8, IP}
    3744:	2200dbe9 	andcs	SP, a1, #238592	; 0x3a400
    3748:	04382100 	ldreqt	a3, [v5], #-256
    374c:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    3750:	1c07f887 	stcne	8, cr15, [v4], {135}
    3754:	21002200 	tstcs	a1, a1, lsl #4
    3758:	0c000428 	cfstrseq	mvf0, [a1], {40}
    375c:	f880f7ff 	stmnvia	a1, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    3760:	e69b1e76 	undefined
    3764:	04282100 	streqt	a3, [v5], #-256
    3768:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    376c:	1c06faff 	stcne	10, cr15, [v3], {255}
    3770:	04121c42 	ldreq	a2, [a3], #-3138
    3774:	21000c12 	tstcs	a1, a3, lsl IP
    3778:	0c000438 	cfstrseq	mvf0, [a1], {56}
    377c:	fc10f7fe 	ldc2	7, cr15, [a1], {254}
    3780:	28001c04 	stmcsda	a1, {a3, v7, v8, IP}
    3784:	2200db13 	andcs	SP, a1, #19456	; 0x4c00
    3788:	04382100 	ldreqt	a3, [v5], #-256
    378c:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    3790:	1c07f867 	stcne	8, cr15, [v4], {103}
    3794:	21002200 	tstcs	a1, a1, lsl #4
    3798:	0c000428 	cfstrseq	mvf0, [a1], {40}
    379c:	f860f7ff 	stmnvda	a1!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    37a0:	1c011c32 	stcne	12, cr1, [a2], {50}
    37a4:	f0111c38 	andnvs	a2, a2, v5, lsr IP
    37a8:	2000fbf7 	strcsd	PC, [a1], -v4
    37ac:	e66655b8 	undefined
    37b0:	000001a0 	andeq	a1, a1, a1, lsr #3
    37b4:	00007525 	andeq	v4, a1, v2, lsr #10
    37b8:	0011b3dc 	ldreqsb	v8, [a2], -IP
    37bc:	b083b5f5 	strltd	v8, [a4], v2
    37c0:	1c1d1c0c 	ldcne	12, cr1, [SP], {12}
    37c4:	1c082700 	stcne	7, cr2, [v5], {0}
    37c8:	f844f7ff 	stmnvda	v1, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    37cc:	70484669 	subvc	v1, v5, v6, ror #12
    37d0:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    37d4:	4669f83f 	undefined
    37d8:	46687008 	strmibt	v4, [v5], -v5
    37dc:	28077800 	stmcsda	v4, {v8, IP, SP, LR}
    37e0:	d0264668 	eorle	v1, v3, v5, ror #12
    37e4:	28087800 	stmcsda	v5, {v8, IP, SP, LR}
    37e8:	aa00d038 	bge	0x378d0
    37ec:	46681c52 	undefined
    37f0:	1c208a01 	stcne	10, cr8, [a1], #-4
    37f4:	f834f7ff 	ldmnvda	v1!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    37f8:	466a1c04 	strmibt	a2, [v7], -v1, lsl #24
    37fc:	8d014668 	stchi	6, cr4, [a2, #-416]
    3800:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    3804:	4669f82d 	strmibt	PC, [v6], -SP, lsr #16
    3808:	f7ff7809 	ldrnvb	v4, [PC, v6, lsl #16]!
    380c:	1c01f86d 	stcne	8, cr15, [a2], {109}
    3810:	78024668 	stmvcda	a3, {a4, v2, v3, v6, v7, LR}
    3814:	200c466b 	andcs	v1, IP, v8, ror #12
    3818:	f0005e18 	andnv	v2, a1, v5, lsl LR
    381c:	1c02f8c3 	stcne	8, cr15, [a3], {195}
    3820:	78414668 	stmvcda	a2, {a4, v2, v3, v6, v7, LR}^
    3824:	f7ff1c20 	ldrnvb	a2, [PC, a1, lsr #24]!
    3828:	2000f84d 	andcs	PC, a1, SP, asr #16
    382c:	f7feb005 	ldrnvb	v8, [LR, v2]!
    3830:	8d01fd80 	stchi	13, cr15, [a2, #-512]
    3834:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    3838:	1c06fa99 	stcne	10, cr15, [v3], {153}
    383c:	8d014668 	stchi	6, cr4, [a2, #-416]
    3840:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    3844:	4669fa87 	strmibt	PC, [v6], -v4, lsl #21
    3848:	466880c8 	strmibt	v5, [v5], -v5, asr #1
    384c:	220a88c9 	andcs	v5, v7, #13172736	; 0xc90000
    3850:	4a534351 	bmi	0x14d459c
    3854:	5a516ad2 	bpl	0x145e3a4
    3858:	e0038501 	and	v5, a4, a2, lsl #10
    385c:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    3860:	1c06fa6f 	stcne	10, cr15, [v3], {111}
    3864:	78404668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}^
    3868:	46682807 	strmibt	a3, [v5], -v4, lsl #16
    386c:	7800d136 	stmvcda	a1, {a2, a3, v1, v2, v5, IP, LR, PC}
    3870:	d0022807 	andle	a3, a3, v4, lsl #16
    3874:	43c02000 	bicmi	a3, a1, #0	; 0x0
    3878:	1c32e7d8 	ldcne	7, cr14, [a3], #-864
    387c:	8a014668 	bhi	0x55224
    3880:	f7fe1c20 	ldrnvb	a2, [LR, a1, lsr #24]!
    3884:	1c07fb8d 	stcne	11, cr15, [v4], {141}
    3888:	da012800 	ble	0x4d890
    388c:	e7cd1c38 	undefined
    3890:	81064668 	tsthi	v3, v5, ror #12
    3894:	1c208a01 	stcne	10, cr8, [a1], #-4
    3898:	fa5cf7ff 	blx	0x174189c
    389c:	80884669 	addhi	v1, v5, v6, ror #12
    38a0:	88894668 	stmhiia	v6, {a4, v2, v3, v6, v7, LR}
    38a4:	4351220a 	cmpmi	a2, #-1610612736	; 0xa0000000
    38a8:	6ad24a3d 	bvs	0xff4961a4
    38ac:	82015a51 	andhi	v2, a2, #331776	; 0x51000
    38b0:	70812100 	addvc	a3, a2, a1, lsl #2
    38b4:	78404668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}^
    38b8:	d0032807 	andle	a3, a4, v4, lsl #16
    38bc:	78404668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}^
    38c0:	d1002808 	tstle	a1, v5, lsl #16
    38c4:	46681c64 	strmibt	a2, [v5], -v1, ror #24
    38c8:	28077800 	stmcsda	v4, {v8, IP, SP, LR}
    38cc:	4668d003 	strmibt	SP, [v5], -a4
    38d0:	28087800 	stmcsda	v5, {v8, IP, SP, LR}
    38d4:	1c6dd100 	stfnep	f5, [SP]
    38d8:	e0182600 	ands	a3, v5, a1, lsl #12
    38dc:	28087840 	stmcsda	v5, {v3, v8, IP, SP, LR}
    38e0:	1c20d1e8 	stfned	f5, [a1], #-928
    38e4:	fa2cf7ff 	blx	0xb418e8
    38e8:	81084669 	tsthi	v5, v6, ror #12
    38ec:	21014668 	tstcs	a2, v5, ror #12
    38f0:	e7e77081 	strb	v4, [v4, a2, lsl #1]!
    38f4:	28087800 	stmcsda	v5, {v8, IP, SP, LR}
    38f8:	4668d108 	strmibt	SP, [v5], -v5, lsl #2
    38fc:	28007880 	stmcsda	a1, {v4, v8, IP, SP, LR}
    3900:	0428d004 	streqt	SP, [v5], #-4
    3904:	f7ff0c00 	ldrnvb	a1, [PC, a1, lsl #24]!
    3908:	1c05f857 	stcne	8, cr15, [v2], {87}
    390c:	46681c76 	undefined
    3910:	04368900 	ldreqt	v5, [v3], #-2304
    3914:	42860c36 	addmi	a1, v3, #13824	; 0x3600
    3918:	4668d2b8 	undefined
    391c:	b4018d00 	strlt	v5, [a2], #-3328
    3920:	0c1b042b 	cfldrseq	mvf0, [v8], {43}
    3924:	8a02a801 	bhi	0xad930
    3928:	0c090421 	cfstrseq	mvf0, [v6], {33}
    392c:	200caf01 	andcs	v7, IP, a2, lsl #30
    3930:	f7ff5e38 	undefined
    3934:	1c07ff43 	stcne	15, cr15, [v4], {67}
    3938:	2800b001 	stmcsda	a1, {a1, IP, SP, PC}
    393c:	4668dba6 	strmibt	SP, [v5], -v3, lsr #23
    3940:	28077840 	stmcsda	v4, {v3, v8, IP, SP, LR}
    3944:	d10c4668 	tstle	IP, v5, ror #12
    3948:	8a094669 	bhi	0x2552f4
    394c:	8892466a 	ldmhiia	a3, {a2, a4, v2, v3, v6, v7, LR}
    3950:	435a230a 	cmpmi	v7, #671088640	; 0x28000000
    3954:	6adb4b12 	bvs	0xff6d65a4
    3958:	8852189a 	ldmhida	a3, {a2, a4, v1, v4, v8, IP}^
    395c:	82011889 	andhi	a2, a2, #8978432	; 0x890000
    3960:	7840e00b 	stmvcda	a1, {a1, a2, a4, SP, LR, PC}^
    3964:	d1082808 	tstle	v5, v5, lsl #16
    3968:	78804668 	stmvcia	a1, {a4, v2, v3, v6, v7, LR}
    396c:	d0042800 	andle	a3, v1, a1, lsl #16
    3970:	0c000420 	cfstrseq	mvf0, [a1], {32}
    3974:	f820f7ff 	stmnvda	a1!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    3978:	46681c04 	strmibt	a2, [v5], -v1, lsl #24
    397c:	28077800 	stmcsda	v4, {v8, IP, SP, LR}
    3980:	d1b74668 	movles	v1, v5, ror #12
    3984:	8d094669 	stchi	6, cr4, [v6, #-420]
    3988:	88d2466a 	ldmhiia	a3, {a2, a4, v2, v3, v6, v7, LR}^
    398c:	435a230a 	cmpmi	v7, #671088640	; 0x28000000
    3990:	6adb4b03 	bvs	0xff6d65a4
    3994:	8852189a 	ldmhida	a3, {a2, a4, v1, v4, v8, IP}^
    3998:	85011889 	strhi	a2, [a2, #-2185]
    399c:	0000e7b6 	streqh	LR, [a1], -v3
    39a0:	00008680 	andeq	v5, a1, a1, lsl #13
    39a4:	1c04b530 	cfstr32ne	mvfx11, [v1], {48}
    39a8:	25e01c08 	strcsb	a2, [a1, #3080]!
    39ac:	218000ed 	orrcs	a1, a1, SP, ror #1
    39b0:	40210109 	eormi	a1, a2, v6, lsl #2
    39b4:	06091209 	streq	a2, [v6], -v6, lsl #4
    39b8:	29080e09 	stmcsdb	v5, {a1, a4, v6, v7, v8}
    39bc:	1c29d107 	stfned	f5, [v6], #-28
    39c0:	12094021 	andne	v1, v6, #33	; 0x21
    39c4:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    39c8:	5c594b12 	fmrrdpl	v1, v6, d2
    39cc:	1c21e000 	stcne	0, cr14, [a2]
    39d0:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    39d4:	d0062902 	andle	a3, v3, a3, lsl #18
    39d8:	d0072909 	andle	a3, v4, v6, lsl #18
    39dc:	d0092912 	andle	a3, v6, a3, lsl v6
    39e0:	d014291b 	andles	a3, v1, v8, lsl v6
    39e4:	4241e012 	submi	LR, a2, #18	; 0x12
    39e8:	e0101c08 	ands	a2, a1, v5, lsl #24
    39ec:	41801e40 	orrmi	a2, a1, a1, asr #28
    39f0:	e00c0fc0 	and	a1, IP, a1, asr #31
    39f4:	1c13b404 	cfldrsne	mvf11, [a4], {4}
    39f8:	1c012200 	sfmne	f2, 4, [a2], {0}
    39fc:	12284025 	eorne	v1, v5, #37	; 0x25
    3a00:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    3a04:	f9d2f7ff 	ldmnvib	a3, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    3a08:	e000b001 	and	v8, a1, a2
    3a0c:	f7fc2000 	ldrnvb	a3, [IP, a1]!
    3a10:	0000fd00 	andeq	PC, a1, a1, lsl #26
    3a14:	00000100 	andeq	a1, a1, a1, lsl #2
    3a18:	b083b5f1 	strltd	v8, [a4], a2
    3a1c:	94022400 	strls	a3, [a3], #-1024
    3a20:	218048cd 	orrcs	v1, a1, SP, asr #17
    3a24:	9a030109 	bls	0xc3e50
    3a28:	400a8812 	andmi	v5, v7, a3, lsl v5
    3a2c:	06121212 	undefined
    3a30:	2a080e12 	bcs	0x207280
    3a34:	9903d119 	stmlsdb	a4, {a1, a4, v1, v5, IP, LR, PC}
    3a38:	5e892200 	cdppl	2, 8, cr2, cr9, cr0, {0}
    3a3c:	00d222e0 	sbceqs	a3, a3, a1, ror #5
    3a40:	1211400a 	andnes	v1, a2, #10	; 0xa
    3a44:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    3a48:	46685c45 	strmibt	v2, [v5], -v2, asr #24
    3a4c:	22009903 	andcs	v6, a1, #49152	; 0xc000
    3a50:	06095e89 	streq	v2, [v6], -v6, lsl #29
    3a54:	22021609 	andcs	a2, a3, #9437184	; 0x900000
    3a58:	5e9a9b03 	cdppl	11, 9, cr9, cr10, cr3, {0}
    3a5c:	80411889 	subhi	a2, a2, v6, lsl #17
    3a60:	884a9903 	stmhida	v7, {a1, a2, v5, v8, IP, PC}^
    3a64:	20048082 	andcs	v5, v1, a3, lsl #1
    3a68:	9a03e01d 	bls	0xfbae4
    3a6c:	40118812 	andmis	v5, a2, a3, lsl v5
    3a70:	06091209 	streq	a2, [v6], -v6, lsl #4
    3a74:	29080e09 	stmcsdb	v5, {a1, a4, v6, v7, v8}
    3a78:	9903d10a 	stmlsdb	a4, {a2, a4, v5, IP, LR, PC}
    3a7c:	5e892200 	cdppl	2, 8, cr2, cr9, cr0, {0}
    3a80:	00d222e0 	sbceqs	a3, a3, a1, ror #5
    3a84:	1211400a 	andnes	v1, a2, #10	; 0xa
    3a88:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    3a8c:	e0025c45 	and	v2, a3, v2, asr #24
    3a90:	21009803 	tstcs	a1, a4, lsl #16
    3a94:	46685e45 	strmibt	v2, [v5], -v2, asr #28
    3a98:	884a9903 	stmhida	v7, {a1, a2, v5, v8, IP, PC}^
    3a9c:	99038042 	stmlsdb	a4, {a2, v3, PC}
    3aa0:	8082888a 	addhi	v5, a3, v7, lsl #17
    3aa4:	99032006 	stmlsdb	a4, {a2, a3, SP}
    3aa8:	062d5e0e 	streqt	v2, [SP], -LR, lsl #28
    3aac:	d00d0e2d 	andle	a1, SP, SP, lsr #28
    3ab0:	d00b2d01 	andle	a3, v8, a2, lsl #26
    3ab4:	d0092d03 	andle	a3, v6, a4, lsl #26
    3ab8:	d0072d04 	andle	a3, v4, v1, lsl #26
    3abc:	d0052d05 	andle	a3, v2, v2, lsl #26
    3ac0:	d0032d06 	andle	a3, a4, v3, lsl #26
    3ac4:	d0012d07 	andle	a3, a2, v4, lsl #26
    3ac8:	d10e2d08 	tstle	LR, v5, lsl #26
    3acc:	20002200 	andcs	a3, a1, a1, lsl #4
    3ad0:	0c090431 	cfstrseq	mvf0, [v6], {49}
    3ad4:	a803b407 	stmgeda	a4, {a1, a2, a3, v7, IP, SP, PC}
    3ad8:	88418883 	stmhida	a2, {a1, a2, v4, v8, PC}^
    3adc:	f0001c28 	andnv	a2, a1, v5, lsr #24
    3ae0:	b003f977 	andlt	PC, a4, v4, ror v6
    3ae4:	f7feb004 	ldrnvb	v8, [LR, v1]!
    3ae8:	2d26fc24 	stccs	12, cr15, [v3, #-144]!
    3aec:	aa01d007 	bge	0x77b10
    3af0:	21001c92 	strcsb	a2, [a1, -a3]
    3af4:	88404668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}^
    3af8:	feb2f7fe 	mrc2	7, 5, PC, cr2, cr14, {7}
    3afc:	2d159002 	ldccs	0, cr9, [v2, #-8]
    3b00:	466ad00c 	strmibt	SP, [v7], -IP
    3b04:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    3b08:	f7fe8880 	ldrnvb	v5, [LR, a1, lsl #17]!
    3b0c:	1c07fea9 	stcne	14, cr15, [v4], {169}
    3b10:	78014668 	stmvcda	a2, {a4, v2, v3, v6, v7, LR}
    3b14:	f7fe1c38 	undefined
    3b18:	1c07fee7 	stcne	14, cr15, [v4], {231}
    3b1c:	d0122d33 	andles	a3, a3, a4, lsr SP
    3b20:	d0102d30 	andles	a3, a1, a1, lsr SP
    3b24:	d00e2d32 	andle	a3, LR, a3, lsr SP
    3b28:	d00c2d15 	andle	a3, IP, v2, lsl SP
    3b2c:	d00a2d1a 	andle	a3, v7, v7, lsl SP
    3b30:	1c52aa00 	mrrcne	10, 0, v7, a3, cr0
    3b34:	04302100 	ldreqt	a3, [a1], #-256
    3b38:	f7fe0c00 	ldrnvb	a1, [LR, a1, lsl #24]!
    3b3c:	4669fe91 	undefined
    3b40:	f7fe7849 	ldrnvb	v4, [LR, v6, asr #16]!
    3b44:	1c38fed1 	ldcne	14, cr15, [v5], #-836
    3b48:	43482106 	cmpmi	v5, #-2147483647	; 0x80000001
    3b4c:	20c01831 	sbccs	a2, a1, a2, lsr v5
    3b50:	43080200 	tstmi	v5, #0	; 0x0
    3b54:	4a9c2100 	bmi	0xfe70bf5c
    3b58:	d0102d11 	andles	a3, a1, a2, lsl SP
    3b5c:	d1002d15 	tstle	a1, v2, lsl SP
    3b60:	2d1ae0b7 	ldccs	0, cr14, [v7, #-732]
    3b64:	e0e8d100 	rsc	SP, v5, a1, lsl #2
    3b68:	d0572d26 	subles	a3, v4, v3, lsr #26
    3b6c:	d1002d30 	tstle	a1, a1, lsr SP
    3b70:	2d32e08d 	ldccs	0, cr14, [a3, #-564]!
    3b74:	e09ad100 	adds	SP, v7, a1, lsl #2
    3b78:	d0702d33 	rsbles	a3, a1, a4, lsr SP
    3b7c:	4668e121 	strmibt	LR, [v5], -a2, lsr #2
    3b80:	f7fe8840 	ldrnvb	v5, [LR, a1, asr #16]!
    3b84:	2807fe67 	stmcsda	v4, {a1, a2, a3, v2, v3, v6, v7, v8, IP, SP, LR, PC}
    3b88:	4668d039 	undefined
    3b8c:	f7fe8840 	ldrnvb	v5, [LR, a1, asr #16]!
    3b90:	2808fe61 	stmcsda	v5, {a1, v2, v3, v6, v7, v8, IP, SP, LR, PC}
    3b94:	4668d033 	undefined
    3b98:	f7fe8880 	ldrnvb	v5, [LR, a1, lsl #17]!
    3b9c:	2807fe5b 	stmcsda	v4, {a1, a2, a4, v1, v3, v6, v7, v8, IP, SP, LR, PC}
    3ba0:	4668d005 	strmibt	SP, [v5], -v2
    3ba4:	f7fe8880 	ldrnvb	v5, [LR, a1, lsl #17]!
    3ba8:	2808fe55 	stmcsda	v5, {a1, a3, v1, v3, v6, v7, v8, IP, SP, LR, PC}
    3bac:	0430d127 	ldreqt	SP, [a1], #-295
    3bb0:	f7fe0c00 	ldrnvb	a1, [LR, a1, lsl #24]!
    3bb4:	2807fe4f 	stmcsda	v4, {a1, a2, a3, a4, v3, v6, v7, v8, IP, SP, LR, PC}
    3bb8:	0430d005 	ldreqt	SP, [a1], #-5
    3bbc:	f7fe0c00 	ldrnvb	a1, [LR, a1, lsl #24]!
    3bc0:	2808fe49 	stmcsda	v5, {a1, a4, v3, v6, v7, v8, IP, SP, LR, PC}
    3bc4:	2100d11b 	tstcs	a1, v8, lsl a2
    3bc8:	0c000430 	cfstrseq	mvf0, [a1], {48}
    3bcc:	2300b403 	tstcs	a1, #50331648	; 0x3000000
    3bd0:	8882a802 	stmhiia	a3, {a2, v8, SP, PC}
    3bd4:	1cc9a903 	stcnel	9, cr10, [v6], {3}
    3bd8:	88009805 	stmhida	a1, {a1, a3, v8, IP, PC}
    3bdc:	00e424e0 	rsceq	a3, v1, a1, ror #9
    3be0:	12204004 	eorne	v1, a1, #4	; 0x4
    3be4:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    3be8:	f92ef7ff 	stmnvdb	LR!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    3bec:	a8021c04 	stmgeda	a3, {a3, v7, v8, IP}
    3bf0:	798179c2 	stmvcib	a2, {a2, v3, v4, v5, v8, IP, SP, LR}
    3bf4:	f7fe9804 	ldrnvb	v6, [LR, v1, lsl #16]!
    3bf8:	b002fe65 	andlt	PC, a3, v2, ror #28
    3bfc:	2200e0b9 	andcs	LR, a1, #185	; 0xb9
    3c00:	04312000 	ldreqt	a3, [a2]
    3c04:	b4070c09 	strlt	a1, [v4], #-3081
    3c08:	8883a803 	stmhiia	a4, {a1, a2, v8, SP, PC}
    3c0c:	98068841 	stmlsda	v3, {a1, v3, v8, PC}
    3c10:	f0005f00 	andnv	v2, a1, a1, lsl #30
    3c14:	1c04f8dd 	stcne	8, cr15, [v1], {221}
    3c18:	e0aab003 	adc	v8, v7, a4
    3c1c:	0c000430 	cfstrseq	mvf0, [a1], {48}
    3c20:	2300b403 	tstcs	a1, #50331648	; 0x3000000
    3c24:	8882a802 	stmhiia	a3, {a2, v8, SP, PC}
    3c28:	1cc9a903 	stcnel	9, cr10, [v6], {3}
    3c2c:	88009805 	stmhida	a1, {a1, a3, v8, IP, PC}
    3c30:	00e424e0 	rsceq	a3, v1, a1, ror #9
    3c34:	12204004 	eorne	v1, a1, #4	; 0x4
    3c38:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    3c3c:	f904f7ff 	stmnvdb	v1, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    3c40:	a8021c04 	stmgeda	a3, {a3, v7, v8, IP}
    3c44:	b00279c0 	andlt	v4, a3, a1, asr #19
    3c48:	d0072800 	andle	a3, v4, a1, lsl #16
    3c4c:	495f485f 	ldmmidb	PC, {a1, a2, a3, a4, v1, v3, v8, LR}^
    3c50:	466a8e49 	strmibt	v5, [v7], -v6, asr #28
    3c54:	18898852 	stmneia	v6, {a2, v1, v3, v8, PC}
    3c58:	24038641 	strcs	v5, [a4], #-1601
    3c5c:	466ae089 	strmibt	LR, [v7], -v6, lsl #1
    3c60:	4347200f 	cmpmi	v4, #15	; 0xf
    3c64:	20c219f3 	strcsd	a2, [a3], #147
    3c68:	43180200 	tstmi	v5, #0	; 0x0
    3c6c:	0c000400 	cfstrseq	mvf0, [a1], {0}
    3c70:	fdf6f7fe 	ldc2l	7, cr15, [v3, #1016]!
    3c74:	46681c07 	strmibt	a2, [v5], -v4, lsl #24
    3c78:	1c387801 	ldcne	8, cr7, [v5], #-4
    3c7c:	fe34f7fe 	mrc2	7, 1, PC, cr4, cr14, {7}
    3c80:	46681c02 	strmibt	a2, [v5], -a3, lsl #24
    3c84:	98027981 	stmlsda	a3, {a1, v4, v5, v8, IP, SP, LR}
    3c88:	fe1cf7fe 	mrc2	7, 0, PC, cr12, cr14, {7}
    3c8c:	466ae071 	undefined
    3c90:	0c000400 	cfstrseq	mvf0, [a1], {0}
    3c94:	fde4f7fe 	stc2l	7, cr15, [v1, #1016]!
    3c98:	46681c07 	strmibt	a2, [v5], -v4, lsl #24
    3c9c:	98027981 	stmlsda	a3, {a1, v4, v5, v8, IP, SP, LR}
    3ca0:	fe22f7fe 	mcr2	7, 1, PC, cr2, cr14, {7}
    3ca4:	46681c02 	strmibt	a2, [v5], -a3, lsl #24
    3ca8:	1c387801 	ldcne	8, cr7, [v5], #-4
    3cac:	466ae7ec 	strmibt	LR, [v7], -IP, ror #15
    3cb0:	0c000400 	cfstrseq	mvf0, [a1], {0}
    3cb4:	fdd4f7fe 	ldc2l	7, cr15, [v1, #1016]
    3cb8:	46681c07 	strmibt	a2, [v5], -v4, lsl #24
    3cbc:	1c387801 	ldcne	8, cr7, [v5], #-4
    3cc0:	fe12f7fe 	mrc2	7, 0, PC, cr2, cr14, {7}
    3cc4:	46681c02 	strmibt	a2, [v5], -a3, lsl #24
    3cc8:	98027981 	stmlsda	a3, {a1, v4, v5, v8, IP, SP, LR}
    3ccc:	fdfaf7fe 	ldc2l	7, cr15, [v7, #1016]!
    3cd0:	0436e04f 	ldreqt	LR, [v3], #-79
    3cd4:	42960c36 	addmis	a1, v3, #13824	; 0x3600
    3cd8:	aa00d00a 	bge	0x37d08
    3cdc:	1c301c52 	ldcne	12, cr1, [a1], #-328
    3ce0:	fdbef7fe 	ldc2	7, cr15, [LR, #1016]!
    3ce4:	78494669 	stmvcda	v6, {a1, a4, v2, v3, v6, v7, LR}^
    3ce8:	fdfef7fe 	ldc2l	7, cr15, [LR, #1016]!
    3cec:	e0001c05 	and	a2, a1, v2, lsl #24
    3cf0:	21002500 	tstcs	a1, a1, lsl #10
    3cf4:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    3cf8:	f82cf7ff 	stmnvda	IP!, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    3cfc:	4348210a 	cmpmi	v5, #-2147483646	; 0x80000002
    3d00:	6ac94932 	bvs	0xff2561d0
    3d04:	88811808 	stmhiia	a2, {a4, v8, IP}
    3d08:	d302428d 	tstle	a3, #-805306360	; 0xd0000008
    3d0c:	43c02000 	bicmi	a3, a1, #0	; 0x0
    3d10:	8801e6e8 	stmhida	a2, {a4, v2, v3, v4, v6, v7, SP, LR, PC}
    3d14:	43688840 	cmnmi	v5, #4194304	; 0x400000
    3d18:	04001808 	streq	a2, [a1], #-2056
    3d1c:	b4010c00 	strlt	a1, [a2], #-3072
    3d20:	8883a801 	stmhiia	a4, {a1, v8, SP, PC}
    3d24:	041b1c5b 	ldreq	a2, [v8], #-3163
    3d28:	22000c1b 	andcs	a1, a1, #6912	; 0x1b00
    3d2c:	201b8841 	andcss	v5, v8, a2, asr #16
    3d30:	fd44f7ff 	stc2l	7, cr15, [v1, #-1020]
    3d34:	b0011c04 	andlt	a2, a2, v1, lsl #24
    3d38:	0436e01b 	ldreqt	LR, [v3], #-27
    3d3c:	42960c36 	addmis	a1, v3, #13824	; 0x3600
    3d40:	aa00d00c 	bge	0x37d78
    3d44:	1c301c52 	ldcne	12, cr1, [a1], #-328
    3d48:	fd8af7fe 	stc2	7, cr15, [v7, #1016]
    3d4c:	78494669 	stmvcda	v6, {a1, a4, v2, v3, v6, v7, LR}^
    3d50:	fdcaf7fe 	stc2l	7, cr15, [v7, #1016]
    3d54:	e0021c05 	and	a2, a3, v2, lsl #24
    3d58:	00000100 	andeq	a1, a1, a1, lsl #2
    3d5c:	042a2500 	streqt	a3, [v7], #-1280
    3d60:	21000c12 	tstcs	a1, a3, lsl IP
    3d64:	88404668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}^
    3d68:	f91af7fe 	ldmnvdb	v7, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    3d6c:	28001c04 	stmcsda	a1, {a3, v7, v8, IP}
    3d70:	1c20da01 	stcne	10, cr13, [a1], #-4
    3d74:	2100e6b6 	strcsh	LR, [a1, -v3]
    3d78:	88404668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}^
    3d7c:	ffeaf7fe 	swinv	0x00eaf7fe
    3d80:	27001c06 	strcs	a2, [a1, -v3, lsl #24]
    3d84:	0c3f043f 	cfldrseq	mvf0, [PC], #-252
    3d88:	d2f242af 	rscles	v1, a3, #-268435446	; 0xf000000a
    3d8c:	4370200a 	cmnmi	a1, #10	; 0xa
    3d90:	6ac9490e 	bvs	0xff2561d0
    3d94:	21001808 	tstcs	a1, v5, lsl #16
    3d98:	a901b402 	stmgedb	a2, {a2, v7, IP, SP, PC}
    3d9c:	8801888b 	stmhida	a2, {a1, a2, a4, v4, v8, PC}
    3da0:	43788840 	cmnmi	v5, #4194304	; 0x400000
    3da4:	0412180a 	ldreq	a2, [a3], #-2058
    3da8:	a8010c12 	stmgeda	a2, {a2, v1, v7, v8}
    3dac:	1c498841 	mcrrne	8, 4, v5, v6, cr1
    3db0:	0c090409 	cfstrseq	mvf0, [v6], {9}
    3db4:	f7ff201b 	undefined
    3db8:	1c04fd01 	stcne	13, cr15, [v1], {1}
    3dbc:	b0011c7f 	andlt	a2, a2, PC, ror IP
    3dc0:	2401e7e0 	strcs	LR, [a2], #-2016
    3dc4:	e7d443e4 	ldrb	v1, [v1, v1, ror #7]
    3dc8:	0000ffff 	streqd	PC, [a1], -PC
    3dcc:	00008680 	andeq	v5, a1, a1, lsl #13
    3dd0:	b085b5f5 	strltd	v8, [v2], v2
    3dd4:	1c1c1c0e 	ldcne	12, cr1, [IP], {14}
    3dd8:	8e854668 	cdphi	6, 8, cr4, cr5, cr8, {3}
    3ddc:	1c082700 	stcne	7, cr2, [v5], {0}
    3de0:	fd38f7fe 	ldc2	7, cr15, [v5, #-1016]!
    3de4:	70884669 	addvc	v1, v5, v6, ror #12
    3de8:	f7fe1c20 	ldrnvb	a2, [LR, a1, lsr #24]!
    3dec:	4669fd33 	undefined
    3df0:	1c287048 	stcne	0, cr7, [v5], #-288
    3df4:	fd2ef7fe 	stc2	7, cr15, [LR, #-1016]!
    3df8:	70084669 	andvc	v1, v5, v6, ror #12
    3dfc:	78404668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}^
    3e00:	46682807 	strmibt	a3, [v5], -v4, lsl #16
    3e04:	7840d043 	stmvcda	a1, {a1, a2, v3, IP, LR, PC}^
    3e08:	d0562808 	subles	a3, v3, v5, lsl #16
    3e0c:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    3e10:	d0572807 	subles	a3, v4, v4, lsl #16
    3e14:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    3e18:	d06e2808 	rsble	a3, LR, v5, lsl #16
    3e1c:	1c92aa00 	fldmiasne	a3, {s20-s19}
    3e20:	8b014668 	blhi	0x557c8
    3e24:	f7fe1c30 	undefined
    3e28:	1c06fd1b 	stcne	13, cr15, [v3], {27}
    3e2c:	1c52aa00 	mrrcne	10, 0, v7, a3, cr0
    3e30:	8e014668 	cfmadd32hi	mvax3, mvfx4, mvfx1, mvfx8
    3e34:	f7fe1c20 	ldrnvb	a2, [LR, a1, lsr #24]!
    3e38:	1c04fd13 	stcne	13, cr15, [v1], {19}
    3e3c:	4668466a 	strmibt	v1, [v5], -v7, ror #12
    3e40:	1c288f01 	stcne	15, cr8, [v5], #-4
    3e44:	fd0cf7fe 	stc2	7, cr15, [IP, #-1016]
    3e48:	46681c05 	strmibt	a2, [v5], -v2, lsl #24
    3e4c:	1c207841 	stcne	8, cr7, [a1], #-260
    3e50:	fd4af7fe 	stc2l	7, cr15, [v7, #-1016]
    3e54:	46681c04 	strmibt	a2, [v5], -v1, lsl #24
    3e58:	1c287801 	stcne	8, cr7, [v5], #-4
    3e5c:	fd44f7fe 	stc2l	7, cr15, [v1, #-1016]
    3e60:	78094669 	stmvcda	v6, {a1, a4, v2, v3, v6, v7, LR}
    3e64:	a901b402 	stmgedb	a2, {a2, v7, IP, SP, PC}
    3e68:	1c02784b 	stcne	8, cr7, [a3], {75}
    3e6c:	ac011c21 	stcge	12, cr1, [a2], {33}
    3e70:	5e202014 	miapl	acc0, v1, a3
    3e74:	f92cf000 	stmnvdb	IP!, {IP, SP, LR, PC}
    3e78:	a8011c02 	stmgeda	a2, {a2, v7, v8, IP}
    3e7c:	1c307881 	ldcne	8, cr7, [a1], #-516
    3e80:	fd20f7fe 	stc2	7, cr15, [a1, #-1016]!
    3e84:	b0012000 	andlt	a3, a2, a1
    3e88:	f7feb007 	ldrnvb	v8, [LR, v4]!
    3e8c:	8e01fa52 	mcrhi	10, 0, PC, cr1, cr2, {2}
    3e90:	f7fe1c20 	ldrnvb	a2, [LR, a1, lsr #24]!
    3e94:	4669ff6b 	strmibt	PC, [v6], -v8, ror #30
    3e98:	46688088 	strmibt	v5, [v5], -v5, lsl #1
    3e9c:	1c208e01 	stcne	14, cr8, [a1], #-4
    3ea0:	ff58f7fe 	swinv	0x0058f7fe
    3ea4:	81884669 	orrhi	v1, v5, v6, ror #12
    3ea8:	89894668 	stmhiib	v6, {a4, v2, v3, v6, v7, LR}
    3eac:	4351220a 	cmpmi	a2, #-1610612736	; 0xa0000000
    3eb0:	6ad24a86 	bvs	0xff4968d0
    3eb4:	86015a51 	undefined
    3eb8:	1c20e004 	stcne	0, cr14, [a1], #-16
    3ebc:	ff40f7fe 	swinv	0x0040f7fe
    3ec0:	80884669 	addhi	v1, v5, v6, ror #12
    3ec4:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    3ec8:	d1162807 	tstle	v3, v4, lsl #16
    3ecc:	8f014668 	swihi	0x00014668
    3ed0:	f7fe1c28 	ldrnvb	a2, [LR, v5, lsr #24]!
    3ed4:	4669ff4b 	strmibt	PC, [v6], -v8, asr #30
    3ed8:	466880c8 	strmibt	v5, [v5], -v5, asr #1
    3edc:	1c288f01 	stcne	15, cr8, [v5], #-4
    3ee0:	ff38f7fe 	swinv	0x0038f7fe
    3ee4:	81c84669 	bichi	v1, v5, v6, ror #12
    3ee8:	89c94668 	stmhiib	v6, {a4, v2, v3, v6, v7, LR}^
    3eec:	4351220a 	cmpmi	a2, #-1610612736	; 0xa0000000
    3ef0:	6ad24a76 	bvs	0xff4968d0
    3ef4:	87015a51 	smlsdhi	a2, a2, v7, v2
    3ef8:	4668e008 	strmibt	LR, [v5], -v5
    3efc:	28087800 	stmcsda	v5, {v8, IP, SP, LR}
    3f00:	1c28d104 	stfned	f5, [v5], #-16
    3f04:	ff1cf7fe 	swinv	0x001cf7fe
    3f08:	80c84669 	sbchi	v1, v5, v6, ror #12
    3f0c:	78804668 	stmvcia	a1, {a4, v2, v3, v6, v7, LR}
    3f10:	46682807 	strmibt	a3, [v5], -v4, lsl #16
    3f14:	7840d154 	stmvcda	a1, {a3, v1, v3, v5, IP, LR, PC}^
    3f18:	46682807 	strmibt	a3, [v5], -v4, lsl #16
    3f1c:	d1147800 	tstle	v1, a1, lsl #16
    3f20:	46682807 	strmibt	a3, [v5], -v4, lsl #16
    3f24:	88894669 	stmhiia	v6, {a1, a4, v2, v3, v6, v7, LR}
    3f28:	466ad104 	strmibt	SP, [v7], -v1, lsl #2
    3f2c:	429188d2 	addmis	v5, a2, #13762560	; 0xd20000
    3f30:	1c11d900 	ldcne	9, cr13, [a2], {0}
    3f34:	89028101 	stmhidb	a3, {a1, v5, PC}
    3f38:	1c308b01 	ldcne	11, cr8, [a1], #-4
    3f3c:	f830f7fe 	ldmnvda	a1!, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    3f40:	28001c07 	stmcsda	a1, {a1, a2, a3, v7, v8, IP}
    3f44:	1c38da0a 	ldcne	10, cr13, [v5], #-40
    3f48:	2807e79e 	stmcsda	v4, {a2, a3, a4, v1, v4, v5, v6, v7, SP, LR, PC}
    3f4c:	4668d103 	strmibt	SP, [v5], -a4, lsl #2
    3f50:	88c94669 	stmhiia	v6, {a1, a4, v2, v3, v6, v7, LR}^
    3f54:	2000e7ee 	andcs	LR, a1, LR, ror #15
    3f58:	e79543c0 	ldr	v1, [v2, a1, asr #7]
    3f5c:	46694668 	strmibt	v1, [v6], -v5, ror #12
    3f60:	82018909 	andhi	v5, a2, #147456	; 0x24000
    3f64:	1c308b01 	ldcne	11, cr8, [a1], #-4
    3f68:	fef4f7fe 	mrc2	7, 7, PC, cr4, cr14, {7}
    3f6c:	81484669 	cmphi	v5, v6, ror #12
    3f70:	89494668 	stmhidb	v6, {a4, v2, v3, v6, v7, LR}^
    3f74:	4351220a 	cmpmi	a2, #-1610612736	; 0xa0000000
    3f78:	6ad24a54 	bvs	0xff4968d0
    3f7c:	83015a51 	tsthi	a2, #331776	; 0x51000
    3f80:	70c12100 	sbcvc	a3, a2, a1, lsl #2
    3f84:	78804668 	stmvcia	a1, {a4, v2, v3, v6, v7, LR}
    3f88:	d0032807 	andle	a3, a4, v4, lsl #16
    3f8c:	78804668 	stmvcia	a1, {a4, v2, v3, v6, v7, LR}
    3f90:	d1002808 	tstle	a1, v5, lsl #16
    3f94:	46681c76 	undefined
    3f98:	28077840 	stmcsda	v4, {v3, v8, IP, SP, LR}
    3f9c:	4668d003 	strmibt	SP, [v5], -a4
    3fa0:	28087840 	stmcsda	v5, {v3, v8, IP, SP, LR}
    3fa4:	1c64d100 	stfnep	f5, [v1]
    3fa8:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    3fac:	d0032807 	andle	a3, a4, v4, lsl #16
    3fb0:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    3fb4:	d1002808 	tstle	a1, v5, lsl #16
    3fb8:	46681c6d 	strmibt	a2, [v5], -SP, ror #24
    3fbc:	e01b2100 	ands	a3, v8, a1, lsl #2
    3fc0:	28087880 	stmcsda	v5, {v4, v8, IP, SP, LR}
    3fc4:	1c30d1de 	ldfned	f5, [a1], #-888
    3fc8:	febaf7fe 	mrc2	7, 5, PC, cr10, cr14, {7}
    3fcc:	82084669 	andhi	v1, v5, #110100480	; 0x6900000
    3fd0:	21014668 	tstcs	a2, v5, ror #12
    3fd4:	e7dd70c1 	ldrb	v4, [SP, a2, asr #1]
    3fd8:	28087800 	stmcsda	v5, {v8, IP, SP, LR}
    3fdc:	4668d108 	strmibt	SP, [v5], -v5, lsl #2
    3fe0:	280078c0 	stmcsda	a1, {v3, v4, v8, IP, SP, LR}
    3fe4:	0428d004 	streqt	SP, [v5], #-4
    3fe8:	f7fe0c00 	ldrnvb	a1, [LR, a1, lsl #24]!
    3fec:	1c05fce5 	stcne	12, cr15, [v2], {229}
    3ff0:	46694668 	strmibt	v1, [v6], -v5, ror #12
    3ff4:	1c498889 	mcrrne	8, 8, v5, v6, cr9
    3ff8:	88808081 	stmhiia	a1, {a1, v4, PC}
    3ffc:	8a094669 	bhi	0x2559a8
    4000:	d2a04288 	adcle	v1, a1, #-2147483640	; 0x80000008
    4004:	8f024668 	swihi	0x00024668
    4008:	04298e00 	streqt	v5, [v6], #-3584
    400c:	b4070c09 	strlt	a1, [v4], #-3081
    4010:	0c1b0423 	cfldrseq	mvf0, [v8], {35}
    4014:	8b02a803 	blhi	0xae028
    4018:	0c090431 	cfstrseq	mvf0, [v6], {49}
    401c:	2014af03 	andcss	v7, v1, a4, lsl #30
    4020:	f7ff5e38 	undefined
    4024:	1c07fed5 	stcne	14, cr15, [v4], {213}
    4028:	2800b003 	stmcsda	a1, {a1, a2, IP, SP, PC}
    402c:	4668db8b 	strmibt	SP, [v5], -v8, lsl #23
    4030:	28077880 	stmcsda	v4, {v4, v8, IP, SP, LR}
    4034:	d10c4668 	tstle	IP, v5, ror #12
    4038:	8b094669 	blhi	0x2559e4
    403c:	8952466a 	ldmhidb	a3, {a2, a4, v2, v3, v6, v7, LR}^
    4040:	435a230a 	cmpmi	v7, #671088640	; 0x28000000
    4044:	6adb4b21 	bvs	0xff6d6cd0
    4048:	8852189a 	ldmhida	a3, {a2, a4, v1, v4, v8, IP}^
    404c:	83011889 	tsthi	a2, #8978432	; 0x890000
    4050:	7880e00b 	stmvcia	a1, {a1, a2, a4, SP, LR, PC}
    4054:	d1082808 	tstle	v5, v5, lsl #16
    4058:	78c04668 	stmvcia	a1, {a4, v2, v3, v6, v7, LR}^
    405c:	d0042800 	andle	a3, v1, a1, lsl #16
    4060:	0c000430 	cfstrseq	mvf0, [a1], {48}
    4064:	fca8f7fe 	stc2	7, cr15, [v5], #1016
    4068:	46681c06 	strmibt	a2, [v5], -v3, lsl #24
    406c:	28077840 	stmcsda	v4, {v3, v8, IP, SP, LR}
    4070:	d10c4668 	tstle	IP, v5, ror #12
    4074:	8e094669 	cfmadd32hi	mvax3, mvfx4, mvfx9, mvfx9
    4078:	8992466a 	ldmhiib	a3, {a2, a4, v2, v3, v6, v7, LR}
    407c:	435a230a 	cmpmi	v7, #671088640	; 0x28000000
    4080:	6adb4b12 	bvs	0xff6d6cd0
    4084:	8852189a 	ldmhida	a3, {a2, a4, v1, v4, v8, IP}^
    4088:	86011889 	strhi	a2, [a2], -v6, lsl #17
    408c:	7840e00b 	stmvcda	a1, {a1, a2, a4, SP, LR, PC}^
    4090:	d1082808 	tstle	v5, v5, lsl #16
    4094:	78c04668 	stmvcia	a1, {a4, v2, v3, v6, v7, LR}^
    4098:	d0042800 	andle	a3, v1, a1, lsl #16
    409c:	0c000420 	cfstrseq	mvf0, [a1], {32}
    40a0:	fc8af7fe 	stc2	7, cr15, [v7], {254}
    40a4:	46681c04 	strmibt	a2, [v5], -v1, lsl #24
    40a8:	28077800 	stmcsda	v4, {v8, IP, SP, LR}
    40ac:	d1934668 	orrles	v1, a4, v5, ror #12
    40b0:	8f094669 	swihi	0x00094669
    40b4:	89d2466a 	ldmhiib	a3, {a2, a4, v2, v3, v6, v7, LR}^
    40b8:	435a230a 	cmpmi	v7, #671088640	; 0x28000000
    40bc:	6adb4b03 	bvs	0xff6d6cd0
    40c0:	8852189a 	ldmhida	a3, {a2, a4, v1, v4, v8, IP}^
    40c4:	87011889 	strhi	a2, [a2, -v6, lsl #17]
    40c8:	0000e792 	muleq	a1, a3, v4
    40cc:	00008680 	andeq	v5, a1, a1, lsl #13
    40d0:	1c04b5f0 	cfstr32ne	mvfx11, [v1], {240}
    40d4:	1c111c08 	ldcne	12, cr1, [a2], {8}
    40d8:	7d15466a 	ldcvc	6, cr4, [v2, #-424]
    40dc:	01122280 	tsteq	a3, a1, lsl #5
    40e0:	12124022 	andnes	v1, a3, #34	; 0x22
    40e4:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    40e8:	d1082a08 	tstle	v5, v5, lsl #20
    40ec:	00d222e0 	sbceqs	a3, a3, a1, ror #5
    40f0:	12124022 	andnes	v1, a3, #34	; 0x22
    40f4:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    40f8:	5cb64e30 	ldcpl	14, cr4, [v3], #192
    40fc:	1c26e000 	stcne	0, cr14, [v3]
    4100:	43021c0a 	tstmi	a3, #2560	; 0xa00
    4104:	0e360636 	cfmsuba32eq	mvax1, mvax0, mvfx6, mvfx6
    4108:	2e01d010 	mcrcs	0, 0, SP, cr1, cr0, {0}
    410c:	2e03d010 	mcrcs	0, 0, SP, cr3, cr0, {0}
    4110:	2e04d010 	mcrcs	0, 0, SP, cr4, cr0, {0}
    4114:	2e05d010 	mcrcs	0, 0, SP, cr5, cr0, {0}
    4118:	2e06d025 	cdpcs	0, 0, cr13, cr6, cr5, {1}
    411c:	2e07d037 	mcrcs	0, 0, SP, cr7, cr7, {1}
    4120:	2e08d037 	mcrcs	0, 0, SP, cr8, cr7, {1}
    4124:	2e11d037 	mrccs	0, 0, SP, cr1, cr7, {1}
    4128:	e007d039 	and	SP, v4, v6, lsr a1
    412c:	e0421840 	sub	a2, a3, a1, asr #16
    4130:	e0401a40 	sub	a2, a1, a1, asr #20
    4134:	e03e4348 	eors	v1, LR, v5, asr #6
    4138:	d1012900 	tstle	a2, a1, lsl #18
    413c:	e03a2000 	eors	a3, v7, a1
    4140:	d0032b02 	andle	a3, a4, a3, lsl #22
    4144:	d0012b04 	andle	a3, a2, v1, lsl #22
    4148:	d1092b06 	tstle	v6, v3, lsl #22
    414c:	d0032d02 	andle	a3, a4, a3, lsl #26
    4150:	d0012d04 	andle	a3, a2, v1, lsl #26
    4154:	d1032d06 	tstle	a4, v3, lsl #26
    4158:	fbd8f013 	blx	0xff6401ae
    415c:	e02a1c08 	eor	a2, v7, v5, lsl #24
    4160:	fbccf013 	blx	0xff3401b6
    4164:	2900e7fa 	stmcsdb	a1, {a2, a4, v1, v2, v3, v4, v5, v6, v7, SP, LR, PC}
    4168:	2b02d025 	blcs	0xb8204
    416c:	2b04d003 	blcs	0x138180
    4170:	2b06d001 	blcs	0x1b817c
    4174:	2d02d108 	stfcsd	f5, [a3, #-32]
    4178:	2d04d003 	stccs	0, cr13, [v1, #-12]
    417c:	2d06d001 	stccs	0, cr13, [v3, #-4]
    4180:	f013d102 	andnvs	SP, a4, a3, lsl #2
    4184:	e016fbc3 	ands	PC, v3, a4, asr #23
    4188:	fbb8f013 	blx	0xfee401de
    418c:	4001e013 	andmi	LR, a2, a4, lsl a1
    4190:	1c10e7e4 	ldcne	7, cr14, [a1], {228}
    4194:	4001e00f 	andmi	LR, a2, PC
    4198:	401043c8 	andmis	v1, a1, v5, asr #7
    419c:	b420e00b 	strltt	LR, [a1], #-11
    41a0:	1c011c0a 	stcne	12, cr1, [a2], {10}
    41a4:	00c020e0 	sbceq	a3, a1, a1, ror #1
    41a8:	12004020 	andne	v1, a1, #32	; 0x20
    41ac:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    41b0:	fdfcf7fe 	ldc2l	7, cr15, [IP, #1016]!
    41b4:	f7feb001 	ldrnvb	v8, [LR, a2]!
    41b8:	0000f8bc 	streqh	PC, [a1], -IP
    41bc:	00000100 	andeq	a1, a1, a1, lsl #2
    41c0:	43c02001 	bicmi	a3, a1, #1	; 0x1
    41c4:	00004770 	andeq	v1, a1, a1, ror v4
    41c8:	b08cb5f0 	strltd	v8, [IP], a1
    41cc:	27001c05 	strcs	a2, [a1, -v2, lsl #24]
    41d0:	21808800 	orrcs	v5, a1, a1, lsl #16
    41d4:	40010109 	andmi	a1, a2, v6, lsl #2
    41d8:	06001208 	streq	a2, [a1], -v5, lsl #4
    41dc:	28080e00 	stmcsda	v5, {v6, v7, v8}
    41e0:	2000d10a 	andcs	SP, a1, v7, lsl #2
    41e4:	21e05e28 	mvncs	v2, v5, lsr #28
    41e8:	400100c9 	andmi	a1, a2, v6, asr #1
    41ec:	06001208 	streq	a2, [a1], -v5, lsl #4
    41f0:	49d70e00 	ldmmiib	v4, {v6, v7, v8}^
    41f4:	e0015c09 	and	v2, a2, v6, lsl #24
    41f8:	5e292000 	cdppl	0, 2, cr2, cr9, cr0, {0}
    41fc:	060948d5 	undefined
    4200:	29160e09 	ldmcsdb	v3, {a1, a4, v6, v7, v8}
    4204:	2918d015 	ldmcsdb	v5, {a1, a3, v1, IP, LR, PC}
    4208:	e1d6d100 	bics	SP, v3, a1, lsl #2
    420c:	d1002919 	tstle	a1, v6, lsl v6
    4210:	291ee0b9 	ldmcsdb	LR, {a1, a4, v1, v2, v4, SP, LR, PC}
    4214:	e2efd100 	rsc	SP, PC, #0	; 0x0
    4218:	d1002920 	tstle	a1, a1, lsr #18
    421c:	2921e335 	stmcsdb	a2!, {a1, a3, v1, v2, v5, v6, SP, LR, PC}
    4220:	e27ad100 	rsbs	SP, v7, #0	; 0x0
    4224:	d1002922 	tstle	a1, a3, lsr #18
    4228:	2931e141 	ldmcsdb	a2!, {a1, v3, v5, SP, LR, PC}
    422c:	e1c0d100 	bic	SP, a1, a1, lsl #2
    4230:	4668e39a 	undefined
    4234:	80818869 	addhi	v5, a2, v6, ror #16
    4238:	800188a9 	andhi	v5, a2, v6, lsr #17
    423c:	5e2c2006 	cdppl	0, 2, cr2, cr12, cr6, {0}
    4240:	89294668 	stmhidb	v6!, {a4, v2, v3, v6, v7, LR}
    4244:	888080c1 	stmhiia	a1, {a1, v3, v4, PC}
    4248:	88094669 	stmhida	v6, {a1, a4, v2, v3, v6, v7, LR}
    424c:	d0104288 	andles	v1, a1, v5, lsl #5
    4250:	b4012000 	strlt	a3, [a2]
    4254:	8803a801 	stmhida	a4, {a1, v8, SP, PC}
    4258:	88812200 	stmhiia	a2, {v6, SP}
    425c:	f7ff201b 	undefined
    4260:	1c07faad 	stcne	10, cr15, [v4], {173}
    4264:	2800b001 	stmcsda	a1, {a1, IP, SP, PC}
    4268:	1c38da03 	ldcne	10, cr13, [v5], #-12
    426c:	f7feb00c 	ldrnvb	v8, [LR, IP]!
    4270:	2100f860 	tstcsp	a1, a1, ror #16
    4274:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    4278:	fd6cf7fe 	stc2l	7, cr15, [IP, #-1016]!
    427c:	81c84669 	bichi	v1, v5, v6, ror #12
    4280:	042448b5 	streqt	v1, [v1], #-2229
    4284:	42840c24 	addmi	a1, v1, #9216	; 0x2400
    4288:	aa02d00c 	bge	0xb82c0
    428c:	1c202100 	stfnes	f2, [a1]
    4290:	fae6f7fe 	blx	0xff9c2290
    4294:	46681c04 	strmibt	a2, [v5], -v1, lsl #24
    4298:	1c207a01 	stcne	10, cr7, [a1], #-4
    429c:	fb24f7fe 	blx	0x94229e
    42a0:	e0001c04 	and	a2, a1, v1, lsl #24
    42a4:	21002400 	tstcs	a1, a1, lsl #8
    42a8:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    42ac:	fd5ef7fe 	ldc2l	7, cr15, [LR, #-1016]
    42b0:	1c061c05 	stcne	12, cr1, [v3], {5}
    42b4:	d3014284 	tstle	a2, #1073741832	; 0x40000008
    42b8:	e7d72000 	ldrb	a3, [v4, a1]
    42bc:	89c04668 	stmhiib	a1, {a4, v2, v3, v6, v7, LR}^
    42c0:	4348210a 	cmpmi	v5, #-2147483646	; 0x80000002
    42c4:	46689004 	strmibt	v6, [v5], -v1
    42c8:	88894669 	stmhiia	v6, {a1, a4, v2, v3, v6, v7, LR}
    42cc:	82c11c49 	sbchi	a2, a2, #18688	; 0x4900
    42d0:	f7fe88c0 	ldrnvb	v5, [LR, a1, asr #17]!
    42d4:	2807fabf 	stmcsda	v4, {a1, a2, a3, a4, v1, v2, v4, v6, v8, IP, SP, LR, PC}
    42d8:	9804d015 	stmlsda	v1, {a1, a3, v1, IP, LR, PC}
    42dc:	6ac9499f 	bvs	0xff256960
    42e0:	21001808 	tstcs	a1, v5, lsl #16
    42e4:	a901b402 	stmgedb	a2, {a2, v7, IP, SP, PC}
    42e8:	880188cb 	stmhida	a2, {a1, a2, a4, v3, v4, v8, PC}
    42ec:	43608840 	cmnmi	a1, #4194304	; 0x400000
    42f0:	0412180a 	ldreq	a2, [a3], #-2058
    42f4:	a8010c12 	stmgeda	a2, {a2, v1, v7, v8}
    42f8:	201b8ac1 	andcss	v5, v8, a2, asr #21
    42fc:	fa5ef7ff 	blx	0x17c2300
    4300:	b0011c07 	andlt	a2, a2, v4, lsl #24
    4304:	2100e7b1 	strcsh	LR, [a1, -a2]
    4308:	88c04668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}^
    430c:	fd22f7fe 	stc2	7, cr15, [a3, #-1016]!
    4310:	85884669 	strhi	v1, [v5, #1641]
    4314:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    4318:	f7fe88c0 	ldrnvb	v5, [LR, a1, asr #17]!
    431c:	1b31fd27 	blne	0xc837c0
    4320:	d2014281 	andle	v1, a2, #268435464	; 0x10000008
    4324:	e0001b2d 	and	a2, a1, SP, lsr #22
    4328:	26001c05 	strcs	a2, [a1], -v2, lsl #24
    432c:	0c360436 	cfldrseq	mvf0, [v3], #-216
    4330:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    4334:	d29842ae 	addles	v1, v5, #-536870902	; 0xe000000a
    4338:	6ac14888 	bvs	0xff056560
    433c:	18089804 	stmneda	v5, {a3, v8, IP, PC}
    4340:	8d92466a 	ldchi	6, cr4, [a3, #424]
    4344:	435a230a 	cmpmi	v7, #671088640	; 0x28000000
    4348:	880a1889 	stmhida	v7, {a1, a4, v4, v8, IP}
    434c:	43718849 	cmnmi	a2, #4784128	; 0x490000
    4350:	04091851 	streq	a2, [v6], #-2129
    4354:	b4020c09 	strlt	a1, [a3], #-3081
    4358:	88cba901 	stmhiia	v8, {a1, v5, v8, SP, PC}^
    435c:	041b1c5b 	ldreq	a2, [v8], #-3163
    4360:	88010c1b 	stmhida	a2, {a1, a2, a4, v1, v7, v8}
    4364:	19a28840 	stmneib	a3!, {v3, v8, PC}
    4368:	180a4350 	stmneda	v7, {v1, v3, v5, v6, LR}
    436c:	0c120412 	cfldrseq	mvf0, [a3], {18}
    4370:	8ac1a801 	bhi	0xff06e37c
    4374:	f7ff201b 	undefined
    4378:	1c07fa21 	stcne	10, cr15, [v4], {33}
    437c:	2800b001 	stmcsda	a1, {a1, IP, SP, PC}
    4380:	1c76dbc0 	ldcnel	11, cr13, [v3], #-768
    4384:	4668e7d2 	undefined
    4388:	80818869 	addhi	v5, a2, v6, ror #16
    438c:	800188a9 	andhi	v5, a2, v6, lsr #17
    4390:	5e2c2006 	cdppl	0, 2, cr2, cr12, cr6, {0}
    4394:	89294668 	stmhidb	v6!, {a4, v2, v3, v6, v7, LR}
    4398:	210080c1 	smlabtcs	a1, a2, a1, v5
    439c:	f7fe8800 	ldrnvb	v5, [LR, a1, lsl #16]!
    43a0:	1c07fce5 	stcne	12, cr15, [v4], {229}
    43a4:	0424486c 	streqt	v1, [v1], #-2156
    43a8:	42840c24 	addmi	a1, v1, #9216	; 0x2400
    43ac:	aa02d00c 	bge	0xb83e4
    43b0:	1c202100 	stfnes	f2, [a1]
    43b4:	fa54f7fe 	blx	0x15423b4
    43b8:	46681c04 	strmibt	a2, [v5], -v1, lsl #24
    43bc:	1c207a01 	stcne	10, cr7, [a1], #-4
    43c0:	fa92f7fe 	blx	0xfe4c23c0
    43c4:	e0001c04 	and	a2, a1, v1, lsl #24
    43c8:	1c3d2400 	cfldrsne	mvf2, [SP]
    43cc:	88c04668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}^
    43d0:	42884961 	addmi	v1, v5, #1589248	; 0x184000
    43d4:	aa02d00c 	bge	0xb840c
    43d8:	21001c52 	tstcs	a1, a3, asr IP
    43dc:	88c04668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}^
    43e0:	fa3ef7fe 	blx	0xfc23e0
    43e4:	7a494669 	bvc	0x1255d90
    43e8:	fa7ef7fe 	blx	0x1fc23e8
    43ec:	e0021c06 	and	a2, a3, v3, lsl #24
    43f0:	04361b2e 	ldreqt	a2, [v3], #-2862
    43f4:	42a50c36 	adcmi	a1, v2, #13824	; 0x3600
    43f8:	2200d207 	andcs	SP, a1, #1879048192	; 0x70000000
    43fc:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    4400:	f7fd8880 	ldrnvb	v5, [SP, a1, lsl #17]!
    4404:	1c07fdcd 	stcne	13, cr15, [v4], {205}
    4408:	1b3de72f 	blne	0xf7e0cc
    440c:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    4410:	d20042ae 	andle	v1, a1, #-536870902	; 0xe000000a
    4414:	042a1c35 	streqt	a2, [v7], #-3125
    4418:	21000c12 	tstcs	a1, a3, lsl IP
    441c:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    4420:	fdbef7fd 	ldc2	7, cr15, [LR, #1012]!
    4424:	28001c07 	stmcsda	a1, {a1, a2, a3, v7, v8, IP}
    4428:	2100dbee 	smlattcs	a1, LR, v8, SP
    442c:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    4430:	fc90f7fe 	ldc2	7, cr15, [a1], {254}
    4434:	81c84669 	bichi	v1, v5, v6, ror #12
    4438:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    443c:	f7fe8800 	ldrnvb	v5, [LR, a1, lsl #16]!
    4440:	4669fc89 	strmibt	PC, [v6], -v6, lsl #25
    4444:	26008388 	strcs	v5, [a1], -v5, lsl #7
    4448:	0c360436 	cfldrseq	mvf0, [v3], #-216
    444c:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    4450:	d2d942ae 	sbcles	v1, v6, #-536870902	; 0xe000000a
    4454:	6ac04841 	bvs	0xff016560
    4458:	89c94669 	stmhiib	v6, {a1, a4, v2, v3, v6, v7, LR}^
    445c:	4351220a 	cmpmi	a2, #-1610612736	; 0xa0000000
    4460:	466a1841 	strmibt	a2, [v7], -a2, asr #16
    4464:	230a8b92 	tstcs	v7, #149504	; 0x24800
    4468:	1880435a 	stmneia	a1, {a2, a4, v1, v3, v5, v6, LR}
    446c:	88408802 	stmhida	a1, {a2, v8, PC}^
    4470:	435819a3 	cmpmi	v5, #2670592	; 0x28c000
    4474:	04001810 	streq	a2, [a1], #-2064
    4478:	b4010c00 	strlt	a1, [a2], #-3072
    447c:	8803a801 	stmhida	a4, {a1, v8, SP, PC}
    4480:	041b1c5b 	ldreq	a2, [v8], #-3163
    4484:	88080c1b 	stmhida	v5, {a1, a2, a4, v1, v7, v8}
    4488:	43718849 	cmnmi	a2, #4784128	; 0x490000
    448c:	04121842 	ldreq	a2, [a3], #-2114
    4490:	a8010c12 	stmgeda	a2, {a2, v1, v7, v8}
    4494:	1c498881 	mcrrne	8, 8, v5, v6, cr1
    4498:	0c090409 	cfstrseq	mvf0, [v6], {9}
    449c:	f7ff201b 	undefined
    44a0:	1c07f98d 	stcne	9, cr15, [v4], {141}
    44a4:	2800b001 	stmcsda	a1, {a1, IP, SP, PC}
    44a8:	1c76dbae 	ldcnel	11, cr13, [v3], #-696
    44ac:	4668e7cc 	strmibt	LR, [v5], -IP, asr #15
    44b0:	80818869 	addhi	v5, a2, v6, ror #16
    44b4:	800188a9 	andhi	v5, a2, v6, lsr #17
    44b8:	5e2c2006 	cdppl	0, 2, cr2, cr12, cr6, {0}
    44bc:	89294668 	stmhidb	v6!, {a4, v2, v3, v6, v7, LR}
    44c0:	210080c1 	smlabtcs	a1, a2, a1, v5
    44c4:	f7fe8800 	ldrnvb	v5, [LR, a1, lsl #16]!
    44c8:	1e47fc51 	mcrne	12, 2, PC, cr7, cr1, {2}
    44cc:	04244822 	streqt	v1, [v1], #-2082
    44d0:	42840c24 	addmi	a1, v1, #9216	; 0x2400
    44d4:	aa02d00c 	bge	0xb850c
    44d8:	1c202100 	stfnes	f2, [a1]
    44dc:	f9c0f7fe 	stmnvib	a1, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    44e0:	46681c04 	strmibt	a2, [v5], -v1, lsl #24
    44e4:	1c207a01 	stcne	10, cr7, [a1], #-4
    44e8:	f9fef7fe 	ldmnvib	LR!, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    44ec:	e0001c04 	and	a2, a1, v1, lsl #24
    44f0:	043f2400 	ldreqt	a3, [pc], #1024	; 0x44f8
    44f4:	1c3d0c3f 	ldcne	12, cr0, [SP], #-252
    44f8:	90041b38 	andls	a2, v1, v5, lsr v8
    44fc:	88c04668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}^
    4500:	42884915 	addmi	v1, v5, #344064	; 0x54000
    4504:	aa02d00c 	bge	0xb853c
    4508:	21001c52 	tstcs	a1, a3, asr IP
    450c:	88c04668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}^
    4510:	f9a6f7fe 	stmnvib	v3!, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    4514:	7a494669 	bvc	0x1255ec0
    4518:	f9e6f7fe 	stmnvib	v3!, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    451c:	e0021c06 	and	a2, a3, v3, lsl #24
    4520:	04369e04 	ldreqt	v6, [v3], #-3588
    4524:	42a50c36 	adcmi	a1, v2, #13824	; 0x3600
    4528:	2201d21a 	andcs	SP, a2, #-1610612735	; 0xa0000001
    452c:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    4530:	f7fd8880 	ldrnvb	v5, [SP, a1, lsl #17]!
    4534:	1c07fd35 	stcne	13, cr15, [v4], {53}
    4538:	db072800 	blle	0x1ce540
    453c:	21002200 	tstcs	a1, a1, lsl #4
    4540:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    4544:	f98cf7fe 	stmnvib	IP, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    4548:	70012100 	andvc	a3, a2, a1, lsl #2
    454c:	46c0e68d 	strmib	LR, [a1], SP, lsl #13
    4550:	00000100 	andeq	a1, a1, a1, lsl #2
    4554:	0000fffd 	streqd	PC, [a1], -SP
    4558:	0000ffff 	streqd	PC, [a1], -PC
    455c:	00008680 	andeq	v5, a1, a1, lsl #13
    4560:	98041b3d 	stmlsda	v1, {a1, a3, a4, v1, v2, v5, v6, v8, IP}
    4564:	d2004286 	andle	v1, a1, #1610612744	; 0x60000008
    4568:	1c6a1c35 	stcnel	12, cr1, [v7], #-212
    456c:	0c120412 	cfldrseq	mvf0, [a3], {18}
    4570:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    4574:	f7fd8880 	ldrnvb	v5, [SP, a1, lsl #17]!
    4578:	1c07fd13 	stcne	13, cr15, [v4], {19}
    457c:	db172800 	blle	0x5ce584
    4580:	21002200 	tstcs	a1, a1, lsl #4
    4584:	88804668 	stmhiia	a1, {a4, v2, v3, v6, v7, LR}
    4588:	f96af7fe 	stmnvdb	v7!, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    458c:	22009009 	andcs	v6, a1, #9	; 0x9
    4590:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    4594:	f7fe8800 	ldrnvb	v5, [LR, a1, lsl #16]!
    4598:	9006f963 	andls	PC, v3, a4, ror #18
    459c:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    45a0:	19011c2a 	stmnedb	a2, {a2, a4, v2, v7, v8, IP}
    45a4:	f0109809 	andnvs	v6, a1, v6, lsl #16
    45a8:	9809fcf7 	stmlsda	v6, {a1, a2, a3, v1, v2, v3, v4, v7, v8, IP, SP, LR, PC}
    45ac:	55412100 	strplb	a3, [a2, #-256]
    45b0:	1c28e65b 	stcne	6, cr14, [v5], #-364
    45b4:	fb28f7fc 	blx	0xa425ae
    45b8:	4669e725 	strmibt	LR, [v6], -v2, lsr #14
    45bc:	800a88aa 	andhi	v5, v7, v7, lsr #17
    45c0:	5e692102 	powple	f2, f1, f2
    45c4:	0fcb466a 	swieq	0x00cb466a
    45c8:	10491859 	subne	a2, v6, v6, asr v5
    45cc:	82901808 	addhis	a2, a1, #524288	; 0x80000
    45d0:	e0012600 	and	a3, a2, a1, lsl #12
    45d4:	1c761c7f 	ldcnel	12, cr1, [v3], #-508
    45d8:	8a804668 	bhi	0xfe015f80
    45dc:	0c360436 	cfldrseq	mvf0, [v3], #-216
    45e0:	d2114286 	andles	v1, a2, #1610612744	; 0x60000008
    45e4:	00714668 	rsbeqs	v1, a2, v5, ror #12
    45e8:	88ca1869 	stmhiia	v7, {a1, a4, v2, v3, v8, IP}^
    45ec:	88418042 	stmhida	a2, {a2, v3, PC}^
    45f0:	f7fe8800 	ldrnvb	v5, [LR, a1, lsl #16]!
    45f4:	2800fa0d 	stmcsda	a1, {a1, a3, a4, v6, v8, IP, SP, LR, PC}
    45f8:	2100d0ec 	smlattcs	a1, IP, a1, SP
    45fc:	88404668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}^
    4600:	fbb4f7fe 	blx	0xfed42602
    4604:	e7e6183f 	undefined
    4608:	0c12043a 	cfldrseq	mvf0, [a3], {58}
    460c:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    4610:	f7fd8800 	ldrnvb	v5, [SP, a1, lsl #16]!
    4614:	1c07fcc5 	stcne	12, cr15, [v4], {197}
    4618:	dbc92800 	blle	0xff24e620
    461c:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    4620:	f7fe8800 	ldrnvb	v5, [LR, a1, lsl #16]!
    4624:	4669fb97 	undefined
    4628:	46688388 	strmibt	v5, [v5], -v5, lsl #7
    462c:	81412100 	cmphi	a2, a1, lsl #2
    4630:	e01e2600 	ands	a3, LR, a1, lsl #12
    4634:	49ce9804 	stmmiib	LR, {a3, v8, IP, PC}^
    4638:	18086ac9 	stmneda	v5, {a1, a4, v3, v4, v6, v8, SP, LR}
    463c:	b4022100 	strlt	a3, [a3], #-256
    4640:	884ba901 	stmhida	v8, {a1, v5, v8, SP, PC}^
    4644:	88408801 	stmhida	a1, {a1, v8, PC}^
    4648:	8952aa01 	ldmhidb	a3, {a1, v6, v8, SP, PC}^
    464c:	180a4350 	stmneda	v7, {v1, v3, v5, v6, LR}
    4650:	0c120412 	cfldrseq	mvf0, [a3], {18}
    4654:	89c1a801 	stmhiib	a2, {a1, v8, SP, PC}^
    4658:	f7ff201b 	undefined
    465c:	1c07f8af 	stcne	8, cr15, [v4], {175}
    4660:	2800b001 	stmcsda	a1, {a1, IP, SP, PC}
    4664:	4668dba4 	strmibt	SP, [v5], -v1, lsr #23
    4668:	89494669 	stmhidb	v6, {a1, a4, v2, v3, v6, v7, LR}^
    466c:	81411c49 	cmphi	a2, v6, asr #24
    4670:	46681c76 	undefined
    4674:	04368a80 	ldreqt	v5, [v3], #-2688
    4678:	42860c36 	addmi	a1, v3, #13824	; 0x3600
    467c:	4668d298 	undefined
    4680:	18690071 	stmneda	v6!, {a1, v1, v2, v3}^
    4684:	804288ca 	subhi	v5, a3, v7, asr #17
    4688:	210a8b80 	smlabbcs	v7, a1, v8, v5
    468c:	90044348 	andls	v1, v1, v5, asr #6
    4690:	46694668 	strmibt	v1, [v6], -v5, ror #12
    4694:	1c498809 	mcrrne	8, 0, v5, v6, cr9
    4698:	884181c1 	stmhida	a2, {a1, v3, v4, v5, PC}^
    469c:	f7fe8800 	ldrnvb	v5, [LR, a1, lsl #16]!
    46a0:	2800f9b7 	stmcsda	a1, {a1, a2, a3, v1, v2, v4, v5, v8, IP, SP, LR, PC}
    46a4:	2100d0c6 	smlabtcs	a1, v3, a1, SP
    46a8:	88404668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}^
    46ac:	fb52f7fe 	blx	0x14c26ae
    46b0:	82c84669 	sbchi	v1, v5, #110100480	; 0x6900000
    46b4:	48ae2400 	stmmiia	LR!, {v7, SP}
    46b8:	46696ac0 	strmibt	v3, [v6], -a1, asr #21
    46bc:	220a8ac9 	andcs	v5, v7, #823296	; 0xc9000
    46c0:	18414351 	stmneda	a2, {a1, v1, v3, v5, v6, LR}^
    46c4:	0424888a 	streqt	v5, [v1], #-2186
    46c8:	42940c24 	addmis	a1, v1, #9216	; 0x2400
    46cc:	9a04d2d0 	bls	0x139214
    46d0:	880a1880 	stmhida	v7, {v4, v8, IP}
    46d4:	43618849 	cmnmi	a2, #4784128	; 0x490000
    46d8:	04091851 	streq	a2, [v6], #-2129
    46dc:	b4020c09 	strlt	a1, [a3], #-3081
    46e0:	884ba901 	stmhida	v8, {a1, v5, v8, SP, PC}^
    46e4:	041b1c5b 	ldreq	a2, [v8], #-3163
    46e8:	88010c1b 	stmhida	a2, {a1, a2, a4, v1, v7, v8}
    46ec:	aa018840 	bge	0x667f4
    46f0:	43508952 	cmpmi	a1, #1343488	; 0x148000
    46f4:	0412180a 	ldreq	a2, [a3], #-2058
    46f8:	a8010c12 	stmgeda	a2, {a2, v1, v7, v8}
    46fc:	201b89c1 	andcss	v5, v8, a2, asr #19
    4700:	f85cf7ff 	ldmnvda	IP, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    4704:	b0011c07 	andlt	a2, a2, v4, lsl #24
    4708:	db3b2800 	blle	0xece710
    470c:	46694668 	strmibt	v1, [v6], -v5, ror #12
    4710:	1c498949 	mcrrne	9, 4, v5, v6, cr9
    4714:	1c648141 	stfnep	f0, [v1], #-260
    4718:	4669e7cd 	strmibt	LR, [v6], -SP, asr #15
    471c:	800a88aa 	andhi	v5, v7, v7, lsr #17
    4720:	5e692102 	powple	f2, f1, f2
    4724:	0fcb466a 	swieq	0x00cb466a
    4728:	10491859 	subne	a2, v6, v6, asr v5
    472c:	82901808 	addhis	a2, a1, #524288	; 0x80000
    4730:	e0072600 	and	a3, v4, a1, lsl #12
    4734:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    4738:	f7fe8840 	ldrnvb	v5, [LR, a1, asr #16]!
    473c:	1e40fb17 	mcrne	11, 2, PC, cr0, cr7, {0}
    4740:	1c76183f 	ldcnel	8, cr1, [v3], #-252
    4744:	8a804668 	bhi	0xfe0160ec
    4748:	0c360436 	cfldrseq	mvf0, [v3], #-216
    474c:	d20f4286 	andle	v1, PC, #1610612744	; 0x60000008
    4750:	00714668 	rsbeqs	v1, a2, v5, ror #12
    4754:	88ca1869 	stmhiia	v7, {a1, a4, v2, v3, v8, IP}^
    4758:	88408042 	stmhida	a1, {a2, v3, PC}^
    475c:	04001c40 	streq	a2, [a1], #-3136
    4760:	f7fe0c00 	ldrnvb	a1, [LR, a1, lsl #24]!
    4764:	2801f877 	stmcsda	a2, {a1, a2, a3, v1, v2, v3, v8, IP, SP, LR, PC}
    4768:	2000d0e4 	andcs	SP, a1, v1, ror #1
    476c:	e57d43c0 	ldrb	v1, [SP, #-960]!
    4770:	043a1c7f 	ldreqt	a2, [v7], #-3199
    4774:	21000c12 	tstcs	a1, a3, lsl IP
    4778:	88004668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}
    477c:	fc10f7fd 	ldc2	7, cr15, [a1], {253}
    4780:	28001c07 	stmcsda	a1, {a1, a2, a3, v7, v8, IP}
    4784:	e570da00 	ldrb	SP, [a1, #-2560]!
    4788:	21004668 	tstcs	a1, v5, ror #12
    478c:	22008141 	andcs	v5, a1, #1073741840	; 0x40000010
    4790:	f7fe8800 	ldrnvb	v5, [LR, a1, lsl #16]!
    4794:	9006f865 	andls	PC, v3, v2, ror #16
    4798:	e0202600 	eor	a3, a1, a1, lsl #12
    479c:	00714668 	rsbeqs	v1, a2, v5, ror #12
    47a0:	88ca1869 	stmhiia	v7, {a1, a4, v2, v3, v8, IP}^
    47a4:	22008042 	andcs	v5, a1, #66	; 0x42
    47a8:	88402100 	stmhida	a1, {v5, SP}^
    47ac:	f858f7fe 	ldmnvda	v5, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    47b0:	21001c04 	tstcs	a1, v1, lsl #24
    47b4:	88404668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}^
    47b8:	fad8f7fe 	blx	0xff6427b8
    47bc:	1e404669 	cdpne	6, 4, cr4, cr0, cr9, {3}
    47c0:	46688048 	strmibt	v5, [v5], -v5, asr #32
    47c4:	1c218842 	stcne	8, cr8, [a2], #-264
    47c8:	f0109804 	andnvs	v6, a1, v1, lsl #16
    47cc:	4668fbe5 	strmibt	PC, [v5], -v2, ror #23
    47d0:	89494669 	stmhidb	v6, {a1, a4, v2, v3, v6, v7, LR}^
    47d4:	8852466a 	ldmhida	a3, {a2, a4, v2, v3, v6, v7, LR}^
    47d8:	81411889 	smlalbbhi	a2, a2, v6, v5
    47dc:	46681c76 	undefined
    47e0:	99068940 	stmlsdb	v3, {v3, v5, v8, PC}
    47e4:	90041808 	andls	a2, v1, v5, lsl #16
    47e8:	8a804668 	bhi	0xfe016190
    47ec:	0c360436 	cfldrseq	mvf0, [v3], #-216
    47f0:	d3d34286 	bicles	v1, a4, #1610612744	; 0x60000008
    47f4:	e6a79804 	strt	v6, [v4], v1, lsl #16
    47f8:	88694668 	stmhida	v6!, {a4, v2, v3, v6, v7, LR}^
    47fc:	88a98081 	stmhiia	v6!, {a1, v4, PC}
    4800:	20068001 	andcs	v5, v3, a2
    4804:	46685e2c 	strmibt	v2, [v5], -IP, lsr #28
    4808:	80c18929 	sbchi	v5, a2, v6, lsr #18
    480c:	04202100 	streqt	a3, [a1], #-256
    4810:	f7fe0c00 	ldrnvb	a1, [LR, a1, lsl #24]!
    4814:	4669faab 	strmibt	PC, [v6], -v8, lsr #21
    4818:	46688048 	strmibt	v5, [v5], -v5, asr #32
    481c:	1e6d8845 	cdpne	8, 6, cr8, cr13, cr5, {2}
    4820:	88c02100 	stmhiia	a1, {v5, SP}^
    4824:	f936f7fe 	ldmnvdb	v3!, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    4828:	0c2d042d 	cfstrseq	mvf0, [SP], #-180
    482c:	d11e4285 	tstle	LR, v2, lsl #5
    4830:	b4012000 	strlt	a3, [a2]
    4834:	88c3a801 	stmhiia	a4, {a1, v8, SP, PC}^
    4838:	88812200 	stmhiia	a2, {v6, SP}
    483c:	f7fe201b 	undefined
    4840:	1c07ffbd 	stcne	15, cr15, [v4], {189}
    4844:	2800b001 	stmcsda	a1, {a1, IP, SP, PC}
    4848:	2200db1e 	andcs	SP, a1, #30720	; 0x7800
    484c:	04202100 	streqt	a3, [a1], #-256
    4850:	f7fe0c00 	ldrnvb	a1, [LR, a1, lsl #24]!
    4854:	1c04f805 	stcne	8, cr15, [v1], {5}
    4858:	21004668 	tstcs	a1, v5, ror #12
    485c:	23008441 	tstcs	a1, #1090519040	; 0x41000000
    4860:	a9088882 	stmgedb	v5, {a2, v4, v8, PC}
    4864:	1c201c89 	stcne	12, cr1, [a1], #-548
    4868:	f9ecf7fe 	stmnvib	IP!, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    486c:	aa03e5cb 	bge	0xfdfa0
    4870:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    4874:	f7fd8800 	ldrnvb	v5, [SP, a1, lsl #16]!
    4878:	9006fff3 	strlsd	PC, [v3], -a4
    487c:	46682201 	strmibt	a3, [v5], -a2, lsl #4
    4880:	98067b01 	stmlsda	v3, {a1, v5, v6, v8, IP, SP, LR}
    4884:	f81ef7fe 	ldmnvda	LR, {a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    4888:	4668e4ef 	strmibt	LR, [v5], -PC, ror #9
    488c:	800188a9 	andhi	v5, a2, v6, lsr #17
    4890:	5e2c2006 	cdppl	0, 2, cr2, cr12, cr6, {0}
    4894:	89294668 	stmhidb	v6!, {a4, v2, v3, v6, v7, LR}
    4898:	896980c1 	stmhidb	v6!, {a1, v3, v4, PC}^
    489c:	aa038401 	bge	0xe58a8
    48a0:	21001c52 	tstcs	a1, a3, asr IP
    48a4:	5e282002 	cdppl	0, 2, cr2, cr8, cr2, {0}
    48a8:	0c000400 	cfstrseq	mvf0, [a1], {0}
    48ac:	ffd8f7fd 	swinv	0x00d8f7fd
    48b0:	aa039009 	bge	0xe88dc
    48b4:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    48b8:	f7fd8800 	ldrnvb	v5, [SP, a1, lsl #16]!
    48bc:	9006ffd1 	ldrlsd	PC, [v3], -a2
    48c0:	2100aa02 	tstcs	a1, a3, lsl #20
    48c4:	0c000420 	cfstrseq	mvf0, [a1], {32}
    48c8:	ffcaf7fd 	swinv	0x00caf7fd
    48cc:	46681c04 	strmibt	a2, [v5], -v1, lsl #24
    48d0:	492888c0 	stmmidb	v5!, {v3, v4, v8, PC}
    48d4:	d00c4288 	andle	v1, IP, v5, lsl #5
    48d8:	1c52aa02 	mrrcne	10, 0, v7, a3, cr2
    48dc:	46682100 	strmibt	a3, [v5], -a1, lsl #2
    48e0:	f7fd88c0 	ldrnvb	v5, [SP, a1, asr #17]!
    48e4:	4669ffbd 	undefined
    48e8:	f7fd7a49 	ldrnvb	v4, [SP, v6, asr #20]!
    48ec:	1c06fffd 	stcne	15, cr15, [v3], {253}
    48f0:	2600e000 	strcs	LR, [a1], -a1
    48f4:	8c004668 	stchi	6, cr4, [a1], {104}
    48f8:	4288491e 	addmi	v1, v5, #491520	; 0x78000
    48fc:	aa07d00c 	bge	0x1f8934
    4900:	21001c92 	strcsb	a2, [a1, -a3]
    4904:	8c004668 	stchi	6, cr4, [a1], {104}
    4908:	ffaaf7fd 	swinv	0x00aaf7fd
    490c:	7f894669 	swivc	0x00894669
    4910:	ffeaf7fd 	swinv	0x00eaf7fd
    4914:	e0001c05 	and	a2, a1, v2, lsl #24
    4918:	aa0a2500 	bge	0x28dd20
    491c:	19a04916 	stmneib	a1!, {a2, a3, v1, v5, v8, LR}
    4920:	fbd8f010 	blx	0xff64096a
    4924:	d1152801 	tstle	v2, a2, lsl #16
    4928:	1c76e000 	ldcnel	0, cr14, [v3]
    492c:	0c360436 	cfldrseq	mvf0, [v3], #-216
    4930:	780119a0 	stmvcda	a2, {v2, v4, v5, v8, IP}
    4934:	d3f82930 	mvnles	a3, #786432	; 0xc0000
    4938:	283a7800 	ldmcsda	v7!, {v8, IP, SP, LR}
    493c:	0436d2f5 	ldreqt	SP, [v3], #-757
    4940:	19a00c36 	stmneib	a1!, {a2, a3, v1, v2, v7, v8}
    4944:	29307801 	ldmcsdb	a1!, {a1, v8, IP, SP, LR}
    4948:	7800d306 	stmvcda	a1, {a2, a3, v5, v6, IP, LR, PC}
    494c:	d203283a 	andle	a3, a4, #3801088	; 0x3a0000
    4950:	e7f41c76 	undefined
    4954:	2600950a 	strcs	v6, [a1], -v7, lsl #10
    4958:	46689a0a 	strmibt	v6, [v5], -v7, lsl #20
    495c:	98097b41 	stmlsda	v6, {a1, v3, v5, v6, v8, IP, SP, LR}
    4960:	ffb0f7fd 	swinv	0x00b0f7fd
    4964:	e78a1c32 	undefined
    4968:	43ff2701 	mvnmis	a3, #262144	; 0x40000
    496c:	0000e47d 	andeq	LR, a1, SP, ror v1
    4970:	00008680 	andeq	v5, a1, a1, lsl #13
    4974:	0000ffff 	streqd	PC, [a1], -PC
    4978:	0011b3dc 	ldreqsb	v8, [a2], -IP
    497c:	2804b510 	stmcsda	v1, {v1, v5, v7, IP, SP, PC}
    4980:	2020d302 	eorcs	SP, a1, a3, lsl #6
    4984:	e01f43c0 	ands	v1, PC, a1, asr #7
    4988:	43432314 	cmpmi	a4, #1342177280	; 0x50000000
    498c:	690a49a9 	stmvsdb	v7, {a1, a4, v2, v4, v5, v8, LR}
    4990:	6a646854 	bvs	0x191eae8
    4994:	7a2418e4 	bvc	0x90ad2c
    4998:	d0052c0b 	andle	a3, v2, v8, lsl #24
    499c:	6a646854 	bvs	0x191eaf4
    49a0:	7a2418e4 	bvc	0x90ad38
    49a4:	d1052c0a 	tstle	v2, v7, lsl #24
    49a8:	6a646854 	bvs	0x191eb00
    49ac:	7c1b18e3 	ldcvc	8, cr1, [v8], {227}
    49b0:	d0012b00 	andle	a3, a2, a1, lsl #22
    49b4:	e7e5201f 	undefined
    49b8:	69522308 	ldmvsdb	a3, {a4, v5, v6, SP}^
    49bc:	18106a52 	ldmneda	a1, {a2, v1, v3, v6, v8, SP, LR}
    49c0:	7800309c 	stmvcda	a1, {a3, a4, v1, v4, IP, SP}
    49c4:	56c01808 	strplb	a2, [a1], v5, lsl #16
    49c8:	0000e2bd 	streqh	LR, [a1], -SP
    49cc:	28041c01 	stmcsda	v1, {a1, v7, v8, IP}
    49d0:	2000d301 	andcs	SP, a1, a2, lsl #6
    49d4:	2013e019 	andcss	LR, a4, v6, lsl a1
    49d8:	48964341 	ldmmiia	v3, {a1, v3, v5, v6, LR}
    49dc:	69506902 	ldmvsdb	a1, {a2, v5, v8, SP, LR}^
    49e0:	18406a40 	stmneda	a1, {v3, v6, v8, SP, LR}^
    49e4:	69537c00 	ldmvsdb	a4, {v7, v8, IP, SP, LR}^
    49e8:	185b6a5b 	ldmneda	v8, {a1, a2, a4, v1, v3, v6, v8, SP, LR}^
    49ec:	1ac07c5b 	bne	0xff023b60
    49f0:	6950d509 	ldmvsdb	a1, {a1, a4, v5, v7, IP, LR, PC}^
    49f4:	18406a40 	stmneda	a1, {v3, v6, v8, SP, LR}^
    49f8:	30107c00 	andccs	v4, a1, a1, lsl #24
    49fc:	6a526952 	bvs	0x149ef4c
    4a00:	7c491851 	mcrrvc	8, 5, a2, v6, cr1
    4a04:	06001a40 	streq	a2, [a1], -a1, asr #20
    4a08:	b0000e00 	andlt	a1, a1, a1, lsl #28
    4a0c:	00004770 	andeq	v1, a1, a1, ror v4
    4a10:	4668b5f9 	undefined
    4a14:	28047800 	stmcsda	v1, {v8, IP, SP, LR}
    4a18:	2020d301 	eorcs	SP, a1, a2, lsl #6
    4a1c:	2911e06b 	ldmcsdb	a2, {a1, a2, a4, v2, v3, SP, LR, PC}
    4a20:	4668d203 	strmibt	SP, [v5], -a4, lsl #4
    4a24:	28117900 	ldmcsda	a2, {v5, v8, IP, SP, LR}
    4a28:	2012d301 	andcss	SP, a3, a2, lsl #6
    4a2c:	4668e063 	strmibt	LR, [v5], -a4, rrx
    4a30:	25147803 	ldrcs	v4, [v1, #-2051]
    4a34:	4c7f435d 	ldcmil	3, cr4, [PC], #-372
    4a38:	68466920 	stmvsda	v3, {v2, v5, v8, SP, LR}^
    4a3c:	19766a76 	ldmnedb	v3!, {a2, a3, v1, v2, v3, v6, v8, SP, LR}^
    4a40:	2e0b7a36 	mcrcs	10, 0, v4, cr11, cr6, {1}
    4a44:	6846d005 	stmvsda	v3, {a1, a3, IP, LR, PC}^
    4a48:	19766a76 	ldmnedb	v3!, {a2, a3, v1, v2, v3, v6, v8, SP, LR}^
    4a4c:	2e0a7a36 	mcrcs	10, 0, v4, cr10, cr6, {1}
    4a50:	6846d10c 	stmvsda	v3, {a3, a4, v5, IP, LR, PC}^
    4a54:	19756a76 	ldmnedb	v2!, {a2, a3, v1, v2, v3, v6, v8, SP, LR}^
    4a58:	2d007c2d 	stccs	12, cr7, [a1, #-180]
    4a5c:	6945d106 	stmvsdb	v2, {a2, a3, v5, IP, LR, PC}^
    4a60:	18ed6a6d 	stmneia	SP!, {a1, a3, a4, v2, v3, v6, v8, SP, LR}^
    4a64:	782d359c 	stmvcda	SP!, {a3, a4, v1, v4, v5, v7, IP, SP}
    4a68:	d0062d00 	andle	a3, v3, a1, lsl #26
    4a6c:	6a6d6945 	bvs	0x1b5ef88
    4a70:	359c18ed 	ldrcc	a2, [IP, #2285]
    4a74:	2d04782d 	stccs	8, cr7, [v1, #-180]
    4a78:	2513d13c 	ldrcs	SP, [a4, #-316]
    4a7c:	6946435d 	stmvsdb	v3, {a1, a3, a4, v1, v3, v5, v6, LR}^
    4a80:	19766a76 	ldmnedb	v3!, {a2, a3, v1, v2, v3, v6, v8, SP, LR}^
    4a84:	2700365c 	smlsdcs	a1, IP, v3, a4
    4a88:	69407037 	stmvsdb	a1, {a1, a2, a3, v1, v2, IP, SP, LR}^
    4a8c:	19406a40 	stmnedb	a1, {v3, v6, v8, SP, LR}^
    4a90:	7007305d 	andvc	a4, v4, SP, asr a1
    4a94:	78004668 	stmvcda	a1, {a4, v2, v3, v6, v7, LR}
    4a98:	43702613 	cmnmi	a1, #19922944	; 0x1300000
    4a9c:	69364e65 	ldmvsdb	v3!, {a1, a3, v2, v3, v6, v7, v8, LR}
    4aa0:	6a766976 	bvs	0x1d9f080
    4aa4:	364c1836 	undefined
    4aa8:	d0031c08 	andle	a2, a4, v5, lsl #24
    4aac:	5c171e40 	ldcpl	14, cr1, [v4], {64}
    4ab0:	d1fb5437 	mvnles	v2, v4, lsr v1
    4ab4:	69426920 	stmvsdb	a3, {v2, v5, v8, SP, LR}^
    4ab8:	19526a52 	ldmnedb	a3, {a2, v1, v3, v6, v8, SP, LR}^
    4abc:	7011325c 	andvcs	a4, a2, IP, asr a3
    4ac0:	6a496941 	bvs	0x125efcc
    4ac4:	466a1949 	strmibt	a2, [v7], -v6, asr #18
    4ac8:	748a7912 	strvc	v4, [v7], #2322
    4acc:	6a496941 	bvs	0x125efd8
    4ad0:	319c18c9 	orrccs	a2, IP, v6, asr #17
    4ad4:	700a2201 	andvc	a3, v7, a2, lsl #4
    4ad8:	6a496941 	bvs	0x125efe4
    4adc:	694031a4 	stmvsdb	a1, {a3, v2, v4, v5, IP, SP}^
    4ae0:	30a46a40 	adccc	v3, v1, a1, asr #20
    4ae4:	466b7800 	strmibt	v4, [v8], -a1, lsl #16
    4ae8:	409a781b 	addmis	v4, v7, v8, lsl v5
    4aec:	700a4302 	andvc	v1, v7, a3, lsl #6
    4af0:	e0012000 	and	a3, a2, a1
    4af4:	43c0201f 	bicmi	a3, a1, #31	; 0x1f
    4af8:	fa9af7fd 	blx	0xfe6c2af4
    4afc:	1c05b5f0 	cfstr32ne	mvfx11, [v2], {240}
    4b00:	1c141c0e 	ldcne	12, cr1, [v1], {14}
    4b04:	d3022804 	tstle	a3, #262144	; 0x40000
    4b08:	43c02020 	bicmi	a3, a1, #32	; 0x20
    4b0c:	2e11e061 	cdpcs	0, 1, cr14, cr1, cr1, {3}
    4b10:	2012d301 	andcss	SP, a3, a2, lsl #6
    4b14:	f7ffe7f9 	undefined
    4b18:	42b0ff59 	adcmis	PC, a1, #356	; 0x164
    4b1c:	201fd202 	andcss	SP, PC, a3, lsl #4
    4b20:	e05643c0 	subs	v1, v3, a1, asr #7
    4b24:	43692113 	cmnmi	v6, #-1073741820	; 0xc0000004
    4b28:	69004842 	stmvsdb	a1, {a2, v3, v8, LR}
    4b2c:	6a526942 	bvs	0x149f03c
    4b30:	7c521852 	mrrcvc	8, 5, a2, a3, cr2
    4b34:	04121992 	ldreq	a2, [a3], #-2450
    4b38:	2a100c12 	bcs	0x407b88
    4b3c:	2210d325 	andcss	SP, a1, #-1811939328	; 0x94000000
    4b40:	6a406940 	bvs	0x101f048
    4b44:	7c401840 	mcrrvc	8, 4, a2, a1, cr0
    4b48:	06121a12 	undefined
    4b4c:	20130e12 	andcss	a1, a4, a3, lsl LR
    4b50:	4b384368 	blmi	0xe158f8
    4b54:	695b691b 	ldmvsdb	v8, {a1, a2, a4, v1, v5, v8, SP, LR}^
    4b58:	18186a5b 	ldmneda	v5, {a1, a2, a4, v1, v3, v6, v8, SP, LR}
    4b5c:	23137c40 	tstcs	a4, #16384	; 0x4000
    4b60:	4f34436b 	swimi	0x0034436b
    4b64:	697f693f 	ldmvsdb	PC!, {a1, a2, a3, a4, v1, v2, v5, v8, SP, LR}^
    4b68:	18fb6a7f 	ldmneia	v8!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}^
    4b6c:	1c10181b 	ldcne	8, cr1, [a1], {27}
    4b70:	1e40d003 	cdpne	0, 4, cr13, cr0, cr3, {0}
    4b74:	54275c1f 	strplt	v2, [v4], #-3103
    4b78:	482ed1fb 	stmmida	LR!, {a1, a2, a4, v1, v2, v3, v4, v5, IP, LR, PC}
    4b7c:	69406900 	stmvsdb	a1, {v5, v8, SP, LR}^
    4b80:	18406a40 	stmneda	a1, {v3, v6, v8, SP, LR}^
    4b84:	74432300 	strvcb	a3, [a4], #-768
    4b88:	06361ab6 	undefined
    4b8c:	20130e36 	andcss	a1, a4, v3, lsr LR
    4b90:	4a284368 	bmi	0xa15938
    4b94:	69526912 	ldmvsdb	a3, {a2, v1, v5, v8, SP, LR}^
    4b98:	18106a52 	ldmneda	a1, {a2, v1, v3, v6, v8, SP, LR}
    4b9c:	22137c40 	andcss	v4, a4, #16384	; 0x4000
    4ba0:	4a244355 	bmi	0x9158fc
    4ba4:	69526912 	ldmvsdb	a3, {a2, v1, v5, v8, SP, LR}^
    4ba8:	19526a52 	ldmnedb	a3, {a2, v1, v3, v6, v8, SP, LR}^
    4bac:	1c301812 	ldcne	8, cr1, [a1], #-72
    4bb0:	1e40d003 	cdpne	0, 4, cr13, cr0, cr3, {0}
    4bb4:	54235c13 	strplt	v2, [a4], #-3091
    4bb8:	481ed1fb 	ldmmida	LR, {a1, a2, a4, v1, v2, v3, v4, v5, IP, LR, PC}
    4bbc:	69506902 	ldmvsdb	a1, {a2, v5, v8, SP, LR}^
    4bc0:	18406a40 	stmneda	a1, {v3, v6, v8, SP, LR}^
    4bc4:	6a526952 	bvs	0x149f114
    4bc8:	7c491851 	mcrrvc	8, 5, a2, v6, cr1
    4bcc:	74411989 	strvcb	a2, [a2], #-2441
    4bd0:	f7fd2000 	ldrnvb	a3, [SP, a1]!
    4bd4:	0000fbae 	andeq	PC, a1, LR, lsr #23
    4bd8:	1c04b570 	cfstr32ne	mvfx11, [v1], {112}
    4bdc:	88006880 	stmhida	a1, {v4, v8, SP, LR}
    4be0:	fee2f7fd 	mcr2	7, 7, PC, cr2, cr13, {7}
    4be4:	68e360a0 	stmvsia	a4!, {v2, v4, SP, LR}^
    4be8:	1c012200 	sfmne	f2, 4, [a2], {0}
    4bec:	4d112080 	ldcmi	0, cr2, [a2, #-512]
    4bf0:	692d692d 	stmvsdb	SP!, {a1, a3, a4, v2, v5, v8, SP, LR}
    4bf4:	682d6a6d 	stmvsda	SP!, {a1, a3, a4, v2, v3, v6, v8, SP, LR}
    4bf8:	fb00f012 	blx	0x40c4a
    4bfc:	020921ff 	andeq	a3, v6, #-1073741761	; 0xc000003f
    4c00:	d1164208 	tstle	v3, v5, lsl #4
    4c04:	0e120602 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    4c08:	435a2315 	cmpmi	v7, #1409286144	; 0x54000000
    4c0c:	189a4b82 	ldmneia	v7, {a2, v4, v5, v6, v8, LR}
    4c10:	2372324a 	cmncs	a3, #-1610612732	; 0xa0000004
    4c14:	68a27013 	stmvsia	a3!, {a1, a2, v1, IP, SP, LR}
    4c18:	0e1b0603 	cfmsub32eq	mvax0, mvfx0, mvfx11, mvfx3
    4c1c:	436b2515 	cmnmi	v8, #88080384	; 0x5400000
    4c20:	18eb4d7d 	stmneia	v8!, {a1, a3, a4, v1, v2, v3, v5, v7, v8, LR}^
    4c24:	2500334b 	strcs	a4, [a1, #-843]
    4c28:	555e5d56 	ldrplb	v2, [LR, #-3414]
    4c2c:	2e001c6d 	cdpcs	12, 0, cr1, cr0, cr13, {3}
    4c30:	e03bd1fa 	ldrsh	SP, [v8], -v7
    4c34:	0000015c 	andeq	a1, a1, IP, asr a2
    4c38:	1c04b570 	cfstr32ne	mvfx11, [v1], {112}
    4c3c:	88006880 	stmhida	a1, {v4, v8, SP, LR}
    4c40:	feb2f7fd 	mrc2	7, 5, PC, cr2, cr13, {7}
    4c44:	68e360a0 	stmvsia	a4!, {v2, v4, SP, LR}^
    4c48:	1c012200 	sfmne	f2, 4, [a2], {0}
    4c4c:	e00b208b 	and	a3, v8, v8, lsl #1
    4c50:	1c04b570 	cfstr32ne	mvfx11, [v1], {112}
    4c54:	88006880 	stmhida	a1, {v4, v8, SP, LR}
    4c58:	fea6f7fd 	mcr2	7, 5, PC, cr6, cr13, {7}
    4c5c:	68e360a0 	stmvsia	a4!, {v2, v4, SP, LR}^
    4c60:	1c012200 	sfmne	f2, 4, [a2], {0}
    4c64:	46c0208c 	strmib	a3, [a1], IP, lsl #1
    4c68:	692d4dbf 	stmvsdb	SP!, {a1, a2, a3, a4, v1, v2, v4, v5, v7, v8, LR}
    4c6c:	6a6d692d 	bvs	0x1b5f128
    4c70:	f012682d 	andnvs	v3, a3, SP, lsr #16
    4c74:	21fffac3 	mvncss	PC, a4, asr #21
    4c78:	42080209 	andmi	a1, v5, #-1879048192	; 0x90000000
    4c7c:	0602d116 	undefined
    4c80:	23150e12 	tstcs	v2, #288	; 0x120
    4c84:	4b64435a 	blmi	0x19159f4
    4c88:	324a189a 	subcc	a2, v7, #10092544	; 0x9a0000
    4c8c:	70132377 	andvcs	a3, a4, v4, ror a4
    4c90:	060368a2 	streq	v3, [a4], -a3, lsr #17
    4c94:	25150e1b 	ldrcs	a1, [v2, #-3611]
    4c98:	4d5f436b 	ldcmil	3, cr4, [PC, #-428]
    4c9c:	334b18eb 	cmpcc	v8, #15400960	; 0xeb0000
    4ca0:	5d562500 	cfldr64pl	mvdx2, [v3]
    4ca4:	1c6d555e 	cfstr64ne	mvdx5, [SP], #-376
    4ca8:	d1fa2e00 	mvnles	a3, a1, lsl #28
    4cac:	40016822 	andmi	v3, a2, a3, lsr #16
    4cb0:	68618011 	stmvsda	a2!, {a1, v1, PC}^
    4cb4:	20007008 	andcs	v4, a1, v5
    4cb8:	bc02bc70 	stclt	12, cr11, [a3], {112}
    4cbc:	00004708 	andeq	v1, a1, v5, lsl #14
    4cc0:	1c04b570 	cfstr32ne	mvfx11, [v1], {112}
    4cc4:	88066880 	stmhida	v3, {v4, v8, SP, LR}
    4cc8:	680168e0 	stmvsda	a2, {v2, v3, v4, v8, SP, LR}
    4ccc:	04091c49 	streq	a2, [v6], #-3145
    4cd0:	1c300c09 	ldcne	12, cr0, [a1], #-36
    4cd4:	f9b0f7fd 	ldmnvib	a1!, {a1, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}
    4cd8:	28001c05 	stmcsda	a1, {a1, a3, v7, v8, IP}
    4cdc:	1c30db1b 	ldcne	11, cr13, [a1], #-108
    4ce0:	fe62f7fd 	mcr2	7, 3, PC, cr2, cr13, {7}
    4ce4:	68e360a0 	stmvsia	a4!, {v2, v4, SP, LR}^
    4ce8:	68611c02 	stmvsda	a2!, {a2, v7, v8, IP}^
    4cec:	4e9e2082 	cdpmi	0, 9, cr2, cr14, cr2, {4}
    4cf0:	69366936 	ldmvsdb	v3!, {a2, a3, v1, v2, v5, v8, SP, LR}
    4cf4:	68366a76 	ldmvsda	v3!, {a2, a3, v1, v2, v3, v6, v8, SP, LR}
    4cf8:	fa7ef012 	blx	0x1fc0d48
    4cfc:	680968e1 	stmvsda	v6, {a1, v2, v3, v4, v8, SP, LR}
    4d00:	230068a2 	tstcs	a1, #10616832	; 0xa20000
    4d04:	68215453 	stmvsda	a2!, {a1, a2, v1, v3, v7, IP, LR}
    4d08:	021222ff 	andeqs	a3, a3, #-268435441	; 0xf000000f
    4d0c:	800a4002 	andhi	v1, v7, a3
    4d10:	70086861 	andvc	v3, v5, a2, ror #16
    4d14:	e7cf1c28 	strb	a2, [PC, v5, lsr #24]
    4d18:	1c04b530 	cfstr32ne	mvfx11, [v1], {48}
    4d1c:	88006880 	stmhida	a1, {v4, v8, SP, LR}
    4d20:	fe42f7fd 	mcr2	7, 2, PC, cr2, cr13, {7}
    4d24:	68e360a0 	stmvsia	a4!, {v2, v4, SP, LR}^
    4d28:	68611c02 	stmvsda	a2!, {a2, v7, v8, IP}^
    4d2c:	4d8e2083 	stcmi	0, cr2, [LR, #524]
    4d30:	692d692d 	stmvsdb	SP!, {a1, a3, a4, v2, v5, v8, SP, LR}
    4d34:	682d6a6d 	stmvsda	SP!, {a1, a3, a4, v2, v3, v6, v8, SP, LR}
    4d38:	fa60f012 	blx	0x1840d88
    4d3c:	22ff6821 	rsccss	v3, PC, #2162688	; 0x210000
    4d40:	40020212 	andmi	a1, a3, a3, lsl a3
    4d44:	6861800a 	stmvsda	a2!, {a2, a4, PC}^
    4d48:	f7fb7008 	ldrnvb	v4, [v8, v5]!
    4d4c:	0000fb61 	andeq	PC, a1, a2, ror #22
    4d50:	1c04b530 	cfstr32ne	mvfx11, [v1], {48}
    4d54:	78006840 	stmvcda	a1, {v3, v8, SP, LR}
    4d58:	d3042810 	tstle	v1, #1048576	; 0x100000
    4d5c:	21936820 	orrcss	v3, a4, a1, lsr #16
    4d60:	80010209 	andhi	a1, a2, v6, lsl #4
    4d64:	2300e01a 	tstcs	a1, #26	; 0x1a
    4d68:	68612200 	stmvsda	a2!, {v6, SP}^
    4d6c:	4d7e2084 	ldcmil	0, cr2, [LR, #-528]!
    4d70:	692d692d 	stmvsdb	SP!, {a1, a3, a4, v2, v5, v8, SP, LR}
    4d74:	682d6a6d 	stmvsda	SP!, {a1, a3, a4, v2, v3, v6, v8, SP, LR}
    4d78:	fa40f012 	blx	0x1040dc8
    4d7c:	22002115 	andcs	a3, a1, #1073741829	; 0x40000005
    4d80:	781b6863 	ldmvcda	v8, {a1, a2, v2, v3, v8, SP, LR}
    4d84:	4d24434b 	stcmi	3, cr4, [v1, #-300]!
    4d88:	334a18eb 	cmpcc	v7, #15400960	; 0xeb0000
    4d8c:	545a1e49 	ldrplb	a2, [v7], #-3657
    4d90:	6821d1fc 	stmvsda	a2!, {a3, a4, v1, v2, v3, v4, v5, IP, LR, PC}
    4d94:	021222ff 	andeqs	a3, a3, #-268435441	; 0xf000000f
    4d98:	800a4002 	andhi	v1, v7, a3
    4d9c:	f7fb2000 	ldrnvb	a3, [v8, a1]!
    4da0:	0000fb38 	andeq	PC, a1, v5, lsr v8
    4da4:	1c04b5f0 	cfstr32ne	mvfx11, [v1], {240}
    4da8:	880068c0 	stmhida	a1, {v3, v4, v8, SP, LR}
    4dac:	fdfcf7fd 	ldc2l	7, cr15, [IP, #1012]!
    4db0:	200060e0 	andcs	v3, a1, a1, ror #1
    4db4:	43412115 	cmpmi	a2, #1073741829	; 0x40000005
    4db8:	18514a17 	ldmneda	a2, {a1, a2, a3, v1, v6, v8, LR}^
    4dbc:	68e2314b 	stmvsia	a3!, {a1, a2, a4, v3, v5, IP, SP}^
    4dc0:	5d8d2600 	stcpl	6, cr2, [SP]
    4dc4:	1c765d93 	ldcnel	13, cr5, [v3], #-588
    4dc8:	d10342ab 	smlatble	a4, v8, a3, v1
    4dcc:	d1f82b00 	mvnles	a3, a1, lsl #22
    4dd0:	e0002700 	and	a3, a1, a1, lsl #14
    4dd4:	2f001b5f 	swics	0x00001b5f
    4dd8:	2115d113 	tstcs	v2, a4, lsl a2
    4ddc:	4a0e4341 	bmi	0x395ae8
    4de0:	314a1851 	cmpcc	v7, a2, asr v5
    4de4:	29777809 	ldmcsdb	v4!, {a1, a4, v8, IP, SP, LR}^
    4de8:	2101d101 	tstcs	a2, a2, lsl #2
    4dec:	2100e000 	tstcs	a1, a1
    4df0:	701168a2 	andvcs	v3, a2, a3, lsr #17
    4df4:	22006821 	andcs	v3, a1, #2162688	; 0x210000
    4df8:	6861800a 	stmvsda	a2!, {a2, a4, PC}^
    4dfc:	f7fd7008 	ldrnvb	v4, [SP, v5]!
    4e00:	1c40fa97 	mcrrne	10, 9, PC, a1, cr7
    4e04:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    4e08:	d3d32810 	bicles	a3, a4, #1048576	; 0x100000
    4e0c:	20ffd1f2 	ldrcssh	SP, [pc, #18]	; 0x4e26
    4e10:	22886821 	addcs	v3, v5, #2162688	; 0x210000
    4e14:	e7ef0212 	undefined
    4e18:	00008680 	andeq	v5, a1, a1, lsl #13
    4e1c:	1c04b531 	cfstr32ne	mvfx11, [v1], {49}
    4e20:	88006840 	stmhida	a1, {v3, v8, SP, LR}
    4e24:	fdc0f7fd 	stc2l	7, cr15, [a1, #1012]
    4e28:	68a06060 	stmvsia	a1!, {v2, v3, SP, LR}
    4e2c:	f7fd8800 	ldrnvb	v5, [SP, a1, lsl #16]!
    4e30:	60a0fdbb 	strvsh	PC, [a1], v8
    4e34:	1c02466b 	stcne	6, cr4, [a3], {107}
    4e38:	20a36861 	adccs	v3, a4, a2, ror #16
    4e3c:	692d4d4a 	stmvsdb	SP!, {a2, a4, v3, v5, v7, v8, LR}
    4e40:	6a6d692d 	bvs	0x1b5f2fc
    4e44:	f012682d 	andnvs	v3, a3, SP, lsr #16
    4e48:	21fff9d9 	ldrcssb	PC, [pc, #153]	; 0x4ee9
    4e4c:	40010209 	andmi	a1, a2, v6, lsl #4
    4e50:	80016820 	andhi	v3, a2, a1, lsr #16
    4e54:	bc382000 	ldclt	0, cr2, [v5]
    4e58:	4708bc02 	strmi	v8, [v5, -a3, lsl #24]
    4e5c:	1c04b530 	cfstr32ne	mvfx11, [v1], {48}
    4e60:	88006840 	stmhida	a1, {v3, v8, SP, LR}
    4e64:	fda0f7fd 	stc2	7, cr15, [a1, #1012]!
    4e68:	23006060 	tstcs	a1, #96	; 0x60
    4e6c:	1c012200 	sfmne	f2, 4, [a2], {0}
    4e70:	4d3d2085 	ldcmi	0, cr2, [SP, #-532]!
    4e74:	692d692d 	stmvsdb	SP!, {a1, a3, a4, v2, v5, v8, SP, LR}
    4e78:	682d6a6d 	stmvsda	SP!, {a1, a3, a4, v2, v3, v6, v8, SP, LR}
    4e7c:	f9bef012 	ldmnvib	LR!, {a2, v1, IP, SP, LR, PC}
    4e80:	020921ff 	andeq	a3, v6, #-1073741761	; 0xc000003f
    4e84:	68204001 	stmvsda	a1!, {a1, LR}
    4e88:	f7fb8001 	ldrnvb	v5, [v8, a2]!
    4e8c:	0000fac1 	andeq	PC, a1, a2, asr #21
    4e90:	1c04b530 	cfstr32ne	mvfx11, [v1], {48}
    4e94:	88006840 	stmhida	a1, {v3, v8, SP, LR}
    4e98:	fd86f7fd 	stc2	7, cr15, [v3, #1012]
    4e9c:	4d326060 	ldcmi	0, cr6, [a3, #-384]!
    4ea0:	1c012213 	sfmne	f2, 4, [a2], {19}
    4ea4:	69c06928 	stmvsib	a1, {a4, v2, v5, v8, SP, LR}^
    4ea8:	1d806a40 	fstsne	s12, [a1, #256]
    4eac:	f952f010 	ldmnvdb	a3, {v1, IP, SP, LR, PC}^
    4eb0:	68a12001 	stmvsia	a2!, {a1, SP}
    4eb4:	29017809 	stmcsdb	a2, {a1, a4, v8, IP, SP, LR}
    4eb8:	69c96929 	stmvsib	v6, {a1, a4, v2, v5, v8, SP, LR}^
    4ebc:	d1016a49 	tstle	a2, v6, asr #20
    4ec0:	e0017708 	and	v4, a2, v5, lsl #14
    4ec4:	770a2200 	strvc	a3, [v7, -a1, lsl #4]
    4ec8:	69ca6929 	stmvsib	v7, {a1, a4, v2, v5, v8, SP, LR}^
    4ecc:	68e36a52 	stmvsia	a4!, {a2, v1, v3, v6, v8, SP, LR}^
    4ed0:	7753781b 	smmlavc	a4, v8, v5, v4
    4ed4:	6a5269ca 	bvs	0x149f604
    4ed8:	80932300 	addhis	a3, a4, a1, lsl #6
    4edc:	6a5269ca 	bvs	0x149f60c
    4ee0:	6a4969c9 	bvs	0x125f60c
    4ee4:	43087e89 	tstmi	v5, #2192	; 0x890
    4ee8:	68207690 	stmvsda	a1!, {v1, v4, v6, v7, IP, SP, LR}
    4eec:	f7fb7003 	ldrnvb	v4, [v8, a4]!
    4ef0:	0000fa8f 	andeq	PC, a1, PC, lsl #21
    4ef4:	491cb510 	ldmmidb	IP, {v1, v5, v7, IP, SP, PC}
    4ef8:	69ca6909 	stmvsib	v7, {a1, a4, v5, v8, SP, LR}^
    4efc:	68436a52 	stmvsda	a4, {a2, v1, v3, v6, v8, SP, LR}^
    4f00:	8013881b 	andhis	v5, a4, v8, lsl v5
    4f04:	6a5269ca 	bvs	0x149f634
    4f08:	881b6883 	ldmhida	v8, {a1, a2, v4, v8, SP, LR}
    4f0c:	69ca8053 	stmvsib	v7, {a1, a2, v1, v3, PC}^
    4f10:	69036a52 	stmvsdb	a4, {a2, v1, v3, v6, v8, SP, LR}
    4f14:	7753781b 	smmlavc	a4, v8, v5, v4
    4f18:	6a5269ca 	bvs	0x149f648
    4f1c:	6a5b69cb 	bvs	0x16df650
    4f20:	24017e9b 	strcs	v4, [a2], #-3739
    4f24:	7694431c 	undefined
    4f28:	781268c2 	ldmvcda	a3, {a2, v3, v4, v8, SP, LR}
    4f2c:	69c92a01 	stmvsib	v6, {a1, v6, v8, SP}^
    4f30:	d1016a49 	tstle	a2, v6, asr #20
    4f34:	e0002203 	and	a3, a1, a4, lsl #4
    4f38:	770a2202 	strvc	a3, [v7, -a3, lsl #4]
    4f3c:	46c06800 	strmib	v3, [a1], a1, lsl #16
    4f40:	70012100 	andvc	a3, a2, a1, lsl #2
    4f44:	bc102000 	ldclt	0, cr2, [a1], {0}
    4f48:	4708bc02 	strmi	v8, [v5, -a3, lsl #24]
    4f4c:	69094906 	stmvsdb	v6, {a2, a3, v5, v8, LR}
    4f50:	69cb6802 	stmvsib	v8, {a2, v8, SP, LR}^
    4f54:	7edb6a5b 	mrcvc	10, 6, v3, cr11, cr11, {2}
    4f58:	68407013 	stmvsda	a1, {a1, a2, v1, IP, SP, LR}^
    4f5c:	6a4969c9 	bvs	0x125f688
    4f60:	70017e89 	andvc	v4, a2, v6, lsl #29
    4f64:	47702000 	ldrmib	a3, [a1, -a1]!
    4f68:	0000015c 	andeq	a1, a1, IP, asr a2
    4f6c:	6909498a 	stmvsdb	v6, {a2, a4, v4, v5, v8, LR}
    4f70:	6a5269ca 	bvs	0x149f6a0
    4f74:	781b6843 	ldmvcda	v8, {a1, a2, v3, v8, SP, LR}
    4f78:	680276d3 	stmvsda	a3, {a1, a2, v1, v3, v4, v6, v7, IP, SP, LR}
    4f7c:	6a5b69cb 	bvs	0x16df6b0
    4f80:	70137edb 	ldrvcsb	v4, [a4], -v8
    4f84:	6a5269ca 	bvs	0x149f6b4
    4f88:	6a4969c9 	bvs	0x125f6b4
    4f8c:	68807e89 	stmvsia	a1, {a1, a4, v4, v6, v7, v8, IP, SP, LR}
    4f90:	43087800 	tstmi	v5, #0	; 0x0
    4f94:	20007690 	mulcs	a1, a1, v3
    4f98:	00004770 	andeq	v1, a1, a1, ror v4
    4f9c:	6841b530 	stmvsda	a2, {v1, v2, v5, v7, IP, SP, PC}^
    4fa0:	2a04780a 	bcs	0x122fd0
    4fa4:	497cd229 	ldmmidb	IP!, {a1, a4, v2, v6, IP, LR, PC}^
    4fa8:	68836909 	stmvsia	a4, {a1, a4, v5, v8, SP, LR}
    4fac:	6a64688c 	bvs	0x191f1e4
    4fb0:	342018a4 	strcct	a2, [a1], #-2212
    4fb4:	25807824 	strcs	v4, [a1, #2084]
    4fb8:	1c2c4025 	stcne	0, cr4, [IP], #-148
    4fbc:	2401d000 	strcs	SP, [a2]
    4fc0:	00d2701c 	sbceqs	v4, a3, IP, lsl a1
    4fc4:	688c68c3 	stmvsia	IP, {a1, a2, v3, v4, v8, SP, LR}
    4fc8:	18a46a64 	stmneia	v1!, {a3, v2, v3, v6, v8, SP, LR}
    4fcc:	701c7924 	andvcs	v4, IP, v1, lsr #18
    4fd0:	781b6903 	ldmvcda	v8, {a1, a2, v5, v8, SP, LR}
    4fd4:	d00c2b00 	andle	a3, IP, a1, lsl #22
    4fd8:	6a5b688b 	bvs	0x16df20c
    4fdc:	2400189b 	strcs	a2, [a1], #-2203
    4fe0:	688b711c 	stmvsia	v8, {a3, a4, v1, v5, IP, SP, LR}
    4fe4:	189b6a5b 	ldmneia	v8, {a1, a2, a4, v1, v3, v6, v8, SP, LR}
    4fe8:	6889709c 	stmvsia	v6, {a3, a4, v1, v4, IP, SP, LR}
    4fec:	18896a49 	stmneia	v6, {a1, a4, v3, v6, v8, SP, LR}
    4ff0:	680070cc 	stmvsda	a1, {a3, a4, v3, v4, IP, SP, LR}
    4ff4:	70012100 	andvc	a3, a2, a1, lsl #2
    4ff8:	6801e008 	stmvsda	a2, {a4, SP, LR, PC}
    4ffc:	43d2220f 	bicmis	a3, a3, #-268435456	; 0xf0000000
    5000:	6881700a 	stmvsia	a2, {a2, a4, IP, SP, LR}
    5004:	700a2200 	andvc	a3, v7, a1, lsl #4
    5008:	700268c0 	andvc	v3, a3, a1, asr #17
    500c:	fa00f7fb 	blx	0x43000
    5010:	6804b5f0 	stmvsda	v1, {v1, v2, v3, v4, v5, v7, IP, SP, PC}
    5014:	780d6841 	stmvcda	SP, {a1, v3, v8, SP, LR}
    5018:	780f68c1 	stmvcda	PC, {a1, v3, v4, v8, SP, LR}
    501c:	88066880 	stmhida	v3, {v4, v8, SP, LR}
    5020:	f7fd1c30 	undefined
    5024:	1c02fcc1 	stcne	12, cr15, [a3], {193}
    5028:	200a1c3b 	andcs	a2, v7, v8, lsr IP
    502c:	48bd4346 	ldmmiia	SP!, {a2, a3, v3, v5, v6, LR}
    5030:	19806ac0 	stmneib	a1, {v3, v4, v6, v8, SP, LR}
    5034:	06098881 	streq	v5, [v6], -a2, lsl #17
    5038:	1c280e09 	stcne	14, cr0, [v5], #-36
    503c:	fce8f7ff 	stc2l	7, cr15, [v5], #1020
    5040:	f7fd7020 	ldrnvb	v4, [SP, a1, lsr #32]!
    5044:	0000f975 	andeq	PC, a1, v2, ror v6
    5048:	1c04b530 	cfstr32ne	mvfx11, [v1], {48}
    504c:	78056840 	stmvcda	v2, {v3, v8, SP, LR}
    5050:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    5054:	6821fc93 	stmvsda	a2!, {a1, a2, v1, v4, v7, v8, IP, SP, LR, PC}
    5058:	1c287008 	stcne	0, cr7, [v5], #-32
    505c:	fcb6f7ff 	ldc2	7, cr15, [v3], #1020
    5060:	700868a1 	andvc	v3, v5, a2, lsr #17
    5064:	f9d4f7fb 	ldmnvib	v1, {a1, a2, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    5068:	6804b5f0 	stmvsda	v1, {v1, v2, v3, v4, v5, v7, IP, SP, PC}
    506c:	780d6841 	stmvcda	SP, {a1, v3, v8, SP, LR}
    5070:	780e68c1 	stmvcda	LR, {a1, v3, v4, v8, SP, LR}
    5074:	88076880 	stmhida	v4, {v4, v8, SP, LR}
    5078:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    507c:	7020fc7f 	eorvc	PC, a1, PC, ror IP
    5080:	f7ff1c28 	ldrnvb	a2, [PC, v5, lsr #24]!
    5084:	2100fca3 	smlatbcs	a1, a4, IP, PC
    5088:	29005661 	stmcsdb	a1, {a1, v2, v3, v6, v7, IP, LR}
    508c:	2800db14 	stmcsda	a1, {a3, v1, v5, v6, v8, IP, LR, PC}
    5090:	42b0d012 	adcmis	SP, a1, #18	; 0x12
    5094:	1c06d200 	sfmne	f5, 1, [v3], {0}
    5098:	1c381c31 	ldcne	12, cr1, [v5], #-196
    509c:	ffccf7fc 	swinv	0x00ccf7fc
    50a0:	db102800 	blle	0x40f0a8
    50a4:	f7fd1c38 	undefined
    50a8:	1c02fc7f 	stcne	12, cr15, [a3], {127}
    50ac:	1c281c31 	stcne	12, cr1, [v5], #-196
    50b0:	fd24f7ff 	stc2	7, cr15, [v1, #-1020]!
    50b4:	e0057020 	and	v4, v2, a1, lsr #32
    50b8:	1c382100 	ldfnes	f2, [v5]
    50bc:	ffbcf7fc 	swinv	0x00bcf7fc
    50c0:	db002800 	blle	0xf0c8
    50c4:	f7fd2000 	ldrnvb	a3, [SP, a1]!
    50c8:	0000f934 	andeq	PC, a1, v1, lsr v6
    50cc:	1c04b530 	cfstr32ne	mvfx11, [v1], {48}
    50d0:	78284d0a 	stmvcda	v5!, {a2, a4, v5, v7, v8, LR}
    50d4:	d1032800 	tstle	a4, a1, lsl #16
    50d8:	faa4f00f 	blx	0xfe94111c
    50dc:	ffd8f00f 	swinv	0x00d8f00f
    50e0:	28157828 	ldmcsda	v2, {a4, v2, v8, IP, SP, LR}
    50e4:	2000d301 	andcs	SP, a1, a2, lsl #6
    50e8:	1c40e000 	marne	acc0, LR, a1
    50ec:	f00f7028 	andnv	v4, PC, v5, lsr #32
    50f0:	6821ff71 	stmvsda	a2!, {a1, v1, v2, v3, v5, v6, v7, v8, IP, SP, LR, PC}
    50f4:	f7fb8008 	ldrnvb	v5, [v8, v5]!
    50f8:	46c0f98b 	strmib	PC, [a1], v8, lsl #19
    50fc:	0000b59e 	muleq	a1, LR, v2
    5100:	21af6800 	movcs	v3, a1, lsl #16
    5104:	4a870089 	bmi	0xfe1c5330
    5108:	60015851 	andvs	v2, a2, a2, asr v5
    510c:	47702000 	ldrmib	a3, [a1, -a1]!
    5110:	1c04b530 	cfstr32ne	mvfx11, [v1], {48}
    5114:	88056880 	stmhida	v2, {v4, v8, SP, LR}
    5118:	f7fd1c28 	ldrnvb	a2, [SP, v5, lsr #24]!
    511c:	60a0fc45 	adcvs	PC, a1, v2, asr #24
    5120:	4345200a 	cmpmi	v2, #10	; 0xa
    5124:	6ac0487f 	bvs	0xff017328
    5128:	88821940 	stmhiia	a3, {v3, v5, v8, IP}
    512c:	686068a1 	stmvsda	a1!, {a1, v2, v4, v8, SP, LR}^
    5130:	f7fd7800 	ldrnvb	v4, [SP, a1, lsl #16]!
    5134:	6821fa8b 	stmvsda	a2!, {a1, a2, a4, v4, v6, v8, IP, SP, LR, PC}
    5138:	28007008 	stmcsda	a1, {a4, IP, SP, LR}
    513c:	2105da03 	tstcs	v2, a4, lsl #20
    5140:	428843c9 	addmi	v1, v5, #603979779	; 0x24000003
    5144:	2000da00 	andcs	SP, a1, a1, lsl #20
    5148:	f963f7fb 	stmnvdb	a4!, {a1, a2, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    514c:	28041c01 	stmcsda	v1, {a1, v7, v8, IP}
    5150:	200fd302 	andcs	SP, PC, a3, lsl #6
    5154:	e01843c0 	ands	v1, v5, a1, asr #7
    5158:	4a0e4873 	bmi	0x39732c
    515c:	28015e10 	stmcsda	a2, {v1, v6, v7, v8, IP, LR}
    5160:	2020d101 	eorcs	SP, a1, a2, lsl #2
    5164:	4a71e011 	bmi	0x1c7d1b0
    5168:	d00a4290 	mulle	v7, a1, a3
    516c:	232f4a08 	teqcs	PC, #32768	; 0x8000
    5170:	4b094359 	blmi	0x255edc
    5174:	681b691b 	ldmvsda	v8, {a1, a2, a4, v1, v5, v8, SP, LR}
    5178:	18596a5b 	ldmneda	v6, {a1, a2, a4, v1, v3, v6, v8, SP, LR}^
    517c:	29005c89 	stmcsdb	a1, {a1, a4, v4, v7, v8, IP, LR}
    5180:	201fd101 	andcss	SP, PC, a2, lsl #2
    5184:	0600e7e6 	streq	LR, [a1], -v3, ror #15
    5188:	b0001600 	andlt	a2, a1, a1, lsl #12
    518c:	46c04770 	undefined
    5190:	000003aa 	andeq	a1, a1, v7, lsr #7
    5194:	00008680 	andeq	v5, a1, a1, lsl #13
    5198:	0000015c 	andeq	a1, a1, IP, asr a2
    519c:	b081b5f1 	strltd	v8, [a2], a2
    51a0:	68409801 	stmvsda	a1, {a1, v8, IP, PC}^
    51a4:	98017806 	stmlsda	a2, {a2, a3, v8, IP, SP, LR}
    51a8:	880468c0 	stmhida	v1, {v3, v4, v8, SP, LR}
    51ac:	46691c37 	undefined
    51b0:	f7fd1c30 	undefined
    51b4:	1c05fab5 	stcne	10, cr15, [v2], {181}
    51b8:	db182800 	blle	0x60f1c0
    51bc:	88004668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}
    51c0:	d0142800 	andles	a3, v1, a1, lsl #16
    51c4:	88014668 	stmhida	a2, {a4, v2, v3, v6, v7, LR}
    51c8:	f7fc1c20 	ldrnvb	a2, [IP, a1, lsr #24]!
    51cc:	2800ff35 	stmcsda	a1, {a1, a3, v1, v2, v5, v6, v7, v8, IP, SP, LR, PC}
    51d0:	1c20db61 	stcne	11, cr13, [a1], #-388
    51d4:	fbe8f7fd 	blx	0xffa431d2
    51d8:	98011c01 	stmlsda	a2, {a1, v7, v8, IP}
    51dc:	78036880 	stmvcda	a4, {v4, v8, SP, LR}
    51e0:	88024668 	stmhida	a3, {a4, v2, v3, v6, v7, LR}
    51e4:	f7fd1c38 	undefined
    51e8:	1c05facf 	stcne	10, cr15, [v2], {207}
    51ec:	2101e00a 	tstcs	a2, v7
    51f0:	f7fc1c20 	ldrnvb	a2, [IP, a1, lsr #24]!
    51f4:	2800ff21 	stmcsda	a1, {a1, v2, v5, v6, v7, v8, IP, SP, LR, PC}
    51f8:	1c20db4d 	stcne	11, cr13, [a1], #-308
    51fc:	fbd4f7fd 	blx	0xff5431fa
    5200:	70012100 	andvc	a3, a2, a1, lsl #2
    5204:	d13a2d40 	teqle	v7, a1, asr #26
    5208:	d2382e0a 	eorles	a3, v5, #160	; 0xa0
    520c:	49454846 	stmmidb	v2, {a2, a3, v3, v8, LR}^
    5210:	2000180c 	andcs	a2, a1, IP, lsl #16
    5214:	28005e20 	stmcsda	a1, {v2, v6, v7, v8, IP, LR}
    5218:	2000da01 	andcs	SP, a1, a2, lsl #20
    521c:	27008020 	strcs	v5, [a1, -a1, lsr #32]
    5220:	1c7fe004 	ldcnel	0, cr14, [PC], #-16
    5224:	0e3f063f 	cfmsuba32eq	mvax1, mvax0, mvfx15, mvfx15
    5228:	d2282f03 	eorle	a3, v5, #12	; 0xc
    522c:	1c407920 	mcrrne	9, 2, v4, a1, cr0
    5230:	06007120 	streq	v4, [a1], -a1, lsr #2
    5234:	28040e00 	stmcsda	v1, {v6, v7, v8}
    5238:	2001d101 	andcs	SP, a2, a2, lsl #2
    523c:	79207120 	stmvcdb	a1!, {v2, v5, IP, SP, LR}
    5240:	ff84f7ff 	swinv	0x0084f7ff
    5244:	d1ec2800 	mvnle	a3, a1, lsl #16
    5248:	1c304d14 	ldcne	13, cr4, [a1], #-80
    524c:	70a8300a 	adcvc	a4, v5, v7
    5250:	1c2170ee 	stcne	0, cr7, [a2], #-952
    5254:	b4031c28 	strlt	a2, [a4], #-3112
    5258:	79222301 	stmvcdb	a3!, {a1, v5, v6, SP}
    525c:	200a2105 	andcs	a3, v7, v2, lsl #2
    5260:	682d692d 	stmvsda	SP!, {a1, a3, a4, v2, v5, v8, SP, LR}
    5264:	682d6a6d 	stmvsda	SP!, {a1, a3, a4, v2, v3, v6, v8, SP, LR}
    5268:	ffc8f011 	swinv	0x00c8f011
    526c:	f7ff7920 	ldrnvb	v4, [PC, a1, lsr #18]!
    5270:	1c05ff6d 	stcne	15, cr15, [v2], {109}
    5274:	2820b002 	stmcsda	a1!, {a2, IP, SP, PC}
    5278:	2001d101 	andcs	SP, a2, a2, lsl #2
    527c:	98017160 	stmlsda	a2, {v2, v3, v5, IP, SP, LR}
    5280:	70056800 	andvc	v3, v2, a1, lsl #16
    5284:	da052d00 	ble	0x15068c
    5288:	43c02005 	bicmi	a3, a1, #5	; 0x5
    528c:	db014285 	blle	0x55ca8
    5290:	e0001c28 	and	a2, a1, v5, lsr #24
    5294:	f7fc2000 	ldrnvb	a3, [IP, a1]!
    5298:	46c0fecb 	strmib	PC, [a1], v8, asr #29
    529c:	0000015c 	andeq	a1, a1, IP, asr a2
    52a0:	1c04b510 	cfstr32ne	mvfx11, [v1], {16}
    52a4:	78006840 	stmvcda	a1, {v3, v8, SP, LR}
    52a8:	ff50f7ff 	swinv	0x0050f7ff
    52ac:	70086821 	andvc	v3, v5, a2, lsr #16
    52b0:	0000e648 	andeq	LR, a1, v5, asr #12
    52b4:	6804b5f0 	stmvsda	v1, {v1, v2, v3, v4, v5, v7, IP, SP, PC}
    52b8:	780d6841 	stmvcda	SP, {a1, v3, v8, SP, LR}
    52bc:	88066880 	stmhida	v3, {v4, v8, SP, LR}
    52c0:	f7fd1c30 	undefined
    52c4:	4917fb71 	ldmmidb	v4, {a1, v1, v2, v3, v5, v6, v8, IP, SP, LR, PC}
    52c8:	4356220a 	cmpmi	v3, #-1610612736	; 0xa0000000
    52cc:	19926aca 	ldmneib	a3, {a2, a4, v3, v4, v6, v8, SP, LR}
    52d0:	4a158896 	bmi	0x567530
    52d4:	2100188f 	smlabbcs	a1, PC, v5, a2
    52d8:	29005e79 	stmcsdb	a1, {a1, a4, v1, v2, v3, v6, v7, v8, IP, LR}
    52dc:	2100da01 	tstcs	a1, a2, lsl #20
    52e0:	1c398039 	ldcne	0, cr8, [v6], #-228
    52e4:	2300b403 	tstcs	a1, #50331648	; 0x3000000
    52e8:	06311c2a 	ldreqt	a2, [a2], -v7, lsr #24
    52ec:	200a0e09 	andcs	a1, v7, v6, lsl #28
    52f0:	692d4d88 	stmvsdb	SP!, {a4, v4, v5, v7, v8, LR}
    52f4:	6a6d682d 	bvs	0x1b5f3b0
    52f8:	f011682d 	andnvs	v3, a2, SP, lsr #16
    52fc:	2000ff7f 	andcs	PC, a1, PC, ror PC
    5300:	b0025e38 	andlt	v2, a3, v5, lsr LR
    5304:	d1042801 	tstle	v1, a2, lsl #16
    5308:	70202020 	eorvc	a3, a1, a1, lsr #32
    530c:	71782001 	cmnvc	v5, a2
    5310:	4906e005 	stmmidb	v3, {a1, a3, SP, LR, PC}
    5314:	d1014288 	smlabble	a2, v5, a3, v1
    5318:	43c0201f 	bicmi	a3, a1, #31	; 0x1f
    531c:	f7fd7020 	ldrnvb	v4, [SP, a1, lsr #32]!
    5320:	0000f807 	andeq	PC, a1, v4, lsl #16
    5324:	00008680 	andeq	v5, a1, a1, lsl #13
    5328:	000002b2 	streqh	a1, [a1], -a3
    532c:	ffff9400 	swinv	0x00ff9400
    5330:	43c02001 	bicmi	a3, a1, #1	; 0x1
    5334:	00004770 	andeq	v1, a1, a1, ror v4
    5338:	4976b410 	ldmmidb	v3!, {v1, v7, IP, SP, PC}^
    533c:	6a8a6909 	bvs	0xfe29f768
    5340:	6a8b6a52 	bvs	0xfe2dfc90
    5344:	7e9b6a5b 	mrcvc	10, 4, v3, cr11, cr11, {2}
    5348:	431c2410 	tstmi	IP, #268435456	; 0x10000000
    534c:	68007694 	stmvsda	a1, {a3, v1, v4, v6, v7, IP, SP, LR}
    5350:	6a496a89 	bvs	0x125fd7c
    5354:	78093121 	stmvcda	v6, {a1, v2, v5, IP, SP}
    5358:	43514a02 	cmpmi	a2, #8192	; 0x2000
    535c:	20006001 	andcs	v3, a1, a2
    5360:	4770bc10 	undefined
    5364:	0000ea60 	andeq	LR, a1, a1, ror #20
    5368:	b09bb5f0 	ldrltsh	v8, [v8], a1
    536c:	68051c04 	stmvsda	v2, {a3, v7, v8, IP}
    5370:	68a14668 	stmvsia	a2!, {a4, v2, v3, v6, v7, LR}
    5374:	80818809 	addhi	v5, a2, v6, lsl #16
    5378:	880068e0 	stmhida	a1, {v2, v3, v4, v8, SP, LR}
    537c:	28419000 	stmcsda	a2, {IP, PC}^
    5380:	2100d30d 	tstcs	a1, SP, lsl #6
    5384:	88006920 	stmhida	a1, {v2, v5, v8, SP, LR}
    5388:	fe56f7fc 	mrc2	7, 2, PC, cr6, cr12, {7}
    538c:	20007028 	andcs	v4, a1, v5, lsr #32
    5390:	28005628 	stmcsda	a1, {a4, v2, v6, v7, IP, LR}
    5394:	2012db62 	andcss	SP, a3, a3, ror #22
    5398:	702843c0 	eorvc	v1, v5, a1, asr #7
    539c:	6860e05d 	stmvsda	a1!, {a1, a3, a4, v1, v3, SP, LR, PC}^
    53a0:	f7fd8800 	ldrnvb	v5, [SP, a1, lsl #16]!
    53a4:	6060fb01 	rsbvs	PC, a1, a2, lsl #22
    53a8:	aa132300 	bge	0x4cdfb0
    53ac:	20901c01 	addcss	a2, a1, a2, lsl #24
    53b0:	69364e58 	ldmvsdb	v3!, {a4, v1, v3, v6, v7, v8, LR}
    53b4:	6a766936 	bvs	0x1d9f894
    53b8:	f0116836 	andnvs	v3, a2, v3, lsr v5
    53bc:	1c07ff1d 	stcne	15, cr15, [v4], {29}
    53c0:	023626ff 	eoreqs	a3, v3, #267386880	; 0xff00000
    53c4:	d13b4230 	teqle	v8, a1, lsr a3
    53c8:	46694668 	strmibt	v1, [v6], -v5, ror #12
    53cc:	81018889 	smlabbhi	a2, v6, v5, v5
    53d0:	aa02466b 	bge	0x96d84
    53d4:	3114a913 	tstcc	v1, a4, lsl v6
    53d8:	4f4e2094 	swimi	0x004e2094
    53dc:	693f693f 	ldmvsdb	PC!, {a1, a2, a3, a4, v1, v2, v5, v8, SP, LR}
    53e0:	683f6a7f 	ldmvsda	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    53e4:	ff06f011 	swinv	0x0006f011
    53e8:	42301c07 	eormis	a2, a1, #1792	; 0x700
    53ec:	4668d128 	strmibt	SP, [v5], -v5, lsr #2
    53f0:	88096921 	stmhida	v6, {a1, v2, v5, v8, SP, LR}
    53f4:	99008081 	stmlsdb	a1, {a1, v4, PC}
    53f8:	0c090409 	cfstrseq	mvf0, [v6], {9}
    53fc:	f7fc8880 	ldrnvb	v5, [IP, a1, lsl #17]!
    5400:	1c06fe1b 	stcne	14, cr15, [v3], {27}
    5404:	da0c2800 	ble	0x30f40c
    5408:	22002300 	andcs	a3, a1, #0	; 0x0
    540c:	20922100 	addcss	a3, a3, a1, lsl #2
    5410:	69244c40 	stmvsdb	v1!, {v3, v7, v8, LR}
    5414:	6a646924 	bvs	0x191f8ac
    5418:	f0116824 	andnvs	v3, a2, v1, lsr #16
    541c:	1c30fef1 	ldcne	14, cr15, [a1], #-964
    5420:	4668e01c 	undefined
    5424:	f7fd8880 	ldrnvb	v5, [SP, a1, lsl #17]!
    5428:	6120fabf 	strvsh	PC, [a1, -PC]!
    542c:	a9029800 	stmgedb	a3, {v8, IP, PC}
    5430:	69221c89 	stmvsdb	a3!, {a1, a4, v4, v7, v8, IP}
    5434:	d0032800 	andle	a3, a4, a1, lsl #16
    5438:	5c0b1e40 	stcpl	14, cr1, [v8], {64}
    543c:	d1fb5413 	mvnles	v2, a4, lsl v1
    5440:	70280a38 	eorvc	a1, v5, v5, lsr v7
    5444:	22002300 	andcs	a3, a1, #0	; 0x0
    5448:	20922100 	addcss	a3, a3, a1, lsl #2
    544c:	69244c31 	stmvsdb	v1!, {a1, v1, v2, v7, v8, LR}
    5450:	6a646924 	bvs	0x191f8e8
    5454:	f0116824 	andnvs	v3, a2, v1, lsr #16
    5458:	2000fed3 	ldrcsd	PC, [a1], -a4
    545c:	f7fcb01b 	undefined
    5460:	0000ff68 	andeq	PC, a1, v5, ror #30
    5464:	b09bb5f0 	ldrltsh	v8, [v8], a1
    5468:	68051c04 	stmvsda	v2, {a3, v7, v8, IP}
    546c:	68a14668 	stmvsia	a2!, {a4, v2, v3, v6, v7, LR}
    5470:	80818809 	addhi	v5, a2, v6, lsl #16
    5474:	88006860 	stmhida	a1, {v2, v3, v8, SP, LR}
    5478:	fa96f7fd 	blx	0xfe5c3474
    547c:	68e06060 	stmvsia	a1!, {v2, v3, SP, LR}^
    5480:	1c308806 	ldcne	8, cr8, [a1], #-24
    5484:	fa90f7fd 	blx	0xfe443480
    5488:	200a60e0 	andcs	v3, v7, a1, ror #1
    548c:	48224346 	stmmida	a3!, {a2, a3, v3, v5, v6, LR}
    5490:	19806ac0 	stmneib	a1, {v3, v4, v6, v8, SP, LR}
    5494:	90008880 	andls	v5, a1, a1, lsl #17
    5498:	d3032841 	tstle	a4, #4259840	; 0x410000
    549c:	43c02012 	bicmi	a3, a1, #18	; 0x12
    54a0:	e0337028 	eors	v4, a4, v5, lsr #32
    54a4:	23004e1b 	tstcs	a1, #432	; 0x1b0
    54a8:	6861aa13 	stmvsda	a2!, {a1, a2, v1, v6, v8, SP, PC}^
    54ac:	69372090 	ldmvsdb	v4!, {v1, v4, SP}
    54b0:	6a7f693f 	bvs	0x1fdf9b4
    54b4:	f011683f 	andnvs	v3, a2, PC, lsr v5
    54b8:	21fffe9d 	ldrcsb	PC, [pc, #237]	; 0x55ad
    54bc:	42080209 	andmi	a1, v5, #-1879048192	; 0x90000000
    54c0:	4668d118 	undefined
    54c4:	88894669 	stmhiia	v6, {a1, a4, v2, v3, v6, v7, LR}
    54c8:	98008101 	stmlsda	a1, {a1, v5, PC}
    54cc:	aa0268e1 	bge	0x9f858
    54d0:	28001c92 	stmcsda	a1, {a2, v1, v4, v7, v8, IP}
    54d4:	1e40d003 	cdpne	0, 4, cr13, cr0, cr3, {0}
    54d8:	54135c0b 	ldrpl	v2, [a4], #-3083
    54dc:	466bd1fb 	undefined
    54e0:	a913aa02 	ldmgedb	a4, {a2, v6, v8, SP, PC}
    54e4:	20953114 	addcss	a4, v2, v1, lsl a2
    54e8:	69246934 	stmvsdb	v1!, {a3, v1, v2, v5, v8, SP, LR}
    54ec:	68246a64 	stmvsda	v1!, {a3, v2, v3, v6, v8, SP, LR}
    54f0:	fe86f011 	mcr2	0, 4, PC, cr6, cr1, {0}
    54f4:	70280a00 	eorvc	a1, v5, a1, lsl #20
    54f8:	22002300 	andcs	a3, a1, #0	; 0x0
    54fc:	20922100 	addcss	a3, a3, a1, lsl #2
    5500:	69246934 	stmvsdb	v1!, {a3, v1, v2, v5, v8, SP, LR}
    5504:	68246a64 	stmvsda	v1!, {a3, v2, v3, v6, v8, SP, LR}
    5508:	fe7af011 	mrc2	0, 3, PC, cr10, cr1, {0}
    550c:	b01b2000 	andlts	a3, v8, a1
    5510:	ff0ff7fc 	swinv	0x000ff7fc
    5514:	0000015c 	andeq	a1, a1, IP, asr a2
    5518:	00008680 	andeq	v5, a1, a1, lsl #13
    551c:	49c7b5f0 	stmmiib	v4, {v1, v2, v3, v4, v5, v7, IP, SP, PC}^
    5520:	4cbd6008 	ldcmi	0, cr6, [SP], #32
    5524:	6020483e 	eorvs	v1, a1, LR, lsr v5
    5528:	6060483e 	rsbvs	v1, a1, LR, lsr v5
    552c:	1825483f 	stmneda	v2!, {a1, a2, a3, a4, v1, v2, v8, LR}
    5530:	72a82000 	adcvc	a3, v5, #0	; 0x0
    5534:	210048c0 	smlabtcs	a1, a1, v5, v1
    5538:	20005421 	andcs	v2, a1, a2, lsr #8
    553c:	2300493c 	tstcs	a1, #983040	; 0xf0000
    5540:	18a20082 	stmneia	a3!, {a2, v4}
    5544:	1c405453 	cfstrdne	mvd5, [a1], {83}
    5548:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    554c:	d3f72803 	mvnles	a3, #196608	; 0x30000
    5550:	fc30f00f 	ldc2	0, cr15, [a1], #-60
    5554:	f8e0f00b 	stmnvia	a1!, {a1, a2, a4, IP, SP, LR, PC}^
    5558:	182048b0 	stmneda	a1!, {v1, v2, v4, v8, LR}
    555c:	70012111 	andvc	a3, a2, a2, lsl a2
    5560:	70412100 	subvc	a3, a2, a1, lsl #2
    5564:	70c16041 	sbcvc	v3, a2, a2, asr #32
    5568:	52a14a2f 	adcpl	v1, a2, #192512	; 0x2f000
    556c:	52a14a31 	adcpl	v1, a2, #200704	; 0x31000
    5570:	7001210b 	andvc	a3, a2, v8, lsl #2
    5574:	72012101 	andvc	a3, a2, #1073741824	; 0x40000000
    5578:	482f71a9 	stmmida	PC!, {a1, a4, v2, v4, v5, IP, SP, LR}
    557c:	70411820 	subvc	a2, a2, a1, lsr #16
    5580:	26002100 	strcs	a3, [a1], -a1, lsl #2
    5584:	434a221f 	cmpmi	v7, #-268435455	; 0xf0000001
    5588:	33231c23 	teqcc	a4, #8960	; 0x2300
    558c:	1c49549e 	cfstrdne	mvd5, [v6], {158}
    5590:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    5594:	d3f5291e 	mvnles	a3, #491520	; 0x78000
    5598:	7006712e 	andvc	v4, v3, LR, lsr #2
    559c:	49272000 	stmmidb	v4!, {SP}
    55a0:	27071861 	strcs	a2, [v4, -a2, ror #16]
    55a4:	4343232f 	cmpmi	a4, #-1140850688	; 0xbc000000
    55a8:	4b25469c 	blmi	0x957020
    55ac:	18d24a9a 	ldmneia	a3, {a2, a4, v1, v4, v6, v8, LR}^
    55b0:	1e7f4462 	cdpne	4, 7, cr4, cr15, cr2, {3}
    55b4:	d1fc55d6 	ldrlesb	v2, [IP, #86]!
    55b8:	3b242710 	blcc	0x90f200
    55bc:	18d24a96 	ldmneia	a3, {a2, a3, v1, v4, v6, v8, LR}^
    55c0:	1e7f4462 	cdpne	4, 7, cr4, cr15, cr2, {3}
    55c4:	d1fc55d6 	ldrlesb	v2, [IP, #86]!
    55c8:	33102704 	tstcc	a1, #1048576	; 0x100000
    55cc:	18d24a92 	ldmneia	a3, {a2, v1, v4, v6, v8, LR}^
    55d0:	1e7f4462 	cdpne	4, 7, cr4, cr15, cr2, {3}
    55d4:	d1fc55d6 	ldrlesb	v2, [IP, #86]!
    55d8:	1d1b2710 	ldcne	7, cr2, [v8, #-64]
    55dc:	18d24a8e 	ldmneia	a3, {a2, a3, a4, v4, v6, v8, LR}^
    55e0:	1e7f4462 	cdpne	4, 7, cr4, cr15, cr2, {3}
    55e4:	d1fc55d6 	ldrlesb	v2, [IP, #86]!
    55e8:	4342222f 	cmpmi	a3, #-268435454	; 0xf0000002
    55ec:	548b23ff 	strpl	a3, [v8], #1023
    55f0:	549e1c4b 	ldrpl	a2, [LR], #3147
    55f4:	549e1c8b 	ldrpl	a2, [LR], #3211
    55f8:	06001c40 	streq	a2, [a1], -a1, asr #24
    55fc:	28040e00 	stmcsda	v1, {v6, v7, v8}
    5600:	2102d3cf 	smlabtcs	a3, PC, a4, SP
    5604:	18204887 	stmneda	a1!, {a1, a2, a3, v4, v8, LR}
    5608:	f954f00b 	ldmnvdb	v1, {a1, a2, a4, IP, SP, LR, PC}^
    560c:	f94cf00b 	stmnvdb	IP, {a1, a2, a4, IP, SP, LR, PC}^
    5610:	fdf8f00b 	ldc2l	0, cr15, [v5, #44]!
    5614:	54264886 	strplt	v1, [v3], #-2182
    5618:	706e702e 	rsbvc	v4, LR, LR, lsr #32
    561c:	ffd6f000 	swinv	0x00d6f000
    5620:	00107fc5 	andeqs	v4, a1, v2, asr #31
    5624:	00108169 	andeqs	v5, a1, v6, ror #2
    5628:	0000086e 	andeq	a1, a1, LR, ror #16
    562c:	0000075d 	andeq	a1, a1, SP, asr v4
    5630:	00000ba8 	andeq	a1, a1, v5, lsr #23
    5634:	0000076c 	andeq	a1, a1, IP, ror #14
    5638:	0000047f 	andeq	a1, a1, PC, ror v1
    563c:	000003d5 	ldreqd	a1, [a1], -v2
    5640:	000003ce 	andeq	a1, a1, LR, asr #7
    5644:	4d74b5f3 	cfldr64mi	mvdx11, [v1, #-972]!
    5648:	182c4874 	stmneda	IP!, {a3, v1, v2, v3, v8, LR}
    564c:	fe24f000 	cdp2	0, 2, cr15, cr4, cr0, {0}
    5650:	d1092800 	tstle	v6, a1, lsl #16
    5654:	70202011 	eorvc	a3, a1, a2, lsl a1
    5658:	70602000 	rsbvc	a3, a1, a1
    565c:	70e06060 	rscvc	v3, a1, a1, rrx
    5660:	219668e0 	orrcss	v3, v3, a1, ror #17
    5664:	80010209 	andhi	a1, a2, v6, lsl #4
    5668:	f82af001 	stmnvda	v7!, {a1, IP, SP, LR, PC}
    566c:	182f486c 	stmneda	PC!, {a3, a4, v2, v3, v8, LR}
    5670:	f936f00b 	ldmnvdb	v3!, {a1, a2, a4, IP, SP, LR, PC}
    5674:	782071b8 	stmvcda	a1!, {a4, v1, v2, v4, v5, IP, SP, LR}
    5678:	d12c2811 	teqle	IP, a2, lsl v5
    567c:	496979b8 	stmmidb	v6!, {a4, v1, v2, v4, v5, v8, IP, SP, LR}^
    5680:	4969186e 	stmmidb	v6!, {a2, a3, a4, v2, v3, v8, IP}^
    5684:	7a221869 	bvc	0x88b830
    5688:	d0042a00 	andle	a3, v1, a1, lsl #20
    568c:	d0082a01 	andle	a3, v5, a2, lsl #20
    5690:	d0132a02 	andles	a3, a4, a3, lsl #20
    5694:	2000e01f 	andcs	LR, a1, PC, lsl a1
    5698:	71f87038 	mvnvcs	v4, v5, lsr a1
    569c:	f8fcf00b 	ldmnvia	IP!, {a1, a2, a4, IP, SP, LR, PC}^
    56a0:	2800e019 	stmcsda	a1, {a1, a4, v1, SP, LR, PC}
    56a4:	2000d017 	andcs	SP, a1, v4, lsl a1
    56a8:	20027008 	andcs	v4, a3, v5
    56ac:	72207038 	eorvc	v4, a1, #56	; 0x38
    56b0:	fa90f00b 	blx	0xfe4416e4
    56b4:	f908f00b 	stmnvdb	v5, {a1, a2, a4, IP, SP, LR, PC}
    56b8:	e0092101 	and	a3, v6, a2, lsl #2
    56bc:	d10a2800 	tstle	v7, a1, lsl #16
    56c0:	70382001 	eorvcs	a3, v5, a2
    56c4:	20007220 	andcs	v4, a1, a1, lsr #4
    56c8:	f00b7008 	andnv	v4, v8, v5
    56cc:	2102f901 	tstcsp	a3, a2, lsl #18
    56d0:	f00b1c30 	andnv	a2, v8, a1, lsr IP
    56d4:	4855f8ef 	ldmmida	v2, {a1, a2, a3, a4, v2, v3, v4, v8, IP, SP, LR, PC}^
    56d8:	54292100 	strplt	a3, [v6], #-256
    56dc:	182c4854 	stmneda	IP!, {a3, v1, v3, v8, LR}
    56e0:	07c07878 	undefined
    56e4:	7878d524 	ldmvcda	v5!, {a3, v2, v5, v7, IP, LR, PC}^
    56e8:	400121fe 	strmid	a3, [a2], -LR
    56ec:	78f87079 	ldmvcia	v5!, {a1, a4, v1, v2, v3, IP, SP, LR}^
    56f0:	d0062801 	andle	a3, v3, a2, lsl #16
    56f4:	d00d2802 	andle	a3, SP, a3, lsl #16
    56f8:	d0122803 	andles	a3, a3, a4, lsl #16
    56fc:	d0132804 	andles	a3, a4, v1, lsl #16
    5700:	f00be016 	andnv	LR, v8, v3, lsl a1
    5704:	2002fda9 	andcs	PC, a3, v6, lsr #27
    5708:	787870f8 	ldmvcda	v5!, {a4, v1, v2, v3, v4, IP, SP, LR}^
    570c:	43012101 	tstmi	a2, #1073741824	; 0x40000000
    5710:	e00d7079 	and	v4, SP, v6, ror a1
    5714:	18284847 	stmneda	v5!, {a1, a2, a3, v3, v8, LR}
    5718:	fe1af00b 	wxornv	wr15, wr10, wr11
    571c:	70202001 	eorvc	a3, a1, a2
    5720:	f000e009 	andnv	LR, a1, v6
    5724:	e003ff31 	and	PC, a4, a2, lsr PC
    5728:	70202000 	eorvc	a3, a1, a1
    572c:	fea2f00b 	cdp2	0, 10, cr15, cr2, cr11, {0}
    5730:	28007820 	stmcsda	a1, {v2, v8, IP, SP, LR}
    5734:	f000d001 	andnv	SP, a1, a2
    5738:	483fff55 	ldmmida	PC!, {a1, a3, v1, v3, v5, v6, v7, v8, IP, SP, LR, PC}
    573c:	7821182c 	stmvcda	a2!, {a3, a4, v2, v8, IP}
    5740:	18283841 	stmneda	v5!, {a1, v3, v8, IP, SP}
    5744:	29009001 	stmcsdb	a1, {a1, IP, PC}
    5748:	9801d004 	stmlsda	a2, {a3, IP, LR, PC}
    574c:	f848f00f 	stmnvda	v5, {a1, a2, a3, a4, IP, SP, LR, PC}^
    5750:	70202000 	eorvc	a3, a1, a1
    5754:	90002000 	andls	a3, a1, a1
    5758:	182c482d 	stmneda	IP!, {a1, a3, a4, v2, v8, LR}
    575c:	f00f4e37 	andnv	v1, PC, v4, lsr LR
    5760:	2801fb19 	stmcsda	a2, {a1, a4, v1, v5, v6, v8, IP, SP, LR, PC}
    5764:	6a806830 	bvs	0xfe01f82c
    5768:	d1146a40 	tstle	v1, a1, asr #20
    576c:	21013020 	tstcs	a2, a1, lsr #32
    5770:	f00f7001 	andnv	v4, PC, a2
    5774:	2801fa77 	stmcsda	a2, {a1, a2, a3, v1, v2, v3, v6, v8, IP, SP, LR, PC}
    5778:	2140d12f 	cmpcs	a1, PC, lsr #2
    577c:	f00e1c20 	andnv	a2, LR, a1, lsr #24
    5780:	9000fff1 	strlsd	PC, [a1], -a2
    5784:	71382001 	teqvc	v5, a2
    5788:	6a806830 	bvs	0xfe01f850
    578c:	30206a40 	eorcc	v3, a1, a1, asr #20
    5790:	70012102 	andvc	a3, a2, a3, lsl #2
    5794:	3020e021 	eorcc	LR, a1, a2, lsr #32
    5798:	70012100 	andvc	a3, a2, a1, lsl #2
    579c:	fb56f00f 	blx	0x15c17e2
    57a0:	28017938 	stmcsda	a2, {a4, v1, v2, v5, v8, IP, SP, LR}
    57a4:	2000d119 	andcs	SP, a1, v6, lsl a2
    57a8:	f00f7138 	andnv	v4, PC, v5, lsr a2
    57ac:	e010fad5 	ldrsb	PC, [a1], -v2
    57b0:	466b7020 	strmibt	v4, [v8], -a1, lsr #32
    57b4:	182a4817 	stmneda	v7!, {a1, a2, a3, v1, v8, LR}
    57b8:	20841c21 	addcs	a2, v1, a2, lsr #24
    57bc:	693f6837 	ldmvsdb	PC!, {a1, a2, a3, v1, v2, v8, SP, LR}
    57c0:	683f6a7f 	ldmvsda	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    57c4:	fd16f011 	ldc2	0, cr15, [v3, #-68]
    57c8:	f00f7820 	andnv	v4, PC, a1, lsr #16
    57cc:	f00ffab3 	strnvh	PC, [PC], -a4
    57d0:	21fffacb 	mvncss	PC, v8, asr #21
    57d4:	42080209 	andmi	a1, v5, #-1879048192	; 0x90000000
    57d8:	9800d0ea 	stmlsda	a1, {a2, a4, v2, v3, v4, IP, LR, PC}
    57dc:	d0112800 	andles	a3, a2, a1, lsl #16
    57e0:	04009800 	streq	v6, [a1], #-2048
    57e4:	b4010c00 	strlt	a1, [a2], #-3072
    57e8:	aa012301 	bge	0x4e3f4
    57ec:	1c209902 	stcne	9, cr9, [a1], #-8
    57f0:	f830f000 	ldmnvda	a1!, {IP, SP, LR, PC}
    57f4:	b0019801 	andlt	v6, a2, a2, lsl #16
    57f8:	d0032800 	andle	a3, a4, a1, lsl #16
    57fc:	98019900 	stmlsda	a2, {v5, v8, IP, PC}
    5800:	ffeef00e 	swinv	0x00eef00e
    5804:	f850f00b 	ldmnvda	a1, {a1, a2, a4, IP, SP, LR, PC}^
    5808:	bc01bcfc 	stclt	12, cr11, [a2], {252}
    580c:	46c04700 	strmib	v1, [a1], a1, lsl #14
    5810:	00000695 	muleq	a1, v2, v3
    5814:	00000697 	muleq	a1, v4, v3
    5818:	00008a54 	andeq	v5, a1, v1, asr v7
    581c:	00000bb4 	streqh	a1, [a1], -v1
    5820:	00000763 	andeq	a1, a1, a4, ror #14
    5824:	0000076e 	andeq	a1, a1, LR, ror #14
    5828:	00000505 	andeq	a1, a1, v2, lsl #10
    582c:	00000486 	andeq	a1, a1, v3, lsl #9
    5830:	00000979 	andeq	a1, a1, v6, ror v6
    5834:	0000097a 	andeq	a1, a1, v7, ror v6
    5838:	0000071a 	andeq	a1, a1, v7, lsl v4
    583c:	00009624 	andeq	v6, a1, v1, lsr #12
    5840:	f00fb500 	andnv	v8, PC, a1, lsl #10
    5844:	f00bfb0b 	andnv	PC, v8, v8, lsl #22
    5848:	f00bfe15 	andnv	PC, v8, v2, lsl LR
    584c:	bc01fb65 	stclt	11, cr15, [a2], {101}
    5850:	00004700 	andeq	v1, a1, a1, lsl #14
    5854:	1c04b5fb 	cfstr32ne	mvfx11, [v1], {251}
    5858:	1c161c0d 	ldcne	12, cr1, [v3], {13}
    585c:	8c014668 	stchi	6, cr4, [a2], {104}
    5860:	08427a00 	stmeqda	a3, {v6, v8, IP, SP, LR}^
    5864:	0092483f 	addeqs	v1, a3, PC, lsr v5
    5868:	189a4b3f 	ldmneia	v7, {a1, a2, a3, a4, v1, v2, v5, v6, v8, LR}
    586c:	90001810 	andls	a2, a1, a1, lsl v5
    5870:	207f2780 	rsbcss	a3, PC, a1, lsl #15
    5874:	78129a00 	ldmvcda	a3, {v6, v8, IP, PC}
    5878:	d14e2a00 	cmple	LR, a1, lsl #20
    587c:	68134a3b 	ldmvsda	a4, {a1, a2, a4, v1, v2, v6, v8, LR}
    5880:	40107822 	andmis	v4, a1, a3, lsr #16
    5884:	2801d01b 	stmcsda	a2, {a1, a2, a4, v1, IP, LR, PC}
    5888:	2802d002 	stmcsda	a3, {a2, IP, LR, PC}
    588c:	e041d037 	sub	SP, a2, v4, lsr a1
    5890:	7a004668 	bvc	0x17238
    5894:	1c33b403 	cfldrsne	mvf11, [a4], #-12
    5898:	1c611caa 	stcnel	12, cr1, [a2], #-680
    589c:	f0007860 	andnv	v4, a1, a1, ror #16
    58a0:	a902f867 	stmgedb	a3, {a1, a2, a3, v2, v3, v8, IP, SP, LR, PC}
    58a4:	78208088 	stmvcda	a1!, {a4, v4, PC}
    58a8:	4238b002 	eormis	v8, v5, #2	; 0x2
    58ac:	2000d01e 	andcs	SP, a1, LR, lsl a1
    58b0:	98007030 	stmlsda	a1, {v1, v2, IP, SP, LR}
    58b4:	78499900 	stmvcda	v6, {v5, v8, IP, PC}^
    58b8:	7047430f 	subvc	v1, v4, PC, lsl #6
    58bc:	7830e04d 	ldmvcda	a1!, {a1, a3, a4, v3, SP, LR, PC}
    58c0:	70301e40 	eorvcs	a2, a1, a1, asr #28
    58c4:	42387820 	eormis	v4, v5, #2097152	; 0x200000
    58c8:	1c32d008 	ldcne	0, cr13, [a3], #-32
    58cc:	1c202100 	stfnes	f2, [a1]
    58d0:	6a5b6a5b 	bvs	0x16e0244
    58d4:	f011691b 	andnvs	v3, a2, v8, lsl v6
    58d8:	e03efc8b 	eors	PC, LR, v8, lsl #25
    58dc:	1ca91c32 	stcne	12, cr1, [v6], #200
    58e0:	6a5b1c20 	bvs	0x16cc968
    58e4:	691b6a5b 	ldmvsdb	v8, {a1, a2, a4, v1, v3, v6, v8, SP, LR}
    58e8:	fc82f011 	stc2	0, cr15, [a3], {17}
    58ec:	28007830 	stmcsda	a1, {v1, v2, v8, IP, SP, LR}
    58f0:	1c80d033 	stcne	0, cr13, [a1], {51}
    58f4:	20027030 	andcs	v4, a3, a1, lsr a1
    58f8:	78607028 	stmvcda	a1!, {a4, v2, IP, SP, LR}^
    58fc:	7860e02c 	stmvcda	a1!, {a3, a4, v2, SP, LR, PC}^
    5900:	d2072814 	andle	a3, v4, #1310720	; 0x140000
    5904:	21001c32 	tstcs	a1, a3, lsr IP
    5908:	6a5b1c20 	bvs	0x16cc990
    590c:	691b6a5b 	ldmvsdb	v8, {a1, a2, a4, v1, v3, v6, v8, SP, LR}
    5910:	fc6ef011 	stc2l	0, cr15, [LR], #-68
    5914:	70302000 	eorvcs	a3, a1, a1
    5918:	9a00e01f 	bls	0x3d99c
    591c:	40107852 	andmis	v4, a1, a3, asr v5
    5920:	d11a2801 	tstle	v7, a2, lsl #16
    5924:	7a004668 	bvc	0x172cc
    5928:	1c33b403 	cfldrsne	mvf11, [a4], #-12
    592c:	1c211caa 	stcne	12, cr1, [a2], #-680
    5930:	78c09802 	stmvcia	a1, {a2, v8, IP, PC}^
    5934:	f81cf000 	ldmnvda	IP, {IP, SP, LR, PC}
    5938:	8088a902 	addhi	v7, v5, a3, lsl #18
    593c:	78409802 	stmvcda	a1, {a2, v8, IP, PC}^
    5940:	4238b002 	eormis	v8, v5, #2	; 0x2
    5944:	7830d1e6 	ldmvcda	a1!, {a2, a3, v2, v3, v4, v5, IP, LR, PC}
    5948:	d0062800 	andle	a3, v3, a1, lsl #16
    594c:	70301c80 	eorvcs	a2, a1, a1, lsl #25
    5950:	70282002 	eorvc	a3, v5, a3
    5954:	78c09800 	stmvcia	a1, {v8, IP, PC}^
    5958:	46687068 	strmibt	v4, [v5], -v5, rrx
    595c:	f0028880 	andnv	v5, a3, a1, lsl #17
    5960:	0000f96d 	andeq	PC, a1, SP, ror #18
    5964:	00000ba8 	andeq	a1, a1, v5, lsr #23
    5968:	00008a54 	andeq	v5, a1, v1, asr v7
    596c:	00009624 	andeq	v6, a1, v1, lsr #12
    5970:	b089b5f3 	strltd	v8, [v6], a4
    5974:	1c1d1c14 	ldcne	12, cr1, [SP], {20}
    5978:	7806a810 	stmvcda	v3, {v1, v8, SP, PC}
    597c:	48db0871 	ldmmiia	v8, {a1, v1, v2, v3, v8}^
    5980:	18104adb 	ldmneda	a1, {a1, a2, a4, v1, v3, v4, v6, v8, LR}
    5984:	48db9002 	ldmmiia	v8, {a2, IP, PC}^
    5988:	aa091810 	bge	0x24b9d0
    598c:	3a807812 	bcc	0xfe0239dc
    5990:	d9002a24 	stmledb	a1, {a3, v2, v6, v8, SP}
    5994:	a302e078 	tstge	a3, #120	; 0x78
    5998:	5a9b0052 	bpl	0xfe6c5ae8
    599c:	46c0449f 	undefined
    59a0:	004a0258 	subeq	a1, v7, v5, asr a3
    59a4:	00ea0294 	smlaleq	a1, v7, v1, a3
    59a8:	031e0228 	tsteq	LR, #-2147483646	; 0x80000002
    59ac:	03ca0370 	biceq	a1, v7, #-1073741823	; 0xc0000001
    59b0:	04300418 	ldreqt	a1, [a1], #-1048
    59b4:	019408c4 	orreqs	a1, v1, v1, asr #17
    59b8:	08c401d6 	stmeqia	v1, {a2, a3, v1, v3, v4, v5}^
    59bc:	08c408c4 	stmeqia	v1, {a3, v3, v4, v8}^
    59c0:	04b00478 	ldreqt	a1, [a1], #1144
    59c4:	08c404e4 	stmeqia	v1, {a3, v2, v3, v4, v7}^
    59c8:	05b00508 	ldreq	a1, [a1, #1288]!
    59cc:	063e08c4 	ldreqt	a1, [LR], -v1, asr #17
    59d0:	08c406ba 	stmeqia	v1, {a2, a4, v1, v2, v4, v6, v7}^
    59d4:	071a06f8 	undefined
    59d8:	08c408c4 	stmeqia	v1, {a3, v3, v4, v8}^
    59dc:	08c408c4 	stmeqia	v1, {a3, v3, v4, v8}^
    59e0:	07900774 	undefined
    59e4:	08c407c2 	stmeqia	v1, {a2, v3, v4, v5, v6, v7}^
    59e8:	980a0896 	stmlsda	v7, {a2, a3, v1, v4, v8}
    59ec:	90007d40 	andls	v4, a1, a1, asr #26
    59f0:	7d89990a 	stcvc	9, cr9, [v6, #40]
    59f4:	18400209 	stmneda	a1, {a1, a4, v6}^
    59f8:	990a9000 	stmlsdb	v7, {IP, PC}
    59fc:	04097dc9 	streq	v4, [v6], #-3529
    5a00:	90001840 	andls	a2, a1, a1, asr #16
    5a04:	7e09990a 	cdpvc	9, 0, cr9, cr9, cr10, {0}
    5a08:	18400609 	stmneda	a1, {a1, a4, v6, v7}^
    5a0c:	22149000 	andcss	v6, v1, #0	; 0x0
    5a10:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    5a14:	f000a804 	andnv	v7, a1, v1, lsl #16
    5a18:	49b7fd8d 	ldmmiib	v4!, {a1, a3, a4, v4, v5, v7, v8, IP, SP, LR, PC}
    5a1c:	a8043114 	stmgeda	v1, {a3, v1, v5, IP, SP}
    5a20:	fbaef00f 	blx	0xfebc1a66
    5a24:	d10d2800 	tstle	SP, a1, lsl #16
    5a28:	311c49b3 	ldrcch	v1, [IP, -a4]
    5a2c:	f00fa804 	andnv	v7, PC, v1, lsl #16
    5a30:	2800fba7 	stmcsda	a1, {a1, a2, a3, v2, v4, v5, v6, v8, IP, SP, LR, PC}
    5a34:	49b0d106 	ldmmiib	a1!, {a2, a3, v5, IP, LR, PC}
    5a38:	a8043124 	stmgeda	v1, {a3, v2, v5, IP, SP}
    5a3c:	fba0f00f 	blx	0xfe841a82
    5a40:	d0052800 	andle	a3, v2, a1, lsl #16
    5a44:	2200466b 	andcs	v1, a1, #112197632	; 0x6b00000
    5a48:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    5a4c:	e0042089 	and	a3, v1, v6, lsl #1
    5a50:	2200466b 	andcs	v1, a1, #112197632	; 0x6b00000
    5a54:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    5a58:	4fa82081 	swimi	0x00a82081
    5a5c:	693f683f 	ldmvsdb	PC!, {a1, a2, a3, a4, v1, v2, v8, SP, LR}
    5a60:	683f6a7f 	ldmvsda	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    5a64:	fbc6f011 	blx	0xff1c1ab2
    5a68:	0a381c07 	beq	0xe0ca8c
    5a6c:	70677020 	rsbvc	v4, v4, a1, lsr #32
    5a70:	70282002 	eorvc	a3, v5, a3
    5a74:	020020ff 	andeq	a3, a1, #255	; 0xff
    5a78:	d1054207 	tstle	v2, v4, lsl #4
    5a7c:	d50307f6 	strle	a1, [a4, #-2038]
    5a80:	0e000638 	cfmadd32eq	mvax1, mvfx0, mvfx0, mvfx8
    5a84:	f944f00f 	stmnvdb	v1, {a1, a2, a3, a4, IP, SP, LR, PC}^
    5a88:	0088e3ec 	addeq	LR, v5, IP, ror #7
    5a8c:	18084998 	stmneda	v5, {a4, v1, v4, v5, v8, LR}
    5a90:	1846499b 	stmneda	v3, {a1, a2, a4, v1, v4, v5, v8, LR}^
    5a94:	29007831 	stmcsdb	a1, {a1, v1, v2, v8, IP, SP, LR}
    5a98:	7828d126 	stmvcda	v5!, {a2, a3, v2, v5, IP, LR, PC}
    5a9c:	90001ec0 	andls	a2, a1, a1, asr #29
    5aa0:	9a0a466b 	bls	0x297454
    5aa4:	990a1c92 	stmlsdb	v7, {a2, v1, v4, v7, v8, IP}
    5aa8:	20831c49 	addcs	a2, a4, v6, asr #24
    5aac:	683f4f93 	ldmvsda	PC!, {a1, a2, v1, v4, v5, v6, v7, v8, LR}
    5ab0:	6a7f693f 	bvs	0x1fdffb4
    5ab4:	f011683f 	andnvs	v3, a2, PC, lsr v5
    5ab8:	1c07fb9d 	stcne	11, cr15, [v4], {157}
    5abc:	70a09800 	adcvc	v6, a1, a1, lsl #16
    5ac0:	04009800 	streq	v6, [a1], #-2048
    5ac4:	70e00e00 	rscvc	a1, a1, a1, lsl #28
    5ac8:	a9117828 	ldmgedb	a2, {a4, v2, v8, IP, SP, LR}
    5acc:	42888809 	addmi	v5, v5, #589824	; 0x90000
    5ad0:	a811d02b 	ldmgeda	a2, {a1, a2, a4, v2, IP, LR, PC}
    5ad4:	28008800 	stmcsda	a1, {v8, PC}
    5ad8:	2083d027 	addcs	SP, a4, v4, lsr #32
    5adc:	200170f0 	strcsd	v4, [a2], -a1
    5ae0:	70307070 	eorvcs	v4, a1, a1, ror a1
    5ae4:	e01c70b7 	ldrh	v4, [IP], -v4
    5ae8:	91007829 	tstls	a1, v6, lsr #16
    5aec:	9a0a466b 	bls	0x2974a0
    5af0:	18414984 	stmneda	a2, {a3, v4, v5, v8, LR}^
    5af4:	4f812083 	swimi	0x00812083
    5af8:	693f683f 	ldmvsdb	PC!, {a1, a2, a3, a4, v1, v2, v8, SP, LR}
    5afc:	683f6a7f 	ldmvsda	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    5b00:	fb78f011 	blx	0x1e41b4e
    5b04:	78e01c07 	stmvcia	a1!, {a1, a2, a3, v7, v8, IP}^
    5b08:	78a10200 	stmvcia	a2!, {v6}
    5b0c:	98004301 	stmlsda	a1, {a1, v5, v6, LR}
    5b10:	70a01808 	adcvc	a2, a1, v5, lsl #16
    5b14:	0e000400 	cfcpyseq	mvf0, mvf0
    5b18:	a81170e0 	ldmgeda	a2, {v2, v3, v4, IP, SP, LR}
    5b1c:	28008800 	stmcsda	a1, {v8, PC}
    5b20:	2000d001 	andcs	SP, a1, a2
    5b24:	2000e39d 	mulcs	a1, SP, a4
    5b28:	0a387030 	beq	0xe21bf0
    5b2c:	70677020 	rsbvc	v4, v4, a1, lsr #32
    5b30:	e3962004 	orrs	a3, v3, #4	; 0x4
    5b34:	7d40980a 	stcvcl	8, cr9, [a1, #-40]
    5b38:	990a9000 	stmlsdb	v7, {IP, PC}
    5b3c:	02097d89 	andeq	v4, v6, #8768	; 0x2240
    5b40:	90001840 	andls	a2, a1, a1, asr #16
    5b44:	7dc9990a 	stcvcl	9, cr9, [v6, #40]
    5b48:	18400409 	stmneda	a1, {a1, a4, v7}^
    5b4c:	990a9000 	stmlsdb	v7, {IP, PC}
    5b50:	06097e09 	streq	v4, [v6], -v6, lsl #28
    5b54:	90001840 	andls	a2, a1, a1, asr #16
    5b58:	2200466b 	andcs	v1, a1, #112197632	; 0x6b00000
    5b5c:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    5b60:	4f66208b 	swimi	0x0066208b
    5b64:	693f683f 	ldmvsdb	PC!, {a1, a2, a3, a4, v1, v2, v8, SP, LR}
    5b68:	683f6a7f 	ldmvsda	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    5b6c:	fb42f011 	blx	0x10c1bba
    5b70:	0a001c07 	beq	0xcb94
    5b74:	466be77a 	undefined
    5b78:	990a2200 	stmlsdb	v7, {v6, SP}
    5b7c:	208c1c49 	addcs	a2, IP, v6, asr #24
    5b80:	683f4f5e 	ldmvsda	PC!, {a2, a3, a4, v1, v3, v5, v6, v7, v8, LR}
    5b84:	6a7f693f 	bvs	0x1fe0088
    5b88:	f011683f 	andnvs	v3, a2, PC, lsr v5
    5b8c:	1c07fb33 	stcne	11, cr15, [v4], {51}
    5b90:	70200a00 	eorvc	a1, a1, a1, lsl #20
    5b94:	98007067 	stmlsda	a1, {a1, a2, a3, v2, v3, IP, SP, LR}
    5b98:	980070a0 	stmlsda	a1, {v2, v4, IP, SP, LR}
    5b9c:	0e000400 	cfcpyseq	mvf0, mvf0
    5ba0:	980070e0 	stmlsda	a1, {v2, v3, v4, IP, SP, LR}
    5ba4:	71200c00 	teqvc	a1, a1, lsl #24
    5ba8:	0e009800 	cdpeq	8, 0, cr9, cr0, cr0, {0}
    5bac:	20067160 	andcs	v4, v3, a1, ror #2
    5bb0:	20ff7028 	rsccss	v4, PC, v5, lsr #32
    5bb4:	42070200 	andmi	a1, v4, #0	; 0x0
    5bb8:	07f6d105 	ldreqb	SP, [v3, v2, lsl #2]!
    5bbc:	0638d503 	ldreqt	SP, [v5], -a4, lsl #10
    5bc0:	f00f0e00 	andnv	a1, PC, a1, lsl #28
    5bc4:	e34df8a5 	cmpp	SP, #10813440	; 0xa50000
    5bc8:	d50307f6 	strle	a1, [a4, #-2038]
    5bcc:	7840980a 	stmvcda	a1, {a2, a4, v8, IP, PC}^
    5bd0:	f8b0f00f 	ldmnvia	a1!, {a1, a2, a3, a4, IP, SP, LR, PC}
    5bd4:	2200466b 	andcs	v1, a1, #112197632	; 0x6b00000
    5bd8:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    5bdc:	4e472084 	cdpmi	0, 4, cr2, cr7, cr4, {4}
    5be0:	69366836 	ldmvsdb	v3!, {a2, a3, v1, v2, v8, SP, LR}
    5be4:	68366a76 	ldmvsda	v3!, {a2, a3, v1, v2, v3, v6, v8, SP, LR}
    5be8:	fb06f011 	blx	0x1c1c36
    5bec:	0a001c07 	beq	0xcc10
    5bf0:	70677020 	rsbvc	v4, v4, a1, lsr #32
    5bf4:	e3342002 	teq	v1, #2	; 0x2
    5bf8:	2200466b 	andcs	v1, a1, #112197632	; 0x6b00000
    5bfc:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    5c00:	4f3e2080 	swimi	0x003e2080
    5c04:	693f683f 	ldmvsdb	PC!, {a1, a2, a3, a4, v1, v2, v8, SP, LR}
    5c08:	683f6a7f 	ldmvsda	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    5c0c:	faf2f011 	blx	0xffcc1c58
    5c10:	0a001c07 	beq	0xcc34
    5c14:	70677020 	rsbvc	v4, v4, a1, lsr #32
    5c18:	70a09800 	adcvc	v6, a1, a1, lsl #16
    5c1c:	04009800 	streq	v6, [a1], #-2048
    5c20:	70e00e00 	rscvc	a1, a1, a1, lsl #28
    5c24:	0c009800 	stceq	8, cr9, [a1], {0}
    5c28:	98007120 	stmlsda	a1, {v2, v5, IP, SP, LR}
    5c2c:	71600e00 	cmnvc	a1, a1, lsl #28
    5c30:	e71e2006 	ldr	a3, [LR, -v3]
    5c34:	78c0980a 	stmvcia	a1, {a2, a4, v8, IP, PC}^
    5c38:	90000200 	andls	a1, a1, a1, lsl #4
    5c3c:	7889990a 	stmvcia	v6, {a2, a4, v5, v8, IP, PC}
    5c40:	91004301 	tstls	a1, a2, lsl #6
    5c44:	297b1c0e 	ldmcsdb	v8!, {a2, a3, a4, v7, v8, IP}^
    5c48:	482fd312 	stmmida	PC!, {a2, v1, v5, v6, IP, LR, PC}
    5c4c:	18084928 	stmneda	v5, {a4, v2, v5, v8, LR}
    5c50:	29117801 	ldmcsdb	a2, {a1, v8, IP, SP, LR}
    5c54:	492dd10c 	stmmidb	SP!, {a3, a4, v5, IP, LR, PC}
    5c58:	18514a25 	ldmneda	a2, {a1, a3, v2, v6, v8, LR}^
    5c5c:	800a9a00 	andhi	v6, v7, a1, lsl #20
    5c60:	78529a0a 	ldmvcda	a3, {a2, a4, v6, v8, IP, PC}^
    5c64:	2282804a 	addcs	v5, a3, #74	; 0x4a
    5c68:	210c770a 	tstcs	IP, v7, lsl #14
    5c6c:	e7587001 	ldrb	v4, [v5, -a2]
    5c70:	1d009800 	stcne	8, cr9, [a1]
    5c74:	466b7028 	strmibt	v4, [v8], -v5, lsr #32
    5c78:	990a1d22 	stmlsdb	v7, {a2, v2, v5, v7, v8, IP}
    5c7c:	20821c49 	addcs	a2, a3, v6, asr #24
    5c80:	682d4d1e 	stmvsda	SP!, {a2, a3, a4, v1, v5, v7, v8, LR}
    5c84:	6a6d692d 	bvs	0x1b60140
    5c88:	f011682d 	andnvs	v3, a2, SP, lsr #16
    5c8c:	1c07fab7 	stcne	10, cr15, [v4], {183}
    5c90:	70200a00 	eorvc	a1, a1, a1, lsl #20
    5c94:	70a67067 	adcvc	v4, v3, v4, rrx
    5c98:	0c000430 	cfstrseq	mvf0, [a1], {48}
    5c9c:	70e00a00 	rscvc	a1, a1, a1, lsl #20
    5ca0:	42b09800 	adcmis	v6, a1, #0	; 0x0
    5ca4:	9800d20a 	stmlsda	a1, {a2, a4, v6, IP, LR, PC}
    5ca8:	21001a30 	tstcs	a1, a1, lsr v7
    5cac:	18a29a00 	stmneia	a3!, {v6, v8, IP, PC}
    5cb0:	28001d12 	stmcsda	a1, {a2, v1, v5, v7, v8, IP}
    5cb4:	1e40d002 	cdpne	0, 4, cr13, cr0, cr2, {0}
    5cb8:	d1fc5411 	mvnles	v2, a2, lsl v1
    5cbc:	466be2d2 	undefined
    5cc0:	990a2200 	stmlsdb	v7, {v6, SP}
    5cc4:	20851c49 	addcs	a2, v2, v6, asr #24
    5cc8:	68364e0c 	ldmvsda	v3!, {a3, a4, v6, v7, v8, LR}
    5ccc:	6a766936 	bvs	0x1da01ac
    5cd0:	f0116836 	andnvs	v3, a2, v3, lsr v5
    5cd4:	1c07fa91 	stcne	10, cr15, [v4], {145}
    5cd8:	70200a00 	eorvc	a1, a1, a1, lsl #20
    5cdc:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    5ce0:	1c201c64 	stcne	12, cr1, [a1], #-400
    5ce4:	fc42f000 	mcrr2	0, 0, PC, a3, cr0
    5ce8:	e2ba2015 	adcs	a3, v7, #21	; 0x15
    5cec:	0000075d 	andeq	a1, a1, SP, asr v4
    5cf0:	00008a54 	andeq	v5, a1, v1, asr v7
    5cf4:	0000060d 	andeq	a1, a1, SP, lsl #12
    5cf8:	00118d8c 	andeqs	v5, a2, IP, lsl #27
    5cfc:	00009624 	andeq	v6, a1, v1, lsr #12
    5d00:	00000ba8 	andeq	a1, a1, v5, lsr #23
    5d04:	00000baa 	andeq	a1, a1, v7, lsr #23
    5d08:	00000bb4 	streqh	a1, [a1], -v1
    5d0c:	00000b88 	andeq	a1, a1, v5, lsl #23
    5d10:	1ca2466b 	stcne	6, cr4, [a3], #428
    5d14:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    5d18:	4fde2086 	swimi	0x00de2086
    5d1c:	693f683f 	ldmvsdb	PC!, {a1, a2, a3, a4, v1, v2, v8, SP, LR}
    5d20:	683f6a7f 	ldmvsda	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    5d24:	fa66f011 	blx	0x19c1d70
    5d28:	0a001c07 	beq	0xcd4c
    5d2c:	70677020 	rsbvc	v4, v4, a1, lsr #32
    5d30:	28007820 	stmcsda	a1, {v2, v8, IP, SP, LR}
    5d34:	9800d111 	stmlsda	a1, {a1, v1, v5, IP, LR, PC}
    5d38:	980075a0 	stmlsda	a1, {v2, v4, v5, v7, IP, SP, LR}
    5d3c:	0e000400 	cfcpyseq	mvf0, mvf0
    5d40:	980075e0 	stmlsda	a1, {v2, v3, v4, v5, v7, IP, SP, LR}
    5d44:	76200c00 	strvct	a1, [a1], -a1, lsl #24
    5d48:	0e009800 	cdpeq	8, 0, cr9, cr0, cr0, {0}
    5d4c:	07f67660 	ldreqb	v4, [v3, a1, ror #12]!
    5d50:	7860d509 	stmvcda	a1!, {a1, a4, v5, v7, IP, LR, PC}^
    5d54:	ffdcf00e 	swinv	0x00dcf00e
    5d58:	2018e005 	andcss	LR, v5, v2
    5d5c:	1ca42100 	stfnes	f2, [v1]
    5d60:	54211e40 	strplt	a2, [a2], #-3648
    5d64:	201ad1fc 	ldrcssh	SP, [v7], -IP
    5d68:	466be27b 	undefined
    5d6c:	990a1ca2 	stmlsdb	v7, {a2, v2, v4, v7, v8, IP}
    5d70:	20871c49 	addcs	a2, v4, v6, asr #24
    5d74:	68364ec7 	ldmvsda	v3!, {a1, a2, a3, v3, v4, v6, v7, v8, LR}
    5d78:	6a766936 	bvs	0x1da0258
    5d7c:	f0116836 	andnvs	v3, a2, v3, lsr v5
    5d80:	1c07fa3b 	stcne	10, cr15, [v4], {59}
    5d84:	70200a00 	eorvc	a1, a1, a1, lsl #20
    5d88:	78207067 	stmvcda	a1!, {a1, a2, a3, v2, v3, IP, SP, LR}
    5d8c:	d10c2800 	tstle	IP, a1, lsl #16
    5d90:	75a09800 	strvc	v6, [a1, #2048]!
    5d94:	04009800 	streq	v6, [a1], #-2048
    5d98:	75e00e00 	strvcb	a1, [a1, #3584]!
    5d9c:	0c009800 	stceq	8, cr9, [a1], {0}
    5da0:	98007620 	stmlsda	a1, {v2, v6, v7, IP, SP, LR}
    5da4:	76600e00 	strvcbt	a1, [a1], -a1, lsl #28
    5da8:	2018e7dd 	ldrcssb	LR, [v5], -SP
    5dac:	1ca42100 	stfnes	f2, [v1]
    5db0:	54211e40 	strplt	a2, [a2], #-3648
    5db4:	e7d6d1fc 	undefined
    5db8:	70202000 	eorvc	a3, a1, a1
    5dbc:	7060207c 	rsbvc	a3, a1, IP, ror a1
    5dc0:	70a02001 	adcvc	a3, a1, a2
    5dc4:	70e02000 	rscvc	a3, a1, a1
    5dc8:	71202001 	teqvc	a1, a2
    5dcc:	e2482005 	sub	a3, v5, #5	; 0x5
    5dd0:	7d40980a 	stcvcl	8, cr9, [a1, #-40]
    5dd4:	990a9000 	stmlsdb	v7, {IP, PC}
    5dd8:	02097d89 	andeq	v4, v6, #8768	; 0x2240
    5ddc:	90001840 	andls	a2, a1, a1, asr #16
    5de0:	7dc9990a 	stcvcl	9, cr9, [v6, #40]
    5de4:	18400409 	stmneda	a1, {a1, a4, v7}^
    5de8:	990a9000 	stmlsdb	v7, {IP, PC}
    5dec:	06097e09 	streq	v4, [v6], -v6, lsl #28
    5df0:	90001840 	andls	a2, a1, a1, asr #16
    5df4:	2200466b 	andcs	v1, a1, #112197632	; 0x6b00000
    5df8:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    5dfc:	4fa52089 	swimi	0x00a52089
    5e00:	693f683f 	ldmvsdb	PC!, {a1, a2, a3, a4, v1, v2, v8, SP, LR}
    5e04:	683f6a7f 	ldmvsda	PC!, {a1, a2, a3, a4, v1, v2, v3, v6, v8, SP, LR}
    5e08:	f9f4f011 	ldmnvib	v1!, {a1, v1, IP, SP, LR, PC}^
    5e0c:	0a001c07 	beq	0xce30
    5e10:	70677020 	rsbvc	v4, v4, a1, lsr #32
    5e14:	e62c2002 	strt	a3, [IP], -a3
    5e18:	1ca2466b 	stcne	6, cr4, [a3], #428
    5e1c:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    5e20:	4e9c2090 	mrcmi	0, 4, a3, cr12, cr0, {4}
    5e24:	69366836 	ldmvsdb	v3!, {a2, a3, v1, v2, v8, SP, LR}
    5e28:	68366a76 	ldmvsda	v3!, {a2, a3, v1, v2, v3, v6, v8, SP, LR}
    5e2c:	f9e4f011 	stmnvib	v1!, {a1, v1, IP, SP, LR, PC}^
    5e30:	0a001c07 	beq	0xce54
    5e34:	20007020 	andcs	v4, a1, a1, lsr #32
    5e38:	78207060 	stmvcda	a1!, {v2, v3, IP, SP, LR}
    5e3c:	d0052800 	andle	a3, v2, a1, lsl #16
    5e40:	2100201e 	tstcs	a1, LR, lsl a1
    5e44:	1e401ca4 	cdpne	12, 4, cr1, cr0, cr4, {5}
    5e48:	d1fc5421 	mvnles	v2, a2, lsr #8
    5e4c:	e2082020 	and	a3, v5, #32	; 0x20
    5e50:	1ca2466b 	stcne	6, cr4, [a3], #428
    5e54:	2091990a 	addcss	v6, a2, v7, lsl #18
    5e58:	68364e8e 	ldmvsda	v3!, {a2, a3, a4, v4, v6, v7, v8, LR}
    5e5c:	6a766936 	bvs	0x1da033c
    5e60:	f0116836 	andnvs	v3, a2, v3, lsr v5
    5e64:	1c07f9c9 	stcne	9, cr15, [v4], {201}
    5e68:	70200a00 	eorvc	a1, a1, a1, lsl #20
    5e6c:	70602000 	rsbvc	a3, a1, a1
    5e70:	28007820 	stmcsda	a1, {v2, v8, IP, SP, LR}
    5e74:	201ed0ea 	andcss	SP, LR, v7, ror #1
    5e78:	1ca42100 	stfnes	f2, [v1]
    5e7c:	54211e40 	strplt	a2, [a2], #-3648
    5e80:	e7e3d1fc 	undefined
    5e84:	22002300 	andcs	a3, a1, #0	; 0x0
    5e88:	20922100 	addcss	a3, a3, a1, lsl #2
    5e8c:	68364e81 	ldmvsda	v3!, {a1, v4, v6, v7, v8, LR}
    5e90:	6a766936 	bvs	0x1da0370
    5e94:	f0116836 	andnvs	v3, a2, v3, lsr v5
    5e98:	1c07f9af 	stcne	9, cr15, [v4], {175}
    5e9c:	70200a00 	eorvc	a1, a1, a1, lsl #20
    5ea0:	70602000 	rsbvc	a3, a1, a1
    5ea4:	e1dc2002 	bics	a3, IP, a3
    5ea8:	7840980a 	stmvcda	a1, {a2, a4, v8, IP, PC}^
    5eac:	990a9001 	stmlsdb	v7, {a1, IP, PC}
    5eb0:	02097889 	andeq	v4, v6, #8978432	; 0x890000
    5eb4:	91014301 	tstls	a2, a2, lsl #6
    5eb8:	990a1c08 	stmlsdb	v7, {a4, v7, v8, IP}
    5ebc:	040978c9 	streq	v4, [v6], #-2249
    5ec0:	91014301 	tstls	a2, a2, lsl #6
    5ec4:	990a1c08 	stmlsdb	v7, {a4, v7, v8, IP}
    5ec8:	06097909 	streq	v4, [v6], -v6, lsl #18
    5ecc:	91014301 	tstls	a2, a2, lsl #6
    5ed0:	7840980a 	stmvcda	a1, {a2, a4, v8, IP, PC}^
    5ed4:	980a7060 	stmlsda	v7, {v2, v3, IP, SP, LR}
    5ed8:	70a07880 	adcvc	v4, a1, a1, lsl #17
    5edc:	78c0980a 	stmvcia	a1, {a2, a4, v8, IP, PC}^
    5ee0:	980a70e0 	stmlsda	v7, {v2, v3, v4, IP, SP, LR}
    5ee4:	71207900 	teqvc	a1, a1, lsl #18
    5ee8:	7940980a 	stmvcdb	a1, {a2, a4, v8, IP, PC}^
    5eec:	980a7160 	stmlsda	v7, {v2, v3, v5, IP, SP, LR}
    5ef0:	71a07980 	movvc	v4, a1, lsl #19
    5ef4:	7a00980a 	bvc	0x2bf24
    5ef8:	90000200 	andls	a1, a1, a1, lsl #4
    5efc:	79c9990a 	stmvcib	v6, {a2, a4, v5, v8, IP, PC}^
    5f00:	91004301 	tstls	a1, a2, lsl #6
    5f04:	1dc81c0e 	stcnel	12, cr1, [v5, #56]
    5f08:	466b7028 	strmibt	v4, [v8], -v5, lsr #32
    5f0c:	a9011d62 	stmgedb	a2, {a2, v2, v3, v5, v7, v8, IP}
    5f10:	4d602094 	stcmil	0, cr2, [a1, #-592]!
    5f14:	692d682d 	stmvsdb	SP!, {a1, a3, a4, v2, v8, SP, LR}
    5f18:	682d6a6d 	stmvsda	SP!, {a1, a3, a4, v2, v3, v6, v8, SP, LR}
    5f1c:	f96ef011 	stmnvdb	LR!, {a1, v1, IP, SP, LR, PC}^
    5f20:	0a001c07 	beq	0xcf44
    5f24:	98007020 	stmlsda	a1, {v2, IP, SP, LR}
    5f28:	98007160 	stmlsda	a1, {v2, v3, v5, IP, SP, LR}
    5f2c:	0e000400 	cfcpyseq	mvf0, mvf0
    5f30:	980071a0 	stmlsda	a1, {v2, v4, v5, IP, SP, LR}
    5f34:	0c360436 	cfldrseq	mvf0, [v3], #-216
    5f38:	d30042b0 	tstle	a1, #11	; 0xb
    5f3c:	9800e192 	stmlsda	a1, {a2, v1, v4, v5, SP, LR, PC}
    5f40:	04001a30 	streq	a2, [a1], #-2608
    5f44:	21000c00 	tstcs	a1, a1, lsl #24
    5f48:	18a29a00 	stmneia	a3!, {v6, v8, IP, PC}
    5f4c:	e6b01dd2 	ssat	a2, #17, a3, ASR #27
    5f50:	7840980a 	stmvcda	a1, {a2, a4, v8, IP, PC}^
    5f54:	980a7060 	stmlsda	v7, {v2, v3, IP, SP, LR}
    5f58:	70a07880 	adcvc	v4, a1, a1, lsl #17
    5f5c:	78c0980a 	stmvcia	a1, {a2, a4, v8, IP, PC}^
    5f60:	980a70e0 	stmlsda	v7, {v2, v3, v4, IP, SP, LR}
    5f64:	71207900 	teqvc	a1, a1, lsl #18
    5f68:	7840980a 	stmvcda	a1, {a2, a4, v8, IP, PC}^
    5f6c:	990a9001 	stmlsdb	v7, {a1, IP, PC}
    5f70:	02097889 	andeq	v4, v6, #8978432	; 0x890000
    5f74:	91014301 	tstls	a2, a2, lsl #6
    5f78:	990a1c08 	stmlsdb	v7, {a4, v7, v8, IP}
    5f7c:	040978c9 	streq	v4, [v6], #-2249
    5f80:	91014301 	tstls	a2, a2, lsl #6
    5f84:	990a1c08 	stmlsdb	v7, {a4, v7, v8, IP}
    5f88:	06097909 	streq	v4, [v6], -v6, lsl #18
    5f8c:	91014301 	tstls	a2, a2, lsl #6
    5f90:	7a00980a 	bvc	0x2bfc0
    5f94:	90000200 	andls	a1, a1, a1, lsl #4
    5f98:	79c9990a 	stmvcib	v6, {a2, a4, v5, v8, IP, PC}^
    5f9c:	91004301 	tstls	a1, a2, lsl #6
    5fa0:	990a980a 	stmlsdb	v7, {a2, a4, v8, IP, PC}
    5fa4:	72017989 	andvc	v4, a2, #2244608	; 0x224000
    5fa8:	990a980a 	stmlsdb	v7, {a2, a4, v8, IP, PC}
    5fac:	71c17949 	bicvc	v4, a2, v6, asr #18
    5fb0:	9a0a466b 	bls	0x297964
    5fb4:	a9011dd2 	stmgedb	a2, {a2, v1, v3, v4, v5, v7, v8, IP}
    5fb8:	4e362095 	mrcmi	0, 1, a3, cr6, cr5, {4}
    5fbc:	69366836 	ldmvsdb	v3!, {a2, a3, v1, v2, v8, SP, LR}
    5fc0:	68366a76 	ldmvsda	v3!, {a2, a3, v1, v2, v3, v6, v8, SP, LR}
    5fc4:	f918f011 	ldmnvdb	v5, {a1, v1, IP, SP, LR, PC}
    5fc8:	0a001c07 	beq	0xcfec
    5fcc:	98007020 	stmlsda	a1, {v2, IP, SP, LR}
    5fd0:	98007160 	stmlsda	a1, {v2, v3, v5, IP, SP, LR}
    5fd4:	0e000400 	cfcpyseq	mvf0, mvf0
    5fd8:	200771a0 	andcs	v4, v4, a1, lsr #3
    5fdc:	208ae141 	addcs	LR, v7, a2, asr #2
    5fe0:	20047020 	andcs	v4, v1, a1, lsr #32
    5fe4:	1c622100 	stfnee	f2, [a3]
    5fe8:	54111e40 	ldrpl	a2, [a2], #-3648
    5fec:	2005d1fc 	strcsd	SP, [v2], -IP
    5ff0:	07f67028 	ldreqb	v4, [v3, v5, lsr #32]!
    5ff4:	2000d530 	andcs	SP, a1, a1, lsr v2
    5ff8:	5c09499d 	stcpl	9, cr4, [v6], {157}
    5ffc:	18129a0a 	ldmneda	a3, {a2, a4, v6, v8, IP, PC}
    6000:	42917852 	addmis	v4, a2, #5373952	; 0x520000
    6004:	1c40d128 	stfnep	f5, [a1], {40}
    6008:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    600c:	d3f32812 	mvnles	a3, #1179648	; 0x120000
    6010:	4820d122 	stmmida	a1!, {a2, v2, v5, IP, LR, PC}
    6014:	68c16800 	stmvsia	a2, {v8, SP, LR}^
    6018:	22756a49 	rsbcss	v3, v2, #299008	; 0x49000
    601c:	33751c0b 	cmncc	v2, #2816	; 0xb00
    6020:	25fe781b 	ldrcsb	v4, [LR, #2075]!
    6024:	548d401d 	strpl	v1, [SP], #29
    6028:	6a4968c1 	bvs	0x1260334
    602c:	68c23175 	stmvsia	a3, {a1, a3, v1, v2, v3, v5, IP, SP}^
    6030:	32756a52 	rsbccs	v3, v2, #335872	; 0x52000
    6034:	23027812 	tstcs	a3, #1179648	; 0x120000
    6038:	700b4313 	andvc	v1, v8, a4, lsl a4
    603c:	6a406a00 	bvs	0x1020844
    6040:	8001498c 	andhi	v1, a2, IP, lsl #19
    6044:	70202000 	eorvc	a3, a1, a1
    6048:	70602059 	rsbvc	a3, a1, v6, asr a1
    604c:	70a02065 	adcvc	a3, a1, v2, rrx
    6050:	70e02073 	rscvc	a3, a1, a4, ror a1
    6054:	71202000 	teqvc	a1, a1
    6058:	2001e104 	andcs	LR, a2, v1, lsl #2
    605c:	a9037028 	stmgedb	a4, {a4, v2, IP, SP, LR}
    6060:	1c40980a 	mcrrne	8, 0, v6, a1, cr10
    6064:	2300b403 	tstcs	a1, #50331648	; 0x3000000
    6068:	21002200 	tstcs	a1, a1, lsl #4
    606c:	f001200e 	andnv	a3, a2, LR
    6070:	b002ffa9 	andlt	PC, a3, v6, lsr #31
    6074:	d1092800 	tstle	v6, a1, lsl #16
    6078:	70202000 	eorvc	a3, a1, a1
    607c:	1c49990a 	mcrrne	9, 0, v6, v6, cr10
    6080:	4aad4882 	bmi	0xfeb58290
    6084:	f0011810 	andnv	a2, a2, a1, lsl v5
    6088:	e0ebfd6b 	rsc	PC, v8, v8, ror #26
    608c:	70202094 	mlavc	a1, v1, a1, a3
    6090:	46c0e0e8 	strmib	LR, [a1], v5, ror #1
    6094:	00009624 	andeq	v6, a1, v1, lsr #12
    6098:	1c612000 	stcnel	0, cr2, [a2]
    609c:	00d2228f 	sbceqs	a3, a3, PC, lsl #5
    60a0:	181b4ba5 	ldmneda	v8, {a1, a3, v2, v4, v5, v6, v8, LR}
    60a4:	540a5c9a 	strpl	v2, [v7], #-3226
    60a8:	06001c40 	streq	a2, [a1], -a1, asr #24
    60ac:	28070e00 	stmcsda	v4, {v6, v7, v8}
    60b0:	2000d3f3 	strcsd	SP, [a1], -a4
    60b4:	20087020 	andcs	v4, v5, a1, lsr #32
    60b8:	2000e0d3 	ldrcsd	LR, [a1], -a4
    60bc:	49737020 	ldmmidb	a4!, {v2, IP, SP, LR}^
    60c0:	18514a9d 	ldmneda	a2, {a1, a3, a4, v1, v4, v6, v8, LR}^
    60c4:	200f1c62 	andcs	a2, PC, a3, ror #24
    60c8:	5c0b1e40 	stcpl	14, cr1, [v8], {64}
    60cc:	d1fb5413 	mvnles	v2, a4, lsl v1
    60d0:	00c0208f 	sbceq	a3, a1, PC, lsl #1
    60d4:	18094998 	stmneda	v6, {a4, v1, v4, v5, v8, LR}
    60d8:	30101c20 	andccs	a2, a1, a1, lsr #24
    60dc:	fd2cf001 	stc2	0, cr15, [IP, #-4]!
    60e0:	49954865 	ldmmiib	v2, {a1, a3, v2, v3, v8, LR}
    60e4:	75e05c08 	strvcb	v2, [a1, #3080]!
    60e8:	5c084864 	stcpl	8, cr4, [v5], {100}
    60ec:	48647620 	stmmida	v1!, {v2, v6, v7, IP, SP, LR}^
    60f0:	76605c08 	strvcbt	v2, [a1], -v5, lsl #24
    60f4:	5c084863 	stcpl	8, cr4, [v5], {99}
    60f8:	496576a0 	stmmidb	v2!, {v2, v4, v6, v7, IP, SP, LR}^
    60fc:	69096809 	stmvsdb	v6, {a1, a4, v8, SP, LR}
    6100:	1d096a49 	fstsne	s12, [v6, #-292]
    6104:	2004341b 	andcs	a4, v1, v8, lsl v1
    6108:	5c0a1e40 	stcpl	14, cr1, [v7], {64}
    610c:	d1fb5422 	mvnles	v2, a3, lsr #8
    6110:	e0a6201f 	adc	a3, v3, PC, lsl a1
    6114:	22002300 	andcs	a3, a1, #0	; 0x0
    6118:	20a02100 	adccs	a3, a1, a1, lsl #2
    611c:	68364e5c 	ldmvsda	v3!, {a3, a4, v1, v3, v6, v7, v8, LR}
    6120:	6a766936 	bvs	0x1da0600
    6124:	f0116836 	andnvs	v3, a2, v3, lsr v5
    6128:	1c07f867 	stcne	8, cr15, [v4], {103}
    612c:	e0962000 	adds	a3, v3, a1
    6130:	70212100 	eorvc	a3, a2, a1, lsl #2
    6134:	7849990a 	stmvcda	v6, {a2, a4, v5, v8, IP, PC}^
    6138:	990a7061 	stmlsdb	v7, {a1, v2, v3, IP, SP, LR}
    613c:	29007849 	stmcsdb	a1, {a1, a4, v3, v8, IP, SP, LR}
    6140:	9802d107 	stmlsda	a3, {a1, a2, a3, v5, IP, LR, PC}
    6144:	99027800 	stmlsdb	a3, {v8, IP, SP, LR}
    6148:	1a407849 	bne	0x1024274
    614c:	0e800680 	cdpeq	6, 8, cr0, cr0, cr0, {4}
    6150:	7801e004 	stmvcda	a2, {a3, SP, LR, PC}
    6154:	1a087840 	bne	0x22425c
    6158:	0e400640 	cdpeq	6, 4, cr0, cr0, cr0, {2}
    615c:	200370a0 	andcs	v4, a4, a1, lsr #1
    6160:	2100e07f 	tstcs	a1, PC, ror a1
    6164:	990a7021 	stmlsdb	v7, {a1, v2, IP, SP, LR}
    6168:	70617849 	rsbvc	v4, a2, v6, asr #16
    616c:	7889990a 	stmvcia	v6, {a2, a4, v5, v8, IP, PC}
    6170:	07f67029 	ldreqb	v4, [v3, v6, lsr #32]!
    6174:	223bd501 	eorcss	SP, v8, #4194304	; 0x400000
    6178:	2279e000 	rsbcss	LR, v6, #0	; 0x0
    617c:	785b9b0a 	ldmvcda	v8, {a2, a4, v5, v6, v8, IP, PC}^
    6180:	d1382b00 	teqle	v5, a1, lsl #22
    6184:	d32d428a 	teqle	SP, #-1610612728	; 0xa0000008
    6188:	e0122100 	ands	a3, a3, a1, lsl #2
    618c:	483e1862 	ldmmida	LR!, {a2, v2, v3, v8, IP}
    6190:	18f34e69 	ldmneia	a4!, {a1, a4, v2, v3, v6, v7, v8, LR}^
    6194:	70d05c18 	sbcvcs	v2, a1, v5, lsl IP
    6198:	78429802 	stmvcda	a3, {a2, v8, IP, PC}^
    619c:	9b021c50 	blls	0x8d2e4
    61a0:	11461c52 	cmpne	v3, a3, asr IP
    61a4:	18300eb6 	ldmneda	a1!, {a2, a3, v1, v2, v4, v6, v7, v8}
    61a8:	400626c0 	andmi	a3, v3, a1, asr #13
    61ac:	70581b90 	ldrvcb	a2, [v5], #-176
    61b0:	78281c49 	stmvcda	v5!, {a1, a4, v3, v7, v8, IP}
    61b4:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    61b8:	d2054281 	andle	v1, v2, #268435464	; 0x10000008
    61bc:	78439802 	stmvcda	a4, {a2, v8, IP, PC}^
    61c0:	78009802 	stmvcda	a1, {a2, v8, IP, PC}
    61c4:	d1e14298 	strleb	v1, [a2, #40]!
    61c8:	782870a1 	stmvcda	v5!, {a1, v2, v4, IP, SP, LR}
    61cc:	22001a40 	andcs	a2, a1, #262144	; 0x40000
    61d0:	1cc91861 	stcnel	8, cr1, [v6], {97}
    61d4:	d0022800 	andle	a3, a3, a1, lsl #16
    61d8:	540a1e40 	strpl	a2, [v7], #-3648
    61dc:	7828d1fc 	stmvcda	v5!, {a3, a4, v1, v2, v3, v4, v5, IP, LR, PC}
    61e0:	e03e1cc0 	eors	a2, LR, a1, asr #25
    61e4:	7020208a 	eorvc	a3, a1, v7, lsl #1
    61e8:	7840980a 	stmvcda	a1, {a2, a4, v8, IP, PC}^
    61ec:	20007060 	andcs	v4, a1, a1, rrx
    61f0:	702870a0 	eorvc	v4, v5, a1, lsr #1
    61f4:	428ae7f3 	addmi	LR, v7, #63700992	; 0x3cc0000
    61f8:	2100d3f4 	strcsd	SP, [a1, -v1]
    61fc:	0609782a 	streq	v4, [v6], -v7, lsr #16
    6200:	42910e09 	addmis	a1, a2, #144	; 0x90
    6204:	7843d2e0 	stmvcda	a4, {v2, v3, v4, v6, IP, LR, PC}^
    6208:	429a7802 	addmis	v4, v7, #131072	; 0x20000
    620c:	1866d0dc 	stmneda	v3!, {a3, a4, v1, v3, v4, IP, LR, PC}^
    6210:	46944a20 	ldrmi	v1, [v1], a1, lsr #20
    6214:	18d24a48 	ldmneia	a3, {a4, v3, v6, v8, LR}^
    6218:	5cd24663 	ldcpll	6, cr4, [a3], {99}
    621c:	784370f2 	stmvcda	a4, {a2, v1, v2, v3, v4, IP, SP, LR}^
    6220:	1c5b1c5a 	mrrcne	12, 5, a2, v8, cr10
    6224:	0eb61156 	mrceq	1, 5, a2, cr6, cr6, {2}
    6228:	26c018b2 	undefined
    622c:	1b9a4016 	blne	0xfe69628c
    6230:	1c497042 	mcrrne	0, 4, v4, v6, cr2
    6234:	07f6e7e2 	ldreqb	LR, [v3, a3, ror #15]!
    6238:	a903d510 	stmgedb	a4, {v1, v5, v7, IP, LR, PC}
    623c:	20001c89 	andcs	a2, a1, v6, lsl #25
    6240:	2300b403 	tstcs	a1, #50331648	; 0x3000000
    6244:	21002200 	tstcs	a1, a1, lsl #4
    6248:	f001200b 	andnv	a3, a2, v8
    624c:	b002febb 	strlth	PC, [a3], -v8
    6250:	d1012800 	tstle	a2, a1, lsl #16
    6254:	e0022000 	and	a3, a3, a1
    6258:	e000208a 	and	a3, a1, v7, lsl #1
    625c:	7020208a 	eorvc	a3, a1, v7, lsl #1
    6260:	70282001 	eorvc	a3, v5, a2
    6264:	0c000438 	cfstrseq	mvf0, [a1], {56}
    6268:	f001b00b 	andnv	v8, a2, v8
    626c:	46c0ff69 	strmib	PC, [a1], v6, ror #30
    6270:	00118d8c 	andeqs	v5, a2, IP, lsl #27
    6274:	0000a55a 	andeq	v7, a1, v7, asr v2
    6278:	000003d7 	ldreqd	a1, [a1], -v4
    627c:	00000406 	andeq	a1, a1, v3, lsl #8
    6280:	00000435 	andeq	a1, a1, v2, lsr v1
    6284:	00000464 	andeq	a1, a1, v1, ror #8
    6288:	0000071d 	andeq	a1, a1, SP, lsl v4
    628c:	00000466 	andeq	a1, a1, v3, ror #8
    6290:	00009624 	andeq	v6, a1, v1, lsr #12
    6294:	0000058d 	andeq	a1, a1, SP, lsl #11
    6298:	a900b5f1 	stmgedb	a1, {a1, v1, v2, v3, v4, v5, v7, IP, SP, PC}
    629c:	46681c89 	strmibt	a2, [v5], -v6, lsl #25
    62a0:	fbb4f00a 	blx	0xfed422d2
    62a4:	28011c04 	stmcsda	a2, {a3, v7, v8, IP}
    62a8:	4668d13b 	undefined
    62ac:	28008800 	stmcsda	a1, {v8, PC}
    62b0:	4668d037 	undefined
    62b4:	491f8800 	ldmmidb	PC, {v8, PC}
    62b8:	18514a1f 	ldmneda	a2, {a1, a2, a3, a4, v1, v6, v8, LR}^
    62bc:	4b1e4a21 	blmi	0x798b48
    62c0:	2800189a 	stmcsda	a1, {a2, a4, v1, v4, v8, IP}
    62c4:	1e40d003 	cdpne	0, 4, cr13, cr0, cr3, {0}
    62c8:	54135c0b 	ldrpl	v2, [a4], #-3083
    62cc:	481ad1fb 	ldmmida	v7, {a1, a2, a4, v1, v2, v3, v4, v5, IP, LR, PC}
    62d0:	5c41491a 	mcrrpl	9, 1, v1, a2, cr10
    62d4:	18854a1a 	stmneia	v2, {a2, a4, v1, v6, v8, LR}
    62d8:	d1022901 	tstle	a3, a2, lsl #18
    62dc:	f834f000 	ldmnvda	v1!, {IP, SP, LR, PC}
    62e0:	2902e01d 	stmcsdb	a3, {a1, a3, a4, v1, SP, LR, PC}
    62e4:	4669d11d 	undefined
    62e8:	70298809 	eorvc	v5, v6, v6, lsl #16
    62ec:	1845490f 	stmneda	v2, {a1, a2, a3, a4, v5, v8, LR}^
    62f0:	88094669 	stmhida	v6, {a1, a4, v2, v3, v6, v7, LR}
    62f4:	490e7029 	stmmidb	LR, {a1, a4, v2, IP, SP, LR}
    62f8:	46691846 	strmibt	a2, [v6], -v3, asr #16
    62fc:	b4028849 	strlt	v5, [a3], #-2121
    6300:	1c2a2302 	stcne	3, cr2, [v7], #-8
    6304:	4f0f1c31 	swimi	0x000f1c31
    6308:	f7ff19c0 	ldrnvb	a2, [PC, a1, asr #19]!
    630c:	7829faa3 	stmvcda	v6!, {a1, a2, v2, v4, v6, v8, IP, SP, LR, PC}
    6310:	2900b001 	stmcsdb	a1, {a1, IP, SP, PC}
    6314:	1c0ad005 	stcne	0, cr13, [v7], {5}
    6318:	f00a1c30 	andnv	a2, v7, a1, lsr IP
    631c:	2000fb07 	andcs	PC, a1, v4, lsl #22
    6320:	1c207028 	stcne	0, cr7, [a1], #-160
    6324:	bc02bcf8 	stclt	12, cr11, [a3], {248}
    6328:	46c04708 	strmib	v1, [a1], v5, lsl #14
    632c:	00000589 	andeq	a1, a1, v6, lsl #11
    6330:	00000509 	andeq	a1, a1, v6, lsl #10
    6334:	0000076e 	andeq	a1, a1, LR, ror #14
    6338:	00008a54 	andeq	v5, a1, v1, asr v7
    633c:	00000763 	andeq	a1, a1, a4, ror #14
    6340:	00000505 	andeq	a1, a1, v2, lsl #10
    6344:	00000485 	andeq	a1, a1, v2, lsl #9
    6348:	f000b5f1 	strnvd	v8, [a1], -a2
    634c:	2800f97d 	stmcsda	a1, {a1, a3, a4, v1, v2, v3, v5, v8, IP, SP, LR, PC}
    6350:	486ed023 	stmmida	LR!, {a1, a2, v2, IP, LR, PC}^
    6354:	180849b8 	stmneda	v5, {a4, v1, v2, v4, v5, v8, LR}
    6358:	4a6d7a01 	bmi	0x1b64b64
    635c:	189a4bb6 	ldmneia	v7, {a2, a3, v1, v2, v4, v5, v6, v8, LR}
    6360:	78139200 	ldmvcda	a4, {v6, IP, PC}
    6364:	4c6c7802 	stcmil	8, cr7, [IP], #-8
    6368:	192d4db3 	stmnedb	SP!, {a1, a2, v1, v2, v4, v5, v7, v8, LR}
    636c:	68244c6f 	stmvsda	v1!, {a1, a2, a3, a4, v2, v3, v7, v8, LR}
    6370:	2e1579c6 	cdpcs	9, 1, cr7, cr5, cr6, {6}
    6374:	2e16d012 	mrccs	0, 0, SP, cr6, cr2, {0}
    6378:	2e17d02b 	cdpcs	0, 1, cr13, cr7, cr11, {1}
    637c:	2e1ad02e 	cdpcs	0, 1, cr13, cr10, cr14, {1}
    6380:	2e1bd03d 	mrccs	0, 0, SP, cr11, cr13, {1}
    6384:	e091d100 	adds	SP, a2, a1, lsl #2
    6388:	d1002e1e 	tstle	a1, LR, lsl LR
    638c:	2e1fe095 	mrccs	0, 0, LR, cr15, cr5, {4}
    6390:	e09bd100 	adds	SP, v8, a1, lsl #2
    6394:	d1002e20 	tstle	a1, a1, lsr #28
    6398:	e0b5e09e 	umlals	LR, v2, LR, a1
    639c:	d1fc2b11 	mvnles	a3, a2, lsl v8
    63a0:	49a5485c 	stmmiib	v2!, {a3, a4, v1, v3, v8, LR}
    63a4:	38b91809 	ldmccia	v6!, {a1, a4, v8, IP}
    63a8:	18104aa3 	ldmneda	a1, {a1, a2, v2, v4, v6, v8, LR}
    63ac:	fbc4f001 	blx	0xff1423ba
    63b0:	6800485e 	stmvsda	a1, {a2, a3, a4, v1, v3, v8, LR}
    63b4:	6a496a81 	bvs	0x1260dc0
    63b8:	6a406a80 	bvs	0x1020dc0
    63bc:	22c07fc0 	sbccs	v4, a1, #768	; 0x300
    63c0:	77ca4302 	strvcb	v1, [v7, a3, lsl #6]
    63c4:	21009800 	tstcs	a1, a1, lsl #16
    63c8:	98006141 	stmlsda	a1, {a1, v3, v5, SP, LR}
    63cc:	70012106 	andvc	a3, a2, v3, lsl #2
    63d0:	2b11e09a 	blcs	0x47e640
    63d4:	9800d1fc 	stmlsda	a1, {a3, a4, v1, v2, v3, v4, v5, IP, LR, PC}
    63d8:	e7f82105 	ldrb	a3, [v5, v2, lsl #2]!
    63dc:	d0f72950 	rscles	a3, v4, a1, asr v6
    63e0:	d0f52953 	rscles	a3, v2, a4, asr v6
    63e4:	6a406aa0 	bvs	0x1020e6c
    63e8:	70013025 	andvc	a4, a2, v2, lsr #32
    63ec:	6a406aa0 	bvs	0x1020e74
    63f0:	6a496aa1 	bvs	0x1260e7c
    63f4:	22087fc9 	andcs	v4, v5, #804	; 0x324
    63f8:	77c2430a 	strvcb	v1, [a3, v7, lsl #6]
    63fc:	2100e084 	smlabbcs	a1, v1, a1, LR
    6400:	4a454f8d 	bmi	0x115a23c
    6404:	434b232f 	cmpmi	v8, #-1140850688	; 0xbc000000
    6408:	18e34c8b 	stmneia	a4!, {a1, a2, a4, v4, v7, v8, LR}^
    640c:	7813189a 	ldmvcda	a4, {a2, a4, v1, v4, v8, IP}
    6410:	42a37a44 	adcmi	v4, a4, #278528	; 0x44000
    6414:	7803d130 	stmvcda	a4, {v1, v2, v5, IP, LR, PC}
    6418:	408c2410 	addmi	a3, IP, a1, lsl v1
    641c:	401d43e5 	andmis	v1, SP, v2, ror #7
    6420:	24077005 	strcs	v4, [v4], #-5
    6424:	4b3d2500 	blmi	0xf4f82c
    6428:	434e262f 	cmpmi	LR, #49283072	; 0x2f00000
    642c:	18f319be 	ldmneia	a4!, {a2, a3, a4, v1, v2, v4, v5, v8, IP}^
    6430:	551d1e64 	ldrpl	a2, [SP, #-3684]
    6434:	2410d1fc 	ldrcs	SP, [a1], #-508
    6438:	262f4b39 	undefined
    643c:	19be434e 	ldmneib	LR!, {a2, a3, a4, v3, v5, v6, LR}
    6440:	1e6418f3 	mcrne	8, 3, a2, cr4, cr3, {7}
    6444:	d1fc551d 	mvnles	v2, SP, lsl v2
    6448:	4b362404 	blmi	0xd8f460
    644c:	434e262f 	cmpmi	LR, #49283072	; 0x2f00000
    6450:	18f319be 	ldmneia	a4!, {a2, a3, a4, v1, v2, v4, v5, v8, IP}^
    6454:	551d1e64 	ldrpl	a2, [SP, #-3684]
    6458:	2410d1fc 	ldrcs	SP, [a1], #-508
    645c:	262f4b32 	undefined
    6460:	4e754371 	mrcmi	3, 3, v1, cr5, cr1, {3}
    6464:	18c91871 	stmneia	v6, {a1, v1, v2, v3, v8, IP}^
    6468:	550d1e64 	strpl	a2, [SP, #-3684]
    646c:	21ffd1fc 	ldrcssh	SP, [pc, #28]	; 0x6490
    6470:	70557011 	subvcs	v4, v2, a2, lsl a1
    6474:	21047095 	swpcs	v4, v2, [v1]
    6478:	06091c49 	streq	a2, [v6], -v6, asr #24
    647c:	29040e09 	stmcsdb	v1, {a1, a4, v6, v7, v8}
    6480:	492ad3bf 	stmmidb	v7!, {a1, a2, a3, a4, v1, v2, v4, v5, v6, IP, LR, PC}
    6484:	78006809 	stmvcda	a1, {a1, a4, v8, SP, LR}
    6488:	421022f0 	andmis	a3, a1, #15	; 0xf
    648c:	6a88d105 	bvs	0xfe23a8a8
    6490:	7fc26a40 	swivc	0x00c26a40
    6494:	401323fd 	ldrmish	a3, [a4], -SP
    6498:	6a8877c3 	bvs	0xfe2243ac
    649c:	6a896a40 	bvs	0xfe260da4
    64a0:	7e896a49 	cdpvc	10, 8, cr6, cr9, cr9, {2}
    64a4:	430a2208 	tstmi	v7, #-2147483648	; 0x80000000
    64a8:	e02d7682 	eor	v4, SP, a3, lsl #13
    64ac:	d1062901 	tstle	v3, a2, lsl #18
    64b0:	70297a41 	eorvc	v4, v6, a2, asr #20
    64b4:	43112102 	tstmi	a2, #-2147483648	; 0x80000000
    64b8:	2901e789 	stmcsdb	a2, {a1, a4, v4, v5, v6, v7, SP, LR, PC}
    64bc:	21ffd124 	mvncss	SP, v1, lsr #2
    64c0:	78017029 	stmvcda	a2, {a1, a4, v2, IP, SP, LR}
    64c4:	400a22fd 	strmid	a3, [v7], -SP
    64c8:	e01d7002 	ands	v4, SP, a3
    64cc:	6a406aa0 	bvs	0x1020f54
    64d0:	06497fc1 	streqb	v4, [v6], -a2, asr #31
    64d4:	e0160e49 	ands	a1, v3, v6, asr #28
    64d8:	4b574915 	blmi	0x15d8934
    64dc:	29015c59 	stmcsdb	a2, {a1, a4, v1, v3, v7, v8, IP, LR}
    64e0:	2101d109 	tstcs	a2, v6, lsl #2
    64e4:	7002430a 	andvc	v1, a3, v7, lsl #6
    64e8:	6a406aa0 	bvs	0x1020f70
    64ec:	6a526aa2 	bvs	0x14a0f7c
    64f0:	43117fd2 	tstmi	a2, #840	; 0x348
    64f4:	21fee007 	mvncss	LR, v4
    64f8:	400a7802 	andmi	v4, v7, a3, lsl #16
    64fc:	6aa07002 	bvs	0xfe82250c
    6500:	7fc26a40 	swivc	0x00c26a40
    6504:	77c14011 	undefined
    6508:	fc42f001 	mcrr2	0, 0, PC, a3, cr1
    650c:	0000047f 	andeq	a1, a1, PC, ror v1
    6510:	00000bb4 	streqh	a1, [a1], -v1
    6514:	00000487 	andeq	a1, a1, v4, lsl #9
    6518:	000003d5 	ldreqd	a1, [a1], -v2
    651c:	000003ce 	andeq	a1, a1, LR, asr #7
    6520:	000003aa 	andeq	a1, a1, v7, lsr #7
    6524:	000003ba 	streqh	a1, [a1], -v7
    6528:	000003be 	streqh	a1, [a1], -LR
    652c:	00009624 	andeq	v6, a1, v1, lsr #12
    6530:	00000976 	andeq	a1, a1, v3, ror v6
    6534:	2300b570 	tstcs	a1, #469762048	; 0x1c000000
    6538:	e0012400 	and	a3, a2, a1, lsl #8
    653c:	1c645585 	cfstr64ne	mvdx5, [v1], #-532
    6540:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    6544:	d2094294 	andle	v1, v6, #1073741833	; 0x40000009
    6548:	5d0d1c26 	stcpl	12, cr1, [SP, #-152]
    654c:	dbf52d61 	blle	0xffd51ad8
    6550:	daf32d7b 	ble	0xffcd1b44
    6554:	e7f13d20 	ldrb	a4, [a2, a1, lsr #26]!
    6558:	1c525483 	cfldrdne	mvd5, [a3], {131}
    655c:	0e120612 	cfmsub32eq	mvax0, mvfx0, mvfx2, mvfx2
    6560:	d3f92a14 	mvnles	a3, #81920	; 0x14000
    6564:	bc01bc70 	stclt	12, cr11, [a2], {112}
    6568:	00004700 	andeq	v1, a1, a1, lsl #14
    656c:	780b2214 	stmvcda	v8, {a3, v1, v6, SP}
    6570:	d0012b00 	andle	a3, a2, a1, lsl #22
    6574:	e0001c49 	and	a2, a1, v6, asr #24
    6578:	70032300 	andvc	a3, a4, a1, lsl #6
    657c:	1e521c40 	cdpne	12, 5, cr1, cr2, cr0, {2}
    6580:	b000d1f5 	strltd	SP, [a1], -v2
    6584:	00004770 	andeq	v1, a1, a1, ror v4
    6588:	4a2bb5f0 	bmi	0xaf3d50
    658c:	18114811 	ldmneda	a2, {a1, v1, v8, LR}
    6590:	80482000 	subhi	a3, v5, a1
    6594:	48108008 	ldmmida	a1, {a4, PC}
    6598:	e00a1813 	and	a2, v7, a4, lsl v5
    659c:	1956785c 	ldmnedb	v3, {a3, a4, v1, v3, v8, IP, SP, LR}^
    65a0:	19174d0e 	ldmnedb	v4, {a2, a3, a4, v5, v7, v8, LR}
    65a4:	54355d7d 	ldrplt	v2, [v2], #-3453
    65a8:	705c1c64 	subvcs	a2, IP, v1, ror #24
    65ac:	1c408808 	mcrrne	8, 0, v5, a1, cr8
    65b0:	880d8008 	stmhida	SP, {a4, PC}
    65b4:	781c480a 	ldmvcda	IP, {a2, a4, v8, LR}
    65b8:	d3ef42a5 	mvnle	v1, #1342177290	; 0x5000000a
    65bc:	1a698849 	bne	0x1a686e8
    65c0:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    65c4:	f00a1810 	andnv	a2, v7, a1, lsl v5
    65c8:	46c0fe1f 	undefined
    65cc:	bc01bcf0 	stclt	12, cr11, [a2], {240}
    65d0:	46c04700 	strmib	v1, [a1], a1, lsl #14
    65d4:	00000b7e 	andeq	a1, a1, LR, ror v8
    65d8:	00000691 	muleq	a1, a2, v3
    65dc:	00000611 	andeq	a1, a1, a2, lsl v3
    65e0:	00000a7e 	andeq	a1, a1, LR, ror v7
    65e4:	4668b571 	undefined
    65e8:	fef4f00a 	cdp2	0, 15, cr15, cr4, cr10, {0}
    65ec:	88004668 	stmhida	a1, {a4, v2, v3, v6, v7, LR}
    65f0:	d01d2800 	andles	a3, SP, a1, lsl #16
    65f4:	49102000 	ldmmidb	a1, {SP}
    65f8:	188a4a10 	stmneia	v7, {v1, v6, v8, LR}
    65fc:	180c4b10 	stmneda	IP, {v1, v5, v6, v8, LR}
    6600:	781418e3 	ldmvcda	v1, {a1, a2, v2, v3, v4, v8, IP}
    6604:	194d4d0f 	stmnedb	SP, {a1, a2, a3, a4, v5, v7, v8, LR}^
    6608:	552e781e 	strpl	v4, [LR, #-2078]!
    660c:	1c647814 	stcnel	8, cr7, [v1], #-80
    6610:	06247014 	undefined
    6614:	2c800e24 	stccs	14, cr0, [a1], {36}
    6618:	2400d301 	strcs	SP, [a1], #-769
    661c:	24007014 	strcs	v4, [a1], #-20
    6620:	1c40701c 	mcrrne	0, 1, v4, a1, cr12
    6624:	881b466b 	ldmhida	v8, {a1, a2, a4, v2, v3, v6, v7, LR}
    6628:	0c000400 	cfstrseq	mvf0, [a1], {0}
    662c:	d3e54298 	mvnle	v1, #-2147483639	; 0x80000009
    6630:	bc01bc78 	stclt	12, cr11, [a2], {120}
    6634:	00004700 	andeq	v1, a1, a1, lsl #14
    6638:	00008a54 	andeq	v5, a1, v1, asr v7
    663c:	0000060d 	andeq	a1, a1, SP, lsl #12
    6640:	0000097a 	andeq	a1, a1, v7, ror v6
    6644:	0000058d 	andeq	a1, a1, SP, lsl #11
    6648:	2200b570 	andcs	v8, a1, #469762048	; 0x1c000000
    664c:	4b132400 	blmi	0x4cf654
    6650:	5cc14819 	stcpll	8, cr4, [a2], {25}
    6654:	e0031e4e 	and	a2, a4, LR, asr #28
    6658:	5ced1945 	stcpll	9, cr1, [SP], #276
    665c:	1c641952 	stcnel	9, cr1, [v1], #-328
    6660:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    6664:	42b41c25 	adcmis	a2, v1, #9472	; 0x2500
    6668:	0412dbf6 	ldreq	SP, [a3], #-3062
    666c:	42530c12 	submis	a1, a4, #4608	; 0x1200
    6670:	18404a09 	stmneda	a1, {a1, a4, v6, v8, LR}^
    6674:	041b1880 	ldreq	a2, [v8], #-2176
    6678:	0a190c1b 	beq	0x6496ec
    667c:	42917802 	addmis	v4, a2, #131072	; 0x20000
    6680:	7840d106 	stmvcda	a1, {a2, a3, v5, IP, LR, PC}^
    6684:	0e1b061b 	cfmsub32eq	mvax0, mvfx0, mvfx11, mvfx11
    6688:	d1014283 	smlabble	a2, a4, a3, v1
    668c:	e0002001 	and	a3, a1, a2
    6690:	bc702000 	ldcltl	0, cr2, [a1]
    6694:	4708bc02 	strmi	v8, [v5, -a3, lsl #24]
    6698:	00000484 	andeq	a1, a1, v1, lsl #9
    669c:	00000485 	andeq	a1, a1, v2, lsl #9
    66a0:	49052000 	stmmidb	v2, {SP}
    66a4:	54884a05 	strpl	v1, [v5], #2565
    66a8:	5488322f 	strpl	a4, [v5], #559
    66ac:	5488322f 	strpl	a4, [v5], #559
    66b0:	5488322f 	strpl	a4, [v5], #559
    66b4:	00004770 	andeq	v1, a1, a1, ror v4
    66b8:	00008a54 	andeq	v5, a1, v1, asr v7
    66bc:	000003d6 	ldreqd	a1, [a1], -v3
    66c0:	b093b5f0 	ldrltsh	v8, [a4], a1
    66c4:	21004668 	tstcs	a1, v5, ror #12
    66c8:	48da7281 	ldmmiia	v7, {a1, v4, v6, IP, SP, LR}^
    66cc:	180849da 	stmneda	v5, {a2, a4, v1, v3, v4, v5, v8, LR}
    66d0:	48da9008 	ldmmiia	v7, {a4, IP, PC}^
    66d4:	90051808 	andls	a2, v2, v5, lsl #16
    66d8:	180848d9 	stmneda	v5, {a1, a4, v1, v3, v4, v8, LR}
    66dc:	48d99009 	ldmmiia	v6, {a1, a4, IP, PC}^
    66e0:	900d1808 	andls	a2, SP, v5, lsl #16
    66e4:	180848d8 	stmneda	v5, {a4, v1, v3, v4, v8, LR}
    66e8:	48d8900e 	ldmmiia	v5, {a2, a3, a4, IP, PC}^
    66ec:	48d8180c 	ldmmiia	v5, {a3, a4, v8, IP}^
    66f0:	90061808 	andls	a2, v3, v5, lsl #16
    66f4:	180848d7 	stmneda	v5, {a1, a2, a3, v1, v3, v4, v8, LR}
    66f8:	48d79000 	ldmmiia	v4, {IP, PC}^
    66fc:	900b1808 	andls	a2, v8, v5, lsl #16
    6700:	180848d6 	stmneda	v5, {a2, a3, v1, v3, v4, v8, LR}
    6704:	48d69003 	ldmmiia	v3, {a1, a2, IP, PC}^
    6708:	90041808 	andls	a2, v1, v5, lsl #16
    670c:	180d48d5 	stmneda	SP, {a1, a3, v1, v3, v4, v8, LR}
    6710:	180f48d5 	stmneda	PC, {a1, a3, v1, v3, v4, v8, LR}
    6714:	180e48d5 	stmneda	LR, {a1, a3, v1, v3, v4, v8, LR}
    6718:	7c3120fe 	ldcvc	0, cr2, [a2], #-1016
    671c:	d9012910 	stmledb	a2, {v1, v5, v8, SP}
    6720:	f9f9f001 	ldmnvib	v6!, {a1, IP, SP, LR, PC}^
    6724:	0049a201 	subeq	v7, v6, a2, lsl #4
    6728:	44975a52 	ldrmi	v2, [v4], #2642
    672c:	02d20386 	sbceqs	a1, a3, #402653186	; 0x18000002
    6730:	05de05f6 	ldreqb	a1, [LR, #1526]
    6734:	0d5e0f0c 	ldceql	15, cr0, [LR, #-48]
    6738:	11541214 	cmpne	v1, v1, lsl a3
    673c:	11c411a8 	bicne	a2, v1, v5, lsr #3
    6740:	002009b8 	streqh	a1, [a1], -v5
    6744:	060a08ec 	streq	a1, [v7], -IP, ror #17
    6748:	126212e4 	rsbne	a2, a3, #1073741838	; 0x4000000e
    674c:	7c391358 	ldcvc	3, cr1, [v6], #-352
    6750:	2a097c72 	bcs	0x265920
    6754:	e192d900 	orrs	SP, a3, a1, lsl #18
    6758:	0052a301 	subeqs	v7, a3, a2, lsl #6
    675c:	449f5a9b 	ldrmi	v2, [pc], #2715	; 0x6764
    6760:	002e0012 	eoreq	a1, LR, a3, lsl a1
    6764:	00580036 	subeqs	a1, v5, v3, lsr a1
    6768:	00c2008c 	sbceq	a1, a3, IP, lsl #1
    676c:	01bc0126 	moveqs	a1, v3, lsr #2
    6770:	025e01fe 	subeqs	a1, LR, #-2147483585	; 0x8000003f
    6774:	680048be 	stmvsda	a1, {a2, a3, a4, v1, v2, v4, v8, LR}
    6778:	6a406a80 	bvs	0x1021180
    677c:	680949bc 	stmvsda	v6, {a3, a4, v1, v2, v4, v5, v8, LR}
    6780:	6a496a89 	bvs	0x12611ac
    6784:	22047fc9 	andcs	v4, v1, #804	; 0x324
    6788:	77c2430a 	strvcb	v1, [a3, v7, lsl #6]
    678c:	e2412001 	sub	a3, a2, #1	; 0x1
    6790:	f0019809 	andnv	v6, a2, v6, lsl #16
    6794:	e172fb89 	cmnp	a3, v6, lsl #23
    6798:	21019800 	tstcs	a2, a1, lsl #16
    679c:	76317081 	ldrvct	v4, [a2], -a2, lsl #1
    67a0:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    67a4:	22007470 	andcs	v4, a1, #1879048192	; 0x70000000
    67a8:	20002100 	andcs	a3, a1, a1, lsl #2
    67ac:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    67b0:	f00a2027 	andnv	a3, v7, v4, lsr #32
    67b4:	b003fa17 	andlt	PC, a4, v4, lsl v7
    67b8:	2928e161 	stmcsdb	v5!, {a1, v2, v3, v5, SP, LR, PC}
    67bc:	e15ed000 	cmp	LR, a1
    67c0:	208f9905 	addcs	v6, PC, v2, lsl #18
    67c4:	4a9c00c0 	bmi	0xfe706acc
    67c8:	f0011810 	andnv	a2, a2, a1, lsl v5
    67cc:	9805f9b5 	stmlsda	v2, {a1, a3, v1, v2, v4, v5, v8, IP, SP, LR, PC}
    67d0:	ff84f00d 	swinv	0x0084f00d
    67d4:	21002200 	tstcs	a1, a1, lsl #4
    67d8:	b4072000 	strlt	a3, [v4]
    67dc:	20292300 	eorcs	a3, v6, a1, lsl #6
    67e0:	fa00f00a 	blx	0x42810
    67e4:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    67e8:	b0037470 	andlt	v4, a4, a1, ror v1
    67ec:	292ce147 	stmcsdb	IP!, {a1, a2, a3, v3, v5, SP, LR, PC}
    67f0:	e144d000 	cmp	v1, a1
    67f4:	4a904991 	bmi	0xfe418e40
    67f8:	4a9e1851 	bmi	0xfe78c944
    67fc:	189a4b8e 	ldmneia	v7, {a2, a3, a4, v4, v5, v6, v8, LR}
    6800:	1e402008 	cdpne	0, 4, cr2, cr0, cr8, {0}
    6804:	54135c0b 	ldrpl	v2, [a4], #-3083
    6808:	2200d1fb 	andcs	SP, a1, #-1073741762	; 0xc000003e
    680c:	20002100 	andcs	a3, a1, a1, lsl #2
    6810:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    6814:	f00a202a 	andnv	a3, v7, v7, lsr #32
    6818:	7c70f9e5 	ldcvcl	9, cr15, [a1], #-916
    681c:	74701c40 	ldrvcbt	a2, [a1], #-3136
    6820:	e12cb003 	teq	IP, a4
    6824:	d000292d 	andle	a3, a1, SP, lsr #18
    6828:	7c79e129 	ldfvcp	f6, [v6], #-164
    682c:	d51007c9 	ldrle	a1, [a1, #-1993]
    6830:	21017a78 	tstcs	a2, v5, ror v7
    6834:	72794301 	rsbvcs	v1, v6, #67108864	; 0x4000000
    6838:	6800488d 	stmvsda	a1, {a1, a3, a4, v4, v8, LR}
    683c:	6a406a80 	bvs	0x1021244
    6840:	6809498b 	stmvsda	v6, {a1, a2, a4, v4, v5, v8, LR}
    6844:	6a496a89 	bvs	0x1261270
    6848:	22017fc9 	andcs	v4, a2, #804	; 0x324
    684c:	77c2430a 	strvcb	v1, [a3, v7, lsl #6]
    6850:	7a79e009 	bvc	0x1e7e87c
    6854:	72794001 	rsbvcs	v1, v6, #1	; 0x1
    6858:	68094985 	stmvsda	v6, {a1, a3, v4, v5, v8, LR}
    685c:	6a496a89 	bvs	0x1261288
    6860:	40107fca 	andmis	v4, a1, v7, asr #31
    6864:	980077c8 	stmlsda	a1, {a4, v3, v4, v5, v6, v7, IP, SP, LR}
    6868:	70012100 	andvc	a3, a2, a1, lsl #2
    686c:	70419800 	subvc	v6, a2, a1, lsl #16
    6870:	20002200 	andcs	a3, a1, a1, lsl #4
    6874:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    6878:	f00a2007 	andnv	a3, v7, v4
    687c:	7c70f9b3 	ldcvcl	9, cr15, [a1], #-716
    6880:	74701c40 	ldrvcbt	a2, [a1], #-3136
    6884:	e0fab003 	rscs	v8, v7, a4
    6888:	d1362918 	teqle	v3, v5, lsl v6
    688c:	98009905 	stmlsda	a1, {a1, a3, v5, v8, IP, PC}
    6890:	221f7800 	andcss	v4, PC, #0	; 0x0
    6894:	4a684350 	bmi	0x1a175dc
    6898:	301c1810 	andccs	a2, IP, a1, lsl v5
    689c:	f94cf001 	stmnvdb	IP, {a1, IP, SP, LR, PC}^
    68a0:	98009908 	stmlsda	a1, {a4, v5, v8, IP, PC}
    68a4:	221f7800 	andcss	v4, PC, #0	; 0x0
    68a8:	4a634350 	bmi	0x18d75f0
    68ac:	30081810 	andcc	a2, v5, a1, lsl v5
    68b0:	f956f001 	ldmnvdb	v3, {a1, IP, SP, LR, PC}^
    68b4:	78009800 	stmvcda	a1, {v8, IP, PC}
    68b8:	4348211f 	cmpmi	v5, #-1073741817	; 0xc0000007
    68bc:	1808495e 	stmneda	v5, {a2, a3, a4, v1, v3, v5, v8, LR}
    68c0:	21023023 	tstcs	a3, a4, lsr #32
    68c4:	495f7001 	ldmmidb	PC, {a1, IP, SP, LR}^
    68c8:	18514a5b 	ldmneda	a2, {a1, a2, a4, v1, v3, v6, v8, LR}^
    68cc:	4b5a4a61 	blmi	0x1699258
    68d0:	231f5c9a 	tstcs	PC, #39424	; 0x9a00
    68d4:	4b58435a 	blmi	0x1617644
    68d8:	3218189a 	andccs	a2, v5, #10092544	; 0x9a0000
    68dc:	1e402004 	cdpne	0, 4, cr2, cr0, cr4, {0}
    68e0:	54135c0b 	ldrpl	v2, [a4], #-3083
    68e4:	9800d1fb 	stmlsda	a1, {a1, a2, a4, v1, v2, v3, v4, v5, IP, LR, PC}
    68e8:	78099900 	stmvcda	v6, {v5, v8, IP, PC}
    68ec:	70011c49 	andvc	a2, a2, v6, asr #24
    68f0:	99009800 	stmlsdb	a1, {v8, IP, PC}
    68f4:	1c497849 	mcrrne	8, 4, v4, v6, cr9
    68f8:	7c387041 	ldcvc	0, cr7, [v5], #-260
    68fc:	d10b2819 	tstle	v8, v6, lsl v5
    6900:	21002200 	tstcs	a1, a1, lsl #4
    6904:	b4072000 	strlt	a3, [v4]
    6908:	202f2300 	eorcs	a3, PC, a1, lsl #6
    690c:	f96af00a 	stmnvdb	v7!, {a2, a4, IP, SP, LR, PC}^
    6910:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    6914:	b0037470 	andlt	v4, a4, a1, ror v1
    6918:	74382000 	ldrvct	a3, [v5]
    691c:	2930e0af 	ldmcsdb	a1!, {a1, a2, a3, a4, v2, v4, SP, LR, PC}
    6920:	e0acd000 	adc	SP, IP, a1
    6924:	70387cb8 	ldrvch	v4, [v5], -v5
    6928:	70787c78 	rsbvcs	v4, v5, v5, ror IP
    692c:	28017ab8 	stmcsda	a2, {a4, v1, v2, v4, v6, v8, IP, SP, LR}
    6930:	2200d109 	andcs	SP, a1, #1073741826	; 0x40000002
    6934:	20002100 	andcs	a3, a1, a1, lsl #2
    6938:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    693c:	f00a2033 	andnv	a3, v7, a4, lsr a1
    6940:	b003f951 	andlt	PC, a4, a2, asr v6
    6944:	2200e008 	andcs	LR, a1, #8	; 0x8
    6948:	20002100 	andcs	a3, a1, a1, lsl #2
    694c:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    6950:	f00a2034 	andnv	a3, v7, v1, lsr a1
    6954:	b003f947 	andlt	PC, a4, v4, asr #18
    6958:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    695c:	e1a37470 	mov	v4, a1, ror v1
    6960:	d11d2931 	tstle	SP, a2, lsr v6
    6964:	72f87cb8 	rscvcs	v4, v5, #47104	; 0xb800
    6968:	28007c78 	stmcsda	a1, {a4, v1, v2, v3, v7, v8, IP, SP, LR}
    696c:	2200d10c 	andcs	SP, a1, #3	; 0x3
    6970:	20002100 	andcs	a3, a1, a1, lsl #2
    6974:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    6978:	f00a2003 	andnv	a3, v7, a4
    697c:	7c70f933 	ldcvcl	9, cr15, [a1], #-204
    6980:	74701c40 	ldrvcbt	a2, [a1], #-3136
    6984:	e00bb003 	and	v8, v8, a4
    6988:	76302000 	ldrvct	a3, [a1], -a1
    698c:	201172b8 	ldrcsh	v4, [a2], -v5
    6990:	20007430 	andcs	v4, a1, a1, lsr v1
    6994:	61707470 	cmnvs	a1, a1, ror v1
    6998:	69f074f0 	ldmvsib	a1!, {v1, v2, v3, v4, v7, IP, SP, LR}^
    699c:	80012100 	andhi	a3, a2, a1, lsl #2
    69a0:	28327c38 	ldmcsda	a3!, {a4, v1, v2, v7, v8, IP, SP, LR}
    69a4:	2200d16b 	andcs	SP, a1, #-1073741798	; 0xc000001a
    69a8:	20002100 	andcs	a3, a1, a1, lsl #2
    69ac:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    69b0:	f00a2003 	andnv	a3, v7, a4
    69b4:	7c70f917 	ldcvcl	9, cr15, [a1], #-92
    69b8:	74701c40 	ldrvcbt	a2, [a1], #-3136
    69bc:	e05eb003 	subs	v8, LR, a4
    69c0:	d15c291b 	cmple	IP, v8, lsl v6
    69c4:	07c07c78 	undefined
    69c8:	d5027a78 	strle	v4, [a3, #-2680]
    69cc:	43012102 	tstmi	a2, #-2147483648	; 0x80000000
    69d0:	21fde001 	mvncss	LR, a2
    69d4:	72794001 	rsbvcs	v1, v6, #1	; 0x1
    69d8:	68004825 	stmvsda	a1, {a1, a3, v2, v8, LR}
    69dc:	6a406a80 	bvs	0x10213e4
    69e0:	22fb7fc1 	rsccss	v4, v8, #772	; 0x304
    69e4:	77c2400a 	strvcb	v1, [a3, v7]
    69e8:	72b82000 	adcvcs	a3, v5, #0	; 0x0
    69ec:	74302011 	ldrvct	a3, [a1], #-17
    69f0:	74702000 	ldrvcbt	a3, [a1]
    69f4:	74f06170 	ldrvcbt	v3, [a1], #368
    69f8:	210069f0 	strcsd	v3, [a1, -a1]
    69fc:	e03e8001 	eors	v5, LR, a2
    6a00:	1c017c70 	stcne	12, cr7, [a2], {112}
    6a04:	d83a2805 	ldmleda	v7!, {a1, a3, v8, SP}
    6a08:	0049a201 	subeq	v7, v6, a2, lsl #4
    6a0c:	44975e52 	ldrmi	v2, [v4], #3666
    6a10:	fd7e000a 	ldc2l	0, cr0, [LR, #-40]!
    6a14:	00660ed8 	ldreqd	a1, [v3], #-232
    6a18:	008a0070 	addeq	a1, v7, a1, ror a1
    6a1c:	68094914 	stmvsda	v6, {a3, v1, v5, v8, LR}
    6a20:	6a496a89 	bvs	0x126144c
    6a24:	07497fc9 	streqb	v4, [v6, -v6, asr #31]
    6a28:	1c40d501 	cfstr64ne	mvdx13, [a1], {1}
    6a2c:	1c80e0f2 	stcne	0, cr14, [a1], {242}
    6a30:	46c0e0f0 	undefined
    6a34:	0000048e 	andeq	a1, a1, LR, lsl #9
    6a38:	00008a54 	andeq	v5, a1, v1, asr v7
    6a3c:	00000487 	andeq	a1, a1, v4, lsl #9
    6a40:	00000bb5 	streqh	a1, [a1], -v2
    6a44:	0000049e 	muleq	a1, LR, v1
    6a48:	0000076e 	andeq	a1, a1, LR, ror #14
    6a4c:	00000505 	andeq	a1, a1, v2, lsl #10
    6a50:	000003d5 	ldreqd	a1, [a1], -v2
    6a54:	00000761 	andeq	a1, a1, a2, ror #14
    6a58:	000003ce 	andeq	a1, a1, LR, asr #7
    6a5c:	00000872 	andeq	a1, a1, a3, ror v5
    6a60:	00000976 	andeq	a1, a1, v3, ror v6
    6a64:	00000b84 	andeq	a1, a1, v1, lsl #23
    6a68:	00000476 	andeq	a1, a1, v3, ror v1
    6a6c:	00000ba4 	andeq	a1, a1, v1, lsr #23
    6a70:	00009624 	andeq	v6, a1, v1, lsr #12
    6a74:	00000466 	andeq	a1, a1, v3, ror #8
    6a78:	f0019809 	andnv	v6, a2, v6, lsl #16
    6a7c:	f001f9cf 	andnv	PC, a2, PC, asr #19
    6a80:	2200f84c 	andcs	PC, a1, #4980736	; 0x4c0000
    6a84:	20002100 	andcs	a3, a1, a1, lsl #2
    6a88:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    6a8c:	f00a2025 	andnv	a3, v7, v2, lsr #32
    6a90:	7c70f8a9 	ldcvcl	8, cr15, [a1], #-676
    6a94:	74701c40 	ldrvcbt	a2, [a1], #-3136
    6a98:	e7f0b003 	ldrb	v8, [a1, a4]!
    6a9c:	28267c38 	stmcsda	v3!, {a4, v1, v2, v7, v8, IP, SP, LR}
    6aa0:	2000d1ed 	andcs	SP, a1, SP, ror #3
    6aa4:	61707470 	cmnvs	a1, a1, ror v1
    6aa8:	200174f0 	strcsd	v4, [a2], -a1
    6aac:	200b72b8 	strcsh	v4, [v8], -v5
    6ab0:	e7e47430 	undefined
    6ab4:	49ca7c70 	stmmiib	v7, {v1, v2, v3, v7, v8, IP, SP, LR}^
    6ab8:	18554aca 	ldmneda	v2, {a2, a4, v3, v4, v6, v8, LR}^
    6abc:	28081c01 	stmcsda	v5, {a1, v7, v8, IP}
    6ac0:	a202d8dd 	andge	SP, a3, #14483456	; 0xdd0000
    6ac4:	5a520049 	bpl	0x1486bf0
    6ac8:	46c04497 	undefined
    6acc:	004e0012 	subeq	a1, LR, a3, lsl a1
    6ad0:	0102006e 	tsteq	a3, LR, rrx
    6ad4:	0e1e0110 	mrceq	1, 0, a1, cr14, cr0, {0}
    6ad8:	0184014c 	orreq	a1, v1, IP, asr #2
    6adc:	48c201f2 	stmmiia	a3, {a2, v1, v2, v3, v4, v5}^
    6ae0:	6a806800 	bvs	0xfe020ae8
    6ae4:	7fc06a40 	swivc	0x00c06a40
    6ae8:	d5140740 	ldrle	a1, [v1, #-1856]
    6aec:	680048be 	stmvsda	a1, {a2, a3, a4, v1, v2, v4, v8, LR}
    6af0:	6a406a80 	bvs	0x10214f8
    6af4:	680949bc 	stmvsda	v6, {a3, a4, v1, v2, v4, v5, v8, LR}
    6af8:	6a496a89 	bvs	0x1261524
    6afc:	22047fc9 	andcs	v4, v1, #804	; 0x324
    6b00:	77c2430a 	strvcb	v1, [a3, v7, lsl #6]
    6b04:	21009800 	tstcs	a1, a1, lsl #16
    6b08:	7c707241 	lfmvc	f7, 2, [a1], #-260
    6b0c:	74701c40 	ldrvcbt	a2, [a1], #-3136
    6b10:	fec2f009 	cdp2	0, 12, cr15, cr2, cr9, {0}
    6b14:	2004e7b3 	strcsh	LR, [v1], -a4
    6b18:	9800e07c 	stmlsda	a1, {a3, a4, v1, v2, v3, SP, LR, PC}
    6b1c:	1c407a40 	mcrrne	10, 4, v4, a1, cr0
    6b20:	72489900 	subvc	v6, v5, #0	; 0x0
    6b24:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    6b28:	d3a82865 	movle	a3, #6619136	; 0x650000
    6b2c:	feb6f009 	cdp2	0, 11, cr15, cr6, cr9, {0}
    6b30:	80282000 	eorhi	a3, v5, a1
    6b34:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    6b38:	8828e06c 	stmhida	v5!, {a3, a4, v2, v3, SP, LR, PC}
    6b3c:	80281c40 	eorhi	a2, v5, a1, asr #24
    6b40:	040049aa 	streq	v1, [a1], #-2474
    6b44:	42880c00 	addmi	a1, v5, #0	; 0x0
    6b48:	48a9d399 	stmmiia	v6!, {a1, a4, v1, v4, v5, v6, IP, LR, PC}
    6b4c:	4aa52100 	bmi	0xfe94ef54
    6b50:	1e803208 	cdpne	2, 8, cr3, cr0, cr8, {0}
    6b54:	d1fc5211 	mvnles	v2, a2, lsl a3
    6b58:	4da22400 	cfstrsmi	mvf2, [a3]
    6b5c:	21002007 	tstcs	a1, v4
    6b60:	4362222f 	cmnmi	a3, #-268435454	; 0xf0000002
    6b64:	18eb4ba3 	stmneia	v8!, {a1, a2, v2, v4, v5, v6, v8, LR}^
    6b68:	1e40189a 	mcrne	8, 2, a2, cr0, cr10, {4}
    6b6c:	d1fc5411 	mvnles	v2, a2, lsl v1
    6b70:	222f2010 	eorcs	a3, PC, #16	; 0x10
    6b74:	4ba04362 	blmi	0xfe817904
    6b78:	189a18eb 	ldmneia	v7, {a1, a2, a4, v2, v3, v4, v8, IP}
    6b7c:	54111e40 	ldrpl	a2, [a2], #-3648
    6b80:	2004d1fc 	strcsd	SP, [v1], -IP
    6b84:	4362222f 	cmnmi	a3, #-268435454	; 0xf0000002
    6b88:	18eb4b9c 	stmneia	v8!, {a3, a4, v1, v4, v5, v6, v8, LR}^
    6b8c:	1e40189a 	mcrne	8, 2, a2, cr0, cr10, {4}
    6b90:	d1fc5411 	mvnles	v2, a2, lsl v1
    6b94:	222f2010 	eorcs	a3, PC, #16	; 0x10
    6b98:	4b994362 	blmi	0xfe657928
    6b9c:	189a18eb 	ldmneia	v7, {a1, a2, a4, v2, v3, v4, v8, IP}
    6ba0:	54111e40 	ldrpl	a2, [a2], #-3648
    6ba4:	202fd1fc 	strcsd	SP, [PC], -IP
    6ba8:	99064360 	stmlsdb	v3, {v2, v3, v5, v6, LR}
    6bac:	540a22ff 	strpl	a3, [v7], #-767
    6bb0:	1c499906 	mcrrne	9, 0, v6, v6, cr6
    6bb4:	540a2200 	strpl	a3, [v7], #-512
    6bb8:	1c899906 	stcne	9, cr9, [v6], {6}
    6bbc:	1c64540a 	cfstrdne	mvd5, [v1], #-40
    6bc0:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    6bc4:	d3c92c04 	bicle	a3, v6, #1024	; 0x400
    6bc8:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    6bcc:	9800e022 	stmlsda	a1, {a2, v2, SP, LR, PC}
    6bd0:	70812101 	addvc	a3, a2, a2, lsl #2
    6bd4:	7c707631 	ldcvcl	6, cr7, [a1], #-196
    6bd8:	e01b1c40 	ands	a2, v8, a1, asr #24
    6bdc:	22009900 	andcs	v6, a1, #0	; 0x0
    6be0:	990071ca 	stmlsdb	a1, {a2, a4, v3, v4, v5, IP, SP, LR}
    6be4:	29027889 	stmcsdb	a3, {a1, a4, v4, v8, IP, SP, LR}
    6be8:	2400d113 	strcs	SP, [a1], #-275
    6bec:	4360202f 	cmnmi	a1, #47	; 0x2f
    6bf0:	1c499906 	mcrrne	9, 0, v6, v6, cr6
    6bf4:	28005c08 	stmcsda	a1, {a4, v7, v8, IP, LR}
    6bf8:	9800d003 	stmlsda	a1, {a1, a2, IP, LR, PC}
    6bfc:	43212180 	teqmi	a2, #32	; 0x20
    6c00:	1c6471c1 	stfnee	f7, [v1], #-772
    6c04:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    6c08:	d3ef2c04 	mvnle	a3, #1024	; 0x400
    6c0c:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    6c10:	1c80e000 	stcne	0, cr14, [a1], {0}
    6c14:	ff80f000 	swinv	0x0080f000
    6c18:	4a72497a 	bmi	0x1c99208
    6c1c:	aa0f1851 	bge	0x3ccd68
    6c20:	1e802008 	cdpne	0, 8, cr2, cr0, cr8, {0}
    6c24:	52135a0b 	andpls	v2, a4, #45056	; 0xb000
    6c28:	2000d1fb 	strcsd	SP, [a1], -v8
    6c2c:	3108a90f 	tstcc	v5, PC, lsl #18
    6c30:	60486008 	subvs	v3, v5, v5
    6c34:	21002200 	tstcs	a1, a1, lsl #4
    6c38:	4b6a4872 	blmi	0x1a98e08
    6c3c:	b4071818 	strlt	a2, [v4], #-2072
    6c40:	20212300 	eorcs	a3, a2, a1, lsl #6
    6c44:	ffcef009 	swinv	0x00cef009
    6c48:	74702007 	ldrvcbt	a3, [a1], #-7
    6c4c:	e716b003 	ldr	v8, [v3, -a4]
    6c50:	28227c38 	stmcsda	a3!, {a4, v1, v2, v7, v8, IP, SP, LR}
    6c54:	e712d000 	ldr	SP, [a3, -a1]
    6c58:	79c49800 	stmvcib	v1, {v8, IP, PC}^
    6c5c:	d5110620 	ldrle	a1, [a2, #-1568]
    6c60:	21002200 	tstcs	a1, a1, lsl #4
    6c64:	b4072000 	strlt	a3, [v4]
    6c68:	48672300 	stmmida	v4!, {v5, v6, SP}^
    6c6c:	438c2180 	orrmi	a3, IP, #32	; 0x20
    6c70:	434c212f 	cmpmi	IP, #-1073741813	; 0xc000000b
    6c74:	1909495b 	stmnedb	v6, {a1, a2, a4, v1, v3, v5, v8, LR}
    6c78:	200b5c09 	andcs	v2, v8, v6, lsl #24
    6c7c:	ffb2f009 	swinv	0x00b2f009
    6c80:	e669b003 	strbt	v8, [v6], -a4
    6c84:	68004858 	stmvsda	a1, {a4, v1, v3, v8, LR}
    6c88:	6a406a80 	bvs	0x1021690
    6c8c:	07407fc0 	streqb	v4, [a1, -a1, asr #31]
    6c90:	2000d501 	andcs	SP, a1, a2, lsl #10
    6c94:	20117630 	andcss	v4, a2, a1, lsr v3
    6c98:	20007430 	andcs	v4, a1, a1, lsr v1
    6c9c:	61707470 	cmnvs	a1, a1, ror v1
    6ca0:	69f074f0 	ldmvsib	a1!, {v1, v2, v3, v4, v7, IP, SP, LR}^
    6ca4:	80012100 	andhi	a3, a2, a1, lsl #2
    6ca8:	6800484f 	stmvsda	a1, {a1, a2, a3, a4, v3, v8, LR}
    6cac:	6a496a81 	bvs	0x12616b8
    6cb0:	6a406a80 	bvs	0x10216b8
    6cb4:	22087e80 	andcs	v4, v5, #2048	; 0x800
    6cb8:	768a4302 	strvc	v1, [v7], a3, lsl #6
    6cbc:	9800e3b3 	stmlsda	a1, {a1, a2, v1, v2, v4, v5, v6, SP, LR, PC}
    6cc0:	28007a00 	stmcsda	a1, {v6, v8, IP, SP, LR}
    6cc4:	e3aed100 	mov	SP, #0	; 0x0
    6cc8:	99004850 	stmlsdb	a1, {v1, v3, v8, LR}
    6ccc:	228079c9 	addcs	v4, a1, #3293184	; 0x324000
    6cd0:	222f4391 	eorcs	v1, PC, #1140850690	; 0x44000002
    6cd4:	4a434351 	bmi	0x10d7a20
    6cd8:	22011851 	andcs	a2, a2, #5308416	; 0x510000
    6cdc:	69f0540a 	ldmvsib	a1!, {a2, a4, v7, IP, LR}^
    6ce0:	80012100 	andhi	a3, a2, a1, lsl #2
    6ce4:	98007021 	stmlsda	a1, {a1, v2, IP, SP, LR}
    6ce8:	70812102 	addvc	a3, a2, a3, lsl #2
    6cec:	f0097631 	andnv	v4, v6, a2, lsr v3
    6cf0:	f009ff71 	andnv	PC, v6, a2, ror PC
    6cf4:	2101fde9 	smlattcs	a2, v6, SP, PC
    6cf8:	f009980e 	andnv	v6, v6, LR, lsl #16
    6cfc:	2011fddb 	ldrcssb	PC, [a2], -v8
    6d00:	20007430 	andcs	v4, a1, a1, lsr v1
    6d04:	61707470 	cmnvs	a1, a1, ror v1
    6d08:	e38c74f0 	orr	v4, IP, #-268435456	; 0xf0000000
    6d0c:	28007c70 	stmcsda	a1, {v1, v2, v3, v7, v8, IP, SP, LR}
    6d10:	f000d101 	andnv	SP, a1, a2, lsl #2
    6d14:	2801fdea 	stmcsda	a2, {a2, a4, v2, v3, v4, v5, v7, v8, IP, SP, LR, PC}
    6d18:	e384d000 	orr	SP, v1, #0	; 0x0
    6d1c:	210069f0 	strcsd	v3, [a1, -a1]
    6d20:	e7ec8001 	strb	v5, [IP, a2]!
    6d24:	28007c70 	stmcsda	a1, {v1, v2, v3, v7, v8, IP, SP, LR}
    6d28:	2801d002 	stmcsda	a2, {a2, IP, LR, PC}
    6d2c:	e37ad0f6 	cmn	v7, #246	; 0xf6
    6d30:	f0009809 	andnv	v6, a1, v6, lsl #16
    6d34:	e376ffc3 	cmnp	v3, #780	; 0x30c
    6d38:	88e94668 	stmhiia	v6!, {a4, v2, v3, v6, v7, LR}^
    6d3c:	7c398601 	ldcvc	6, cr8, [v6], #-4
    6d40:	72027bfa 	andvc	v4, a3, #256000	; 0x3e800
    6d44:	7c727820 	ldcvcl	8, cr7, [a3], #-128
    6d48:	d9002a0a 	stmledb	a1, {a2, a4, v6, v8, SP}
    6d4c:	a302e36b 	tstge	a3, #-1409286143	; 0xac000001
    6d50:	5e9b0052 	mrcpl	0, 4, a1, cr11, cr2, {2}
    6d54:	46c0449f 	undefined
    6d58:	0016ffd8 	ldreqsb	PC, [v3], -v5
    6d5c:	010800c8 	smlabteq	v5, v5, a1, a1
    6d60:	0202018e 	andeq	a1, a3, #-2147483613	; 0x80000023
    6d64:	0260023c 	rsbeq	a1, a1, #-1073741821	; 0xc0000003
    6d68:	0b92029e 	bleq	0xfe4877e8
    6d6c:	4827ffa6 	stmmida	v4!, {a2, a3, v2, v4, v5, v6, v7, v8, IP, SP, LR, PC}
    6d70:	222f7871 	eorcs	v4, PC, #7405568	; 0x710000
    6d74:	4a1b4351 	bmi	0x6d7ac0
    6d78:	5c081851 	stcpl	8, cr1, [v5], {81}
    6d7c:	d0212800 	eorle	a3, a2, a1, lsl #16
    6d80:	21019803 	tstcs	a2, a4, lsl #16
    6d84:	98037001 	stmlsda	a4, {a1, IP, SP, LR}
    6d88:	70412181 	subvc	a3, a2, a2, lsl #3
    6d8c:	010921b9 	streqh	a3, [v6, -v6]
    6d90:	4a1f1851 	bmi	0x7ccedc
    6d94:	189a4b13 	ldmneia	v7, {a1, a2, v1, v5, v6, v8, LR}
    6d98:	1f002014 	swine	0x00002014
    6d9c:	5013580b 	andpls	v2, a4, v8, lsl #16
    6da0:	481cd1fb 	ldmmida	IP, {a1, a2, a4, v1, v2, v3, v4, v5, IP, LR, PC}
    6da4:	1808490f 	stmneda	v5, {a1, a2, a3, a4, v5, v8, LR}
    6da8:	4a0e491b 	bmi	0x39921c
    6dac:	68021851 	stmvsda	a3, {a1, v1, v3, v8, IP}
    6db0:	221a600a 	andcss	v3, v7, #10	; 0xa
    6db4:	9803211a 	stmlsda	a4, {a2, a4, v1, v5, SP}
    6db8:	fdb8f009 	ldc2	0, cr15, [v5, #36]!
    6dbc:	81682000 	cmnhi	v5, a1
    6dc0:	e31d2002 	tst	SP, #2	; 0x2
    6dc4:	49158968 	ldmmidb	v2, {a4, v2, v3, v5, v8, PC}
    6dc8:	d3054288 	tstle	v2, #-2147483640	; 0x80000008
    6dcc:	219a69f0 	ldrcssh	v3, [v7, a1]
    6dd0:	80010209 	andhi	a1, a2, v6, lsl #4
    6dd4:	e3132008 	tst	a4, #8	; 0x8
    6dd8:	81681c40 	cmnhi	v5, a1, asr #24
    6ddc:	46c0e323 	strmib	LR, [a1], a4, lsr #6
    6de0:	0000076c 	andeq	a1, a1, IP, ror #14
    6de4:	00008a54 	andeq	v5, a1, v1, asr v7
    6de8:	00009624 	andeq	v6, a1, v1, lsr #12
    6dec:	000007d1 	ldreqd	a1, [a1], -a2
    6df0:	000003a2 	andeq	a1, a1, a3, lsr #7
    6df4:	000003ce 	andeq	a1, a1, LR, asr #7
    6df8:	000003aa 	andeq	a1, a1, v7, lsr #7
    6dfc:	000003ba 	streqh	a1, [a1], -v7
    6e00:	000003be 	streqh	a1, [a1], -LR
    6e04:	00000466 	andeq	a1, a1, v3, ror #8
    6e08:	000003d5 	ldreqd	a1, [a1], -v2
    6e0c:	000003d6 	ldreqd	a1, [a1], -v3
    6e10:	00000874 	andeq	a1, a1, v1, ror v5
    6e14:	00000b84 	andeq	a1, a1, v1, lsl #23
    6e18:	00000888 	andeq	a1, a1, v5, lsl #17
    6e1c:	00007530 	andeq	v4, a1, a1, lsr v2
    6e20:	d1132804 	tstle	a4, v1, lsl #16
    6e24:	7a004668 	bvc	0x187cc
    6e28:	d10f2802 	tstle	PC, a3, lsl #16
    6e2c:	d10d2981 	smlabble	SP, a2, v6, a3
    6e30:	28007c78 	stmcsda	a1, {a4, v1, v2, v3, v7, v8, IP, SP, LR}
    6e34:	7cb8d106 	ldfvcd	f5, [v5], #24
    6e38:	20038128 	andcs	v5, a4, v5, lsr #2
    6e3c:	20007470 	andcs	v4, a1, a1, ror v1
    6e40:	e0037020 	and	v4, a4, a1, lsr #32
    6e44:	800869f1 	strhid	v3, [v5], -a2
    6e48:	74702008 	ldrvcbt	a3, [a1], #-8
    6e4c:	49cf8968 	stmmiib	PC, {a4, v2, v3, v5, v8, PC}^
    6e50:	d3c14288 	bicle	v1, a2, #-2147483640	; 0x80000008
    6e54:	219769f0 	ldrcssh	v3, [v4, a1]
    6e58:	80010209 	andhi	a1, a2, v6, lsl #4
    6e5c:	e2cf2008 	sbc	a3, PC, #8	; 0x8
    6e60:	81682000 	cmnhi	v5, a1
    6e64:	49ca6828 	stmmiib	v7, {a4, v2, v8, SP, LR}^
    6e68:	d3004288 	tstle	a1, #-2147483640	; 0x80000008
    6e6c:	80a81e48 	adchi	a2, v5, v5, asr #28
    6e70:	0c000400 	cfstrseq	mvf0, [a1], {0}
    6e74:	d303287c 	tstle	a4, #8126464	; 0x7c0000
    6e78:	9001207b 	andls	a3, a2, v8, ror a1
    6e7c:	e0022004 	and	a3, a3, v1
    6e80:	900188a8 	andls	v5, a2, v5, lsr #17
    6e84:	74702005 	ldrvcbt	a3, [a1], #-5
    6e88:	46694668 	strmibt	v1, [v6], -v5, ror #12
    6e8c:	72418e09 	subvc	v5, a2, #144	; 0x90
    6e90:	48c0ab01 	stmmiia	a1, {a1, v5, v6, v8, SP, PC}^
    6e94:	180a49c0 	stmneda	v7, {v3, v4, v5, v8, LR}
    6e98:	1c49a902 	mcrrne	9, 0, v7, v6, cr2
    6e9c:	4cbf2082 	ldcmi	0, cr2, [PC], #520
    6ea0:	69246824 	stmvsdb	v1!, {a3, v2, v8, SP, LR}
    6ea4:	68246a64 	stmvsda	v1!, {a3, v2, v3, v6, v8, SP, LR}
    6ea8:	f9aaf010 	stmnvib	v7!, {v1, IP, SP, LR, PC}
    6eac:	1cd288aa 	ldcnel	8, cr8, [a3], {170}
    6eb0:	21019803 	tstcs	a2, a4, lsl #16
    6eb4:	98037001 	stmlsda	a4, {a1, IP, SP, LR}
    6eb8:	70412183 	subvc	a3, a2, a4, lsl #3
    6ebc:	89299803 	stmhidb	v6!, {a1, a2, v8, IP, PC}
    6ec0:	04127081 	ldreq	v4, [a3], #-129
    6ec4:	99010c12 	stmlsdb	a2, {a2, v1, v7, v8}
    6ec8:	06091cc9 	streq	a2, [v6], -v6, asr #25
    6ecc:	98030e09 	stmlsda	a4, {a1, a4, v6, v7, v8}
    6ed0:	fd2cf009 	stc2	0, cr15, [IP, #-36]!
    6ed4:	990188a8 	stmlsdb	a2, {a4, v2, v4, v8, PC}
    6ed8:	80a81a40 	adchi	a2, v5, a1, asr #20
    6edc:	99016828 	stmlsdb	a2, {a4, v2, v8, SP, LR}
    6ee0:	60281a40 	eorvs	a2, v5, a1, asr #20
    6ee4:	f009e29f 	mulnv	v6, PC, a3
    6ee8:	2800fd17 	stmcsda	a1, {a1, a2, a3, v1, v5, v7, v8, IP, SP, LR, PC}
    6eec:	e29ad100 	adds	SP, v7, #0	; 0x0
    6ef0:	81682000 	cmnhi	v5, a1
    6ef4:	288088a8 	stmcsia	a1, {a4, v2, v4, v8, PC}
    6ef8:	2180d302 	orrcs	SP, a1, a3, lsl #6
    6efc:	e0009101 	and	v6, a1, a2, lsl #2
    6f00:	99019001 	stmlsdb	a2, {a1, IP, PC}
    6f04:	80a81a40 	adchi	a2, v5, a1, asr #20
    6f08:	99016828 	stmlsdb	a2, {a4, v2, v8, SP, LR}
    6f0c:	60281a40 	eorvs	a2, v5, a1, asr #20
    6f10:	88e94668 	stmhiia	v6!, {a4, v2, v3, v6, v7, LR}^
    6f14:	ab017241 	blge	0x63820
    6f18:	a9029a03 	stmgedb	a3, {a1, a2, v6, v8, IP, PC}
    6f1c:	20821c49 	addcs	a2, a3, v6, asr #24
    6f20:	683f4f9e 	ldmvsda	PC!, {a2, a3, a4, v1, v4, v5, v6, v7, v8, LR}
    6f24:	6a7f693f 	bvs	0x1fe1428
    6f28:	f010683f 	andnvs	v3, a1, PC, lsr v5
    6f2c:	2180f963 	orrcs	PC, a1, a4, ror #18
    6f30:	42880209 	addmi	a1, v5, #-1879048192	; 0x90000000
    6f34:	2000d301 	andcs	SP, a1, a2, lsl #6
    6f38:	99019001 	stmlsdb	a2, {a1, IP, PC}
    6f3c:	0e090609 	cfmadd32eq	mvax0, mvfx0, mvfx9, mvfx9
    6f40:	f0099803 	andnv	v6, v6, a4, lsl #16
    6f44:	88a8fd2f 	stmhiia	v5!, {a1, a2, a3, a4, v2, v5, v7, v8, IP, SP, LR, PC}
    6f48:	d0002800 	andle	a3, a1, a1, lsl #16
    6f4c:	2005e26b 	andcs	LR, v2, v8, ror #4
    6f50:	20007470 	andcs	v4, a1, a1, ror v1
    6f54:	70208168 	eorvc	v5, a1, v5, ror #2
    6f58:	2806e265 	stmcsda	v3, {a1, a3, v2, v3, v6, SP, LR, PC}
    6f5c:	2983d115 	stmcsib	a4, {a1, a3, v1, v5, IP, LR, PC}
    6f60:	4668d113 	undefined
    6f64:	28027a00 	stmcsda	a3, {v6, v8, IP, SP, LR}
    6f68:	8928d10f 	stmhidb	v5!, {a1, a2, a3, a4, v5, IP, LR, PC}
    6f6c:	42887cb9 	addmi	v4, v5, #47360	; 0xb900
    6f70:	7c78d10b 	ldfvcp	f5, [v5], #-44
    6f74:	d1082800 	tstle	v5, a1, lsl #16
    6f78:	28006828 	stmcsda	a1, {a4, v2, v8, SP, LR}
    6f7c:	2003d001 	andcs	SP, a4, a2
    6f80:	2006e000 	andcs	LR, v3, a1
    6f84:	20007470 	andcs	v4, a1, a1, ror v1
    6f88:	89687020 	stmhidb	v5!, {v2, IP, SP, LR}^
    6f8c:	4288497f 	addmi	v1, v5, #2080768	; 0x1fc000
    6f90:	e721d22e 	str	SP, [a2, -LR, lsr #4]!
    6f94:	21019803 	tstcs	a2, a4, lsl #16
    6f98:	98037001 	stmlsda	a4, {a1, IP, SP, LR}
    6f9c:	70412184 	subvc	a3, a2, v1, lsl #3
    6fa0:	89299803 	stmhidb	v6!, {a1, a2, v8, IP, PC}
    6fa4:	22037081 	andcs	v4, a4, #129	; 0x81
    6fa8:	98032103 	stmlsda	a4, {a1, a2, v5, SP}
    6fac:	fcbef009 	ldc2	0, cr15, [LR], #36
    6fb0:	81682000 	cmnhi	v5, a1
    6fb4:	e2232007 	eor	a3, a4, #7	; 0x7
    6fb8:	d1162804 	tstle	v3, v1, lsl #16
    6fbc:	d1142984 	tstle	v1, v1, lsl #19
    6fc0:	7a004668 	bvc	0x18968
    6fc4:	d1102802 	tstle	a1, a3, lsl #16
    6fc8:	7cb98928 	ldcvc	9, cr8, [v6], #160
    6fcc:	d10c4288 	smlabble	IP, v5, a3, v1
    6fd0:	28007c78 	stmcsda	a1, {a4, v1, v2, v3, v7, v8, IP, SP, LR}
    6fd4:	d10169f0 	strled	v3, [a2, -a1]
    6fd8:	e0012100 	and	a3, a2, a1, lsl #2
    6fdc:	0209219b 	andeq	a3, v6, #-1073741786	; 0xc0000026
    6fe0:	20088001 	andcs	v5, v5, a2
    6fe4:	20007470 	andcs	v4, a1, a1, ror v1
    6fe8:	89687020 	stmhidb	v5!, {v2, IP, SP, LR}^
    6fec:	42884967 	addmi	v1, v5, #1687552	; 0x19c000
    6ff0:	e72fd300 	str	SP, [PC, -a1, lsl #6]!
    6ff4:	4668e6f0 	undefined
    6ff8:	8e094669 	cfmadd32hi	mvax3, mvfx4, mvfx9, mvfx9
    6ffc:	23007201 	tstcs	a1, #268435456	; 0x10000000
    7000:	a9022200 	stmgedb	a3, {v6, SP}
    7004:	4c652084 	stcmil	0, cr2, [v2], #-528
    7008:	69246824 	stmvsdb	v1!, {a3, v2, v8, SP, LR}
    700c:	68246a64 	stmvsda	v1!, {a3, v2, v3, v6, v8, SP, LR}
    7010:	f8f6f010 	ldmnvia	v3!, {v1, IP, SP, LR, PC}^
    7014:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    7018:	7c70e1f2 	ldfvcp	f6, [a1], #-968
    701c:	d0022800 	andle	a3, a3, a1, lsl #16
    7020:	d0322801 	eorles	a3, a3, a2, lsl #16
    7024:	2078e1ff 	ldrcssh	LR, [v5], #-31
    7028:	46689001 	strmibt	v6, [v5], -a2
    702c:	724188e9 	subvc	v5, a2, #15269888	; 0xe90000
    7030:	485bab01 	ldmmida	v8, {a1, v5, v6, v8, SP, PC}^
    7034:	180a4958 	stmneda	v7, {a4, v1, v3, v5, v8, LR}
    7038:	1c49a902 	mcrrne	9, 0, v7, v6, cr2
    703c:	4c572082 	mrrcmi	0, 8, a3, v4, cr2
    7040:	69246824 	stmvsdb	v1!, {a3, v2, v8, SP, LR}
    7044:	68246a64 	stmvsda	v1!, {a3, v2, v3, v6, v8, SP, LR}
    7048:	f8daf010 	ldmnvia	v7, {v1, IP, SP, LR, PC}^
    704c:	22029903 	andcs	v6, a3, #49152	; 0xc000
    7050:	9903700a 	stmlsdb	a4, {a2, a4, IP, SP, LR}
    7054:	704a7832 	subvc	v4, v7, a3, lsr v5
    7058:	0a029903 	beq	0xad46c
    705c:	9903708a 	stmlsdb	a4, {a2, a4, v4, IP, SP, LR}
    7060:	980370c8 	stmlsda	a4, {a4, v3, v4, IP, SP, LR}
    7064:	710188a9 	smlatbvc	a2, v6, v5, v5
    7068:	88a99803 	stmhiia	v6!, {a1, a2, v8, IP, PC}
    706c:	71410a09 	cmpvc	a2, v6, lsl #20
    7070:	1d9288aa 	ldcne	8, cr8, [a3, #680]
    7074:	0c120412 	cfldrseq	mvf0, [a3], {18}
    7078:	9803217e 	stmlsda	a4, {a2, a3, a4, v1, v2, v3, v5, SP}
    707c:	fc56f009 	mrrc2	0, 0, PC, v3, cr9
    7080:	387888a8 	ldmccda	v5!, {a4, v2, v4, v8, PC}^
    7084:	200180a8 	andcs	v5, a2, v5, lsr #1
    7088:	f009e1ba 	strnvh	LR, [v6], -v7
    708c:	2800fc45 	stmcsda	a1, {a1, a3, v3, v7, v8, IP, SP, LR, PC}
    7090:	e1c8d100 	bic	SP, v5, a1, lsl #2
    7094:	288188a8 	stmcsia	a2, {a4, v2, v4, v8, PC}
    7098:	3880d304 	stmccia	a1, {a3, v5, v6, IP, LR, PC}
    709c:	208080a8 	addcs	v5, a1, v5, lsr #1
    70a0:	e00a9001 	and	v6, v7, a2
    70a4:	20009001 	andcs	v6, a1, a2
    70a8:	69f080a8 	ldmvsib	a1!, {a4, v2, v4, PC}^
    70ac:	80012100 	andhi	a3, a2, a1, lsl #2
    70b0:	74302011 	ldrvct	a3, [a1], #-17
    70b4:	61717471 	cmnvs	a2, a2, ror v1
    70b8:	466874f1 	undefined
    70bc:	724188e9 	subvc	v5, a2, #15269888	; 0xe90000
    70c0:	9a03ab01 	bls	0xf1ccc
    70c4:	1c49a902 	mcrrne	9, 0, v7, v6, cr2
    70c8:	4c342082 	ldcmi	0, cr2, [v1], #-520
    70cc:	69246824 	stmvsdb	v1!, {a3, v2, v8, SP, LR}
    70d0:	68246a64 	stmvsda	v1!, {a3, v2, v3, v6, v8, SP, LR}
    70d4:	f894f010 	ldmnvia	v1, {v1, IP, SP, LR, PC}
    70d8:	06099901 	streq	v6, [v6], -a2, lsl #18
    70dc:	98030e09 	stmlsda	a4, {a1, a4, v6, v7, v8}
    70e0:	fc60f009 	stc2l	0, cr15, [a1], #-36
    70e4:	4668e19f 	undefined
    70e8:	72017cb1 	andvc	v4, a2, #45312	; 0xb100
    70ec:	7c707c39 	ldcvcl	12, cr7, [a1], #-228
    70f0:	78129a00 	ldmvcda	a3, {v6, v8, IP, PC}
    70f4:	781b9b04 	ldmvcda	v8, {a3, v5, v6, v8, IP, PC}
    70f8:	4d274c2a 	stcmi	12, cr4, [v4, #-168]!
    70fc:	940a192c 	strls	a2, [v7], #-2348
    7100:	28081c04 	stmcsda	v5, {a3, v7, v8, IP}
    7104:	e18ed900 	orr	SP, LR, a1, lsl #18
    7108:	0064a501 	rsbeq	v7, v1, a2, lsl #10
    710c:	44af5b2d 	strmit	v2, [pc], #2861	; 0x7114
    7110:	001007d8 	ldreqsb	a1, [a1], -v5
    7114:	005e0018 	subeqs	a1, LR, v5, lsl a1
    7118:	01820114 	orreq	a1, a3, v1, lsl a2
    711c:	031602e0 	tsteq	v3, #14	; 0xe
    7120:	98090350 	stmlsda	v6, {v1, v3, v5, v6}
    7124:	fe4af000 	cdp2	0, 4, cr15, cr10, cr0, {0}
    7128:	2400e17d 	strcs	LR, [a1], #-381
    712c:	4360201f 	cmnmi	a1, #31	; 0x1f
    7130:	18094919 	stmneda	v6, {a1, a4, v1, v5, v8, LR}
    7134:	32234a18 	eorcc	v1, a4, #98304	; 0x18000
    7138:	07805c10 	usada8eq	a1, a1, IP, v2
    713c:	3123d502 	teqcc	a4, a3, lsl #10
    7140:	e0012082 	and	a3, a2, a3, lsl #1
    7144:	20003123 	andcs	a4, a1, a4, lsr #2
    7148:	1c647008 	stcnel	0, cr7, [v1], #-32
    714c:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    7150:	d3eb2c1e 	mvnle	a3, #7680	; 0x1e00
    7154:	21002200 	tstcs	a1, a1, lsl #4
    7158:	b4072000 	strlt	a3, [v4]
    715c:	220a2300 	andcs	a3, v7, #0	; 0x0
    7160:	f009211e 	andnv	a3, v6, LR, lsl a2
    7164:	7c70fd3f 	ldcvcl	13, cr15, [a1], #-252
    7168:	74701c40 	ldrvcbt	a2, [a1], #-3136
    716c:	e15ab003 	cmp	v7, a4
    7170:	d1192b01 	tstle	v6, a2, lsl #22
    7174:	21002200 	tstcs	a1, a1, lsl #4
    7178:	b4072000 	strlt	a3, [v4]
    717c:	20012300 	andcs	a3, a2, a1, lsl #6
    7180:	fd30f009 	ldc2	0, cr15, [a1, #-36]!
    7184:	74702007 	ldrvcbt	a3, [a1], #-7
    7188:	e04ab003 	sub	v8, v7, a4
    718c:	00007530 	andeq	v4, a1, a1, lsr v2
    7190:	0000ea5c 	andeq	LR, a1, IP, asr v7
    7194:	00000875 	andeq	a1, a1, v2, ror v5
    7198:	00008a54 	andeq	v5, a1, v1, asr v7
    719c:	00009624 	andeq	v6, a1, v1, lsr #12
    71a0:	00000878 	andeq	a1, a1, v5, ror v5
    71a4:	00000bcc 	andeq	a1, a1, IP, asr #23
    71a8:	d12f290f 	teqle	PC, PC, lsl #18
    71ac:	d2382a1e 	eorles	a3, v5, #122880	; 0x1e000
    71b0:	fd0cf009 	stc2	0, cr15, [IP, #-36]
    71b4:	1c80a802 	stcne	8, cr10, [a1], {2}
    71b8:	2301b401 	tstcs	a2, #16777216	; 0x1000000
    71bc:	99099a0e 	stmlsdb	v6, {a2, a3, a4, v6, v8, IP, PC}
    71c0:	f0009806 	andnv	v6, a1, v3, lsl #16
    71c4:	b001fcd7 	ldrltd	PC, [a2], -v4
    71c8:	0e240604 	cfmadda32eq	mvax0, mvax0, mvfx4, mvfx4
    71cc:	d2142c1e 	andles	a3, v1, #7680	; 0x1e00
    71d0:	7a804668 	bvc	0xfe018b78
    71d4:	d0192800 	andles	a3, v6, a1, lsl #16
    71d8:	4344201f 	cmpmi	v1, #31	; 0x1f
    71dc:	190048bb 	stmnedb	a1, {a1, a2, a4, v1, v2, v4, v8, LR}
    71e0:	1c022123 	stfnes	f2, [a3], {35}
    71e4:	78123223 	ldmvcda	a3, {a1, a2, v2, v6, IP, SP}
    71e8:	0e520652 	mrceq	6, 2, a1, cr2, cr2, {2}
    71ec:	98005442 	stmlsda	a1, {a2, v3, v7, IP, LR}
    71f0:	78099900 	stmvcda	v6, {v5, v8, IP, PC}
    71f4:	70011c49 	andvc	a2, a2, v6, asr #24
    71f8:	2200e008 	andcs	LR, a1, #8	; 0x8
    71fc:	20002100 	andcs	a3, a1, a1, lsl #2
    7200:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    7204:	f0092001 	andnv	a3, v6, a2
    7208:	b003fced 	andlt	PC, a4, SP, ror #25
    720c:	28107c38 	ldmcsda	a1, {a4, v1, v2, v7, v8, IP, SP, LR}
    7210:	2000d107 	andcs	SP, a1, v4, lsl #2
    7214:	980a74b0 	stmlsda	v7, {v1, v2, v4, v7, IP, SP, LR}
    7218:	70012100 	andvc	a3, a2, a1, lsl #2
    721c:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    7220:	f7ff7470 	undefined
    7224:	2b01fb79 	blcs	0x86010
    7228:	2008d101 	andcs	SP, v5, a2, lsl #2
    722c:	4669e0e8 	strmibt	LR, [v6], -v5, ror #1
    7230:	06247a0c 	streqt	v4, [v1], -IP, lsl #20
    7234:	2c1e0e24 	ldccs	14, cr0, [LR], {36}
    7238:	211fd217 	tstcs	PC, v4, lsl a3
    723c:	4ba34361 	blmi	0xfe8d7fc8
    7240:	2123185b 	teqcs	a4, v8, asr v5
    7244:	1c645c59 	stcnel	12, cr5, [v1], #-356
    7248:	d0012901 	andle	a3, a2, a2, lsl #18
    724c:	d1f02902 	mvnles	a3, a3, lsl #18
    7250:	1c4074b4 	cfstrdne	mvd7, [a1], {180}
    7254:	22007470 	andcs	v4, a1, #1879048192	; 0x70000000
    7258:	20002100 	andcs	a3, a1, a1, lsl #2
    725c:	331cb407 	tstcc	IP, #117440512	; 0x7000000
    7260:	f0092004 	andnv	a3, v6, v1
    7264:	b003fcbf 	strlth	PC, [a4], -PC
    7268:	d000e0dd 	ldrled	LR, [a1], -SP
    726c:	980ae0db 	stmlsda	v7, {a1, a2, a4, v1, v3, v4, SP, LR, PC}
    7270:	1c407800 	mcrrne	8, 0, v4, a1, cr0
    7274:	7008990a 	andvc	v6, v5, v7, lsl #18
    7278:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    727c:	d3002803 	tstle	a1, #196608	; 0x30000
    7280:	9800e0f4 	stmlsda	a1, {a3, v1, v2, v3, v4, SP, LR, PC}
    7284:	42907840 	addmis	v4, a1, #4194304	; 0x400000
    7288:	f7ffd101 	ldrnvb	SP, [PC, a2, lsl #2]!
    728c:	2000fbaf 	andcs	PC, a1, PC, lsr #23
    7290:	e0c874b0 	strh	v4, [v5], #64
    7294:	d1732911 	cmnle	a4, a2, lsl v6
    7298:	99009800 	stmlsdb	a1, {v8, IP, PC}
    729c:	1c497849 	mcrrne	8, 4, v4, v6, cr9
    72a0:	7cb47041 	ldcvc	0, cr7, [v1], #260
    72a4:	99051e64 	stmlsdb	v2, {a3, v2, v3, v6, v7, v8, IP}
    72a8:	0e240624 	cfmadda32eq	mvax1, mvax0, mvfx4, mvfx4
    72ac:	4360201f 	cmnmi	a1, #31	; 0x1f
    72b0:	18104a86 	ldmneda	a1, {a2, a3, v4, v6, v8, LR}
    72b4:	f000301c 	andnv	a4, a1, IP, lsl a1
    72b8:	2801fc47 	stmcsda	a2, {a1, a2, a3, v3, v7, v8, IP, SP, LR, PC}
    72bc:	2400d00f 	strcs	SP, [a1], #-15
    72c0:	201f9905 	andcss	v6, PC, v2, lsl #18
    72c4:	4a814360 	bmi	0xfe05804c
    72c8:	301c1810 	andccs	a2, IP, a1, lsl v5
    72cc:	fc3cf000 	ldc2	0, cr15, [IP]
    72d0:	d0042801 	andle	a3, v1, a2, lsl #16
    72d4:	06241c64 	streqt	a2, [v1], -v1, ror #24
    72d8:	2c1e0e24 	ldccs	14, cr0, [LR], {36}
    72dc:	201fd3f0 	ldrcssh	SP, [PC], -a1
    72e0:	497a4360 	ldmmidb	v7!, {v2, v3, v5, v6, LR}^
    72e4:	90011808 	andls	a2, a2, v5, lsl #16
    72e8:	90073008 	andls	a4, v4, v5
    72ec:	d2412c1e 	suble	a3, a2, #7680	; 0x1e00
    72f0:	28007e38 	stmcsda	a1, {a4, v1, v2, v6, v7, v8, IP, SP, LR}
    72f4:	9807d108 	stmlsda	v4, {a4, v5, IP, LR, PC}
    72f8:	28007800 	stmcsda	a1, {v8, IP, SP, LR}
    72fc:	4974d11f 	ldmmidb	v1!, {a1, a2, a3, a4, v1, v5, IP, LR, PC}^
    7300:	f0009807 	andnv	v6, a1, v4, lsl #16
    7304:	e01afc2d 	ands	PC, v7, SP, lsr #24
    7308:	18084872 	stmneda	v5, {a2, v1, v2, v3, v8, LR}
    730c:	434c211f 	cmpmi	IP, #-1073741817	; 0xc0000007
    7310:	1909496e 	stmnedb	v6, {a2, a3, a4, v2, v3, v5, v8, LR}
    7314:	24003108 	strcs	a4, [a1], #-264
    7318:	5d0a5d03 	stcpl	13, cr5, [v7, #-12]
    731c:	429a1c64 	addmis	a2, v7, #25600	; 0x6400
    7320:	2a00d103 	bcs	0x3b734
    7324:	2500d1f8 	strcs	SP, [a1, #-504]
    7328:	1ad5e000 	bne	0xff57f330
    732c:	d0062d00 	andle	a3, v3, a1, lsl #26
    7330:	98079908 	stmlsda	v4, {a4, v5, v8, IP, PC}
    7334:	fc14f000 	ldc2	0, cr15, [v1], {0}
    7338:	21014668 	tstcs	a2, v5, ror #12
    733c:	98077281 	stmlsda	v4, {a1, v4, v6, IP, SP, LR}
    7340:	28027ec0 	stmcsda	a3, {v3, v4, v6, v7, v8, IP, SP, LR}
    7344:	4668d113 	undefined
    7348:	28017a80 	stmcsda	a2, {v4, v6, v8, IP, SP, LR}
    734c:	2200d10f 	andcs	SP, a1, #-1073741821	; 0xc0000003
    7350:	31189901 	tstcc	v5, a2, lsl #18
    7354:	b4079807 	strlt	v6, [v4], #-2055
    7358:	331c9b04 	tstcc	IP, #4096	; 0x1000
    735c:	20052100 	andcs	a3, v2, a1, lsl #2
    7360:	fc40f009 	mcrr2	0, 0, PC, a1, cr9
    7364:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    7368:	b0037470 	andlt	v4, a4, a1, ror v1
    736c:	7c70e002 	ldcvcl	0, cr14, [a1], #-8
    7370:	74701e40 	ldrvcbt	a2, [a1], #-3648
    7374:	99079807 	stmlsdb	v4, {a1, a2, a3, v8, IP, PC}
    7378:	22407ec9 	subcs	v4, a1, #3216	; 0xc90
    737c:	76c2430a 	strvcb	v1, [a3], v7, lsl #6
    7380:	28127c38 	ldmcsda	a3, {a4, v1, v2, v7, v8, IP, SP, LR}
    7384:	e74cd000 	strb	SP, [IP, -a1]
    7388:	7800980a 	stmvcda	a1, {a2, a4, v8, IP, PC}
    738c:	d12d2802 	teqle	SP, a3, lsl #16
    7390:	7cb09905 	ldcvc	9, cr9, [a1], #20
    7394:	06001e40 	streq	a2, [a1], -a1, asr #28
    7398:	221f0e00 	andcss	a1, PC, #0	; 0x0
    739c:	4a4b4350 	bmi	0x12d80e4
    73a0:	301c1810 	andccs	a2, IP, a1, lsl v5
    73a4:	fbd0f000 	blx	0xff4433ae
    73a8:	d01a2801 	andles	a3, v7, a2, lsl #16
    73ac:	e0042400 	and	a3, v1, a1, lsl #8
    73b0:	06241c64 	streqt	a2, [v1], -v1, ror #24
    73b4:	2c1e0e24 	ldccs	14, cr0, [LR], {36}
    73b8:	201fd213 	andcss	SP, PC, a4, lsl a3
    73bc:	49434360 	stmmidb	a4, {v2, v3, v5, v6, LR}^
    73c0:	9905180d 	stmlsdb	v2, {a1, a3, a4, v8, IP}
    73c4:	301c1c28 	andccs	a2, IP, v5, lsr #24
    73c8:	fbbef000 	blx	0xfefc33d2
    73cc:	d1ef2801 	mvnle	a3, a2, lsl #16
    73d0:	5c282023 	stcpl	0, cr2, [v5], #-140
    73d4:	d1042801 	tstle	v1, a2, lsl #16
    73d8:	3508493d 	strcc	v1, [v5, #-2365]
    73dc:	f0001c28 	andnv	a2, a1, v5, lsr #24
    73e0:	9800fbbf 	stmlsda	a1, {a1, a2, a3, a4, v1, v2, v4, v5, v6, v8, IP, SP, LR, PC}
    73e4:	78499900 	stmvcda	v6, {v5, v8, IP, PC}^
    73e8:	70411c49 	subvc	a2, a2, v6, asr #24
    73ec:	1e407c70 	mcrne	12, 2, v4, cr0, cr0, {3}
    73f0:	2917e716 	ldmcsdb	v4, {a2, a3, v1, v5, v6, v7, SP, LR, PC}
    73f4:	7c78d117 	ldfvcp	f5, [v5], #-92
    73f8:	d1022850 	tstle	a3, a1, asr v5
    73fc:	30fe7c70 	rscccs	v4, LR, a1, ror IP
    7400:	4935e38a 	ldmmidb	v2!, {a2, a4, v4, v5, v6, SP, LR, PC}
    7404:	6a896809 	bvs	0xfe261430
    7408:	31256a49 	teqcc	v2, v6, asr #20
    740c:	48327008 	ldmmida	a3!, {a4, IP, SP, LR}
    7410:	6a806800 	bvs	0xfe021418
    7414:	49306a40 	ldmmidb	a1!, {v3, v6, v8, SP, LR}
    7418:	6a896809 	bvs	0xfe261444
    741c:	7fc96a49 	swivc	0x00c96a49
    7420:	430a2208 	tstmi	v7, #-2147483648	; 0x80000000
    7424:	e37877c2 	cmn	v5, #50855936	; 0x3080000
    7428:	d1fc2910 	mvnles	a3, a1, lsl v6
    742c:	e00c2400 	and	a3, IP, a1, lsl #8
    7430:	21003023 	tstcs	a1, a4, lsr #32
    7434:	98007001 	stmlsda	a1, {a1, IP, SP, LR}
    7438:	70012100 	andvc	a3, a2, a1, lsl #2
    743c:	70419800 	subvc	v6, a2, a1, lsl #16
    7440:	06241c64 	streqt	a2, [v1], -v1, ror #24
    7444:	2c1e0e24 	ldccs	14, cr0, [LR], {36}
    7448:	211fd210 	tstcs	PC, a1, lsl a3
    744c:	481f4361 	ldmmida	PC, {a1, v2, v3, v5, v6, LR}
    7450:	4a1e1840 	bmi	0x78d558
    7454:	5c513223 	lfmpl	f3, 2, [a2], {35}
    7458:	d5e90789 	strleb	a1, [v6, #1929]!
    745c:	21023023 	tstcs	a3, a4, lsr #32
    7460:	4668e7e8 	strmibt	LR, [v5], -v5, ror #15
    7464:	06247a04 	streqt	v4, [v1], -v1, lsl #20
    7468:	2c1e0e24 	ldccs	14, cr0, [LR], {36}
    746c:	f7ffd301 	ldrnvb	SP, [PC, a2, lsl #6]!
    7470:	201ffabd 	ldrcsh	PC, [PC], -SP
    7474:	49154360 	ldmmidb	v2, {v2, v3, v5, v6, LR}
    7478:	21231808 	teqcs	a4, v5, lsl #16
    747c:	29015c41 	stmcsdb	a2, {a1, v3, v7, v8, IP, LR}
    7480:	3023d102 	eorcc	SP, a4, a3, lsl #2
    7484:	70012100 	andvc	a3, a2, a1, lsl #2
    7488:	e7ec1c64 	strb	a2, [IP, v1, ror #24]!
    748c:	7c707c39 	ldcvcl	12, cr7, [a1], #-228
    7490:	d8192804 	ldmleda	v6, {a3, v8, SP}
    7494:	0040a201 	subeq	v7, a1, a2, lsl #4
    7498:	44975a12 	ldrmi	v2, [v4], #2578
    749c:	003e0008 	eoreqs	a1, LR, v5
    74a0:	01620082 	smulbbeq	a3, a3, a1
    74a4:	2200018a 	andcs	a1, a1, #-2147483614	; 0x80000022
    74a8:	20002100 	andcs	a3, a1, a1, lsl #2
    74ac:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    74b0:	20092101 	andcs	a3, v6, a2, lsl #2
    74b4:	fb96f009 	blx	0xfe5c34e2
    74b8:	980e9908 	stmlsda	LR, {a4, v5, v8, IP, PC}
    74bc:	fb3cf000 	blx	0xf434c6
    74c0:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    74c4:	b0037470 	andlt	v4, a4, a1, ror v1
    74c8:	46c0e327 	strmib	LR, [a1], v4, lsr #6
    74cc:	00008a54 	andeq	v5, a1, v1, asr v7
    74d0:	00118db8 	ldreqh	v5, [a2], -v5
    74d4:	0000048e 	andeq	a1, a1, LR, lsl #9
    74d8:	00009624 	andeq	v6, a1, v1, lsr #12
    74dc:	28137c38 	ldmcsda	a4, {a4, v1, v2, v7, v8, IP, SP, LR}
    74e0:	7c78d1f2 	ldfvcp	f5, [v5], #-968
    74e4:	d1212801 	teqle	a2, a2, lsl #16
    74e8:	7cb99806 	ldcvc	8, cr9, [v6], #24
    74ec:	48d97001 	ldmmiia	v6, {a1, IP, SP, LR}^
    74f0:	6a806800 	bvs	0xfe0214f8
    74f4:	49d76a40 	ldmmiib	v4, {v3, v6, v8, SP, LR}^
    74f8:	6a896809 	bvs	0xfe261524
    74fc:	7fc96a49 	swivc	0x00c96a49
    7500:	430a2202 	tstmi	v7, #536870912	; 0x20000000
    7504:	220077c2 	andcs	v4, a1, #50855936	; 0x3080000
    7508:	20002100 	andcs	a3, a1, a1, lsl #2
    750c:	9b0eb407 	blls	0x3b4530
    7510:	f0092004 	andnv	a3, v6, v1
    7514:	7c70fb67 	ldcvcl	11, cr15, [a1], #-412
    7518:	74701c40 	ldrvcbt	a2, [a1], #-3136
    751c:	e2fcb003 	rscs	v8, IP, #3	; 0x3
    7520:	d10e291a 	tstle	LR, v7, lsl v6
    7524:	78009806 	stmvcda	a1, {a2, a3, v8, IP, PC}
    7528:	d1f828ff 	ldrlesh	a3, [v5, #143]!
    752c:	74302011 	ldrvct	a3, [a1], #-17
    7530:	74702000 	ldrvcbt	a3, [a1]
    7534:	74f06170 	ldrvcbt	v3, [a1], #368
    7538:	219569f0 	ldrcssh	v3, [v2, a1]
    753c:	f7ff0209 	ldrnvb	a1, [PC, v6, lsl #4]!
    7540:	2911fa5d 	ldmcsdb	a2, {a1, a3, a4, v1, v3, v6, v8, IP, SP, LR, PC}
    7544:	a802d14d 	stmgeda	a3, {a1, a3, a4, v3, v5, IP, LR, PC}
    7548:	b4011c80 	strlt	a2, [a2], #-3200
    754c:	9a0e2302 	bls	0x39015c
    7550:	98069909 	stmlsda	v3, {a1, a4, v5, v8, IP, PC}
    7554:	fb0ef000 	blx	0x3c355e
    7558:	0604b001 	streq	v8, [v1], -a2
    755c:	2c1e0e24 	ldccs	14, cr0, [LR], {36}
    7560:	9908d22a 	stmlsdb	v5, {a2, a4, v2, v6, IP, LR, PC}
    7564:	4abd48bc 	bmi	0xfef5985c
    7568:	f0001810 	andnv	a2, a1, a1, lsl v5
    756c:	9905faf9 	stmlsdb	v2, {a1, a4, v1, v2, v3, v4, v6, v8, IP, SP, LR, PC}
    7570:	f000980b 	andnv	v6, a1, v8, lsl #16
    7574:	211ffae1 	tstcsp	PC, a2, ror #21
    7578:	4ab84361 	bmi	0xfee18304
    757c:	31181851 	tstcc	v5, a2, asr v5
    7580:	4bb64ab7 	blmi	0xfed9a064
    7584:	2004189a 	mulcs	v1, v7, v5
    7588:	5c0b1e40 	stcpl	14, cr1, [v8], {64}
    758c:	d1fb5413 	mvnles	v2, a4, lsl v1
    7590:	4344201f 	cmpmi	v1, #31	; 0x1f
    7594:	190348b1 	stmnedb	a4, {a1, v1, v2, v4, v8, LR}
    7598:	1c192200 	lfmne	f2, 4, [v6], {0}
    759c:	1c183118 	ldfnes	f3, [v5], {24}
    75a0:	b4073008 	strlt	a4, [v4], #-8
    75a4:	2100331c 	tstcs	a1, IP, lsl a4
    75a8:	f0092005 	andnv	a3, v6, v2
    75ac:	7c70fb1b 	ldcvcl	11, cr15, [a1], #-108
    75b0:	74701c40 	ldrvcbt	a2, [a1], #-3136
    75b4:	e014b003 	ands	v8, v1, a4
    75b8:	21002200 	tstcs	a1, a1, lsl #4
    75bc:	b4072000 	strlt	a3, [v4]
    75c0:	98092300 	stmlsda	v6, {v5, v6, SP}
    75c4:	20087801 	andcs	v4, v5, a2, lsl #16
    75c8:	fb0cf009 	blx	0x3435f6
    75cc:	74302011 	ldrvct	a3, [a1], #-17
    75d0:	74702000 	ldrvcbt	a3, [a1]
    75d4:	74f06170 	ldrvcbt	v3, [a1], #368
    75d8:	219569f0 	ldrcssh	v3, [v2, a1]
    75dc:	80010209 	andhi	a1, a2, v6, lsl #4
    75e0:	7c38b003 	ldcvc	0, cr11, [v5], #-12
    75e4:	d11e2812 	tstle	LR, a3, lsl v5
    75e8:	21002200 	tstcs	a1, a1, lsl #4
    75ec:	b4072000 	strlt	a3, [v4]
    75f0:	98092300 	stmlsda	v6, {v5, v6, SP}
    75f4:	20087801 	andcs	v4, v5, a2, lsl #16
    75f8:	faf4f009 	blx	0xffd43624
    75fc:	e114b003 	tst	v1, a4
    7600:	d1102917 	tstle	a1, v4, lsl v6
    7604:	28507c78 	ldmcsda	a1, {a4, v1, v2, v3, v7, v8, IP, SP, LR}^
    7608:	2200d1ee 	andcs	SP, a1, #-2147483589	; 0x8000003b
    760c:	20002100 	andcs	a3, a1, a1, lsl #2
    7610:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    7614:	78019809 	stmvcda	a2, {a1, a4, v8, IP, PC}
    7618:	f009200b 	andnv	a3, v6, v8
    761c:	7c70fae3 	ldcvcl	10, cr15, [a1], #-908
    7620:	74701c40 	ldrvcbt	a2, [a1], #-3136
    7624:	e278b003 	rsbs	v8, v5, #3	; 0x3
    7628:	7a009800 	bvc	0x2d630
    762c:	d0fa2800 	rscles	a3, v7, a1, lsl #16
    7630:	21019806 	tstcs	a2, v3, lsl #16
    7634:	f7ff7041 	ldrnvb	v4, [PC, a2, asr #32]!
    7638:	7c39fb52 	ldcvc	11, cr15, [v6], #-328
    763c:	28067c70 	stmcsda	v3, {v1, v2, v3, v7, v8, IP, SP, LR}
    7640:	a202d8f1 	andge	SP, a3, #15794176	; 0xf10000
    7644:	5e120040 	cdppl	0, 1, cr0, cr2, cr0, {2}
    7648:	46c04497 	undefined
    764c:	fad6029e 	blx	0xff5880cc
    7650:	0036000e 	eoreqs	a1, v3, LR
    7654:	01e60184 	mvneq	a1, v1, lsl #3
    7658:	2200022c 	andcs	a1, a1, #-1073741822	; 0xc0000002
    765c:	20002100 	andcs	a3, a1, a1, lsl #2
    7660:	9807b407 	stmlsda	v4, {a1, a2, a3, v7, IP, SP, PC}
    7664:	211f7800 	tstcs	PC, a1, lsl #16
    7668:	497c4348 	ldmmidb	IP!, {a4, v3, v5, v6, LR}^
    766c:	331c180b 	tstcc	IP, #720896	; 0xb0000
    7670:	20022100 	andcs	a3, a3, a1, lsl #2
    7674:	fab6f009 	blx	0xfedc36a0
    7678:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    767c:	b0037470 	andlt	v4, a4, a1, ror v1
    7680:	2913e24b 	ldmcsdb	a4, {a1, a2, a4, v3, v6, SP, LR, PC}
    7684:	e098d000 	adds	SP, v5, a1
    7688:	28017c78 	stmcsda	a2, {a4, v1, v2, v3, v7, v8, IP, SP, LR}
    768c:	e08ad000 	add	SP, v7, a1
    7690:	99044874 	stmlsdb	v1, {a3, v1, v2, v3, v8, LR}
    7694:	222f7849 	eorcs	v4, PC, #4784128	; 0x490000
    7698:	4a704351 	bmi	0x1c183e4
    769c:	7cba1851 	ldcvc	8, cr1, [v7], #324
    76a0:	486c540a 	stmmida	IP!, {a2, a4, v7, IP, LR}^
    76a4:	6a806800 	bvs	0xfe0216ac
    76a8:	496a6a40 	stmmidb	v7!, {v3, v6, v8, SP, LR}^
    76ac:	6a896809 	bvs	0xfe2616d8
    76b0:	7fc96a49 	swivc	0x00c96a49
    76b4:	430a2202 	tstmi	v7, #536870912	; 0x20000000
    76b8:	496b77c2 	stmmidb	v8!, {a2, v3, v4, v5, v6, v7, IP, SP, LR}^
    76bc:	5c514a67 	mrrcpl	10, 6, v1, a2, cr7
    76c0:	4351221f 	cmpmi	a2, #-268435455	; 0xf0000001
    76c4:	18514a65 	ldmneda	a2, {a1, a3, v2, v3, v6, v8, LR}^
    76c8:	4a68311c 	bmi	0x1a13b40
    76cc:	4c634b66 	stcmil	11, cr4, [a4], #-408
    76d0:	785b18e3 	ldmvcda	v8, {a1, a2, v2, v3, v4, v8, IP}^
    76d4:	4363242f 	cmnmi	a4, #788529152	; 0x2f000000
    76d8:	18e34c60 	stmneia	a4!, {v2, v3, v7, v8, LR}^
    76dc:	2007189a 	mulcs	v4, v7, v5
    76e0:	5c0b1e40 	stcpl	14, cr1, [v8], {64}
    76e4:	d1fb5413 	mvnles	v2, a4, lsl v1
    76e8:	78009804 	stmvcda	a1, {a3, v8, IP, PC}
    76ec:	4348211f 	cmpmi	v5, #-1073741817	; 0xc0000007
    76f0:	1809495a 	stmneda	v6, {a2, a4, v1, v3, v5, v8, LR}
    76f4:	48583108 	ldmmida	v5, {a4, v5, IP, SP}^
    76f8:	78529a04 	ldmvcda	a3, {a3, v6, v8, IP, PC}^
    76fc:	435a232f 	cmpmi	v7, #-1140850688	; 0xbc000000
    7700:	189a4b56 	ldmneia	v7, {a2, a3, v1, v3, v5, v6, v8, LR}
    7704:	f0001810 	andnv	a2, a1, a1, lsl v5
    7708:	4957fa2b 	ldmmidb	v4, {a1, a2, a4, v2, v6, v8, IP, SP, LR, PC}^
    770c:	5c514a53 	mrrcpl	10, 5, v1, a2, cr3
    7710:	4351221f 	cmpmi	a2, #-268435455	; 0xf0000001
    7714:	18514a51 	ldmneda	a2, {a1, v1, v3, v6, v8, LR}^
    7718:	4a513118 	bmi	0x1453b80
    771c:	18e34b52 	stmneia	a4!, {a2, v1, v3, v5, v6, v8, LR}^
    7720:	242f785b 	strcst	v4, [pc], #2139	; 0x7728
    7724:	4c4d4363 	mcrrmi	3, 6, v1, SP, cr3
    7728:	189a18e3 	ldmneia	v7, {a1, a2, v2, v3, v4, v8, IP}
    772c:	1e402004 	cdpne	0, 4, cr2, cr0, cr4, {0}
    7730:	54135c0b 	ldrpl	v2, [a4], #-3083
    7734:	9804d1fb 	stmlsda	v1, {a1, a2, a4, v1, v2, v3, v4, v5, IP, LR, PC}
    7738:	211f7800 	tstcs	PC, a1, lsl #16
    773c:	49474348 	stmmidb	v4, {a4, v3, v5, v6, LR}^
    7740:	30231808 	eorcc	a2, a4, v5, lsl #16
    7744:	70012102 	andvc	a3, a2, a3, lsl #2
    7748:	78409804 	stmvcda	a1, {a3, v8, IP, PC}^
    774c:	d1042801 	tstle	v1, a2, lsl #16
    7750:	21207a78 	teqcs	a1, v5, ror v7
    7754:	72794301 	rsbvcs	v1, v6, #67108864	; 0x4000000
    7758:	7a79e009 	bvc	0x1e7f784
    775c:	d1012802 	tstle	a2, a3, lsl #16
    7760:	e0022040 	and	a3, a3, a1, asr #32
    7764:	d1022803 	tstle	a3, a4, lsl #16
    7768:	43082080 	tstmi	v5, #128	; 0x80
    776c:	98047278 	stmlsda	v1, {a4, v1, v2, v3, v6, IP, SP, LR}
    7770:	212f7840 	teqcs	PC, a1, asr #16
    7774:	49394348 	ldmmidb	v6!, {a4, v3, v5, v6, LR}
    7778:	2200180b 	andcs	a2, a1, #720896	; 0xb0000
    777c:	78009804 	stmvcda	a1, {a3, v8, IP, PC}
    7780:	4348211f 	cmpmi	v5, #-1073741817	; 0xc0000007
    7784:	18094935 	stmneda	v6, {a1, a3, v1, v2, v5, v8, LR}
    7788:	48333118 	ldmmida	a4!, {a4, v1, v5, IP, SP}
    778c:	b4071818 	strlt	a2, [v4], #-2072
    7790:	181b4836 	ldmneda	v8, {a2, a3, v1, v2, v8, LR}
    7794:	20052100 	andcs	a3, v2, a1, lsl #2
    7798:	fa24f009 	blx	0x9437c4
    779c:	1cc07c70 	stcnel	12, cr7, [a1], {112}
    77a0:	b0037470 	andlt	v4, a4, a1, ror v1
    77a4:	69f0e009 	ldmvsib	a1!, {a1, a4, SP, LR, PC}^
    77a8:	02092195 	andeq	a3, v6, #1073741861	; 0x40000025
    77ac:	20118001 	andcss	v5, a2, a2
    77b0:	20007430 	andcs	v4, a1, a1, lsr v1
    77b4:	61707470 	cmnvs	a1, a1, ror v1
    77b8:	7c3874f0 	cfldrsvc	mvf7, [v5], #-960
    77bc:	d1672815 	cmnle	v4, v2, lsl v5
    77c0:	210269f0 	strcsd	v3, [a3, -a1]
    77c4:	20008001 	andcs	v5, a1, a2
    77c8:	7c706270 	lfmvc	f6, 2, [a1], #-448
    77cc:	e1a31c40 	mov	a2, a1, asr #24
    77d0:	28006a70 	stmcsda	a1, {v1, v2, v3, v6, v8, SP, LR}
    77d4:	4926d026 	stmmidb	v3!, {a2, a3, v2, IP, LR, PC}
    77d8:	18514a20 	ldmneda	a2, {v2, v6, v8, LR}^
    77dc:	4a256a49 	bmi	0x962108
    77e0:	4c1e4b21 	ldcmi	11, cr4, [LR], {33}
    77e4:	785b18e3 	ldmvcda	v8, {a1, a2, v2, v3, v4, v8, IP}^
    77e8:	4363242f 	cmnmi	a4, #788529152	; 0x2f000000
    77ec:	18e34c1b 	stmneia	a4!, {a1, a2, a4, v1, v7, v8, LR}^
    77f0:	2010189a 	mulcss	a1, v7, v5
    77f4:	5c0b1e40 	stcpl	14, cr1, [v8], {64}
    77f8:	d1fb5413 	mvnles	v2, a4, lsl v1
    77fc:	21006a72 	tstcs	a1, a3, ror v7
    7800:	b4072000 	strlt	a3, [v4]
    7804:	78009807 	stmvcda	a1, {a1, a2, a3, v8, IP, PC}
    7808:	4348211f 	cmpmi	v5, #-1073741817	; 0xc0000007
    780c:	180b4913 	stmneda	v8, {a1, a2, v1, v5, v8, LR}
    7810:	2200331c 	andcs	a4, a1, #1879048192	; 0x70000000
    7814:	200a2100 	andcs	a3, v7, a1, lsl #2
    7818:	f9e4f009 	stmnvib	v1!, {a1, a4, IP, SP, LR, PC}^
    781c:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    7820:	b0037470 	andlt	v4, a4, a1, ror v1
    7824:	28137c38 	ldmcsda	a4, {a4, v1, v2, v7, v8, IP, SP, LR}
    7828:	69f0d132 	ldmvsib	a1!, {a2, v1, v2, v5, IP, LR, PC}^
    782c:	02092195 	andeq	a3, v6, #1073741861	; 0x40000025
    7830:	2913e0ed 	ldmcsdb	a4, {a1, a3, a4, v2, v3, v4, SP, LR, PC}
    7834:	69f0d109 	ldmvsib	a1!, {a1, a4, v5, IP, LR, PC}^
    7838:	02092195 	andeq	a3, v6, #1073741861	; 0x40000025
    783c:	20118001 	andcss	v5, a2, a2
    7840:	20007430 	andcs	v4, a1, a1, lsr v1
    7844:	61707470 	cmnvs	a1, a1, ror v1
    7848:	7c3874f0 	cfldrsvc	mvf7, [v5], #-960
    784c:	d11f281f 	tstle	PC, PC, lsl v5
    7850:	e1612003 	cmn	a2, a4
    7854:	00009624 	andeq	v6, a1, v1, lsr #12
    7858:	000003aa 	andeq	a1, a1, v7, lsr #7
    785c:	00008a54 	andeq	v5, a1, v1, asr v7
    7860:	000003ba 	streqh	a1, [a1], -v7
    7864:	000003d5 	ldreqd	a1, [a1], -v2
    7868:	00000976 	andeq	a1, a1, v3, ror v6
    786c:	000003ce 	andeq	a1, a1, LR, asr #7
    7870:	00000ba4 	andeq	a1, a1, v1, lsr #23
    7874:	000003be 	streqh	a1, [a1], -LR
    7878:	28177c38 	ldmcsda	v4, {a4, v1, v2, v7, v8, IP, SP, LR}
    787c:	f7ffd108 	ldrnvb	SP, [PC, v5, lsl #2]!
    7880:	7c70fa4d 	ldcvcl	10, cr15, [a1], #-308
    7884:	d0302800 	eorles	a3, a1, a1, lsl #16
    7888:	d0022801 	andle	a3, a3, a2, lsl #16
    788c:	d01a2802 	andles	a3, v7, a3, lsl #16
    7890:	9804e143 	stmlsda	v1, {a1, a2, v3, v5, SP, LR, PC}
    7894:	48a27803 	stmmiia	a3!, {a1, a2, v8, IP, SP, LR}
    7898:	434b212f 	cmpmi	v8, #-1073741813	; 0xc000000b
    789c:	18c949a1 	stmneia	v6, {a1, v2, v4, v5, v8, LR}^
    78a0:	2cff5c0c 	ldccsl	12, cr5, [PC], #48
    78a4:	9804d0eb 	stmlsda	v1, {a1, a2, a4, v2, v3, v4, IP, LR, PC}
    78a8:	22007004 	andcs	v4, a1, #4	; 0x4
    78ac:	20002100 	andcs	a3, a1, a1, lsl #2
    78b0:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    78b4:	20081c21 	andcs	a2, v5, a2, lsr #24
    78b8:	f994f009 	ldmnvib	v1, {a1, a4, IP, SP, LR, PC}
    78bc:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    78c0:	b0037470 	andlt	v4, a4, a1, ror v1
    78c4:	7c38e129 	ldfvcd	f6, [v5], #-164
    78c8:	d1fb281a 	mvnles	a3, v7, lsl v5
    78cc:	78009804 	stmvcda	a1, {a3, v8, IP, PC}
    78d0:	42887cb9 	addmi	v4, v5, #47360	; 0xb900
    78d4:	7c70e7d2 	ldcvcl	7, cr14, [a1], #-840
    78d8:	d0062800 	andle	a3, v3, a1, lsl #16
    78dc:	d1012801 	tstle	a2, a2, lsl #16
    78e0:	f8caf7ff 	stmnvia	v7, {a1, a2, a3, a4, v1, v2, v3, v4, v5, v6, v7, IP, SP, LR, PC}^
    78e4:	f7ff2802 	ldrnvb	a3, [PC, a3, lsl #16]!
    78e8:	9809fa21 	stmlsda	v6, {a1, v2, v6, v8, IP, SP, LR, PC}
    78ec:	f9aaf000 	stmnvib	v7!, {IP, SP, LR, PC}
    78f0:	7c70e113 	ldfvcp	f6, [a1], #-76
    78f4:	d8fb2803 	ldmleia	v8!, {a1, a2, v8, SP}^
    78f8:	0040a101 	subeq	v7, a1, a2, lsl #2
    78fc:	448f5e09 	strmi	v2, [pc], #3593	; 0x7904
    7900:	f820ffe8 	stmnvda	a1!, {a4, v2, v3, v4, v5, v6, v7, v8, IP, SP, LR, PC}
    7904:	ff760006 	swinv	0x00760006
    7908:	21002200 	tstcs	a1, a1, lsl #4
    790c:	b4072000 	strlt	a3, [v4]
    7910:	78009807 	stmvcda	a1, {a1, a2, a3, v8, IP, PC}
    7914:	4348211f 	cmpmi	v5, #-1073741817	; 0xc0000007
    7918:	180b4982 	stmneda	v8, {a2, v4, v5, v8, LR}
    791c:	2100331c 	tstcs	a1, IP, lsl a4
    7920:	f0092006 	andnv	a3, v6, v3
    7924:	9807f95f 	stmlsda	v4, {a1, a2, a3, a4, v1, v3, v5, v8, IP, SP, LR, PC}
    7928:	211f7800 	tstcs	PC, a1, lsl #16
    792c:	497d4348 	ldmmidb	SP!, {a4, v3, v5, v6, LR}^
    7930:	30231808 	eorcc	a2, a4, v5, lsl #16
    7934:	70012100 	andvc	a3, a2, a1, lsl #2
    7938:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    793c:	b0037470 	andlt	v4, a4, a1, ror v1
    7940:	7c70e0eb 	ldcvcl	0, cr14, [a1], #-940
    7944:	d0022800 	andle	a3, a3, a1, lsl #16
    7948:	d01d2801 	andles	a3, SP, a2, lsl #16
    794c:	6a70e0e5 	bvs	0x1c3fce8
    7950:	d0fb2800 	rscles	a3, v8, a1, lsl #16
    7954:	4a734974 	bmi	0x1cd9f2c
    7958:	6a491851 	bvs	0x124daa4
    795c:	4b714a73 	blmi	0x1c5a330
    7960:	2010189a 	mulcss	a1, v7, v5
    7964:	5c0b1e40 	stcpl	14, cr1, [v8], {64}
    7968:	d1fb5413 	mvnles	v2, a4, lsl v1
    796c:	21006a72 	tstcs	a1, a3, ror v7
    7970:	b4072000 	strlt	a3, [v4]
    7974:	22009b0e 	andcs	v6, a1, #14336	; 0x3800
    7978:	f009200a 	andnv	a3, v6, v7
    797c:	7c70f933 	ldcvcl	9, cr15, [a1], #-204
    7980:	74701c40 	ldrvcbt	a2, [a1], #-3136
    7984:	e0c8b003 	sbc	v8, v5, a4
    7988:	281f7c38 	ldmcsda	PC, {a4, v1, v2, v7, v8, IP, SP, LR}
    798c:	e0c0d1fb 	strd	SP, [a1], #27
    7990:	29037c71 	stmcsdb	a4, {a1, v1, v2, v3, v7, v8, IP, SP, LR}
    7994:	a202d8f7 	andge	SP, a3, #16187392	; 0xf70000
    7998:	5e520049 	cdppl	0, 5, cr0, cr2, cr9, {2}
    799c:	46c04497 	undefined
    79a0:	f782ff4a 	strnv	PC, [a3, v7, asr #30]
    79a4:	00260008 	eoreq	a1, v3, v5
    79a8:	21002200 	tstcs	a1, a1, lsl #4
    79ac:	b4072000 	strlt	a3, [v4]
    79b0:	98072300 	stmlsda	v4, {v5, v6, SP}
    79b4:	201c7801 	andcss	v4, IP, a2, lsl #16
    79b8:	f914f009 	ldmnvdb	v1, {a1, a4, IP, SP, LR, PC}
    79bc:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    79c0:	b0037470 	andlt	v4, a4, a1, ror v1
    79c4:	7c39e0a9 	ldcvc	0, cr14, [v6], #-676
    79c8:	d1fb2920 	mvnles	a3, a1, lsr #18
    79cc:	78099904 	stmvcda	v6, {a3, v5, v8, IP, PC}
    79d0:	d1102901 	tstle	a1, a2, lsl #18
    79d4:	21017a78 	tstcs	a2, v5, ror v7
    79d8:	72794301 	rsbvcs	v1, v6, #67108864	; 0x4000000
    79dc:	68004854 	stmvsda	a1, {a3, v1, v3, v8, LR}
    79e0:	6a406a80 	bvs	0x10223e8
    79e4:	68094952 	stmvsda	v6, {a2, v1, v3, v5, v8, LR}
    79e8:	6a496a89 	bvs	0x1262414
    79ec:	22017fc9 	andcs	v4, a2, #804	; 0x324
    79f0:	77c2430a 	strvcb	v1, [a3, v7, lsl #6]
    79f4:	7a79e009 	bvc	0x1e7fa20
    79f8:	72794001 	rsbvcs	v1, v6, #1	; 0x1
    79fc:	6809494c 	stmvsda	v6, {a3, a4, v3, v5, v8, LR}
    7a00:	6a496a89 	bvs	0x126242c
    7a04:	40107fca 	andmis	v4, a1, v7, asr #31
    7a08:	69f077c8 	ldmvsib	a1!, {a4, v3, v4, v5, v6, v7, IP, SP, LR}^
    7a0c:	f7ff2100 	ldrnvb	a3, [PC, a1, lsl #2]!
    7a10:	7c70f987 	ldcvcl	9, cr15, [a1], #-540
    7a14:	d8142803 	ldmleda	v1, {a1, a2, v8, SP}
    7a18:	0040a101 	subeq	v7, a1, a2, lsl #2
    7a1c:	448f5e09 	strmi	v2, [pc], #3593	; 0x7a24
    7a20:	f056fec8 	subnvs	PC, v3, v5, asr #29
    7a24:	00220006 	eoreq	a1, a3, v3
    7a28:	21002200 	tstcs	a1, a1, lsl #4
    7a2c:	b4072000 	strlt	a3, [v4]
    7a30:	21012300 	tstcs	a2, a1, lsl #6
    7a34:	f0092034 	andnv	a3, v6, v1, lsr a1
    7a38:	7c70f8d5 	ldcvcl	8, cr15, [a1], #-852
    7a3c:	74701c40 	ldrvcbt	a2, [a1], #-3136
    7a40:	e06ab003 	rsb	v8, v7, a4
    7a44:	28327c38 	ldmcsda	a3!, {a4, v1, v2, v7, v8, IP, SP, LR}
    7a48:	7c78d167 	ldfvcp	f5, [v5], #-412
    7a4c:	d1dc2850 	bicles	a3, IP, a1, asr v5
    7a50:	76302000 	ldrvct	a3, [a1], -a1
    7a54:	68004836 	stmvsda	a1, {a2, a3, v1, v2, v8, LR}
    7a58:	6a406a80 	bvs	0x1022460
    7a5c:	68094934 	stmvsda	v6, {a3, v1, v2, v5, v8, LR}
    7a60:	6a496a89 	bvs	0x126248c
    7a64:	22047fc9 	andcs	v4, v1, #804	; 0x324
    7a68:	77c2430a 	strvcb	v1, [a3, v7, lsl #6]
    7a6c:	68004830 	stmvsda	a1, {v1, v2, v8, LR}
    7a70:	6a406a80 	bvs	0x1022478
    7a74:	6809492e 	stmvsda	v6, {a2, a3, a4, v2, v5, v8, LR}
    7a78:	6a496a89 	bvs	0x12624a4
    7a7c:	22087e89 	andcs	v4, v5, #2192	; 0x890
    7a80:	7682430a 	strvc	v1, [a3], v7, lsl #6
    7a84:	7c70e7c1 	ldcvcl	7, cr14, [a1], #-772
    7a88:	28041c01 	stmcsda	v1, {a1, v7, v8, IP}
    7a8c:	a202d845 	andge	SP, a3, #4521984	; 0x450000
    7a90:	5e520049 	cdppl	0, 5, cr0, cr2, cr9, {2}
    7a94:	46c04497 	undefined
    7a98:	f298000a 	addnvs	a1, v5, #10	; 0xa
    7a9c:	003e0028 	eoreqs	a1, LR, v5, lsr #32
    7aa0:	49240058 	stmmidb	v1!, {a4, v1, v3}
    7aa4:	78529a04 	ldmvcda	a3, {a3, v6, v8, IP, PC}^
    7aa8:	435a232f 	cmpmi	v7, #-1140850688	; 0xbc000000
    7aac:	189a4b1d 	ldmneia	v7, {a1, a3, a4, v1, v5, v6, v8, LR}
    7ab0:	29015c51 	stmcsdb	a2, {a1, v1, v3, v7, v8, IP, LR}
    7ab4:	7c70d102 	ldfvcp	f5, [a1], #-8
    7ab8:	e02d1c80 	eor	a2, SP, a1, lsl #25
    7abc:	e02b1c40 	eor	a2, v8, a1, asr #24
    7ac0:	73f82000 	mvnvcs	a3, #0	; 0x0
    7ac4:	78019804 	stmvcda	a2, {a3, v8, IP, PC}
    7ac8:	98031c0a 	stmlsda	a4, {a2, a4, v7, v8, IP}
    7acc:	ff2ef008 	swinv	0x002ef008
    7ad0:	1c407c70 	mcrrne	12, 7, v4, a1, cr0
    7ad4:	f008e020 	andnv	LR, v5, a1, lsr #32
    7ad8:	2800ff1f 	stmcsda	a1, {a1, a2, a3, a4, v1, v5, v6, v7, v8, IP, SP, LR, PC}
    7adc:	9804d01d 	stmlsda	v1, {a1, a3, a4, v1, IP, LR, PC}
    7ae0:	28007880 	stmcsda	a1, {v4, v8, IP, SP, LR}
    7ae4:	2000d091 	mulcs	a1, a2, a1
    7ae8:	7c708168 	ldfvcp	f0, [a1], #-416
    7aec:	e0131c40 	ands	a2, a4, a1, asr #24
    7af0:	28027bf8 	stmcsda	a3, {a4, v1, v2, v3, v4, v5, v6, v8, IP, SP, LR}
    7af4:	e6c2d100 	strb	SP, [a3], a1, lsl #2
    7af8:	1c408968 	mcrrne	9, 6, v5, a1, cr8
    7afc:	21ff8168 	mvncss	v5, v5, ror #2
    7b00:	040031f6 	streq	a4, [a1], #-502
    7b04:	42880c00 	addmi	a1, v5, #0	; 0x0
    7b08:	69f0d307 	ldmvsib	a1!, {a1, a2, a3, v5, v6, IP, LR, PC}^
    7b0c:	02092196 	andeq	a3, v6, #-2147483611	; 0x80000025
    7b10:	f7ff8001 	ldrnvb	v5, [PC, a2]!
    7b14:	2000f8f4 	strcsd	PC, [a1], -v1
    7b18:	b0137470 	andlts	v4, a4, a1, ror v1
    7b1c:	fd56f7fe 	ldc2l	7, cr15, [v3, #-1016]
    7b20:	000003d5 	ldreqd	a1, [a1], -v2
    7b24:	00008a54 	andeq	v5, a1, v1, asr v7
    7b28:	00000ba4 	andeq	a1, a1, v1, lsr #23
    7b2c:	000003be 	streqh	a1, [a1], -LR
    7b30:	00009624 	andeq	v6, a1, v1, lsr #12
    7b34:	000003d6 	ldreqd	a1, [a1], -v3
    7b38:	1e522207 	cdpne	2, 5, cr2, cr2, cr7, {0}
    7b3c:	54835c8b 	strpl	v2, [a4], #3211
    7b40:	2007d1fb 	strcsd	SP, [v4], -v8
    7b44:	00004770 	andeq	v1, a1, a1, ror v4
    7b48:	2400b510 	strcs	v8, [a1], #-1296
    7b4c:	f00d2207 	andnv	a3, SP, v4, lsl #4
    7b50:	2800fa0b 	stmcsda	a1, {a1, a2, a4, v6, v8, IP, SP, LR, PC}
    7b54:	2401d100 	strcs	SP, [a2], #-256
    7b58:	bc101c20 	ldclt	12, cr1, [a1], {32}
    7b5c:	4708bc02 	strmi	v8, [v5, -a3, lsl #24]
    7b60:	1e52220f 	cdpne	2, 5, cr2, cr2, cr15, {0}
    7b64:	54835c8b 	strpl	v2, [a4], #3211
    7b68:	2100d1fb 	strcsd	SP, [a1, -v8]
    7b6c:	20107381 	andcss	v4, a1, a2, lsl #7
    7b70:	00004770 	andeq	v1, a1, a1, ror v4
    7b74:	1c14b5fb 	cfldr32ne	mvfx11, [v1], {251}
    7b78:	20009d08 	andcs	v6, a1, v5, lsl #26
    7b7c:	26007028 	strcs	v4, [a1], -v5, lsr #32
    7b80:	4370201f 	cmnmi	a1, #31	; 0x1f
    7b84:	180f49a4 	stmneda	PC, {a3, v2, v4, v5, v8, LR}
    7b88:	1c389900 	ldcne	9, cr9, [v5]
    7b8c:	f7ff301c 	undefined
    7b90:	2801ffdb 	stmcsda	a2, {a1, a2, a4, v1, v3, v4, v5, v6, v7, v8, IP, SP, LR, PC}
    7b94:	2023d120 	eorcs	SP, a4, a1, lsr #2
    7b98:	28005c38 	stmcsda	a1, {a4, v1, v2, v7, v8, IP, LR}
    7b9c:	0600d01c 	undefined
    7ba0:	2001d54a 	andcs	SP, a2, v7, asr #10
    7ba4:	20237028 	eorcs	v4, a4, v5, lsr #32
    7ba8:	06495c39 	undefined
    7bac:	54390e49 	ldrplt	a1, [v6], #-3657
    7bb0:	28015c38 	stmcsda	a2, {a4, v1, v2, v7, v8, IP, LR}
    7bb4:	3723d103 	strcc	SP, [a4, -a4, lsl #2]!
    7bb8:	7a004668 	bvc	0x19560
    7bbc:	2c007038 	stccs	0, cr7, [a1], {56}
    7bc0:	211fd03a 	tstcs	PC, v7, lsr a1
    7bc4:	4a944371 	bmi	0xfe518990
    7bc8:	31181851 	tstcc	v5, a2, asr v5
    7bcc:	1e402004 	cdpne	0, 4, cr2, cr0, cr4, {0}
    7bd0:	540a5c22 	strpl	v2, [v7], #-3106
    7bd4:	e02fd1fb 	strd	SP, [PC], -v8
    7bd8:	04361c76 	ldreqt	a2, [v3], #-3190
    7bdc:	2e1e0c36 	mrccs	12, 0, a1, cr14, cr6, {1}
    7be0:	2600d3ce 	strcs	SP, [a1], -LR, asr #7
    7be4:	201f498c 	andcss	v1, PC, IP, lsl #19
    7be8:	180f4370 	stmneda	PC, {v1, v2, v3, v5, v6, LR}
    7bec:	5c382023 	ldcpl	0, cr2, [v5], #-140
    7bf0:	d11c2800 	tstle	IP, a1, lsl #16
    7bf4:	70282002 	eorvc	a3, v5, a3
    7bf8:	46692023 	strmibt	a3, [v6], -a4, lsr #32
    7bfc:	54397a09 	ldrplt	v4, [v6], #-2569
    7c00:	1c389900 	ldcne	9, cr9, [v5]
    7c04:	f7ff301c 	undefined
    7c08:	9901ff97 	stmlsdb	a2, {a1, a2, a3, v1, v4, v5, v6, v7, v8, IP, SP, LR, PC}
    7c0c:	1c383708 	ldcne	7, cr3, [v5], #-32
    7c10:	ffa6f7ff 	swinv	0x00a6f7ff
    7c14:	d1d42c00 	bicles	a3, v1, a1, lsl #24
    7c18:	21002004 	tstcs	a1, v1
    7c1c:	4372221f 	cmnmi	a3, #-268435455	; 0xf0000001
    7c20:	189a4b7d 	ldmneia	v7, {a1, a3, a4, v1, v2, v3, v5, v6, v8, LR}
    7c24:	1e403218 	mcrne	2, 2, a4, cr0, cr8, {0}
    7c28:	d1fc5411 	mvnles	v2, a2, lsl v1
    7c2c:	1c76e004 	ldcnel	0, cr14, [v3], #-16
    7c30:	0c360436 	cfldrseq	mvf0, [v3], #-216
    7c34:	d3d62e1e 	bicles	a3, v3, #480	; 0x1e0
    7c38:	46c01c30 	undefined
    7c3c:	bc02bcfe 	stclt	12, cr11, [a3], {254}
    7c40:	00004708 	andeq	v1, a1, v5, lsl #14
    7c44:	1c04b5f0 	cfstr32ne	mvfx11, [v1], {240}
    7c48:	481b4d73 	ldmmida	v8, {a1, a2, v1, v2, v3, v5, v7, v8, LR}
    7c4c:	7837182e 	ldmvcda	v4!, {a2, a3, a4, v2, v8, IP}
    7c50:	18294856 	stmneda	v6!, {a2, a3, v1, v3, v8, LR}
    7c54:	2f002000 	swics	0x00002000
    7c58:	2f01d004 	swics	0x0001d004
    7c5c:	2f02d00f 	swics	0x0002d00f
    7c60:	e025d016 	eor	SP, v2, v3, lsl a1
    7c64:	29017809 	stmcsdb	a2, {a1, a4, v8, IP, SP, LR}
    7c68:	f7fed004 	ldrnvb	SP, [LR, v1]!
    7c6c:	1c7ffd19 	ldcnel	13, cr15, [PC], #-100
    7c70:	e01e7037 	ands	v4, LR, v4, lsr a1
    7c74:	78207030 	stmvcda	a1!, {v1, v2, IP, SP, LR}
    7c78:	70201c40 	eorvc	a2, a1, a1, asr #24
    7c7c:	f008e019 	andnv	LR, v5, v6, lsl a1
    7c80:	2801fe3d 	stmcsda	a2, {a1, a3, a4, v1, v2, v6, v7, v8, IP, SP, LR, PC}
    7c84:	f008d115 	andnv	SP, v5, v2, lsl a2
    7c88:	7830fe23 	ldmvcda	a1!, {a1, a2, v2, v6, v7, v8, IP, SP, LR, PC}
    7c8c:	e00f1c40 	and	a2, PC, a1, asr #24
    7c90:	2a00798a 	bcs	0x262c0
    7c94:	2201d10d 	andcs	SP, a2, #1073741827	; 0x40000003
    7c98:	7172700a 	cmnvc	a3, v7
    7c9c:	54684944 	strplbt	v1, [v5], #-2372
    7ca0:	fe16f008 	wxornv	wr15, wr6, wr8
    7ca4:	48432102 	stmmida	a4, {a2, v5, SP}^
    7ca8:	f0081828 	andnv	a2, v5, v5, lsr #16
    7cac:	e7e2fe03 	strb	PC, [a3, a4, lsl #28]!
    7cb0:	f7fe7030 	undefined
    7cb4:	46c0fc8b 	strmib	PC, [a1], v8, lsl #25
    7cb8:	00000bb7 	streqh	a1, [a1], -v4
    7cbc:	1c04b5f1 	cfstr32ne	mvfx11, [v1], {241}
    7cc0:	48354d55 	ldmmida	v2!, {a1, a3, v1, v3, v5, v7, v8, LR}
    7cc4:	90001828 	andls	a2, a1, v5, lsr #16
    7cc8:	202f7801 	eorcs	v4, PC, a2, lsl #16
    7ccc:	182e4348 	stmneda	LR!, {a4, v3, v5, v6, LR}
    7cd0:	18284832 	stmneda	v5!, {a2, v1, v2, v8, LR}
    7cd4:	18af4a34 	stmneia	PC!, {a3, v1, v2, v6, v8, LR}
    7cd8:	2a04793a 	bcs	0x1261c8
    7cdc:	a301d856 	tstge	a2, #5636096	; 0x560000
    7ce0:	449f5c9b 	ldrmi	v2, [pc], #3227	; 0x7ce8
    7ce4:	4c464004 	mcrrmi	0, 0, v1, v3, cr4
    7ce8:	20110068 	andcss	a1, a2, v5, rrx
    7cec:	d2172904 	andles	a3, v4, #65536	; 0x10000
    7cf0:	5c7149b1 	ldcpll	9, cr4, [a2], #-708
    7cf4:	d00a2900 	andle	a3, v7, a1, lsl #18
    7cf8:	183048ac 	ldmneda	a1!, {a3, a4, v2, v4, v8, LR}
    7cfc:	28017840 	stmcsda	a2, {v3, v8, IP, SP, LR}
    7d00:	7820d103 	stmvcda	a1!, {a1, a2, v5, IP, LR, PC}
    7d04:	70201c40 	eorvc	a2, a1, a1, asr #24
    7d08:	2001e042 	andcs	LR, a2, a3, asr #32
    7d0c:	68f9e03f 	ldmvsia	v6!, {a1, a2, a3, a4, v1, v2, SP, LR, PC}^
    7d10:	800a4a23 	andhi	v1, v7, a4, lsr #20
    7d14:	20007038 	andcs	v4, a1, v5, lsr a1
    7d18:	60787078 	rsbvss	v4, v5, v5, ror a1
    7d1c:	e03770f8 	ldrsh	v4, [v4], -v5
    7d20:	4a2068f9 	bmi	0x82210c
    7d24:	f7ffe7f5 	undefined
    7d28:	e031ff8d 	eors	PC, a2, SP, lsl #31
    7d2c:	f846f000 	stmnvda	v3, {IP, SP, LR, PC}^
    7d30:	2004e02e 	andcs	LR, v1, LR, lsr #32
    7d34:	22007138 	andcs	v4, a1, #14	; 0xe
    7d38:	20002100 	andcs	a3, a1, a1, lsl #2
    7d3c:	2300b407 	tstcs	a1, #117440512	; 0x7000000
    7d40:	5c31489a 	ldcpl	8, cr4, [a2], #-616
    7d44:	f008200b 	andnv	a3, v5, v8
    7d48:	b003ff4d 	andlt	PC, a4, SP, asr #30
    7d4c:	4817e020 	ldmmida	v4, {v2, SP, LR, PC}
    7d50:	79811828 	stmvcib	a2, {a4, v2, v8, IP}
    7d54:	d01b2900 	andles	a3, v8, a1, lsl #18
    7d58:	22004915 	andcs	v1, a1, #344064	; 0x54000
    7d5c:	2102546a 	tstcs	a3, v7, ror #8
    7d60:	72397001 	eorvcs	v4, v6, #1	; 0x1
    7d64:	ff36f008 	swinv	0x0036f008
    7d68:	fdaef008 	stc2	0, cr15, [LR, #32]!
    7d6c:	48112101 	ldmmida	a2, {a1, v5, SP}
    7d70:	f0081828 	andnv	a2, v5, v5, lsr #16
    7d74:	4810fd9f 	ldmmida	a1, {a1, a2, a3, a4, v1, v4, v5, v7, v8, IP, SP, LR, PC}
    7d78:	78099900 	stmvcda	v6, {v5, v8, IP, PC}
    7d7c:	4351222f 	cmpmi	a2, #-268435454	; 0xf0000002
    7d80:	22011869 	andcs	a2, a2, #6881280	; 0x690000
    7d84:	2000540a 	andcs	v2, a1, v7, lsl #8
    7d88:	e7ba7138 	undefined
    7d8c:	71382000 	teqvc	v5, a1
    7d90:	bc01bcf8 	stclt	12, cr11, [a2], {248}
    7d94:	46c04700 	strmib	v1, [a1], a1, lsl #14
    7d98:	00000977 	andeq	a1, a1, v4, ror v6
    7d9c:	00000bb8 	streqh	a1, [a1], -v5
    7da0:	0000ffe0 	andeq	PC, a1, a1, ror #31
    7da4:	0000ffdf 	ldreqd	PC, [a1], -PC
    7da8:	00000bb4 	streqh	a1, [a1], -v1
    7dac:	00000763 	andeq	a1, a1, a4, ror #14
    7db0:	00000505 	andeq	a1, a1, v2, lsl #10
    7db4:	0000076e 	andeq	a1, a1, LR, ror #14
    7db8:	000003d6 	ldreqd	a1, [a1], -v3
    7dbc:	4c16b510 	cfldr32mi	mvfx11, [v3], {16}
    7dc0:	18614914 	stmneda	a2!, {a3, v1, v5, v8, LR}^
    7dc4:	2a00780a 	bcs	0x25df4
    7dc8:	2a01d002 	bcs	0x7bdd8
    7dcc:	e01cd016 	ands	SP, IP, v3, lsl a1
    7dd0:	5ca24a79 	fstmiaspl	a3!, {s8-s128}
    7dd4:	d00d2a00 	andle	a3, SP, a1, lsl #20
    7dd8:	70082001 	andvc	a3, v5, a2
    7ddc:	21002200 	tstcs	a1, a1, lsl #4
    7de0:	b4072000 	strlt	a3, [v4]
    7de4:	48712300 	ldmmida	a2!, {v5, v6, SP}^
    7de8:	20085c21 	andcs	v2, v5, a2, lsr #24
    7dec:	fefaf008 	cdp2	0, 15, cr15, cr10, cr8, {0}
    7df0:	e00cb003 	and	v8, IP, a4
    7df4:	1c497801 	mcrrne	8, 0, v4, v6, cr1
    7df8:	e0087001 	and	v4, v5, a2
    7dfc:	5ca24a69 	fstmiaspl	a3!, {s8-s112}
    7e00:	d1042a1a 	tstle	v1, v7, lsl v7
    7e04:	700a2200 	andvc	a3, v7, a1, lsl #4
    7e08:	2000e7f4 	strcsd	LR, [a1], -v1
    7e0c:	bc107008 	ldclt	0, cr7, [a1], {8}
    7e10:	4700bc01 	strmi	v8, [a1, -a2, lsl #24]
    7e14:	00000bb9 	streqh	a1, [a1], -v6
    7e18:	00008a54 	andeq	v5, a1, v1, asr v7
    7e1c:	4c64b5f0 	cfstr64mi	mvdx11, [v1], #-960
    7e20:	1865491f 	stmneda	v2!, {a1, a2, a3, a4, v1, v5, v8, LR}^
    7e24:	4a1f7829 	bmi	0x7e5ed0
    7e28:	290018a6 	stmcsdb	a1, {a2, a3, v2, v4, v8, IP}
    7e2c:	2901d004 	stmcsdb	a2, {a3, IP, LR, PC}
    7e30:	2902d008 	stmcsdb	a3, {a4, IP, LR, PC}
    7e34:	e030d02b 	eors	SP, a1, v8, lsr #32
    7e38:	70302000 	eorvcs	a3, a1, a1
    7e3c:	e02b1c49 	eor	a2, v8, v6, asr #24
    7e40:	70311c49 	eorvcs	a2, a2, v6, asr #24
    7e44:	272f7831 	undefined
    7e48:	4a5b434f 	bmi	0x16d8b8c
    7e4c:	5dd218a2 	ldcpll	8, cr1, [a3, #648]
    7e50:	d1012a00 	tstle	a2, a1, lsl #20
    7e54:	d3f32904 	mvnles	a3, #65536	; 0x10000
    7e58:	d2122904 	andles	a3, a3, #65536	; 0x10000
    7e5c:	21002200 	tstcs	a1, a1, lsl #4
    7e60:	b4072000 	strlt	a3, [v4]
    7e64:	48512300 	ldmmida	a2, {v5, v6, SP}^
    7e68:	5c0919e1 	stcpl	9, cr1, [v6], {225}
    7e6c:	f0082008 	andnv	a3, v5, v5
    7e70:	7830feb9 	ldmvcda	a1!, {a1, a4, v1, v2, v4, v6, v7, v8, IP, SP, LR, PC}
    7e74:	70301c40 	eorvcs	a2, a1, a1, asr #24
    7e78:	1c407828 	mcrrne	8, 2, v4, a1, cr8
    7e7c:	b0037028 	andlt	v4, a4, v5, lsr #32
    7e80:	2100e00b 	tstcs	a1, v8
    7e84:	78017029 	stmvcda	a2, {a1, a4, v2, IP, SP, LR}
    7e88:	70011c49 	andvc	a2, a2, v6, asr #24
    7e8c:	4845e005 	stmmida	v2, {a1, a3, SP, LR, PC}^
    7e90:	281a5c20 	ldmcsda	v7, {v2, v7, v8, IP, LR}
    7e94:	1e49d101 	sqtnee	f5, f1
    7e98:	f7fe7029 	ldrnvb	v4, [LR, v6, lsr #32]!
    7e9c:	46c0fb97 	undefined
    7ea0:	00000bba 	streqh	a1, [a1], -v7
    7ea4:	00000976 	andeq	a1, a1, v3, ror v6
    7ea8:	4941b5f0 	stmmidb	a2, {v1, v2, v3, v4, v5, v7, IP, SP, PC}^
    7eac:	188d4a3b 	stmneia	SP, {a1, a2, a4, v1, v2, v6, v8, LR}
    7eb0:	188a3a09 	stmneia	v7, {a1, a4, v6, v8, IP, SP}
    7eb4:	18cc4b38 	stmneia	IP, {a4, v1, v2, v5, v6, v8, LR}^
    7eb8:	2b037823 	blcs	0xe5f4c
    7ebc:	a601d86a 	strge	SP, [a2], -v7, ror #16
    7ec0:	44b75cf6 	ldrmit	v2, [v4], #3318
    7ec4:	c22c1002 	eorgt	a2, IP, #2	; 0x2
    7ec8:	71d02000 	bicvcs	a3, a1, a1
    7ecc:	70202001 	eorvc	a3, a1, a2
    7ed0:	fce2f008 	stc2l	0, cr15, [a3], #32
    7ed4:	79d0e05e 	ldmvcib	a1, {a2, a3, a4, v1, v3, SP, LR, PC}^
    7ed8:	71d01c40 	bicvcs	a2, a1, a1, asr #24
    7edc:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    7ee0:	d3572865 	cmple	v4, #6619136	; 0x650000
    7ee4:	fcdaf008 	ldc2l	0, cr15, [v7], {8}
    7ee8:	80282000 	eorhi	a3, v5, a1
    7eec:	70202002 	eorvc	a3, a1, a3
    7ef0:	8828e050 	stmhida	v5!, {v1, v3, SP, LR, PC}
    7ef4:	80281c40 	eorhi	a2, v5, a1, asr #24
    7ef8:	04004a29 	streq	v1, [a1], #-2601
    7efc:	42900c00 	addmis	a1, a1, #0	; 0x0
    7f00:	4828d203 	stmmida	v5!, {a1, a2, v6, IP, LR, PC}
    7f04:	28145c08 	ldmcsda	v1, {a4, v7, v8, IP, LR}
    7f08:	4827d144 	stmmida	v4!, {a3, v3, v5, IP, LR, PC}
    7f0c:	4b282200 	blmi	0xa10714
    7f10:	1e803308 	cdpne	3, 8, cr3, cr0, cr8, {0}
    7f14:	d1fc521a 	mvnles	v2, v7, lsl a3
    7f18:	4a242000 	bmi	0x90ff20
    7f1c:	25001889 	strcs	a2, [a1, #-2185]
    7f20:	23074f23 	tstcs	v4, #140	; 0x8c
    7f24:	4342222f 	cmpmi	a3, #-268435454	; 0xf0000002
    7f28:	19be4e22 	ldmneib	LR!, {a2, v2, v6, v7, v8, LR}
    7f2c:	1e5b18b2 	mrcne	8, 2, a2, cr11, cr2, {5}
    7f30:	d1fc54d5 	ldrlesb	v2, [IP, #69]!
    7f34:	222f2310 	eorcs	a3, PC, #1073741824	; 0x40000000
    7f38:	4e1f4342 	cdpmi	3, 1, cr4, cr15, cr2, {2}
    7f3c:	18b219be 	ldmneia	a3!, {a2, a3, a4, v1, v2, v4, v5, v8, IP}
    7f40:	54d51e5b 	ldrplb	a2, [v2], #3675
    7f44:	2304d1fc 	tstcs	v1, #63	; 0x3f
    7f48:	4342222f 	cmpmi	a3, #-268435454	; 0xf0000002
    7f4c:	19be4e1b 	ldmneib	LR!, {a1, a2, a4, v1, v6, v7, v8, LR}
    7f50:	1e5b18b2 	mrcne	8, 2, a2, cr11, cr2, {5}
    7f54:	d1fc54d5 	ldrlesb	v2, [IP, #69]!
    7f58:	222f2310 	eorcs	a3, PC, #1073741824	; 0x40000000
    7f5c:	4e184342 	cdpmi	3, 1, cr4, cr8, cr2, {2}
    7f60:	18b219be 	ldmneia	a3!, {a2, a3, a4, v1, v2, v4, v5, v8, IP}
    7f64:	54d51e5b 	ldrplb	a2, [v2], #3675
    7f68:	222fd1fc 	eorcs	SP, PC, #63	; 0x3f
    7f6c:	23ff4342 	mvncss	v1, #134217729	; 0x8000001
    7f70:	1c4b548b 	cfstrdne	mvd5, [v8], {139}
    7f74:	1c8b549d 	cfstrsne	mvf5, [v8], {157}
    7f78:	1c40549d 	cfstrdne	mvd5, [a1], {157}
    7f7c:	0e000600 	cfmadd32eq	mvax0, mvfx0, mvfx0, mvfx0
    7f80:	d3ce2804 	bicle	a3, LR, #262144	; 0x40000
    7f84:	e7b22003 	ldr	a3, [a3, a4]!
    7f88:	70112101 	andvcs	a3, a2, a2, lsl #2
    7f8c:	78017061 	stmvcda	a2, {a1, v2, v3, IP, SP, LR}
    7f90:	70011c49 	andvc	a2, a2, v6, asr #24
    7f94:	fb1af7fe 	blx	0x6c5f96
    7f98:	00000bbb 	streqh	a1, [a1], -v8
    7f9c:	0000076c 	andeq	a1, a1, IP, ror #14
    7fa0:	000007d1 	ldreqd	a1, [a1], -a2
    7fa4:	00000486 	andeq	a1, a1, v3, lsl #9
    7fa8:	000003a2 	andeq	a1, a1, a3, lsr #7
    7fac:	000003d5 	ldreqd	a1, [a1], -v2
    7fb0:	00008a54 	andeq	v5, a1, v1, asr v7
    7fb4:	000003ce 	andeq	a1, a1, LR, asr #7
    7fb8:	000003aa 	andeq	a1, a1, v7, lsr #7
    7fbc:	000003ba 	streqh	a1, [a1], -v7
    7fc0:	000003be 	streqh	a1, [a1], -LR
    7fc4:	b084b5fc 	strltd	v8, [v1], IP
    7fc8:	990c1c0c 	stmlsdb	IP, {a3, a4, v7, v8, IP}
    7fcc:	02122294 	andeqs	a3, a3, #1073741833	; 0x40000009
    7fd0:	801a466b 	andhis	v1, v7, v8, ror #12
    7fd4:	4a5c800a 	bmi	0x1728004
    7fd8:	189d4b62 	ldmneia	SP, {a2, v2, v3, v5, v6, v8, LR}
    7fdc:	2b117c2b 	blcs	0x467090
    7fe0:	2b0ad003 	blcs	0x2bbff4
    7fe4:	2802d145 	stmcsda	a3, {a1, a3, v3, v5, IP, LR, PC}
    7fe8:	466ad143 	strmibt	SP, [v7], -a4, asr #2
    7fec:	80162600 	andhis	a3, v3, a1, lsl #12
    7ff0:	800a2201 	andhi	a3, v7, a2, lsl #4
    7ff4:	4a5561e9 	bmi	0x15607a0
    7ff8:	92026812 	andls	v3, a3, #1179648	; 0x120000
    7ffc:	4e594a54 	mrcmi	10, 2, v1, cr9, cr4, {2}
