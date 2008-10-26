/**
 * PlatformSerialC
 * The purpose of this configuration is to fake a UartStream interface using
 * SerialByteComm. 
 *
 * It is unclear which is /the/ TinyOS serial interface,
 * SerialByteComm is covered by TEP113, while UartStream is covered by
 * TEP117. TEP117 does not specify a configuration that provides the
 * interface. On the otherhand TEP117 states that the platform must
 * provide SerialByteComm through UartC.
 *
 * There seems to be a consensus between current platforms to provice
 * a configuration of this name with at least two interface StdControl
 * and UartStream. Further it seems that StdControl handles enabling
 * or disabling the uart and updating the power state. This is /not/
 * faked and may fail horribly.
 *
 */

/**
 * @Author Martin Leopold <leopold@polaric.dk>
 */

configuration PlatformSerialC {
  provides interface StdControl;
  provides interface UartStream;
}
implementation {
  components new SerialByteCommToUartStreamC() as FakeUart;
  components UartC as RealUart;

  UartStream = FakeUart.UartStream;
  StdControl = RealUart.StdControl;
  RealUart.SerialByteComm <- FakeUart.SerialByteComm;
}

