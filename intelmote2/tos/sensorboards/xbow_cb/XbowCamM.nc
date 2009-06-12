/*
 * Copyright (c) 2005 Yale University.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials provided
 *    with the distribution.
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgement:
 *       This product includes software developed by the Embedded Networks
 *       and Applications Lab (ENALAB) at Yale University.
 * 4. Neither the name of the University nor that of the Laboratory
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY YALE UNIVERSITY AND CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */

/**
 * @brief Camera Service Layer Module
 * @author Andrew Barton-Sweeney (abs@cs.yale.edu)
 * @author Thiago Teixeira
 *
 * Description
 * The camera module is a very basic module that utilizes the camera
 * interface to take a picture.
 */

 /**
 * Modified and ported to tinyos-2.x.
 *
 * @author Brano Kusy (branislav.kusy@gmail.com)
 * @version October 25, 2007
 */

/*
  Modified by RMK, Crossbow Technology
*/

#include "XbowCam.h"
#include "OV7670.h"

module XbowCamM
{
    provides interface Init;
    provides interface XbowCam;

    uses interface HplPXA27XQuickCaptInt as CIF;
    uses interface HplOV7670 as OV;

    uses interface Leds;
}
implementation
{
  // ======================= Data ==================================
  norace frame_t* currframe;
  norace window_t window_stat;
  //norace uint8_t* subSamp;

  void CIF_clear_frame(frame_t *frame) {
    uint32_t i;

    for (i=0; i < frame->size; i++) frame->buf[i] = 0;
  }

  command error_t Init.init() {

    // SET DEFAULT WINDOW
    window_stat.x = 0;
    window_stat.y = 0;
    window_stat.width = 640;
    window_stat.height = 480;
    call CIF.init(COLOR_UYVY);
    call OV.init(COLOR_UYVY, 0, SIZE_VGA); // COLOR_UYVY
    call CIF.setImageSize(window_stat.width, window_stat.height, (call OV.get_config())->color);
    // call XbowCam.set_window(&window_stat);
    return SUCCESS;
  }


  command error_t XbowCam.set_window(window_t *window) {
    uint8_t hstrt, hstop, vstrt, vstop;
    int val;
    window_t new_window;
    /*
    val = (2 * WINDOW_HMAX) - (2 * WINDOW_HZERO);
    //if (window->x > val) return -1;
    new_window.x = window->x;

    val = WINDOW_VMAX - WINDOW_VZERO;
    //if (window->y > val) return -1;
    new_window.y = window->y;

    val = (2 * WINDOW_HMAX) - (2 * WINDOW_HZERO) - (window->x) ;
    //if (window->width > val) return -1;
    if (window->width) new_window.width = window->width;

    val = WINDOW_VMAX-WINDOW_VZERO - (window->y);
    //if (window->height > val) return -1;
    if (window->height) new_window.height = window->height;

    //
    // HOW CAN WE ENSURE THE AREA OF THE WINDOW IS 16384 ???
    //

    hstrt = WINDOW_HZERO + new_window.x / 2;
    hstop = WINDOW_HZERO + (new_window.x + new_window.width) / 2;
    vstrt = WINDOW_VZERO + new_window.y;
    vstop = WINDOW_VZERO + new_window.y + new_window.height;

    //
    //  WE CANNOT CHANGE THE OV CAMERA WHILE CIF IS CAPTURING!!!!
    //

    window_stat.x = new_window.x;
    window_stat.y = new_window.y;
    window_stat.width = new_window.width;
    window_stat.height = new_window.height;
    // DO WE NEED A DELAY BEFORE NEXT CAPTURE ???

    call CIF.setImageSize(new_window.width, new_window.height, (call OV.get_config())->color);
    */

    call CIF.setImageSize(window->width, window->height, (call OV.get_config())->color);
    return SUCCESS;
    }

  command window_t *XbowCam.get_window() {

    return &window_stat;
  }

  void CIF_clear_header(frame_header_t *header) {

    header->height     = 0;
    header->width      = 0;
    header->color      = 0; // ! Color Depth    (Pixel Width)
    header->size       = 0;
    header->time_stamp = 0;
  }

  void CIF_set_header(frame_header_t *header) {

    header->height     = window_stat.height;
    header->width      = window_stat.width;
    header->color      = 0;
    header->size       = window_stat.height * window_stat.width * 2;
    header->time_stamp = 0;
  }

  /******************************************************************
   *  Camera Start
   *  Function : acquire
   *      Tells the CIF to acquire a picture.
   *      Parameters
   *          Input  :  address
   *          Output :  Nothing
   ******************************************************************/

  //command frame_t* XbowCam.acquire(uint8_t color, void *address,void *subSampBuf, uint8_t _output_type) {
  command frame_t* XbowCam.acquire(uint8_t color, void *address, uint8_t size, uint8_t _output_type) {

    if (size == SIZE_VGA) {
      window_stat.width = VGA_WIDTH;
      window_stat.height = VGA_HEIGHT;
    } else { // QVGA
      window_stat.width = QVGA_WIDTH;
      window_stat.height = QVGA_HEIGHT;
    }
    currframe = (frame_t*) address;
    currframe->size   = window_stat.height * window_stat.width * 2; // 2 bytes per pixel
    currframe->header = (frame_header_t*) (address + sizeof(frame_t));
    currframe->buf    = (uint8_t*) (address + sizeof(frame_t) + sizeof(frame_header_t));
    //subSamp = subSampBuf;
		
    call OV.config_window(size);
    call OV.init(color, 1, size);

    // CIF_clear_header(currframe->header);
    CIF_set_header(currframe->header);
    currframe->header->type = _output_type;

    call CIF.init(color);
    call CIF.setImageSize(window_stat.width, window_stat.height, (call OV.get_config())->color);
    call CIF.initDMA(currframe->size, currframe->buf);
    call CIF.enable();

    return currframe;
  }

  /******************************************************************
   *  Capture Stop
   *  Function : cancel()
   *      Cancels the current CIF operation.
   *      Parameters
   *          Input  :  Nothing
   *          Output :  Nothing
   ******************************************************************/

  command void XbowCam.cancel() {

    call CIF.disableQuick();
  }

  async event void CIF.startOfFrame() {

    ov_stat_t *stat = call OV.get_config();
    frame_header_t *header = currframe->header;

    atomic {
      header->height     = window_stat.height;
      header->width      = window_stat.width;
    }
    header->color      = stat->color;
    header->size       = header->width * 2 * header->height;
    header->time_stamp = RCNR;

    call CIF.initDMA(header->size, currframe->buf);
    CIFR |= CIFR_RESETF;
    call CIF.startDMA();
  }

  async event void CIF.endOfFrame() {
    call CIF.disableQuick();
    signal XbowCam.acquireDone(); // post fixAcqBuffer();
  }

  async event void CIF.endOfLine(){;}

  async event void CIF.recvDataAvailable(uint8_t channel){;}

  async event void CIF.fifoOverrun(uint8_t channel){;}
}
