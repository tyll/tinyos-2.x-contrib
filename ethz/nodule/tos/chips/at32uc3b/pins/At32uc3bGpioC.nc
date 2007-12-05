/* $Id$ */

/**
 * Implementation of the general-purpose I/O abstraction
 * for the Atmel AT32UC3B microcontroller.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 * @see  Please refer to TEP 117 for more information about this component and its
 *          intended use.
 */

// MY: no hardware timestamping on AT32UC3B, emulate timestamping over SoftCaptureC component? Is this necessary?

generic module At32uc3bGpioC() {
  provides interface GeneralIO;
//  provides interface GpioInterrupt;
//  provides interface GpioCapture;
  uses interface HplAt32uc3bGeneralIO as HplGeneralIO;
//  uses interface HplAt32uc3bGpioInterrupt as HplGpioInterrupt;
//  uses interface HplAt32uc3bGpioCapture as HplGpioCapture;
}
implementation {
  async command void GeneralIO.set() { call HplGeneralIO.set(); }
  async command void GeneralIO.clr() { call HplGeneralIO.clr(); }
  async command void GeneralIO.toggle() { call HplGeneralIO.toggle(); }
  async command bool GeneralIO.get() { return call HplGeneralIO.get(); }
  async command void GeneralIO.makeInput() { call HplGeneralIO.makeInput(); }
  async command bool GeneralIO.isInput() { return call HplGeneralIO.isInput(); }
  async command void GeneralIO.makeOutput() { call HplGeneralIO.makeOutput(); }
  async command bool GeneralIO.isOutput() { return call HplGeneralIO.isOutput(); }

//  async command error_t GpioInterrupt.enableRisingEdge() { return call HplGpioInterrupt.enableRisingEdge(); }
//  async command bool GpioInterrupt.isRisingEdgeEnabled() { return call HplGpioInterrupt.isRisingEdgeEnabled(); }
//  async command error_t GpioInterrupt.enableFallingEdge() { return call HplGpioInterrupt.enableFallingEdge(); }
//  async command bool GpioInterrupt.isFallingEdgeEnabled() { return call HplGpioInterrupt.isFallingEdgeEnabled(); }
//  async command error_t GpioInterrupt.disable() { return call HplGpioInterrupt.disable(); }
//  async event void GpioInterrupt.fired() { call HplGpioInterrupt.fired(); }

//  async command error_t HplGpioCapture.enableRisingEdge() { return call HplGpioCapture.enableRisingEdge(); }
//  async command bool HplGpioCapture.isRisingEdgeEnabled() { return call HplGpioCapture.isRisingEdgeEnabled(); }
//  async command error_t HplGpioCapture.enableFallingEdge() { return call HplGpioCapture.enableFallingEdge(); }
//  async command bool HplGpioCapture.isFallingEdgeEnabled() { return call HplGpioCapture.isFallingEdgeEnabled(); }
//  async command error_t HplGpioCapture.disable() { return call HplGpioCapture.disable(); }
//  async event void HplGpioCapture.fired() { return call HplGpioCapture.fired(); }
}
