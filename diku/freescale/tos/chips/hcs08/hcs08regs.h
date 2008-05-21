//$Id$
//@author Cory Sharp <cssharp@eecs.berkeley.edu>

// This file was automatically generated with the command:
//  ./make_hcs08regs.pl hcs08regs.txt > hcs08regs.h

#ifndef _H_hcs08regs_h
#define _H_hcs08regs_h

#define HC08_REGISTER(type,addr) (*((type*)(addr)))

enum { PTAD_Addr = 0x00 };

typedef struct
{
  uint8_t PTAD0 : 1;
  uint8_t PTAD1 : 1;
  uint8_t PTAD2 : 1;
  uint8_t PTAD3 : 1;
  uint8_t PTAD4 : 1;
  uint8_t PTAD5 : 1;
  uint8_t PTAD6 : 1;
  uint8_t PTAD7 : 1;
} PTAD_t;

#define PTAD HC08_REGISTER(uint8_t,PTAD_Addr)

#define PTAD_Bits HC08_REGISTER(PTAD_t,PTAD_Addr)

#define PTAD_PTAD7 PTAD_Bits.PTAD7
#define PTAD_PTAD6 PTAD_Bits.PTAD6
#define PTAD_PTAD5 PTAD_Bits.PTAD5
#define PTAD_PTAD4 PTAD_Bits.PTAD4
#define PTAD_PTAD3 PTAD_Bits.PTAD3
#define PTAD_PTAD2 PTAD_Bits.PTAD2
#define PTAD_PTAD1 PTAD_Bits.PTAD1
#define PTAD_PTAD0 PTAD_Bits.PTAD0


enum { PTAPE_Addr = 0x01 };

typedef struct
{
  uint8_t PTAPE0 : 1;
  uint8_t PTAPE1 : 1;
  uint8_t PTAPE2 : 1;
  uint8_t PTAPE3 : 1;
  uint8_t PTAPE4 : 1;
  uint8_t PTAPE5 : 1;
  uint8_t PTAPE6 : 1;
  uint8_t PTAPE7 : 1;
} PTAPE_t;

#define PTAPE HC08_REGISTER(uint8_t,PTAPE_Addr)

#define PTAPE_Bits HC08_REGISTER(PTAPE_t,PTAPE_Addr)

#define PTAPE_PTAPE7 PTAPE_Bits.PTAPE7
#define PTAPE_PTAPE6 PTAPE_Bits.PTAPE6
#define PTAPE_PTAPE5 PTAPE_Bits.PTAPE5
#define PTAPE_PTAPE4 PTAPE_Bits.PTAPE4
#define PTAPE_PTAPE3 PTAPE_Bits.PTAPE3
#define PTAPE_PTAPE2 PTAPE_Bits.PTAPE2
#define PTAPE_PTAPE1 PTAPE_Bits.PTAPE1
#define PTAPE_PTAPE0 PTAPE_Bits.PTAPE0


enum { PTASE_Addr = 0x02 };

typedef struct
{
  uint8_t PTASE0 : 1;
  uint8_t PTASE1 : 1;
  uint8_t PTASE2 : 1;
  uint8_t PTASE3 : 1;
  uint8_t PTASE4 : 1;
  uint8_t PTASE5 : 1;
  uint8_t PTASE6 : 1;
  uint8_t PTASE7 : 1;
} PTASE_t;

#define PTASE HC08_REGISTER(uint8_t,PTASE_Addr)

#define PTASE_Bits HC08_REGISTER(PTASE_t,PTASE_Addr)

#define PTASE_PTASE7 PTASE_Bits.PTASE7
#define PTASE_PTASE6 PTASE_Bits.PTASE6
#define PTASE_PTASE5 PTASE_Bits.PTASE5
#define PTASE_PTASE4 PTASE_Bits.PTASE4
#define PTASE_PTASE3 PTASE_Bits.PTASE3
#define PTASE_PTASE2 PTASE_Bits.PTASE2
#define PTASE_PTASE1 PTASE_Bits.PTASE1
#define PTASE_PTASE0 PTASE_Bits.PTASE0


enum { PTADD_Addr = 0x03 };

typedef struct
{
  uint8_t PTADD0 : 1;
  uint8_t PTADD1 : 1;
  uint8_t PTADD2 : 1;
  uint8_t PTADD3 : 1;
  uint8_t PTADD4 : 1;
  uint8_t PTADD5 : 1;
  uint8_t PTADD6 : 1;
  uint8_t PTADD7 : 1;
} PTADD_t;

#define PTADD HC08_REGISTER(uint8_t,PTADD_Addr)

#define PTADD_Bits HC08_REGISTER(PTADD_t,PTADD_Addr)

#define PTADD_PTADD7 PTADD_Bits.PTADD7
#define PTADD_PTADD6 PTADD_Bits.PTADD6
#define PTADD_PTADD5 PTADD_Bits.PTADD5
#define PTADD_PTADD4 PTADD_Bits.PTADD4
#define PTADD_PTADD3 PTADD_Bits.PTADD3
#define PTADD_PTADD2 PTADD_Bits.PTADD2
#define PTADD_PTADD1 PTADD_Bits.PTADD1
#define PTADD_PTADD0 PTADD_Bits.PTADD0


enum { PTBD_Addr = 0x04 };

typedef struct
{
  uint8_t PTBD0 : 1;
  uint8_t PTBD1 : 1;
  uint8_t PTBD2 : 1;
  uint8_t PTBD3 : 1;
  uint8_t PTBD4 : 1;
  uint8_t PTBD5 : 1;
  uint8_t PTBD6 : 1;
  uint8_t PTBD7 : 1;
} PTBD_t;

#define PTBD HC08_REGISTER(uint8_t,PTBD_Addr)

#define PTBD_Bits HC08_REGISTER(PTBD_t,PTBD_Addr)

#define PTBD_PTBD7 PTBD_Bits.PTBD7
#define PTBD_PTBD6 PTBD_Bits.PTBD6
#define PTBD_PTBD5 PTBD_Bits.PTBD5
#define PTBD_PTBD4 PTBD_Bits.PTBD4
#define PTBD_PTBD3 PTBD_Bits.PTBD3
#define PTBD_PTBD2 PTBD_Bits.PTBD2
#define PTBD_PTBD1 PTBD_Bits.PTBD1
#define PTBD_PTBD0 PTBD_Bits.PTBD0


enum { PTBPE_Addr = 0x05 };

typedef struct
{
  uint8_t PTBPE0 : 1;
  uint8_t PTBPE1 : 1;
  uint8_t PTBPE2 : 1;
  uint8_t PTBPE3 : 1;
  uint8_t PTBPE4 : 1;
  uint8_t PTBPE5 : 1;
  uint8_t PTBPE6 : 1;
  uint8_t PTBPE7 : 1;
} PTBPE_t;

#define PTBPE HC08_REGISTER(uint8_t,PTBPE_Addr)

#define PTBPE_Bits HC08_REGISTER(PTBPE_t,PTBPE_Addr)

#define PTBPE_PTBPE7 PTBPE_Bits.PTBPE7
#define PTBPE_PTBPE6 PTBPE_Bits.PTBPE6
#define PTBPE_PTBPE5 PTBPE_Bits.PTBPE5
#define PTBPE_PTBPE4 PTBPE_Bits.PTBPE4
#define PTBPE_PTBPE3 PTBPE_Bits.PTBPE3
#define PTBPE_PTBPE2 PTBPE_Bits.PTBPE2
#define PTBPE_PTBPE1 PTBPE_Bits.PTBPE1
#define PTBPE_PTBPE0 PTBPE_Bits.PTBPE0


enum { PTBSE_Addr = 0x06 };

typedef struct
{
  uint8_t PTBSE0 : 1;
  uint8_t PTBSE1 : 1;
  uint8_t PTBSE2 : 1;
  uint8_t PTBSE3 : 1;
  uint8_t PTBSE4 : 1;
  uint8_t PTBSE5 : 1;
  uint8_t PTBSE6 : 1;
  uint8_t PTBSE7 : 1;
} PTBSE_t;

#define PTBSE HC08_REGISTER(uint8_t,PTBSE_Addr)

#define PTBSE_Bits HC08_REGISTER(PTBSE_t,PTBSE_Addr)

#define PTBSE_PTBSE7 PTBSE_Bits.PTBSE7
#define PTBSE_PTBSE6 PTBSE_Bits.PTBSE6
#define PTBSE_PTBSE5 PTBSE_Bits.PTBSE5
#define PTBSE_PTBSE4 PTBSE_Bits.PTBSE4
#define PTBSE_PTBSE3 PTBSE_Bits.PTBSE3
#define PTBSE_PTBSE2 PTBSE_Bits.PTBSE2
#define PTBSE_PTBSE1 PTBSE_Bits.PTBSE1
#define PTBSE_PTBSE0 PTBSE_Bits.PTBSE0


enum { PTBDD_Addr = 0x07 };

typedef struct
{
  uint8_t PTBDD0 : 1;
  uint8_t PTBDD1 : 1;
  uint8_t PTBDD2 : 1;
  uint8_t PTBDD3 : 1;
  uint8_t PTBDD4 : 1;
  uint8_t PTBDD5 : 1;
  uint8_t PTBDD6 : 1;
  uint8_t PTBDD7 : 1;
} PTBDD_t;

#define PTBDD HC08_REGISTER(uint8_t,PTBDD_Addr)

#define PTBDD_Bits HC08_REGISTER(PTBDD_t,PTBDD_Addr)

#define PTBDD_PTBDD7 PTBDD_Bits.PTBDD7
#define PTBDD_PTBDD6 PTBDD_Bits.PTBDD6
#define PTBDD_PTBDD5 PTBDD_Bits.PTBDD5
#define PTBDD_PTBDD4 PTBDD_Bits.PTBDD4
#define PTBDD_PTBDD3 PTBDD_Bits.PTBDD3
#define PTBDD_PTBDD2 PTBDD_Bits.PTBDD2
#define PTBDD_PTBDD1 PTBDD_Bits.PTBDD1
#define PTBDD_PTBDD0 PTBDD_Bits.PTBDD0


enum { PTCD_Addr = 0x08 };

typedef struct
{
  uint8_t PTCD0 : 1;
  uint8_t PTCD1 : 1;
  uint8_t PTCD2 : 1;
  uint8_t PTCD3 : 1;
  uint8_t PTCD4 : 1;
  uint8_t PTCD5 : 1;
  uint8_t PTCD6 : 1;
  uint8_t PTCD7 : 1;
} PTCD_t;

#define PTCD HC08_REGISTER(uint8_t,PTCD_Addr)

#define PTCD_Bits HC08_REGISTER(PTCD_t,PTCD_Addr)

#define PTCD_PTCD7 PTCD_Bits.PTCD7
#define PTCD_PTCD6 PTCD_Bits.PTCD6
#define PTCD_PTCD5 PTCD_Bits.PTCD5
#define PTCD_PTCD4 PTCD_Bits.PTCD4
#define PTCD_PTCD3 PTCD_Bits.PTCD3
#define PTCD_PTCD2 PTCD_Bits.PTCD2
#define PTCD_PTCD1 PTCD_Bits.PTCD1
#define PTCD_PTCD0 PTCD_Bits.PTCD0


enum { PTCPE_Addr = 0x09 };

typedef struct
{
  uint8_t PTCPE0 : 1;
  uint8_t PTCPE1 : 1;
  uint8_t PTCPE2 : 1;
  uint8_t PTCPE3 : 1;
  uint8_t PTCPE4 : 1;
  uint8_t PTCPE5 : 1;
  uint8_t PTCPE6 : 1;
  uint8_t PTCPE7 : 1;
} PTCPE_t;

#define PTCPE HC08_REGISTER(uint8_t,PTCPE_Addr)

#define PTCPE_Bits HC08_REGISTER(PTCPE_t,PTCPE_Addr)

#define PTCPE_PTCPE7 PTCPE_Bits.PTCPE7
#define PTCPE_PTCPE6 PTCPE_Bits.PTCPE6
#define PTCPE_PTCPE5 PTCPE_Bits.PTCPE5
#define PTCPE_PTCPE4 PTCPE_Bits.PTCPE4
#define PTCPE_PTCPE3 PTCPE_Bits.PTCPE3
#define PTCPE_PTCPE2 PTCPE_Bits.PTCPE2
#define PTCPE_PTCPE1 PTCPE_Bits.PTCPE1
#define PTCPE_PTCPE0 PTCPE_Bits.PTCPE0


enum { PTCSE_Addr = 0x0A };

typedef struct
{
  uint8_t PTCSE0 : 1;
  uint8_t PTCSE1 : 1;
  uint8_t PTCSE2 : 1;
  uint8_t PTCSE3 : 1;
  uint8_t PTCSE4 : 1;
  uint8_t PTCSE5 : 1;
  uint8_t PTCSE6 : 1;
  uint8_t PTCSE7 : 1;
} PTCSE_t;

