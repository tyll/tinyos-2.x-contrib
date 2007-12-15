/* Copyright (c) 2005-2006 Arch Rock Corporation All rights reserved.
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * The Notify interface is intended for delivery of values from
 * self-triggered devices, at relatively low rates. For example, a
 * driver for a motion detector or a switch might provide this
 * interface. The type of the value is given as a template
 * argument. Generally, these values are backed by memory or
 * computation. Because no error code is included, both calls must be
 * guaranteed to succeed. This interface should be used when a single
 * logical unit supports both getting and setting.
 *
 * <p>
 * See TEP114 - SIDs: Source and Sink Independent Drivers for details.
 * 
 * @param val_t the type of the object that will be stored
 *
 * @author Gilman Tolle <gtolle@archrock.com>
 * @version $Revision$ $Date$
 */

interface NotifyBit<bool> {
  /**
   * Enables delivery of notifications from the device to the calling
   * generic client component.
   *
   * @return SUCCESS if notifications were enabled
   */
  command error_t enable();

  /**
   * Disables delivery of notifications from the device to the calling
   * generic client component.
   *
   * @return SUCCESS if notifications were disabled
   */
  command error_t disable();

  /**
   * Signals the arrival of a new value from the device.
   *
   * @param val the value arriving from the device
   */
  event void notify( bool val );
}
