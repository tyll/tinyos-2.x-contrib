/* $Id$ */

/* @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

generic module At32uc3bUartStreamC
{
  provides interface UartStream;
  uses interface HplAt32uc3bUartStream as HplUartStream;
}
implementation
{
  async command error_t UartStream.send(uint8_t* buf, uint16_t len) { return call HplUartStream.send(buf, len); }
  async event void HplUartStream.sendDone(uint8_t* buf, uint16_t len, error_t error) { signal UartStream.sendDone(buf, len, error); }

  async command error_t UartStream.enableReceiveInterrupt() { return call HplUartStream.enableReceiveInterrupt(); }
  async command error_t UartStream.disableReceiveInterrupt() { return call HplUartStream.disableReceiveInterrupt(); }
  async event void HplUartStream.receivedByte(uint8_t byte) { signal UartStream.receivedByte(byte); }

  async command error_t UartStream.receive(uint8_t* buf, uint16_t len) { return call HplUartStream.receive(buf, len); }
  async event void HplUartStream.receiveDone(uint8_t* buf, uint16_t len, error_t error) { signal UartStream.receiveDone(buf, len, error); }
}
