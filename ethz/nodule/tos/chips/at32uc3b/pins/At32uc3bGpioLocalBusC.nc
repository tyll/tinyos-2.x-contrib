/* $Id$ */

/**
 * Implementation of the general-purpose I/O abstraction
 * for the Atmel AT32UC3B microcontroller.
 *
 * Mapping registers on the local bus allows cycle-deterministic
 * toggling of GPIO  pins since the CPU and GPIO are the only
 * modules connected to this bus. Also, since the local bus runs
 * at CPU speed, one write or read operation can be performed
 * per clock cycle to the local busmapped GPIO registers.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 * @see  Please refer to TEP 117 for more information about this component and its
 *          intended use.
 */

generic module At32uc3bGpioLocalBusC()
{
  provides interface GeneralIO;
  uses interface GeneralIO as HplGeneralIO;
}
implementation
{
  async command void GeneralIO.set() { call HplGeneralIO.set(); }
  async command void GeneralIO.clr() { call HplGeneralIO.clr(); }
  async command void GeneralIO.toggle() { call HplGeneralIO.toggle(); }
  async command bool GeneralIO.get() { return call HplGeneralIO.get(); }
  async command void GeneralIO.makeInput() { call HplGeneralIO.makeInput(); }
  async command bool GeneralIO.isInput() { return call HplGeneralIO.isInput(); }
  async command void GeneralIO.makeOutput() { call HplGeneralIO.makeOutput(); }
  async command bool GeneralIO.isOutput() { return call HplGeneralIO.isOutput(); }
}
