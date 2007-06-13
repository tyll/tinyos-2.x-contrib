
flash.bin:     file format binary

Disassembly of section .data:

00000000 <.data>:
   0:	e3a0d821 	mov	sp, #2162688	; 0x210000
   4:	e92d4000 	stmdb	sp!, {lr}
   8:	eb000000 	bl	0x10
   c:	e8bd8000 	ldmia	sp!, {pc}
  10:	e3e02000 	mvn	r2, #0	; 0x0
  14:	e5123097 	ldr	r3, [r2, #-151]
  18:	e3130001 	tst	r3, #1	; 0x1
  1c:	0afffffc 	beq	0x14
  20:	e3a0c602 	mov	ip, #2097152	; 0x200000
  24:	e1a0000c 	mov	r0, ip
  28:	e2800c21 	add	r0, r0, #8448	; 0x2100
  2c:	e28cca02 	add	ip, ip, #8192	; 0x2000
  30:	e3a01000 	mov	r1, #0	; 0x0
  34:	e59c3300 	ldr	r3, [ip, #768]
  38:	e0813303 	add	r3, r1, r3, lsl #6
  3c:	e7902101 	ldr	r2, [r0, r1, lsl #2]
  40:	e1a03103 	mov	r3, r3, lsl #2
  44:	e2811001 	add	r1, r1, #1	; 0x1
  48:	e2833601 	add	r3, r3, #1048576	; 0x100000
  4c:	e3510040 	cmp	r1, #64	; 0x40
  50:	e5832000 	str	r2, [r3]
  54:	1afffff6 	bne	0x34
  58:	e59c3300 	ldr	r3, [ip, #768]
  5c:	e1a03b03 	mov	r3, r3, lsl #22
  60:	e1a03b23 	mov	r3, r3, lsr #22
  64:	e1a03403 	mov	r3, r3, lsl #8
  68:	e283345a 	add	r3, r3, #1509949440	; 0x5a000000
  6c:	e2833001 	add	r3, r3, #1	; 0x1
  70:	e3e02000 	mvn	r2, #0	; 0x0
  74:	e502309b 	str	r3, [r2, #-155]
  78:	e5123097 	ldr	r3, [r2, #-151]
  7c:	e3130001 	tst	r3, #1	; 0x1
  80:	0afffffc 	beq	0x78
  84:	e3a00000 	mov	r0, #0	; 0x0
  88:	e12fff1e 	bx	lr
