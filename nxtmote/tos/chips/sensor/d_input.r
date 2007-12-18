//// d_input.r ////

#ifndef D_INPUT_R
#define D_INPUT_R

#define   MAX_AD_VALUE                  0x3FF

#define   INPUTInit                     {\
                                          UBYTE Tmp;\
                                          for (Tmp = 0; Tmp < NOS_OF_AVR_INPUTS; Tmp++)\
                                          {\
                                            IoFromAvr.AdValue[Tmp]  = MAX_AD_VALUE;\
                                          }\
                                          IoToAvr.InputPower = 0;\
                                          for (Tmp = 0; Tmp < NO_OF_INPUTS; Tmp++)\
                                          {\
                                            *AT91C_PIOA_PPUDR  = Digi0Alloc[Tmp];\
                                            *AT91C_PIOA_PPUDR  = Digi1Alloc[Tmp];\
                                            INPUTSetInDigi0(Tmp);\
                                            INPUTSetInDigi1(Tmp);\
                                          }\
                                        }

#define   INPUTGetVal(pValues, No)      *pValues  = (UWORD)IoFromAvr.AdValue[No];\
                                        *pValues &= 0x03FF

#define   INPUTSetActive(Input)         IoToAvr.InputPower |=  (0x01 << Input);\
                                        IoToAvr.InputPower &= ~(0x10 << Input)
#define   INPUTSet9v(Input)             IoToAvr.InputPower |=  (0x10 << Input);\
                                        IoToAvr.InputPower &= ~(0x01 << Input)
#define   INPUTSetInactive(Input)       IoToAvr.InputPower &= ~(0x11 << Input)

const     ULONG  Digi0Alloc[] =         {AT91C_PIO_PA23, AT91C_PIO_PA28, AT91C_PIO_PA29, AT91C_PIO_PA30};
const     ULONG  Digi1Alloc[] =         {AT91C_PIO_PA18, AT91C_PIO_PA19, AT91C_PIO_PA20, AT91C_PIO_PA2};

#define   INPUTSetOutDigi0(Input)       *AT91C_PIOA_PER  = Digi0Alloc[Input];\
                                        *AT91C_PIOA_OER  = Digi0Alloc[Input]

#define   INPUTSetOutDigi1(Input)       *AT91C_PIOA_PER  = Digi1Alloc[Input];\
                                        *AT91C_PIOA_OER  = Digi1Alloc[Input]


#define   INPUTSetInDigi0(Input)        *AT91C_PIOA_PER  = Digi0Alloc[Input];\
                                        *AT91C_PIOA_ODR  = Digi0Alloc[Input]

#define   INPUTSetInDigi1(Input)        *AT91C_PIOA_PER  = Digi1Alloc[Input];\
                                        *AT91C_PIOA_ODR  = Digi1Alloc[Input]

#define   INPUTSetDigi0(Input)          *AT91C_PIOA_SODR = Digi0Alloc[Input]

#define   INPUTSetDigi1(Input)          *AT91C_PIOA_SODR = Digi1Alloc[Input]

#define   INPUTClearDigi0(Input)        *AT91C_PIOA_CODR = Digi0Alloc[Input]

#define   INPUTClearDigi1(Input)        *AT91C_PIOA_CODR = Digi1Alloc[Input]

#define   INPUTReadDigi0(Input, Data)   if ((*AT91C_PIOA_PDSR) & Digi0Alloc[Input])\
                                        {\
                                          *Data |= 0x00000001;\
                                        }\
                                        else\
                                        {\
                                          *Data &= ~0x00000001;\
                                        }
#define   INPUTReadDigi1(Input, Data)   if ((*AT91C_PIOA_PDSR) & Digi1Alloc[Input])\
                                        {\
                                          *Data |= 0x00000002;\
                                        }\
                                        else\
                                        {\
                                          *Data &= ~0x00000002;\
                                        }

#define   INPUTExit                     {\
                                          UBYTE Tmp;\
                                          for (Tmp = 0; Tmp < NO_OF_INPUTS; Tmp++)\
                                          {\
                                            INPUTSetInDigi0(Tmp);\
                                            INPUTSetInDigi1(Tmp);\
                                          }\
                                        }

#endif
