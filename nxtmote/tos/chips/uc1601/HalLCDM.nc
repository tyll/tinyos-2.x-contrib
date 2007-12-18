/**
 * Display module.
 * @author Rasmus Ulslev Pedersen
 */

#include "LCD.h"

module HalLCDM {
  provides {
    interface HalLCD;
    interface Init;
  }
  
  uses {
    interface HplUC1601LCD as HplLCD;
  }
}

implementation {

  command error_t Init.init() {
	  error_t error = SUCCESS;
	  
	  call HplLCD.initLCD();
	  
	  return error;
  }
  
  error_t dispStr(uint8_t* str, uint8_t line, uint8_t fast) {
    error_t status;

		UBYTE   *pSource;
		UBYTE   *pDestination;
		UBYTE   FontWidth;
		UBYTE   Line;
		UBYTE   Items;
		UBYTE   Item;
		FONT*   pFont;
		uint8_t max, cnt;

    max = DISPLINELENGTH;
    cnt = 0;

		pFont = (FONT*)&Font;
		
		//Clear line data
		memset(txbuf1,0x00,sizeof(txbuf1));
    
		Line         = line;
		Items        = pFont->ItemsX * pFont->ItemsY;
		pDestination = (UBYTE*)&txbuf1[0];
		while (*str && ++cnt<DISPLINELENGTH)
		{
			Item           = *str - ' ';
			if (Item < Items)
			{
				FontWidth    = pFont->ItemPixelsX;
				pSource      = (UBYTE*)&pFont->Data[Item * FontWidth];
				while (FontWidth--)
				{
					*pDestination = *pSource;
					pDestination++;
					pSource++;
				}
			}
			str++;
		}
	  
	  if(fast == 1) {
		  status = call HplLCD.writefast(txbuf1, sizeof(txbuf1), line);
		}
		else {
		  status = call HplLCD.write(txbuf1, sizeof(txbuf1), line);
		}
  
    return status;
  }

  command error_t HalLCD.displayStringFast(uint8_t* str, uint8_t line){
  
    return dispStr(str, line, 1);
  }

  
  command error_t HalLCD.displayString(uint8_t* str, uint8_t line){
  
    return dispStr(str, line, 0);
  }
}