#define PTCSE HC08_REGISTER(uint8_t,PTCSE_Addr)

#define PTCSE_Bits HC08_REGISTER(PTCSE_t,PTCSE_Addr)

#define PTCSE_PTCSE7 PTCSE_Bits.PTCSE7
#define PTCSE_PTCSE6 PTCSE_Bits.PTCSE6
#define PTCSE_PTCSE5 PTCSE_Bits.PTCSE5
#define PTCSE_PTCSE4 PTCSE_Bits.PTCSE4
#define PTCSE_PTCSE3 PTCSE_Bits.PTCSE3
#define PTCSE_PTCSE2 PTCSE_Bits.PTCSE2
#define PTCSE_PTCSE1 PTCSE_Bits.PTCSE1
#define PTCSE_PTCSE0 PTCSE_Bits.PTCSE0


enum { PTCDD_Addr = 0x0B };

typedef struct
{
  uint8_t PTCDD0 : 1;
  uint8_t PTCDD1 : 1;
  uint8_t PTCDD2 : 1;
  uint8_t PTCDD3 : 1;
  uint8_t PTCDD4 : 1;
  uint8_t PTCDD5 : 1;
  uint8_t PTCDD6 : 1;
  uint8_t PTCDD7 : 1;
} PTCDD_t;

#define PTCDD HC08_REGISTER(uint8_t,PTCDD_Addr)

#define PTCDD_Bits HC08_REGISTER(PTCDD_t,PTCDD_Addr)

#define PTCDD_PTCDD7 PTCDD_Bits.PTCDD7
#define PTCDD_PTCDD6 PTCDD_Bits.PTCDD6
#define PTCDD_PTCDD5 PTCDD_Bits.PTCDD5
#define PTCDD_PTCDD4 PTCDD_Bits.PTCDD4
#define PTCDD_PTCDD3 PTCDD_Bits.PTCDD3
#define PTCDD_PTCDD2 PTCDD_Bits.PTCDD2
#define PTCDD_PTCDD1 PTCDD_Bits.PTCDD1
#define PTCDD_PTCDD0 PTCDD_Bits.PTCDD0


enum { PTDD_Addr = 0x0C };

typedef struct
{
  uint8_t PTDD0 : 1;
  uint8_t PTDD1 : 1;
  uint8_t PTDD2 : 1;
  uint8_t PTDD3 : 1;
  uint8_t PTDD4 : 1;
  uint8_t PTDD5 : 1;
  uint8_t PTDD6 : 1;
  uint8_t PTDD7 : 1;
} PTDD_t;

#define PTDD HC08_REGISTER(uint8_t,PTDD_Addr)

#define PTDD_Bits HC08_REGISTER(PTDD_t,PTDD_Addr)

#define PTDD_PTDD7 PTDD_Bits.PTDD7
#define PTDD_PTDD6 PTDD_Bits.PTDD6
#define PTDD_PTDD5 PTDD_Bits.PTDD5
#define PTDD_PTDD4 PTDD_Bits.PTDD4
#define PTDD_PTDD3 PTDD_Bits.PTDD3
#define PTDD_PTDD2 PTDD_Bits.PTDD2
#define PTDD_PTDD1 PTDD_Bits.PTDD1
#define PTDD_PTDD0 PTDD_Bits.PTDD0


enum { PTDPE_Addr = 0x0D };

typedef struct
{
  uint8_t PTDPE0 : 1;
  uint8_t PTDPE1 : 1;
  uint8_t PTDPE2 : 1;
  uint8_t PTDPE3 : 1;
  uint8_t PTDPE4 : 1;
  uint8_t PTDPE5 : 1;
  uint8_t PTDPE6 : 1;
  uint8_t PTDPE7 : 1;
} PTDPE_t;

#define PTDPE HC08_REGISTER(uint8_t,PTDPE_Addr)

#define PTDPE_Bits HC08_REGISTER(PTDPE_t,PTDPE_Addr)

#define PTDPE_PTDPE7 PTDPE_Bits.PTDPE7
#define PTDPE_PTDPE6 PTDPE_Bits.PTDPE6
#define PTDPE_PTDPE5 PTDPE_Bits.PTDPE5
#define PTDPE_PTDPE4 PTDPE_Bits.PTDPE4
#define PTDPE_PTDPE3 PTDPE_Bits.PTDPE3
#define PTDPE_PTDPE2 PTDPE_Bits.PTDPE2
#define PTDPE_PTDPE1 PTDPE_Bits.PTDPE1
#define PTDPE_PTDPE0 PTDPE_Bits.PTDPE0


enum { PTDSE_Addr = 0x0E };

typedef struct
{
  uint8_t PTDSE0 : 1;
  uint8_t PTDSE1 : 1;
  uint8_t PTDSE2 : 1;
  uint8_t PTDSE3 : 1;
  uint8_t PTDSE4 : 1;
  uint8_t PTDSE5 : 1;
  uint8_t PTDSE6 : 1;
  uint8_t PTDSE7 : 1;
} PTDSE_t;

#define PTDSE HC08_REGISTER(uint8_t,PTDSE_Addr)

#define PTDSE_Bits HC08_REGISTER(PTDSE_t,PTDSE_Addr)

#define PTDSE_PTDSE7 PTDSE_Bits.PTDSE7
#define PTDSE_PTDSE6 PTDSE_Bits.PTDSE6
#define PTDSE_PTDSE5 PTDSE_Bits.PTDSE5
#define PTDSE_PTDSE4 PTDSE_Bits.PTDSE4
#define PTDSE_PTDSE3 PTDSE_Bits.PTDSE3
#define PTDSE_PTDSE2 PTDSE_Bits.PTDSE2
#define PTDSE_PTDSE1 PTDSE_Bits.PTDSE1
#define PTDSE_PTDSE0 PTDSE_Bits.PTDSE0


enum { PTDDD_Addr = 0x0F };

typedef struct
{
  uint8_t PTDDD0 : 1;
  uint8_t PTDDD1 : 1;
  uint8_t PTDDD2 : 1;
  uint8_t PTDDD3 : 1;
  uint8_t PTDDD4 : 1;
  uint8_t PTDDD5 : 1;
  uint8_t PTDDD6 : 1;
  uint8_t PTDDD7 : 1;
} PTDDD_t;

#define PTDDD HC08_REGISTER(uint8_t,PTDDD_Addr)

#define PTDDD_Bits HC08_REGISTER(PTDDD_t,PTDDD_Addr)

#define PTDDD_PTDDD7 PTDDD_Bits.PTDDD7
#define PTDDD_PTDDD6 PTDDD_Bits.PTDDD6
#define PTDDD_PTDDD5 PTDDD_Bits.PTDDD5
#define PTDDD_PTDDD4 PTDDD_Bits.PTDDD4
#define PTDDD_PTDDD3 PTDDD_Bits.PTDDD3
#define PTDDD_PTDDD2 PTDDD_Bits.PTDDD2
#define PTDDD_PTDDD1 PTDDD_Bits.PTDDD1
#define PTDDD_PTDDD0 PTDDD_Bits.PTDDD0


enum { PTED_Addr = 0x10 };

typedef struct
{
  uint8_t PTED0 : 1;
  uint8_t PTED1 : 1;
  uint8_t PTED2 : 1;
  uint8_t PTED3 : 1;
  uint8_t PTED4 : 1;
  uint8_t PTED5 : 1;
  uint8_t PTED6 : 1;
  uint8_t PTED7 : 1;
} PTED_t;

#define PTED HC08_REGISTER(uint8_t,PTED_Addr)

#define PTED_Bits HC08_REGISTER(PTED_t,PTED_Addr)

#define PTED_PTED7 PTED_Bits.PTED7
#define PTED_PTED6 PTED_Bits.PTED6
#define PTED_PTED5 PTED_Bits.PTED5
#define PTED_PTED4 PTED_Bits.PTED4
#define PTED_PTED3 PTED_Bits.PTED3
#define PTED_PTED2 PTED_Bits.PTED2
#define PTED_PTED1 PTED_Bits.PTED1
#define PTED_PTED0 PTED_Bits.PTED0


enum { PTEPE_Addr = 0x11 };

typedef struct
{
  uint8_t PTEPE0 : 1;
  uint8_t PTEPE1 : 1;
  uint8_t PTEPE2 : 1;
  uint8_t PTEPE3 : 1;
  uint8_t PTEPE4 : 1;
  uint8_t PTEPE5 : 1;
  uint8_t PTEPE6 : 1;
  uint8_t PTEPE7 : 1;
} PTEPE_t;

#define PTEPE HC08_REGISTER(uint8_t,PTEPE_Addr)

#define PTEPE_Bits HC08_REGISTER(PTEPE_t,PTEPE_Addr)

#define PTEPE_PTEPE7 PTEPE_Bits.PTEPE7
#define PTEPE_PTEPE6 PTEPE_Bits.PTEPE6
#define PTEPE_PTEPE5 PTEPE_Bits.PTEPE5
#define PTEPE_PTEPE4 PTEPE_Bits.PTEPE4
#define PTEPE_PTEPE3 PTEPE_Bits.PTEPE3
#define PTEPE_PTEPE2 PTEPE_Bits.PTEPE2
#define PTEPE_PTEPE1 PTEPE_Bits.PTEPE1
#define PTEPE_PTEPE0 PTEPE_Bits.PTEPE0


enum { PTESE_Addr = 0x12 };

typedef struct
{
  uint8_t PTESE0 : 1;
  uint8_t PTESE1 : 1;
  uint8_t PTESE2 : 1;
  uint8_t PTESE3 : 1;
  uint8_t PTESE4 : 1;
  uint8_t PTESE5 : 1;
  uint8_t PTESE6 : 1;
  uint8_t PTESE7 : 1;
} PTESE_t;

#define PTESE HC08_REGISTER(uint8_t,PTESE_Addr)

#define PTESE_Bits HC08_REGISTER(PTESE_t,PTESE_Addr)

#define PTESE_PTESE7 PTESE_Bits.PTESE7
#define PTESE_PTESE6 PTESE_Bits.PTESE6
#define PTESE_PTESE5 PTESE_Bits.PTESE5
#define PTESE_PTESE4 PTESE_Bits.PTESE4
#define PTESE_PTESE3 PTESE_Bits.PTESE3
#define PTESE_PTESE2 PTESE_Bits.PTESE2
#define PTESE_PTESE1 PTESE_Bits.PTESE1
#define PTESE_PTESE0 PTESE_Bits.PTESE0


enum { PTEDD_Addr = 0x13 };

typedef struct
{
  uint8_t PTEDD0 : 1;
  uint8_t PTEDD1 : 1;
  uint8_t PTEDD2 : 1;
  uint8_t PTEDD3 : 1;
  uint8_t PTEDD4 : 1;
  uint8_t PTEDD5 : 1;
  uint8_t PTEDD6 : 1;
  uint8_t PTEDD7 : 1;
} PTEDD_t;

#define PTEDD HC08_REGISTER(uint8_t,PTEDD_Addr)

#define PTEDD_Bits HC08_REGISTER(PTEDD_t,PTEDD_Addr)

#define PTEDD_PTEDD7 PTEDD_Bits.PTEDD7
#define PTEDD_PTEDD6 PTEDD_Bits.PTEDD6
#define PTEDD_PTEDD5 PTEDD_Bits.PTEDD5
#define PTEDD_PTEDD4 PTEDD_Bits.PTEDD4
#define PTEDD_PTEDD3 PTEDD_Bits.PTEDD3
#define PTEDD_PTEDD2 PTEDD_Bits.PTEDD2
#define PTEDD_PTEDD1 PTEDD_Bits.PTEDD1
#define PTEDD_PTEDD0 PTEDD_Bits.PTEDD0


enum { IRQSC_Addr = 0x14 };

typedef struct
{
  uint8_t IRQMOD : 1;
  uint8_t IRQIE : 1;
  uint8_t IRQACK : 1;
  uint8_t IRQF : 1;
  uint8_t IRQPE : 1;
  uint8_t IRQEDG : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} IRQSC_t;

#define IRQSC HC08_REGISTER(uint8_t,IRQSC_Addr)

#define IRQSC_Bits HC08_REGISTER(IRQSC_t,IRQSC_Addr)

#define IRQSC_IRQEDG IRQSC_Bits.IRQEDG
#define IRQSC_IRQPE IRQSC_Bits.IRQPE
#define IRQSC_IRQF IRQSC_Bits.IRQF
#define IRQSC_IRQACK IRQSC_Bits.IRQACK
#define IRQSC_IRQIE IRQSC_Bits.IRQIE
#define IRQSC_IRQMOD IRQSC_Bits.IRQMOD


enum { KBISC_Addr = 0x16 };

