/* This module writes a buffer to a byte-wide processor port.
 * The implementation is done for the Hydrowatch platform, to
 * communicate with the LabJack (www.labjack.com) module.
 * The Labjack is clocked by the mote, and logs a 16-bit sample
 * to a TCP socket on a host computer.
 * We use 8 bits for the log, and bit 2 of the other word for a 
 * framing bit.
 * FF xx indicates the beginning of a buffer
 * FD xx indicates that the byte is not the beginning of a buffer.
 * There is no length or any other overhead.
 * 
 * Connections:
 * MSP430 Port 5  : labjack port E
 * MSP430 Port 2.0: clock signal (capture on fall)
 * MSP430 Port 2.3: framing bit

 * The write interface is split phase, and will post a task for each
 * byte. It will return the buffer to the caller on writeDone.
 */


module PortWriterP {
    provides interface PortWriter;

    uses interface Boot;
    uses interface HplMsp430GeneralIO as FRAME;
    uses interface HplMsp430GeneralIO as CLOCK; 
    uses interface TaskQuanto as WriteBufferTask;
}
implementation {

  uint8_t *m_buf;
  uint16_t m_len;
  uint8_t m_busy;

  norace act_t act_quanto_log;
  
    
  event void Boot.booted()
  {
    // Set clock line and turn into output.
    call CLOCK.selectIOFunc();
    call CLOCK.set();
    call CLOCK.makeOutput();

    call FRAME.selectIOFunc();
    call FRAME.clr();
    call FRAME.makeOutput();

    // Configure Port P5 as a GPIO output.
    P5SEL = 0x00;  // Select I/O function for all pins.
    P5OUT = 0x00;  // Make the output low.
    P5DIR = 0xff;  // Make the port an output.

    atomic m_busy = FALSE;
   
    act_quanto_log = mk_act_local(ACT_TYPE_QUANTO_WRITER);
  }

  

  inline void writeByte(uint8_t* p) {
    //write a byte
    P5OUT = *p;
    // Setup time (was 6, added above check) 
    //nop();
    //nop();
    nop();
    nop();
    nop();
    nop();
    // Drive clk low
    call CLOCK.clr();
    // Wait a few cycles
    nop();
    nop();
    nop();
    nop();
    nop();
    nop();
    nop();
    nop();
    // Drive clk high
    call CLOCK.set();
    // Need about 55 cycles before the next byte.
    //nop();
  }

  //task void writeByteTask() {
  event void WriteBufferTask.runTask() {
    uint8_t* p;
    uint8_t* end;

    atomic {
        p = m_buf;
        end = m_buf + m_len;
    }

    call FRAME.set();
    writeByte(p++);
    call FRAME.clr();
    for (; p < end; p++) {
        writeByte(p);
    }
    atomic {
        m_busy = FALSE;
        p = m_buf;
    }
    signal PortWriter.writeDone(p, SUCCESS);
  }

  async command error_t PortWriter.write(uint8_t* buf, uint16_t len)
  {
    atomic {
    if (m_busy) 
      return EBUSY;
    if (!len)
      return EINVAL;

    m_buf = buf;
    m_len = len;
    m_busy = TRUE; 
    }
    //return post writeByteTask();
    return call WriteBufferTask.postTask(act_quanto_log);
  }
    
}

