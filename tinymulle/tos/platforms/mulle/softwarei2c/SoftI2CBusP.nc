/**
 * Mulle specific implementation of a software I2C bus.
 *
 * @author Gong Liang
 * @author Henrik Makitaavola
 */
module SoftI2CBusP
{
  provides interface SoftI2CBus as I2C;

  uses interface GeneralIO as I2CClk;
  uses interface GeneralIO as I2CData;
  uses interface GeneralIO as I2CCtrl;
}
implementation
{
  /***************************************************************************************/
  // Name:idle(), transition(),halfTransition()
  // I2C-bus can be transferred at rates of up to 100 kbit/s in the Standard-mode  
  // 10MHz main clock frequency
  // The Baud rate of IIC bus communication can be adjusted by altering the loop times.
  /***************************************************************************************/

  void idle(void)
  {
    volatile long int i;
    for(i=0;i<1000;i++)
    {
      asm("nop");
    }
  }

  void transition(void)
  {
    volatile int i;
    for(i=0;i<100;i++)
    {
      asm("nop");
    }
  }

  void halfTransition(void)
  {
    volatile int i;
    for(i=0;i<50;i++)
    {
      asm("nop");
    }
  }

  
  async command void I2C.init()
  {
    call I2CData.makeOutput(); 
    call I2CClk.makeOutput();
    call I2CCtrl.makeOutput();
    call I2CCtrl.set();
    call I2CData.set();  // drive bus high (default)
    call I2CClk.set();  // drive bus high (default)
  }

  async command void I2C.off()
  {
    // TODO(henrik): Exactly what should be set if I2C bus should be turned off?
    call I2CData.makeInput();
    call I2CClk.makeInput();
    call I2CCtrl.makeInput();
    call I2CCtrl.clr();
    call I2CClk.clr();
    call I2CData.clr();
  }

  async command void I2C.start()
  {
    atomic 
    {
      call I2CData.makeOutput();
      call I2CClk.clr();
      call I2CData.set();
      idle();
      call I2CClk.set();
      idle();
      call I2CData.clr();
      idle();
      call I2CClk.clr();
      idle();
    }
  }

  async command void I2C.stop()
  {
    atomic
    {
      call I2CData.makeOutput();

      call I2CData.set(); 
      call I2CClk.clr();
      idle();
      call I2CData.clr();
      idle();
      call I2CClk.set();
      idle();
      call I2CData.set();
      idle();
    }
  }

  async command void I2C.restart()
  {
    atomic
    {
      call I2CClk.clr();
      call I2CData.set();
      call I2CClk.set();
      idle();
      call I2CData.clr();
      idle();
      call I2CClk.clr();
    }
  }

  async command uint8_t I2C.readByte(bool ack)
  {
    uint8_t retChar;
    uint8_t bitCnt;

    atomic
    {
      call I2CData.makeInput();

      retChar = 0;
      
      for (bitCnt=0; bitCnt<8; ++bitCnt)
      {
        asm("nop");
        call I2CClk.clr();
        transition();

        call I2CClk.set();  // Validate the RevData on the SDA2 line
        halfTransition();
        retChar<<=1;        // Push each received bit toward MSB
        if(call I2CData.get() == 1) retChar+=1; //  Read the bit on SDA2 line
        halfTransition();
      }

      call I2CClk.clr();
      if (ack) call I2C.masterAck();
      else     call I2C.masterNack();
    }
    return retChar;
  }

  async command void I2C.writeByte(uint8_t byte)
  {
    uint8_t bitCnt;

    atomic
    {
      call I2CData.makeOutput();

      for (bitCnt=0; bitCnt<8; ++bitCnt)
      {
        if ((byte<<bitCnt) & 0x80)
        {
          call I2CData.set();  // MSB sending logic
        }
        else
        {
          call I2CData.clr();
        }
        transition();  // Use this function to adjust the baut rate of I2C bus

        call I2CClk.set(); //Set SCL2 high to inform slave of receiving sth.
        transition();      // Greater than 4¦Ìs
        call I2CClk.clr();
      }


      call I2CData.set();  // Release SDA2 for ACK-waiting after sending 8 bits  
      transition();

      call I2CClk.set(); 
      transition();
      call I2CClk.clr();

      // ...Check the ACK from the receiver....  

      //  if(SDA2==1){ACK=0;} /* ACK received£¿*/    
      //  else  ACK= 1;

      //  SCL2 = LOW;
      //  transition();
      idle(); 
    }
  }
  
  async command void I2C.masterAck()
  {
    atomic
    {
      call I2CClk.clr();
      call I2CData.clr(); // Low for ack
      transition();
      call I2CClk.set();
      transition();
      call I2CClk.clr();

      call I2CData.makeInput();
    }
  }

  async command void I2C.masterNack()
  {
    atomic 
    {
      call I2CClk.clr();

      call I2CData.set(); // High for nack
      transition();
      call I2CClk.set();
      transition();
      call I2CClk.clr();

      call I2CData.makeInput();
    }
  }
}