typedef struct
{
  uint8_t KBIMOD : 1;
  uint8_t KBIE : 1;
  uint8_t KBACK : 1;
  uint8_t KBF : 1;
  uint8_t KBEDG4 : 1;
  uint8_t KBEDG5 : 1;
  uint8_t KBEDG6 : 1;
  uint8_t KBEDG7 : 1;
} KBISC_t;

#define KBISC HC08_REGISTER(uint8_t,KBISC_Addr)

#define KBISC_Bits HC08_REGISTER(KBISC_t,KBISC_Addr)

#define KBISC_KBEDG7 KBISC_Bits.KBEDG7
#define KBISC_KBEDG6 KBISC_Bits.KBEDG6
#define KBISC_KBEDG5 KBISC_Bits.KBEDG5
#define KBISC_KBEDG4 KBISC_Bits.KBEDG4
#define KBISC_KBF KBISC_Bits.KBF
#define KBISC_KBACK KBISC_Bits.KBACK
#define KBISC_KBIE KBISC_Bits.KBIE
#define KBISC_KBIMOD KBISC_Bits.KBIMOD


enum { KBIPE_Addr = 0x17 };

typedef struct
{
  uint8_t KBIPE0 : 1;
  uint8_t KBIPE1 : 1;
  uint8_t KBIPE2 : 1;
  uint8_t KBIPE3 : 1;
  uint8_t KBIPE4 : 1;
  uint8_t KBIPE5 : 1;
  uint8_t KBIPE6 : 1;
  uint8_t KBIPE7 : 1;
} KBIPE_t;

#define KBIPE HC08_REGISTER(uint8_t,KBIPE_Addr)

#define KBIPE_Bits HC08_REGISTER(KBIPE_t,KBIPE_Addr)

#define KBIPE_KBIPE7 KBIPE_Bits.KBIPE7
#define KBIPE_KBIPE6 KBIPE_Bits.KBIPE6
#define KBIPE_KBIPE5 KBIPE_Bits.KBIPE5
#define KBIPE_KBIPE4 KBIPE_Bits.KBIPE4
#define KBIPE_KBIPE3 KBIPE_Bits.KBIPE3
#define KBIPE_KBIPE2 KBIPE_Bits.KBIPE2
#define KBIPE_KBIPE1 KBIPE_Bits.KBIPE1
#define KBIPE_KBIPE0 KBIPE_Bits.KBIPE0


enum { SCI1BDH_Addr = 0x18 };

typedef struct
{
  uint8_t SBR8 : 1;
  uint8_t SBR9 : 1;
  uint8_t SBR10 : 1;
  uint8_t SBR11 : 1;
  uint8_t SBR12 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} SCI1BDH_t;

#define SCI1BD HC08_REGISTER(uint16_t,SCI1BDH_Addr)
#define SCI1BDH HC08_REGISTER(uint8_t,SCI1BDH_Addr)

#define SCI1BDH_Bits HC08_REGISTER(SCI1BDH_t,SCI1BDH_Addr)

#define SCI1BDH_SBR12 SCI1BDH_Bits.SBR12
#define SCI1BDH_SBR11 SCI1BDH_Bits.SBR11
#define SCI1BDH_SBR10 SCI1BDH_Bits.SBR10
#define SCI1BDH_SBR9 SCI1BDH_Bits.SBR9
#define SCI1BDH_SBR8 SCI1BDH_Bits.SBR8


enum { SCI1BDL_Addr = 0x19 };

typedef struct
{
  uint8_t SBR0 : 1;
  uint8_t SBR1 : 1;
  uint8_t SBR2 : 1;
  uint8_t SBR3 : 1;
  uint8_t SBR4 : 1;
  uint8_t SBR5 : 1;
  uint8_t SBR6 : 1;
  uint8_t SBR7 : 1;
} SCI1BDL_t;

#define SCI1BDL HC08_REGISTER(uint8_t,SCI1BDL_Addr)

#define SCI1BDL_Bits HC08_REGISTER(SCI1BDL_t,SCI1BDL_Addr)

#define SCI1BDL_SBR7 SCI1BDL_Bits.SBR7
#define SCI1BDL_SBR6 SCI1BDL_Bits.SBR6
#define SCI1BDL_SBR5 SCI1BDL_Bits.SBR5
#define SCI1BDL_SBR4 SCI1BDL_Bits.SBR4
#define SCI1BDL_SBR3 SCI1BDL_Bits.SBR3
#define SCI1BDL_SBR2 SCI1BDL_Bits.SBR2
#define SCI1BDL_SBR1 SCI1BDL_Bits.SBR1
#define SCI1BDL_SBR0 SCI1BDL_Bits.SBR0


enum { SCI1C1_Addr = 0x1A };

typedef struct
{
  uint8_t PT : 1;
  uint8_t PE : 1;
  uint8_t ILT : 1;
  uint8_t WAKE : 1;
  uint8_t M : 1;
  uint8_t RSRC : 1;
  uint8_t SCISWAI : 1;
  uint8_t LOOPS : 1;
} SCI1C1_t;

#define SCI1C1 HC08_REGISTER(uint8_t,SCI1C1_Addr)

#define SCI1C1_Bits HC08_REGISTER(SCI1C1_t,SCI1C1_Addr)

#define SCI1C1_LOOPS SCI1C1_Bits.LOOPS
#define SCI1C1_SCISWAI SCI1C1_Bits.SCISWAI
#define SCI1C1_RSRC SCI1C1_Bits.RSRC
#define SCI1C1_M SCI1C1_Bits.M
#define SCI1C1_WAKE SCI1C1_Bits.WAKE
#define SCI1C1_ILT SCI1C1_Bits.ILT
#define SCI1C1_PE SCI1C1_Bits.PE
#define SCI1C1_PT SCI1C1_Bits.PT


enum { SCI1C2_Addr = 0x1B };

typedef struct
{
  uint8_t SBK : 1;
  uint8_t RWU : 1;
  uint8_t RE : 1;
  uint8_t TE : 1;
  uint8_t ILIE : 1;
  uint8_t RIE : 1;
  uint8_t TCIE : 1;
  uint8_t TIE : 1;
} SCI1C2_t;

#define SCI1C2 HC08_REGISTER(uint8_t,SCI1C2_Addr)

#define SCI1C2_Bits HC08_REGISTER(SCI1C2_t,SCI1C2_Addr)

#define SCI1C2_TIE SCI1C2_Bits.TIE
#define SCI1C2_TCIE SCI1C2_Bits.TCIE
#define SCI1C2_RIE SCI1C2_Bits.RIE
#define SCI1C2_ILIE SCI1C2_Bits.ILIE
#define SCI1C2_TE SCI1C2_Bits.TE
#define SCI1C2_RE SCI1C2_Bits.RE
#define SCI1C2_RWU SCI1C2_Bits.RWU
#define SCI1C2_SBK SCI1C2_Bits.SBK


enum { SCI1S1_Addr = 0x1C };

typedef struct
{
  uint8_t PF : 1;
  uint8_t FE : 1;
  uint8_t NF : 1;
  uint8_t OR : 1;
  uint8_t IDLE : 1;
  uint8_t RDRF : 1;
  uint8_t TC : 1;
  uint8_t TDRE : 1;
} SCI1S1_t;

#define SCI1S1 HC08_REGISTER(uint8_t,SCI1S1_Addr)

#define SCI1S1_Bits HC08_REGISTER(SCI1S1_t,SCI1S1_Addr)

#define SCI1S1_TDRE SCI1S1_Bits.TDRE
#define SCI1S1_TC SCI1S1_Bits.TC
#define SCI1S1_RDRF SCI1S1_Bits.RDRF
#define SCI1S1_IDLE SCI1S1_Bits.IDLE
#define SCI1S1_OR SCI1S1_Bits.OR
#define SCI1S1_NF SCI1S1_Bits.NF
#define SCI1S1_FE SCI1S1_Bits.FE
#define SCI1S1_PF SCI1S1_Bits.PF


enum { SCI1S2_Addr = 0x1D };

typedef struct
{
  uint8_t RAF : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} SCI1S2_t;

#define SCI1S2 HC08_REGISTER(uint8_t,SCI1S2_Addr)

#define SCI1S2_Bits HC08_REGISTER(SCI1S2_t,SCI1S2_Addr)

#define SCI1S2_RAF SCI1S2_Bits.RAF


enum { SCI1C3_Addr = 0x1E };

typedef struct
{
  uint8_t PEIE : 1;
  uint8_t FEIE : 1;
  uint8_t NEIE : 1;
  uint8_t ORIE : 1;
  uint8_t bit4 : 1;
  uint8_t TXDIR : 1;
  uint8_t T8 : 1;
  uint8_t R8 : 1;
} SCI1C3_t;

#define SCI1C3 HC08_REGISTER(uint8_t,SCI1C3_Addr)

#define SCI1C3_Bits HC08_REGISTER(SCI1C3_t,SCI1C3_Addr)

#define SCI1C3_R8 SCI1C3_Bits.R8
#define SCI1C3_T8 SCI1C3_Bits.T8
#define SCI1C3_TXDIR SCI1C3_Bits.TXDIR
#define SCI1C3_ORIE SCI1C3_Bits.ORIE
#define SCI1C3_NEIE SCI1C3_Bits.NEIE
#define SCI1C3_FEIE SCI1C3_Bits.FEIE
#define SCI1C3_PEIE SCI1C3_Bits.PEIE


enum { SCI1D_Addr = 0x1F };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} SCI1D_t;

#define SCI1D HC08_REGISTER(uint8_t,SCI1D_Addr)

#define SCI1D_Bits HC08_REGISTER(SCI1D_t,SCI1D_Addr)



enum { SCI2BDH_Addr = 0x20 };

typedef struct
{
  uint8_t SBR8 : 1;
  uint8_t SBR9 : 1;
  uint8_t SBR10 : 1;
  uint8_t SBR11 : 1;
  uint8_t SBR12 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} SCI2BDH_t;

#define SCI2BD HC08_REGISTER(uint16_t,SCI2BDH_Addr)
#define SCI2BDH HC08_REGISTER(uint8_t,SCI2BDH_Addr)

#define SCI2BDH_Bits HC08_REGISTER(SCI2BDH_t,SCI2BDH_Addr)

#define SCI2BDH_SBR12 SCI2BDH_Bits.SBR12
#define SCI2BDH_SBR11 SCI2BDH_Bits.SBR11
#define SCI2BDH_SBR10 SCI2BDH_Bits.SBR10
#define SCI2BDH_SBR9 SCI2BDH_Bits.SBR9
#define SCI2BDH_SBR8 SCI2BDH_Bits.SBR8


enum { SCI2BDL_Addr = 0x21 };

typedef struct
{
  uint8_t SBR0 : 1;
  uint8_t SBR1 : 1;
  uint8_t SBR2 : 1;
  uint8_t SBR3 : 1;
  uint8_t SBR4 : 1;
  uint8_t SBR5 : 1;
  uint8_t SBR6 : 1;
  uint8_t SBR7 : 1;
} SCI2BDL_t;

#define SCI2BDL HC08_REGISTER(uint8_t,SCI2BDL_Addr)

#define SCI2BDL_Bits HC08_REGISTER(SCI2BDL_t,SCI2BDL_Addr)

#define SCI2BDL_SBR7 SCI2BDL_Bits.SBR7
#define SCI2BDL_SBR6 SCI2BDL_Bits.SBR6
#define SCI2BDL_SBR5 SCI2BDL_Bits.SBR5
#define SCI2BDL_SBR4 SCI2BDL_Bits.SBR4
#define SCI2BDL_SBR3 SCI2BDL_Bits.SBR3
#define SCI2BDL_SBR2 SCI2BDL_Bits.SBR2
#define SCI2BDL_SBR1 SCI2BDL_Bits.SBR1
#define SCI2BDL_SBR0 SCI2BDL_Bits.SBR0


enum { SCI2C1_Addr = 0x22 };

typedef struct
{
  uint8_t PT : 1;
  uint8_t PE : 1;
  uint8_t ILT : 1;
  uint8_t WAKE : 1;
  uint8_t M : 1;
  uint8_t RSRC : 1;
  uint8_t SCISWAI : 1;
  uint8_t LOOPS : 1;
} SCI2C1_t;

#define SCI2C1 HC08_REGISTER(uint8_t,SCI2C1_Addr)

#define SCI2C1_Bits HC08_REGISTER(SCI2C1_t,SCI2C1_Addr)

#define SCI2C1_LOOPS SCI2C1_Bits.LOOPS
#define SCI2C1_SCISWAI SCI2C1_Bits.SCISWAI
#define SCI2C1_RSRC SCI2C1_Bits.RSRC
#define SCI2C1_M SCI2C1_Bits.M
#define SCI2C1_WAKE SCI2C1_Bits.WAKE
#define SCI2C1_ILT SCI2C1_Bits.ILT
#define SCI2C1_PE SCI2C1_Bits.PE
#define SCI2C1_PT SCI2C1_Bits.PT


