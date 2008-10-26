/*
 * Copyright (c) 2006 Moteiv Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached MOTEIV-LICENSE     
 * file. If you do not find these files, copies can be found at
 * http://www.moteiv.com/MOTEIV-LICENSE.txt and by emailing info@moteiv.com.
 */

/**
 * Basic interface for handling button events.
 *
 * @author Joe Polastre, Moteiv Corporation <info@moteiv.com>
 */
interface Button {

  /**
   * Enable the button events.
   */
  async command void enable();
  /**
   * Disable button events.
   */
  async command void disable();

  /**
   * Notification that the button has been pressed.
   *
   * @param time the time that the button was pressed
   */
  async event void pressed(uint32_t time);

  /**
   * Notification that the button has been released.
   * 
   * @param time the time that the button was released
   */
  async event void released(uint32_t time);

}