enum { SCI2C2_Addr = 0x23 };

typedef struct
{
  uint8_t SBK : 1;
  uint8_t RWU : 1;
  uint8_t RE : 1;
  uint8_t TE : 1;
  uint8_t ILIE : 1;
  uint8_t RIE : 1;
  uint8_t TCIE : 1;
  uint8_t TIE : 1;
} SCI2C2_t;

#define SCI2C2 HC08_REGISTER(uint8_t,SCI2C2_Addr)

#define SCI2C2_Bits HC08_REGISTER(SCI2C2_t,SCI2C2_Addr)

#define SCI2C2_TIE SCI2C2_Bits.TIE
#define SCI2C2_TCIE SCI2C2_Bits.TCIE
#define SCI2C2_RIE SCI2C2_Bits.RIE
#define SCI2C2_ILIE SCI2C2_Bits.ILIE
#define SCI2C2_TE SCI2C2_Bits.TE
#define SCI2C2_RE SCI2C2_Bits.RE
#define SCI2C2_RWU SCI2C2_Bits.RWU
#define SCI2C2_SBK SCI2C2_Bits.SBK


enum { SCI2S1_Addr = 0x24 };

typedef struct
{
  uint8_t PF : 1;
  uint8_t FE : 1;
  uint8_t NF : 1;
  uint8_t OR : 1;
  uint8_t IDLE : 1;
  uint8_t RDRF : 1;
  uint8_t TC : 1;
  uint8_t TDRE : 1;
} SCI2S1_t;

#define SCI2S1 HC08_REGISTER(uint8_t,SCI2S1_Addr)

#define SCI2S1_Bits HC08_REGISTER(SCI2S1_t,SCI2S1_Addr)

#define SCI2S1_TDRE SCI2S1_Bits.TDRE
#define SCI2S1_TC SCI2S1_Bits.TC
#define SCI2S1_RDRF SCI2S1_Bits.RDRF
#define SCI2S1_IDLE SCI2S1_Bits.IDLE
#define SCI2S1_OR SCI2S1_Bits.OR
#define SCI2S1_NF SCI2S1_Bits.NF
#define SCI2S1_FE SCI2S1_Bits.FE
#define SCI2S1_PF SCI2S1_Bits.PF


enum { SCI2S2_Addr = 0x25 };

typedef struct
{
  uint8_t RAF : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} SCI2S2_t;

#define SCI2S2 HC08_REGISTER(uint8_t,SCI2S2_Addr)

#define SCI2S2_Bits HC08_REGISTER(SCI2S2_t,SCI2S2_Addr)

#define SCI2S2_RAF SCI2S2_Bits.RAF


enum { SCI2C3_Addr = 0x26 };

typedef struct
{
  uint8_t PEIE : 1;
  uint8_t FEIE : 1;
  uint8_t NEIE : 1;
  uint8_t ORIE : 1;
  uint8_t bit4 : 1;
  uint8_t TXDIR : 1;
  uint8_t T8 : 1;
  uint8_t R8 : 1;
} SCI2C3_t;

#define SCI2C3 HC08_REGISTER(uint8_t,SCI2C3_Addr)

#define SCI2C3_Bits HC08_REGISTER(SCI2C3_t,SCI2C3_Addr)

#define SCI2C3_R8 SCI2C3_Bits.R8
#define SCI2C3_T8 SCI2C3_Bits.T8
#define SCI2C3_TXDIR SCI2C3_Bits.TXDIR
#define SCI2C3_ORIE SCI2C3_Bits.ORIE
#define SCI2C3_NEIE SCI2C3_Bits.NEIE
#define SCI2C3_FEIE SCI2C3_Bits.FEIE
#define SCI2C3_PEIE SCI2C3_Bits.PEIE


enum { SCI2D_Addr = 0x27 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} SCI2D_t;

#define SCI2D HC08_REGISTER(uint8_t,SCI2D_Addr)

#define SCI2D_Bits HC08_REGISTER(SCI2D_t,SCI2D_Addr)



enum { SPIC1_Addr = 0x28 };

typedef struct
{
  uint8_t LSBFE : 1;
  uint8_t SSOE : 1;
  uint8_t CPHA : 1;
  uint8_t CPOL : 1;
  uint8_t MSTR : 1;
  uint8_t SPTIE : 1;
  uint8_t SPE : 1;
  uint8_t SPIE : 1;
} SPIC1_t;

#define SPIC1 HC08_REGISTER(uint8_t,SPIC1_Addr)

#define SPIC1_Bits HC08_REGISTER(SPIC1_t,SPIC1_Addr)

#define SPIC1_SPIE SPIC1_Bits.SPIE
#define SPIC1_SPE SPIC1_Bits.SPE
#define SPIC1_SPTIE SPIC1_Bits.SPTIE
#define SPIC1_MSTR SPIC1_Bits.MSTR
#define SPIC1_CPOL SPIC1_Bits.CPOL
#define SPIC1_CPHA SPIC1_Bits.CPHA
#define SPIC1_SSOE SPIC1_Bits.SSOE
#define SPIC1_LSBFE SPIC1_Bits.LSBFE


enum { SPIC2_Addr = 0x29 };

typedef struct
{
  uint8_t SPC0 : 1;
  uint8_t SPISWAI : 1;
  uint8_t bit2 : 1;
  uint8_t BIDIROE : 1;
  uint8_t MODFEN : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} SPIC2_t;

#define SPIC2 HC08_REGISTER(uint8_t,SPIC2_Addr)

#define SPIC2_Bits HC08_REGISTER(SPIC2_t,SPIC2_Addr)

#define SPIC2_MODFEN SPIC2_Bits.MODFEN
#define SPIC2_BIDIROE SPIC2_Bits.BIDIROE
#define SPIC2_SPISWAI SPIC2_Bits.SPISWAI
#define SPIC2_SPC0 SPIC2_Bits.SPC0


enum { SPIBR_Addr = 0x2A };

typedef struct
{
  uint8_t SPR0 : 1;
  uint8_t SPR1 : 1;
  uint8_t SPR2 : 1;
  uint8_t bit3 : 1;
  uint8_t SPPR0 : 1;
  uint8_t SPPR1 : 1;
  uint8_t SPPR2 : 1;
  uint8_t bit7 : 1;
} SPIBR_t;

#define SPIBR HC08_REGISTER(uint8_t,SPIBR_Addr)

#define SPIBR_Bits HC08_REGISTER(SPIBR_t,SPIBR_Addr)

#define SPIBR_SPPR2 SPIBR_Bits.SPPR2
#define SPIBR_SPPR1 SPIBR_Bits.SPPR1
#define SPIBR_SPPR0 SPIBR_Bits.SPPR0
#define SPIBR_SPR2 SPIBR_Bits.SPR2
#define SPIBR_SPR1 SPIBR_Bits.SPR1
#define SPIBR_SPR0 SPIBR_Bits.SPR0


enum { SPIS_Addr = 0x2B };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t MODF : 1;
  uint8_t SPTEF : 1;
  uint8_t bit6 : 1;
  uint8_t SPRF : 1;
} SPIS_t;

#define SPIS HC08_REGISTER(uint8_t,SPIS_Addr)

#define SPIS_Bits HC08_REGISTER(SPIS_t,SPIS_Addr)

#define SPIS_SPRF SPIS_Bits.SPRF
#define SPIS_SPTEF SPIS_Bits.SPTEF
#define SPIS_MODF SPIS_Bits.MODF


enum { SPID_Addr = 0x2D };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} SPID_t;

#define SPID HC08_REGISTER(uint8_t,SPID_Addr)

#define SPID_Bits HC08_REGISTER(SPID_t,SPID_Addr)



enum { TPM1SC_Addr = 0x30 };

typedef struct
{
  uint8_t PS0 : 1;
  uint8_t PS1 : 1;
  uint8_t PS2 : 1;
  uint8_t CLKSA : 1;
  uint8_t CLKSB : 1;
  uint8_t CPWMS : 1;
  uint8_t TOIE : 1;
  uint8_t TOF : 1;
} TPM1SC_t;

#define TPM1SC HC08_REGISTER(uint8_t,TPM1SC_Addr)

#define TPM1SC_Bits HC08_REGISTER(TPM1SC_t,TPM1SC_Addr)

#define TPM1SC_TOF TPM1SC_Bits.TOF
#define TPM1SC_TOIE TPM1SC_Bits.TOIE
#define TPM1SC_CPWMS TPM1SC_Bits.CPWMS
#define TPM1SC_CLKSB TPM1SC_Bits.CLKSB
#define TPM1SC_CLKSA TPM1SC_Bits.CLKSA
#define TPM1SC_PS2 TPM1SC_Bits.PS2
#define TPM1SC_PS1 TPM1SC_Bits.PS1
#define TPM1SC_PS0 TPM1SC_Bits.PS0


enum { TPM1CNTH_Addr = 0x31 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM1CNTH_t;

#define TPM1CNT HC08_REGISTER(uint16_t,TPM1CNTH_Addr)
#define TPM1CNTH HC08_REGISTER(uint8_t,TPM1CNTH_Addr)

#define TPM1CNTH_Bits HC08_REGISTER(TPM1CNTH_t,TPM1CNTH_Addr)



enum { TPM1CNTL_Addr = 0x32 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM1CNTL_t;

#define TPM1CNTL HC08_REGISTER(uint8_t,TPM1CNTL_Addr)

#define TPM1CNTL_Bits HC08_REGISTER(TPM1CNTL_t,TPM1CNTL_Addr)



enum { TPM1MODH_Addr = 0x33 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM1MODH_t;

#define TPM1MOD HC08_REGISTER(uint16_t,TPM1MODH_Addr)
#define TPM1MODH HC08_REGISTER(uint8_t,TPM1MODH_Addr)

#define TPM1MODH_Bits HC08_REGISTER(TPM1MODH_t,TPM1MODH_Addr)



enum { TPM1MODL_Addr = 0x34 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM1MODL_t;

#define TPM1MODL HC08_REGISTER(uint8_t,TPM1MODL_Addr)

#define TPM1MODL_Bits HC08_REGISTER(TPM1MODL_t,TPM1MODL_Addr)



enum { TPM1C0SC_Addr = 0x35 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t ELS0A : 1;
  uint8_t ELS0B : 1;
  uint8_t MS0A : 1;
  uint8_t MS0B : 1;
  uint8_t CH0IE : 1;
  uint8_t CH0F : 1;
} TPM1C0SC_t;

#define TPM1C0SC HC08_REGISTER(uint8_t,TPM1C0SC_Addr)

#define TPM1C0SC_Bits HC08_REGISTER(TPM1C0SC_t,TPM1C0SC_Addr)

#define TPM1C0SC_CH0F TPM1C0SC_Bits.CH0F
#define TPM1C0SC_CH0IE TPM1C0SC_Bits.CH0IE
#define TPM1C0SC_MS0B TPM1C0SC_Bits.MS0B
#define TPM1C0SC_MS0A TPM1C0SC_Bits.MS0A
#define TPM1C0SC_ELS0B TPM1C0SC_Bits.ELS0B
#define TPM1C0SC_ELS0A TPM1C0SC_Bits.ELS0A


enum { TPM1C0VH_Addr = 0x36 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM1C0VH_t;

#define TPM1C0V HC08_REGISTER(uint16_t,TPM1C0VH_Addr)
#define TPM1C0VH HC08_REGISTER(uint8_t,TPM1C0VH_Addr)

#define TPM1C0VH_Bits HC08_REGISTER(TPM1C0VH_t,TPM1C0VH_Addr)



enum { TPM1C0VL_Addr = 0x37 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM1C0VL_t;

#define TPM1C0VL HC08_REGISTER(uint8_t,TPM1C0VL_Addr)

#define TPM1C0VL_Bits HC08_REGISTER(TPM1C0VL_t,TPM1C0VL_Addr)



enum { TPM1C1SC_Addr = 0x38 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t ELS1A : 1;
  uint8_t ELS1B : 1;
  uint8_t MS1A : 1;
  uint8_t MS1B : 1;
  uint8_t CH1IE : 1;
  uint8_t CH1F : 1;
} TPM1C1SC_t;

#define TPM1C1SC HC08_REGISTER(uint8_t,TPM1C1SC_Addr)

#define TPM1C1SC_Bits HC08_REGISTER(TPM1C1SC_t,TPM1C1SC_Addr)

#define TPM1C1SC_CH1F TPM1C1SC_Bits.CH1F
#define TPM1C1SC_CH1IE TPM1C1SC_Bits.CH1IE
#define TPM1C1SC_MS1B TPM1C1SC_Bits.MS1B
#define TPM1C1SC_MS1A TPM1C1SC_Bits.MS1A
#define TPM1C1SC_ELS1B TPM1C1SC_Bits.ELS1B
#define TPM1C1SC_ELS1A TPM1C1SC_Bits.ELS1A


enum { TPM1C1VH_Addr = 0x39 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM1C1VH_t;

#define TPM1C1V HC08_REGISTER(uint16_t,TPM1C1VH_Addr)
#define TPM1C1VH HC08_REGISTER(uint8_t,TPM1C1VH_Addr)

#define TPM1C1VH_Bits HC08_REGISTER(TPM1C1VH_t,TPM1C1VH_Addr)



enum { TPM1C1VL_Addr = 0x3A };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM1C1VL_t;

#define TPM1C1VL HC08_REGISTER(uint8_t,TPM1C1VL_Addr)

#define TPM1C1VL_Bits HC08_REGISTER(TPM1C1VL_t,TPM1C1VL_Addr)



enum { TPM1C2SC_Addr = 0x3B };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t ELS2A : 1;
  uint8_t ELS2B : 1;
  uint8_t MS2A : 1;
  uint8_t MS2B : 1;
  uint8_t CH2IE : 1;
  uint8_t CH2F : 1;
} TPM1C2SC_t;

#define TPM1C2SC HC08_REGISTER(uint8_t,TPM1C2SC_Addr)

#define TPM1C2SC_Bits HC08_REGISTER(TPM1C2SC_t,TPM1C2SC_Addr)

#define TPM1C2SC_CH2F TPM1C2SC_Bits.CH2F
#define TPM1C2SC_CH2IE TPM1C2SC_Bits.CH2IE
#define TPM1C2SC_MS2B TPM1C2SC_Bits.MS2B
#define TPM1C2SC_MS2A TPM1C2SC_Bits.MS2A
#define TPM1C2SC_ELS2B TPM1C2SC_Bits.ELS2B
#define TPM1C2SC_ELS2A TPM1C2SC_Bits.ELS2A


enum { TPM1C2VH_Addr = 0x3C };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM1C2VH_t;

#define TPM1C2V HC08_REGISTER(uint16_t,TPM1C2VH_Addr)
#define TPM1C2VH HC08_REGISTER(uint8_t,TPM1C2VH_Addr)

#define TPM1C2VH_Bits HC08_REGISTER(TPM1C2VH_t,TPM1C2VH_Addr)



enum { TPM1C2VL_Addr = 0x3D };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM1C2VL_t;

#define TPM1C2VL HC08_REGISTER(uint8_t,TPM1C2VL_Addr)

#define TPM1C2VL_Bits HC08_REGISTER(TPM1C2VL_t,TPM1C2VL_Addr)



enum { PTFD_Addr = 0x40 };

typedef struct
{
  uint8_t PTFD0 : 1;
  uint8_t PTFD1 : 1;
  uint8_t PTFD2 : 1;
  uint8_t PTFD3 : 1;
  uint8_t PTFD4 : 1;
  uint8_t PTFD5 : 1;
  uint8_t PTFD6 : 1;
  uint8_t PTFD7 : 1;
} PTFD_t;

#define PTFD HC08_REGISTER(uint8_t,PTFD_Addr)

#define PTFD_Bits HC08_REGISTER(PTFD_t,PTFD_Addr)

#define PTFD_PTFD7 PTFD_Bits.PTFD7
#define PTFD_PTFD6 PTFD_Bits.PTFD6
#define PTFD_PTFD5 PTFD_Bits.PTFD5
#define PTFD_PTFD4 PTFD_Bits.PTFD4
#define PTFD_PTFD3 PTFD_Bits.PTFD3
#define PTFD_PTFD2 PTFD_Bits.PTFD2
#define PTFD_PTFD1 PTFD_Bits.PTFD1
#define PTFD_PTFD0 PTFD_Bits.PTFD0


enum { PTFPE_Addr = 0x41 };

typedef struct
{
  uint8_t PTFPE0 : 1;
  uint8_t PTFPE1 : 1;
  uint8_t PTFPE2 : 1;
  uint8_t PTFPE3 : 1;
  uint8_t PTFPE4 : 1;
  uint8_t PTFPE5 : 1;
  uint8_t PTFPE6 : 1;
  uint8_t PTFPE7 : 1;
} PTFPE_t;

#define PTFPE HC08_REGISTER(uint8_t,PTFPE_Addr)

#define PTFPE_Bits HC08_REGISTER(PTFPE_t,PTFPE_Addr)

#define PTFPE_PTFPE7 PTFPE_Bits.PTFPE7
#define PTFPE_PTFPE6 PTFPE_Bits.PTFPE6
#define PTFPE_PTFPE5 PTFPE_Bits.PTFPE5
#define PTFPE_PTFPE4 PTFPE_Bits.PTFPE4
#define PTFPE_PTFPE3 PTFPE_Bits.PTFPE3
#define PTFPE_PTFPE2 PTFPE_Bits.PTFPE2
#define PTFPE_PTFPE1 PTFPE_Bits.PTFPE1
#define PTFPE_PTFPE0 PTFPE_Bits.PTFPE0


enum { PTFSE_Addr = 0x42 };

typedef struct
{
  uint8_t PTFSE0 : 1;
  uint8_t PTFSE1 : 1;
  uint8_t PTFSE2 : 1;
  uint8_t PTFSE3 : 1;
  uint8_t PTFSE4 : 1;
  uint8_t PTFSE5 : 1;
  uint8_t PTFSE6 : 1;
  uint8_t PTFSE7 : 1;
} PTFSE_t;

#define PTFSE HC08_REGISTER(uint8_t,PTFSE_Addr)

#define PTFSE_Bits HC08_REGISTER(PTFSE_t,PTFSE_Addr)

#define PTFSE_PTFSE7 PTFSE_Bits.PTFSE7
#define PTFSE_PTFSE6 PTFSE_Bits.PTFSE6
#define PTFSE_PTFSE5 PTFSE_Bits.PTFSE5
#define PTFSE_PTFSE4 PTFSE_Bits.PTFSE4
#define PTFSE_PTFSE3 PTFSE_Bits.PTFSE3
#define PTFSE_PTFSE2 PTFSE_Bits.PTFSE2
#define PTFSE_PTFSE1 PTFSE_Bits.PTFSE1
#define PTFSE_PTFSE0 PTFSE_Bits.PTFSE0


enum { PTFDD_Addr = 0x43 };

typedef struct
{
  uint8_t PTFDD0 : 1;
  uint8_t PTFDD1 : 1;
  uint8_t PTFDD2 : 1;
  uint8_t PTFDD3 : 1;
  uint8_t PTFDD4 : 1;
  uint8_t PTFDD5 : 1;
  uint8_t PTFDD6 : 1;
  uint8_t PTFDD7 : 1;
} PTFDD_t;

#define PTFDD HC08_REGISTER(uint8_t,PTFDD_Addr)

#define PTFDD_Bits HC08_REGISTER(PTFDD_t,PTFDD_Addr)

#define PTFDD_PTFDD7 PTFDD_Bits.PTFDD7
#define PTFDD_PTFDD6 PTFDD_Bits.PTFDD6
#define PTFDD_PTFDD5 PTFDD_Bits.PTFDD5
#define PTFDD_PTFDD4 PTFDD_Bits.PTFDD4
#define PTFDD_PTFDD3 PTFDD_Bits.PTFDD3
#define PTFDD_PTFDD2 PTFDD_Bits.PTFDD2
#define PTFDD_PTFDD1 PTFDD_Bits.PTFDD1
#define PTFDD_PTFDD0 PTFDD_Bits.PTFDD0


enum { PTGD_Addr = 0x44 };

typedef struct
{
  uint8_t PTGD0 : 1;
  uint8_t PTGD1 : 1;
  uint8_t PTGD2 : 1;
  uint8_t PTGD3 : 1;
  uint8_t PTGD4 : 1;
  uint8_t PTGD5 : 1;
  uint8_t PTGD6 : 1;
  uint8_t PTGD7 : 1;
} PTGD_t;

#define PTGD HC08_REGISTER(uint8_t,PTGD_Addr)

#define PTGD_Bits HC08_REGISTER(PTGD_t,PTGD_Addr)

#define PTGD_PTGD7 PTGD_Bits.PTGD7
#define PTGD_PTGD6 PTGD_Bits.PTGD6
#define PTGD_PTGD5 PTGD_Bits.PTGD5
#define PTGD_PTGD4 PTGD_Bits.PTGD4
#define PTGD_PTGD3 PTGD_Bits.PTGD3
#define PTGD_PTGD2 PTGD_Bits.PTGD2
#define PTGD_PTGD1 PTGD_Bits.PTGD1
#define PTGD_PTGD0 PTGD_Bits.PTGD0


enum { PTGPE_Addr = 0x45 };

typedef struct
{
  uint8_t PTGPE0 : 1;
  uint8_t PTGPE1 : 1;
  uint8_t PTGPE2 : 1;
  uint8_t PTGPE3 : 1;
  uint8_t PTGPE4 : 1;
  uint8_t PTGPE5 : 1;
  uint8_t PTGPE6 : 1;
  uint8_t PTGPE7 : 1;
} PTGPE_t;

#define PTGPE HC08_REGISTER(uint8_t,PTGPE_Addr)

#define PTGPE_Bits HC08_REGISTER(PTGPE_t,PTGPE_Addr)

#define PTGPE_PTGPE7 PTGPE_Bits.PTGPE7
#define PTGPE_PTGPE6 PTGPE_Bits.PTGPE6
#define PTGPE_PTGPE5 PTGPE_Bits.PTGPE5
#define PTGPE_PTGPE4 PTGPE_Bits.PTGPE4
#define PTGPE_PTGPE3 PTGPE_Bits.PTGPE3
#define PTGPE_PTGPE2 PTGPE_Bits.PTGPE2
#define PTGPE_PTGPE1 PTGPE_Bits.PTGPE1
#define PTGPE_PTGPE0 PTGPE_Bits.PTGPE0


enum { PTGSE_Addr = 0x46 };

typedef struct
{
  uint8_t PTGSE0 : 1;
  uint8_t PTGSE1 : 1;
  uint8_t PTGSE2 : 1;
  uint8_t PTGSE3 : 1;
  uint8_t PTGSE4 : 1;
  uint8_t PTGSE5 : 1;
  uint8_t PTGSE6 : 1;
  uint8_t PTGSE7 : 1;
} PTGSE_t;

#define PTGSE HC08_REGISTER(uint8_t,PTGSE_Addr)

#define PTGSE_Bits HC08_REGISTER(PTGSE_t,PTGSE_Addr)

#define PTGSE_PTGSE7 PTGSE_Bits.PTGSE7
#define PTGSE_PTGSE6 PTGSE_Bits.PTGSE6
#define PTGSE_PTGSE5 PTGSE_Bits.PTGSE5
#define PTGSE_PTGSE4 PTGSE_Bits.PTGSE4
#define PTGSE_PTGSE3 PTGSE_Bits.PTGSE3
#define PTGSE_PTGSE2 PTGSE_Bits.PTGSE2
#define PTGSE_PTGSE1 PTGSE_Bits.PTGSE1
#define PTGSE_PTGSE0 PTGSE_Bits.PTGSE0


enum { PTGDD_Addr = 0x47 };

typedef struct
{
  uint8_t PTGDD0 : 1;
  uint8_t PTGDD1 : 1;
  uint8_t PTGDD2 : 1;
  uint8_t PTGDD3 : 1;
  uint8_t PTGDD4 : 1;
  uint8_t PTGDD5 : 1;
  uint8_t PTGDD6 : 1;
  uint8_t PTGDD7 : 1;
} PTGDD_t;

#define PTGDD HC08_REGISTER(uint8_t,PTGDD_Addr)

#define PTGDD_Bits HC08_REGISTER(PTGDD_t,PTGDD_Addr)

#define PTGDD_PTGDD7 PTGDD_Bits.PTGDD7
#define PTGDD_PTGDD6 PTGDD_Bits.PTGDD6
#define PTGDD_PTGDD5 PTGDD_Bits.PTGDD5
#define PTGDD_PTGDD4 PTGDD_Bits.PTGDD4
#define PTGDD_PTGDD3 PTGDD_Bits.PTGDD3
#define PTGDD_PTGDD2 PTGDD_Bits.PTGDD2
#define PTGDD_PTGDD1 PTGDD_Bits.PTGDD1
#define PTGDD_PTGDD0 PTGDD_Bits.PTGDD0


enum { ICGC1_Addr = 0x48 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t OSCSTEN : 1;
  uint8_t CLKS : 2;
  uint8_t REFS : 1;
  uint8_t RANGE : 1;
  uint8_t bit7 : 1;
} ICGC1_t;

#define ICGC1 HC08_REGISTER(uint8_t,ICGC1_Addr)

#define ICGC1_Bits HC08_REGISTER(ICGC1_t,ICGC1_Addr)

#define ICGC1_RANGE ICGC1_Bits.RANGE
#define ICGC1_REFS ICGC1_Bits.REFS
#define ICGC1_CLKS ICGC1_Bits.CLKS
#define ICGC1_OSCSTEN ICGC1_Bits.OSCSTEN


enum { ICGC2_Addr = 0x49 };

typedef struct
{
  uint8_t RFD : 3;
  uint8_t LOCRE : 1;
  uint8_t MFD : 3;
  uint8_t LOLRE : 1;
} ICGC2_t;

#define ICGC2 HC08_REGISTER(uint8_t,ICGC2_Addr)

#define ICGC2_Bits HC08_REGISTER(ICGC2_t,ICGC2_Addr)

#define ICGC2_LOLRE ICGC2_Bits.LOLRE
#define ICGC2_MFD ICGC2_Bits.MFD
#define ICGC2_LOCRE ICGC2_Bits.LOCRE
#define ICGC2_RFD ICGC2_Bits.RFD


enum { ICGS1_Addr = 0x4A };

typedef struct
{
  uint8_t ICGIF : 1;
  uint8_t ERCS : 1;
  uint8_t LOCS : 1;
  uint8_t LOCK : 1;
  uint8_t LOLS : 1;
  uint8_t REFST : 1;
  uint8_t CLKST : 2;
} ICGS1_t;

#define ICGS1 HC08_REGISTER(uint8_t,ICGS1_Addr)

#define ICGS1_Bits HC08_REGISTER(ICGS1_t,ICGS1_Addr)

#define ICGS1_CLKST ICGS1_Bits.CLKST
#define ICGS1_REFST ICGS1_Bits.REFST
#define ICGS1_LOLS ICGS1_Bits.LOLS
#define ICGS1_LOCK ICGS1_Bits.LOCK
#define ICGS1_LOCS ICGS1_Bits.LOCS
#define ICGS1_ERCS ICGS1_Bits.ERCS
#define ICGS1_ICGIF ICGS1_Bits.ICGIF


enum { ICGS2_Addr = 0x4B };

typedef struct
{
  uint8_t DCOS : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} ICGS2_t;

#define ICGS2 HC08_REGISTER(uint8_t,ICGS2_Addr)

#define ICGS2_Bits HC08_REGISTER(ICGS2_t,ICGS2_Addr)

#define ICGS2_DCOS ICGS2_Bits.DCOS


enum { ICGFLTU_Addr = 0x4C };

typedef struct
{
  uint8_t FLT : 4;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} ICGFLTU_t;

#define ICGFLTU HC08_REGISTER(uint8_t,ICGFLTU_Addr)

#define ICGFLTU_Bits HC08_REGISTER(ICGFLTU_t,ICGFLTU_Addr)

#define ICGFLTU_FLT ICGFLTU_Bits.FLT


enum { ICGFLTL_Addr = 0x4D };

typedef struct
{
  uint8_t FLT : 8;
} ICGFLTL_t;

#define ICGFLTL HC08_REGISTER(uint8_t,ICGFLTL_Addr)

#define ICGFLTL_Bits HC08_REGISTER(ICGFLTL_t,ICGFLTL_Addr)

#define ICGFLTL_FLT ICGFLTL_Bits.FLT


enum { ICGTRM_Addr = 0x4E };

typedef struct
{
  uint8_t TRIM : 8;
} ICGTRM_t;

#define ICGTRM HC08_REGISTER(uint8_t,ICGTRM_Addr)

#define ICGTRM_Bits HC08_REGISTER(ICGTRM_t,ICGTRM_Addr)

#define ICGTRM_TRIM ICGTRM_Bits.TRIM


enum { ATDC_Addr = 0x50 };

typedef struct
{
  uint8_t PRS : 4;
  uint8_t SGN : 1;
  uint8_t RES8 : 1;
  uint8_t DJM : 1;
  uint8_t ATDPU : 1;
} ATDC_t;

#define ATDC HC08_REGISTER(uint8_t,ATDC_Addr)

#define ATDC_Bits HC08_REGISTER(ATDC_t,ATDC_Addr)

#define ATDC_ATDPU ATDC_Bits.ATDPU
#define ATDC_DJM ATDC_Bits.DJM
#define ATDC_RES8 ATDC_Bits.RES8
#define ATDC_SGN ATDC_Bits.SGN
#define ATDC_PRS ATDC_Bits.PRS


enum { ATDSC_Addr = 0x51 };

typedef struct
{
  uint8_t ATDCH : 5;
  uint8_t ATDCO : 1;
  uint8_t ATDIE : 1;
  uint8_t CCF : 1;
} ATDSC_t;

#define ATDSC HC08_REGISTER(uint8_t,ATDSC_Addr)

#define ATDSC_Bits HC08_REGISTER(ATDSC_t,ATDSC_Addr)

#define ATDSC_CCF ATDSC_Bits.CCF
#define ATDSC_ATDIE ATDSC_Bits.ATDIE
#define ATDSC_ATDCO ATDSC_Bits.ATDCO
#define ATDSC_ATDCH ATDSC_Bits.ATDCH


enum { ATDRH_Addr = 0x52 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} ATDRH_t;

#define ATDR HC08_REGISTER(uint16_t,ATDRH_Addr)
#define ATDRH HC08_REGISTER(uint8_t,ATDRH_Addr)

#define ATDRH_Bits HC08_REGISTER(ATDRH_t,ATDRH_Addr)



enum { ATDRL_Addr = 0x53 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} ATDRL_t;

#define ATDRL HC08_REGISTER(uint8_t,ATDRL_Addr)

#define ATDRL_Bits HC08_REGISTER(ATDRL_t,ATDRL_Addr)



enum { ATDPE_Addr = 0x54 };

typedef struct
{
  uint8_t ATDPE0 : 1;
  uint8_t ATDPE1 : 1;
  uint8_t ATDPE2 : 1;
  uint8_t ATDPE3 : 1;
  uint8_t ATDPE4 : 1;
  uint8_t ATDPE5 : 1;
  uint8_t ATDPE6 : 1;
  uint8_t ATDPE7 : 1;
} ATDPE_t;

#define ATDPE HC08_REGISTER(uint8_t,ATDPE_Addr)

#define ATDPE_Bits HC08_REGISTER(ATDPE_t,ATDPE_Addr)

#define ATDPE_ATDPE7 ATDPE_Bits.ATDPE7
#define ATDPE_ATDPE6 ATDPE_Bits.ATDPE6
#define ATDPE_ATDPE5 ATDPE_Bits.ATDPE5
#define ATDPE_ATDPE4 ATDPE_Bits.ATDPE4
#define ATDPE_ATDPE3 ATDPE_Bits.ATDPE3
#define ATDPE_ATDPE2 ATDPE_Bits.ATDPE2
#define ATDPE_ATDPE1 ATDPE_Bits.ATDPE1
#define ATDPE_ATDPE0 ATDPE_Bits.ATDPE0


enum { IICA_Addr = 0x58 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t ADDR : 7;
} IICA_t;

#define IICA HC08_REGISTER(uint8_t,IICA_Addr)

#define IICA_Bits HC08_REGISTER(IICA_t,IICA_Addr)

#define IICA_ADDR IICA_Bits.ADDR


enum { IICF_Addr = 0x59 };

typedef struct
{
  uint8_t ICR : 6;
  uint8_t MULT : 2;
} IICF_t;

#define IICF HC08_REGISTER(uint8_t,IICF_Addr)

#define IICF_Bits HC08_REGISTER(IICF_t,IICF_Addr)

#define IICF_MULT IICF_Bits.MULT
#define IICF_ICR IICF_Bits.ICR


enum { IICC_Addr = 0x5A };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t RSTA : 1;
  uint8_t TXAK : 1;
  uint8_t TX : 1;
  uint8_t MST : 1;
  uint8_t IICIE : 1;
  uint8_t IICEN : 1;
} IICC_t;

#define IICC HC08_REGISTER(uint8_t,IICC_Addr)

#define IICC_Bits HC08_REGISTER(IICC_t,IICC_Addr)

#define IICC_IICEN IICC_Bits.IICEN
#define IICC_IICIE IICC_Bits.IICIE
#define IICC_MST IICC_Bits.MST
#define IICC_TX IICC_Bits.TX
#define IICC_TXAK IICC_Bits.TXAK
#define IICC_RSTA IICC_Bits.RSTA


enum { IICS_Addr = 0x5B };

typedef struct
{
  uint8_t RXAK : 1;
  uint8_t IICIF : 1;
  uint8_t SRW : 1;
  uint8_t bit3 : 1;
  uint8_t ARBL : 1;
  uint8_t BUSY : 1;
  uint8_t IAAS : 1;
  uint8_t TCF : 1;
} IICS_t;

#define IICS HC08_REGISTER(uint8_t,IICS_Addr)

#define IICS_Bits HC08_REGISTER(IICS_t,IICS_Addr)

#define IICS_TCF IICS_Bits.TCF
#define IICS_IAAS IICS_Bits.IAAS
#define IICS_BUSY IICS_Bits.BUSY
#define IICS_ARBL IICS_Bits.ARBL
#define IICS_SRW IICS_Bits.SRW
#define IICS_IICIF IICS_Bits.IICIF
#define IICS_RXAK IICS_Bits.RXAK


enum { IICD_Addr = 0x5C };

typedef struct
{
  uint8_t DATA : 8;
} IICD_t;

#define IICD HC08_REGISTER(uint8_t,IICD_Addr)

#define IICD_Bits HC08_REGISTER(IICD_t,IICD_Addr)

#define IICD_DATA IICD_Bits.DATA


enum { TPM2SC_Addr = 0x60 };

typedef struct
{
  uint8_t PS0 : 1;
  uint8_t PS1 : 1;
  uint8_t PS2 : 1;
  uint8_t CLKSA : 1;
  uint8_t CLKSB : 1;
  uint8_t CPWMS : 1;
  uint8_t TOIE : 1;
  uint8_t TOF : 1;
} TPM2SC_t;

#define TPM2SC HC08_REGISTER(uint8_t,TPM2SC_Addr)

#define TPM2SC_Bits HC08_REGISTER(TPM2SC_t,TPM2SC_Addr)

#define TPM2SC_TOF TPM2SC_Bits.TOF
#define TPM2SC_TOIE TPM2SC_Bits.TOIE
#define TPM2SC_CPWMS TPM2SC_Bits.CPWMS
#define TPM2SC_CLKSB TPM2SC_Bits.CLKSB
#define TPM2SC_CLKSA TPM2SC_Bits.CLKSA
#define TPM2SC_PS2 TPM2SC_Bits.PS2
#define TPM2SC_PS1 TPM2SC_Bits.PS1
#define TPM2SC_PS0 TPM2SC_Bits.PS0


enum { TPM2CNTH_Addr = 0x61 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM2CNTH_t;

#define TPM2CNT HC08_REGISTER(uint16_t,TPM2CNTH_Addr)
#define TPM2CNTH HC08_REGISTER(uint8_t,TPM2CNTH_Addr)

#define TPM2CNTH_Bits HC08_REGISTER(TPM2CNTH_t,TPM2CNTH_Addr)



enum { TPM2CNTL_Addr = 0x62 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM2CNTL_t;

#define TPM2CNTL HC08_REGISTER(uint8_t,TPM2CNTL_Addr)

#define TPM2CNTL_Bits HC08_REGISTER(TPM2CNTL_t,TPM2CNTL_Addr)



enum { TPM2MODH_Addr = 0x63 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM2MODH_t;

#define TPM2MOD HC08_REGISTER(uint16_t,TPM2MODH_Addr)
#define TPM2MODH HC08_REGISTER(uint8_t,TPM2MODH_Addr)

#define TPM2MODH_Bits HC08_REGISTER(TPM2MODH_t,TPM2MODH_Addr)



enum { TPM2MODL_Addr = 0x64 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM2MODL_t;

#define TPM2MODL HC08_REGISTER(uint8_t,TPM2MODL_Addr)

#define TPM2MODL_Bits HC08_REGISTER(TPM2MODL_t,TPM2MODL_Addr)



enum { TPM2C0SC_Addr = 0x65 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t ELS0A : 1;
  uint8_t ELS0B : 1;
  uint8_t MS0A : 1;
  uint8_t MS0B : 1;
  uint8_t CH0IE : 1;
  uint8_t CH0F : 1;
} TPM2C0SC_t;

#define TPM2C0SC HC08_REGISTER(uint8_t,TPM2C0SC_Addr)

#define TPM2C0SC_Bits HC08_REGISTER(TPM2C0SC_t,TPM2C0SC_Addr)

#define TPM2C0SC_CH0F TPM2C0SC_Bits.CH0F
#define TPM2C0SC_CH0IE TPM2C0SC_Bits.CH0IE
#define TPM2C0SC_MS0B TPM2C0SC_Bits.MS0B
#define TPM2C0SC_MS0A TPM2C0SC_Bits.MS0A
#define TPM2C0SC_ELS0B TPM2C0SC_Bits.ELS0B
#define TPM2C0SC_ELS0A TPM2C0SC_Bits.ELS0A


enum { TPM2C0VH_Addr = 0x66 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM2C0VH_t;

#define TPM2C0V HC08_REGISTER(uint16_t,TPM2C0VH_Addr)
#define TPM2C0VH HC08_REGISTER(uint8_t,TPM2C0VH_Addr)

#define TPM2C0VH_Bits HC08_REGISTER(TPM2C0VH_t,TPM2C0VH_Addr)



enum { TPM2C0VL_Addr = 0x67 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM2C0VL_t;

#define TPM2C0VL HC08_REGISTER(uint8_t,TPM2C0VL_Addr)

#define TPM2C0VL_Bits HC08_REGISTER(TPM2C0VL_t,TPM2C0VL_Addr)



enum { TPM2C1SC_Addr = 0x68 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t ELS1A : 1;
  uint8_t ELS1B : 1;
  uint8_t MS1A : 1;
  uint8_t MS1B : 1;
  uint8_t CH1IE : 1;
  uint8_t CH1F : 1;
} TPM2C1SC_t;

#define TPM2C1SC HC08_REGISTER(uint8_t,TPM2C1SC_Addr)

#define TPM2C1SC_Bits HC08_REGISTER(TPM2C1SC_t,TPM2C1SC_Addr)

#define TPM2C1SC_CH1F TPM2C1SC_Bits.CH1F
#define TPM2C1SC_CH1IE TPM2C1SC_Bits.CH1IE
#define TPM2C1SC_MS1B TPM2C1SC_Bits.MS1B
#define TPM2C1SC_MS1A TPM2C1SC_Bits.MS1A
#define TPM2C1SC_ELS1B TPM2C1SC_Bits.ELS1B
#define TPM2C1SC_ELS1A TPM2C1SC_Bits.ELS1A


enum { TPM2C1VH_Addr = 0x69 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM2C1VH_t;

#define TPM2C1V HC08_REGISTER(uint16_t,TPM2C1VH_Addr)
#define TPM2C1VH HC08_REGISTER(uint8_t,TPM2C1VH_Addr)

#define TPM2C1VH_Bits HC08_REGISTER(TPM2C1VH_t,TPM2C1VH_Addr)



enum { TPM2C1VL_Addr = 0x6A };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM2C1VL_t;

#define TPM2C1VL HC08_REGISTER(uint8_t,TPM2C1VL_Addr)

#define TPM2C1VL_Bits HC08_REGISTER(TPM2C1VL_t,TPM2C1VL_Addr)



enum { TPM2C2SC_Addr = 0x6B };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t ELS2A : 1;
  uint8_t ELS2B : 1;
  uint8_t MS2A : 1;
  uint8_t MS2B : 1;
  uint8_t CH2IE : 1;
  uint8_t CH2F : 1;
} TPM2C2SC_t;

#define TPM2C2SC HC08_REGISTER(uint8_t,TPM2C2SC_Addr)

#define TPM2C2SC_Bits HC08_REGISTER(TPM2C2SC_t,TPM2C2SC_Addr)

#define TPM2C2SC_CH2F TPM2C2SC_Bits.CH2F
#define TPM2C2SC_CH2IE TPM2C2SC_Bits.CH2IE
#define TPM2C2SC_MS2B TPM2C2SC_Bits.MS2B
#define TPM2C2SC_MS2A TPM2C2SC_Bits.MS2A
#define TPM2C2SC_ELS2B TPM2C2SC_Bits.ELS2B
#define TPM2C2SC_ELS2A TPM2C2SC_Bits.ELS2A


enum { TPM2C2VH_Addr = 0x6C };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM2C2VH_t;

#define TPM2C2V HC08_REGISTER(uint16_t,TPM2C2VH_Addr)
#define TPM2C2VH HC08_REGISTER(uint8_t,TPM2C2VH_Addr)

#define TPM2C2VH_Bits HC08_REGISTER(TPM2C2VH_t,TPM2C2VH_Addr)



enum { TPM2C2VL_Addr = 0x6D };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM2C2VL_t;

#define TPM2C2VL HC08_REGISTER(uint8_t,TPM2C2VL_Addr)

#define TPM2C2VL_Bits HC08_REGISTER(TPM2C2VL_t,TPM2C2VL_Addr)



enum { TPM2C3SC_Addr = 0x6E };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t ELS3A : 1;
  uint8_t ELS3B : 1;
  uint8_t MS3A : 1;
  uint8_t MS3B : 1;
  uint8_t CH3IE : 1;
  uint8_t CH3F : 1;
} TPM2C3SC_t;

#define TPM2C3SC HC08_REGISTER(uint8_t,TPM2C3SC_Addr)

#define TPM2C3SC_Bits HC08_REGISTER(TPM2C3SC_t,TPM2C3SC_Addr)

#define TPM2C3SC_CH3F TPM2C3SC_Bits.CH3F
#define TPM2C3SC_CH3IE TPM2C3SC_Bits.CH3IE
#define TPM2C3SC_MS3B TPM2C3SC_Bits.MS3B
#define TPM2C3SC_MS3A TPM2C3SC_Bits.MS3A
#define TPM2C3SC_ELS3B TPM2C3SC_Bits.ELS3B
#define TPM2C3SC_ELS3A TPM2C3SC_Bits.ELS3A


enum { TPM2C3VH_Addr = 0x6F };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM2C3VH_t;

#define TPM2C3V HC08_REGISTER(uint16_t,TPM2C3VH_Addr)
#define TPM2C3VH HC08_REGISTER(uint8_t,TPM2C3VH_Addr)

#define TPM2C3VH_Bits HC08_REGISTER(TPM2C3VH_t,TPM2C3VH_Addr)



enum { TPM2C3VL_Addr = 0x70 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM2C3VL_t;

#define TPM2C3VL HC08_REGISTER(uint8_t,TPM2C3VL_Addr)

#define TPM2C3VL_Bits HC08_REGISTER(TPM2C3VL_t,TPM2C3VL_Addr)



enum { TPM2C4SC_Addr = 0x71 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t ELS4A : 1;
  uint8_t ELS4B : 1;
  uint8_t MS4A : 1;
  uint8_t MS4B : 1;
  uint8_t CH4IE : 1;
  uint8_t CH4F : 1;
} TPM2C4SC_t;

#define TPM2C4SC HC08_REGISTER(uint8_t,TPM2C4SC_Addr)

#define TPM2C4SC_Bits HC08_REGISTER(TPM2C4SC_t,TPM2C4SC_Addr)

#define TPM2C4SC_CH4F TPM2C4SC_Bits.CH4F
#define TPM2C4SC_CH4IE TPM2C4SC_Bits.CH4IE
#define TPM2C4SC_MS4B TPM2C4SC_Bits.MS4B
#define TPM2C4SC_MS4A TPM2C4SC_Bits.MS4A
#define TPM2C4SC_ELS4B TPM2C4SC_Bits.ELS4B
#define TPM2C4SC_ELS4A TPM2C4SC_Bits.ELS4A


enum { TPM2C4VH_Addr = 0x72 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} TPM2C4VH_t;

#define TPM2C4V HC08_REGISTER(uint16_t,TPM2C4VH_Addr)
#define TPM2C4VH HC08_REGISTER(uint8_t,TPM2C4VH_Addr)

#define TPM2C4VH_Bits HC08_REGISTER(TPM2C4VH_t,TPM2C4VH_Addr)



enum { TPM2C4VL_Addr = 0x73 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} TPM2C4VL_t;

#define TPM2C4VL HC08_REGISTER(uint8_t,TPM2C4VL_Addr)

#define TPM2C4VL_Bits HC08_REGISTER(TPM2C4VL_t,TPM2C4VL_Addr)



enum { SRS_Addr = 0x1800 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t LVD : 1;
  uint8_t ICG : 1;
  uint8_t bit3 : 1;
  uint8_t ILOP : 1;
  uint8_t COP : 1;
  uint8_t PIN : 1;
  uint8_t POR : 1;
} SRS_t;

#define SRS HC08_REGISTER(uint8_t,SRS_Addr)

#define SRS_Bits HC08_REGISTER(SRS_t,SRS_Addr)

#define SRS_POR SRS_Bits.POR
#define SRS_PIN SRS_Bits.PIN
#define SRS_COP SRS_Bits.COP
#define SRS_ILOP SRS_Bits.ILOP
#define SRS_ICG SRS_Bits.ICG
#define SRS_LVD SRS_Bits.LVD


enum { SBDFR_Addr = 0x1801 };

typedef struct
{
  uint8_t BDFR : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} SBDFR_t;

#define SBDFR HC08_REGISTER(uint8_t,SBDFR_Addr)

#define SBDFR_Bits HC08_REGISTER(SBDFR_t,SBDFR_Addr)

#define SBDFR_BDFR SBDFR_Bits.BDFR


enum { SOPT_Addr = 0x1802 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t BKGDPE : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t STOPE : 1;
  uint8_t COPT : 1;
  uint8_t COPE : 1;
} SOPT_t;

#define SOPT HC08_REGISTER(uint8_t,SOPT_Addr)

#define SOPT_Bits HC08_REGISTER(SOPT_t,SOPT_Addr)

#define SOPT_COPE SOPT_Bits.COPE
#define SOPT_COPT SOPT_Bits.COPT
#define SOPT_STOPE SOPT_Bits.STOPE
#define SOPT_BKGDPE SOPT_Bits.BKGDPE


enum { SDIDH_Addr = 0x1806 };

typedef struct
{
  uint8_t ID8 : 1;
  uint8_t ID9 : 1;
  uint8_t ID10 : 1;
  uint8_t ID11 : 1;
  uint8_t REV0 : 1;
  uint8_t REV1 : 1;
  uint8_t REV2 : 1;
  uint8_t REV3 : 1;
} SDIDH_t;

#define SDID HC08_REGISTER(uint16_t,SDIDH_Addr)
#define SDIDH HC08_REGISTER(uint8_t,SDIDH_Addr)

#define SDIDH_Bits HC08_REGISTER(SDIDH_t,SDIDH_Addr)

#define SDIDH_REV3 SDIDH_Bits.REV3
#define SDIDH_REV2 SDIDH_Bits.REV2
#define SDIDH_REV1 SDIDH_Bits.REV1
#define SDIDH_REV0 SDIDH_Bits.REV0
#define SDIDH_ID11 SDIDH_Bits.ID11
#define SDIDH_ID10 SDIDH_Bits.ID10
#define SDIDH_ID9 SDIDH_Bits.ID9
#define SDIDH_ID8 SDIDH_Bits.ID8


enum { SDIDL_Addr = 0x1807 };

typedef struct
{
  uint8_t ID0 : 1;
  uint8_t ID1 : 1;
  uint8_t ID2 : 1;
  uint8_t ID3 : 1;
  uint8_t ID4 : 1;
  uint8_t ID5 : 1;
  uint8_t ID6 : 1;
  uint8_t ID7 : 1;
} SDIDL_t;

#define SDIDL HC08_REGISTER(uint8_t,SDIDL_Addr)

#define SDIDL_Bits HC08_REGISTER(SDIDL_t,SDIDL_Addr)

#define SDIDL_ID7 SDIDL_Bits.ID7
#define SDIDL_ID6 SDIDL_Bits.ID6
#define SDIDL_ID5 SDIDL_Bits.ID5
#define SDIDL_ID4 SDIDL_Bits.ID4
#define SDIDL_ID3 SDIDL_Bits.ID3
#define SDIDL_ID2 SDIDL_Bits.ID2
#define SDIDL_ID1 SDIDL_Bits.ID1
#define SDIDL_ID0 SDIDL_Bits.ID0


enum { SRTISC_Addr = 0x1808 };

typedef struct
{
  uint8_t RTIS0 : 1;
  uint8_t RTIS1 : 1;
  uint8_t RTIS2 : 1;
  uint8_t bit3 : 1;
  uint8_t RTIE : 1;
  uint8_t RTICLKS : 1;
  uint8_t RTIACK : 1;
  uint8_t RTIF : 1;
} SRTISC_t;

#define SRTISC HC08_REGISTER(uint8_t,SRTISC_Addr)

#define SRTISC_Bits HC08_REGISTER(SRTISC_t,SRTISC_Addr)

#define SRTISC_RTIF SRTISC_Bits.RTIF
#define SRTISC_RTIACK SRTISC_Bits.RTIACK
#define SRTISC_RTICLKS SRTISC_Bits.RTICLKS
#define SRTISC_RTIE SRTISC_Bits.RTIE
#define SRTISC_RTIS2 SRTISC_Bits.RTIS2
#define SRTISC_RTIS1 SRTISC_Bits.RTIS1
#define SRTISC_RTIS0 SRTISC_Bits.RTIS0


enum { SPMSC1_Addr = 0x1809 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t LVDE : 1;
  uint8_t LVDSE : 1;
  uint8_t LVDRE : 1;
  uint8_t LVDIE : 1;
  uint8_t LVDACK : 1;
  uint8_t LVDF : 1;
} SPMSC1_t;

#define SPMSC1 HC08_REGISTER(uint8_t,SPMSC1_Addr)

#define SPMSC1_Bits HC08_REGISTER(SPMSC1_t,SPMSC1_Addr)

#define SPMSC1_LVDF SPMSC1_Bits.LVDF
#define SPMSC1_LVDACK SPMSC1_Bits.LVDACK
#define SPMSC1_LVDIE SPMSC1_Bits.LVDIE
#define SPMSC1_LVDRE SPMSC1_Bits.LVDRE
#define SPMSC1_LVDSE SPMSC1_Bits.LVDSE
#define SPMSC1_LVDE SPMSC1_Bits.LVDE


enum { SPMSC2_Addr = 0x180A };

typedef struct
{
  uint8_t PPDC : 1;
  uint8_t PDC : 1;
  uint8_t PPDACK : 1;
  uint8_t PPDF : 1;
  uint8_t LVWV : 1;
  uint8_t LVDV : 1;
  uint8_t LVWACK : 1;
  uint8_t LVWF : 1;
} SPMSC2_t;

#define SPMSC2 HC08_REGISTER(uint8_t,SPMSC2_Addr)

#define SPMSC2_Bits HC08_REGISTER(SPMSC2_t,SPMSC2_Addr)

#define SPMSC2_LVWF SPMSC2_Bits.LVWF
#define SPMSC2_LVWACK SPMSC2_Bits.LVWACK
#define SPMSC2_LVDV SPMSC2_Bits.LVDV
#define SPMSC2_LVWV SPMSC2_Bits.LVWV
#define SPMSC2_PPDF SPMSC2_Bits.PPDF
#define SPMSC2_PPDACK SPMSC2_Bits.PPDACK
#define SPMSC2_PDC SPMSC2_Bits.PDC
#define SPMSC2_PPDC SPMSC2_Bits.PPDC


enum { DBGCAH_Addr = 0x1810 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} DBGCAH_t;

#define DBGCA HC08_REGISTER(uint16_t,DBGCAH_Addr)
#define DBGCAH HC08_REGISTER(uint8_t,DBGCAH_Addr)

#define DBGCAH_Bits HC08_REGISTER(DBGCAH_t,DBGCAH_Addr)



enum { DBGCAL_Addr = 0x1811 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} DBGCAL_t;

#define DBGCAL HC08_REGISTER(uint8_t,DBGCAL_Addr)

#define DBGCAL_Bits HC08_REGISTER(DBGCAL_t,DBGCAL_Addr)



enum { DBGCBH_Addr = 0x1812 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} DBGCBH_t;

#define DBGCB HC08_REGISTER(uint16_t,DBGCBH_Addr)
#define DBGCBH HC08_REGISTER(uint8_t,DBGCBH_Addr)

#define DBGCBH_Bits HC08_REGISTER(DBGCBH_t,DBGCBH_Addr)



enum { DBGCBL_Addr = 0x1813 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} DBGCBL_t;

#define DBGCBL HC08_REGISTER(uint8_t,DBGCBL_Addr)

#define DBGCBL_Bits HC08_REGISTER(DBGCBL_t,DBGCBL_Addr)



enum { DBGFH_Addr = 0x1814 };

typedef struct
{
  uint8_t bit8 : 1;
  uint8_t bit9 : 1;
  uint8_t bit10 : 1;
  uint8_t bit11 : 1;
  uint8_t bit12 : 1;
  uint8_t bit13 : 1;
  uint8_t bit14 : 1;
  uint8_t bit15 : 1;
} DBGFH_t;

#define DBGF HC08_REGISTER(uint16_t,DBGFH_Addr)
#define DBGFH HC08_REGISTER(uint8_t,DBGFH_Addr)

#define DBGFH_Bits HC08_REGISTER(DBGFH_t,DBGFH_Addr)



enum { DBGFL_Addr = 0x1815 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} DBGFL_t;

#define DBGFL HC08_REGISTER(uint8_t,DBGFL_Addr)

#define DBGFL_Bits HC08_REGISTER(DBGFL_t,DBGFL_Addr)



enum { DBGC_Addr = 0x1816 };

typedef struct
{
  uint8_t RWBEN : 1;
  uint8_t RWB : 1;
  uint8_t RWAEN : 1;
  uint8_t RWA : 1;
  uint8_t BRKEN : 1;
  uint8_t TAG : 1;
  uint8_t ARM : 1;
  uint8_t DBGEN : 1;
} DBGC_t;

#define DBGC HC08_REGISTER(uint8_t,DBGC_Addr)

#define DBGC_Bits HC08_REGISTER(DBGC_t,DBGC_Addr)

#define DBGC_DBGEN DBGC_Bits.DBGEN
#define DBGC_ARM DBGC_Bits.ARM
#define DBGC_TAG DBGC_Bits.TAG
#define DBGC_BRKEN DBGC_Bits.BRKEN
#define DBGC_RWA DBGC_Bits.RWA
#define DBGC_RWAEN DBGC_Bits.RWAEN
#define DBGC_RWB DBGC_Bits.RWB
#define DBGC_RWBEN DBGC_Bits.RWBEN


enum { DBGT_Addr = 0x1817 };

typedef struct
{
  uint8_t TRG0 : 1;
  uint8_t TRG1 : 1;
  uint8_t TRG2 : 1;
  uint8_t TRG3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t BEGIN : 1;
  uint8_t TRGSEL : 1;
} DBGT_t;

#define DBGT HC08_REGISTER(uint8_t,DBGT_Addr)

#define DBGT_Bits HC08_REGISTER(DBGT_t,DBGT_Addr)

#define DBGT_TRGSEL DBGT_Bits.TRGSEL
#define DBGT_BEGIN DBGT_Bits.BEGIN
#define DBGT_TRG3 DBGT_Bits.TRG3
#define DBGT_TRG2 DBGT_Bits.TRG2
#define DBGT_TRG1 DBGT_Bits.TRG1
#define DBGT_TRG0 DBGT_Bits.TRG0


enum { DBGS_Addr = 0x1818 };

typedef struct
{
  uint8_t CNT0 : 1;
  uint8_t CNT1 : 1;
  uint8_t CNT2 : 1;
  uint8_t CNT3 : 1;
  uint8_t bit4 : 1;
  uint8_t ARMF : 1;
  uint8_t BF : 1;
  uint8_t AF : 1;
} DBGS_t;

#define DBGS HC08_REGISTER(uint8_t,DBGS_Addr)

#define DBGS_Bits HC08_REGISTER(DBGS_t,DBGS_Addr)

#define DBGS_AF DBGS_Bits.AF
#define DBGS_BF DBGS_Bits.BF
#define DBGS_ARMF DBGS_Bits.ARMF
#define DBGS_CNT3 DBGS_Bits.CNT3
#define DBGS_CNT2 DBGS_Bits.CNT2
#define DBGS_CNT1 DBGS_Bits.CNT1
#define DBGS_CNT0 DBGS_Bits.CNT0


enum { FCDIV_Addr = 0x1820 };

typedef struct
{
  uint8_t DIV0 : 1;
  uint8_t DIV1 : 1;
  uint8_t DIV2 : 1;
  uint8_t DIV3 : 1;
  uint8_t DIV4 : 1;
  uint8_t DIV5 : 1;
  uint8_t PRDIV8 : 1;
  uint8_t DIVLD : 1;
} FCDIV_t;

#define FCDIV HC08_REGISTER(uint8_t,FCDIV_Addr)

#define FCDIV_Bits HC08_REGISTER(FCDIV_t,FCDIV_Addr)

#define FCDIV_DIVLD FCDIV_Bits.DIVLD
#define FCDIV_PRDIV8 FCDIV_Bits.PRDIV8
#define FCDIV_DIV5 FCDIV_Bits.DIV5
#define FCDIV_DIV4 FCDIV_Bits.DIV4
#define FCDIV_DIV3 FCDIV_Bits.DIV3
#define FCDIV_DIV2 FCDIV_Bits.DIV2
#define FCDIV_DIV1 FCDIV_Bits.DIV1
#define FCDIV_DIV0 FCDIV_Bits.DIV0


enum { FOPT_Addr = 0x1821 };

typedef struct
{
  uint8_t SEC00 : 1;
  uint8_t SEC01 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t bit5 : 1;
  uint8_t FNORED : 1;
  uint8_t KEYEN : 1;
} FOPT_t;

#define FOPT HC08_REGISTER(uint8_t,FOPT_Addr)

#define FOPT_Bits HC08_REGISTER(FOPT_t,FOPT_Addr)

#define FOPT_KEYEN FOPT_Bits.KEYEN
#define FOPT_FNORED FOPT_Bits.FNORED
#define FOPT_SEC01 FOPT_Bits.SEC01
#define FOPT_SEC00 FOPT_Bits.SEC00


enum { FCNFG_Addr = 0x1823 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t bit3 : 1;
  uint8_t bit4 : 1;
  uint8_t KEYACC : 1;
  uint8_t bit6 : 1;
  uint8_t bit7 : 1;
} FCNFG_t;

#define FCNFG HC08_REGISTER(uint8_t,FCNFG_Addr)

#define FCNFG_Bits HC08_REGISTER(FCNFG_t,FCNFG_Addr)

#define FCNFG_KEYACC FCNFG_Bits.KEYACC


enum { FPROT_Addr = 0x1824 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t bit2 : 1;
  uint8_t FPS0 : 1;
  uint8_t FPS1 : 1;
  uint8_t FPS2 : 1;
  uint8_t FPDIS : 1;
  uint8_t FPOPEN : 1;
} FPROT_t;

#define FPROT HC08_REGISTER(uint8_t,FPROT_Addr)

#define FPROT_Bits HC08_REGISTER(FPROT_t,FPROT_Addr)

#define FPROT_FPOPEN FPROT_Bits.FPOPEN
#define FPROT_FPDIS FPROT_Bits.FPDIS
#define FPROT_FPS2 FPROT_Bits.FPS2
#define FPROT_FPS1 FPROT_Bits.FPS1
#define FPROT_FPS0 FPROT_Bits.FPS0


enum { FSTAT_Addr = 0x1825 };

typedef struct
{
  uint8_t bit0 : 1;
  uint8_t bit1 : 1;
  uint8_t FBLANK : 1;
  uint8_t bit3 : 1;
  uint8_t FACCERR : 1;
  uint8_t FPVIOL : 1;
  uint8_t FCCF : 1;
  uint8_t FCBEF : 1;
} FSTAT_t;

#define FSTAT HC08_REGISTER(uint8_t,FSTAT_Addr)

#define FSTAT_Bits HC08_REGISTER(FSTAT_t,FSTAT_Addr)

#define FSTAT_FCBEF FSTAT_Bits.FCBEF
#define FSTAT_FCCF FSTAT_Bits.FCCF
#define FSTAT_FPVIOL FSTAT_Bits.FPVIOL
#define FSTAT_FACCERR FSTAT_Bits.FACCERR
#define FSTAT_FBLANK FSTAT_Bits.FBLANK


enum { FCMD_Addr = 0x1826 };

typedef struct
{
  uint8_t FCMD0 : 1;
  uint8_t FCMD1 : 1;
  uint8_t FCMD2 : 1;
  uint8_t FCMD3 : 1;
  uint8_t FCMD4 : 1;
  uint8_t FCMD5 : 1;
  uint8_t FCMD6 : 1;
  uint8_t FCMD7 : 1;
} FCMD_t;

#define FCMD HC08_REGISTER(uint8_t,FCMD_Addr)

#define FCMD_Bits HC08_REGISTER(FCMD_t,FCMD_Addr)

#define FCMD_FCMD7 FCMD_Bits.FCMD7
#define FCMD_FCMD6 FCMD_Bits.FCMD6
#define FCMD_FCMD5 FCMD_Bits.FCMD5
#define FCMD_FCMD4 FCMD_Bits.FCMD4
#define FCMD_FCMD3 FCMD_Bits.FCMD3
#define FCMD_FCMD2 FCMD_Bits.FCMD2
#define FCMD_FCMD1 FCMD_Bits.FCMD1
#define FCMD_FCMD0 FCMD_Bits.FCMD0


#endif//_H_hcs08regs_h

