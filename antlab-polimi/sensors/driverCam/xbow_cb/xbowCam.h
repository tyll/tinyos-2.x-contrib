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
#ifndef _XBOW_CB_H
#define _XBOW_CB_H

#define MAX_HEIGHT          480
#define MAX_WIDTH           640
#define BYTES_PER_PIXEL     2
#define FRAME_BUF_SIZE      MAX_HEIGHT*MAX_WIDTH*BYTES_PER_PIXEL    // 16-bit color
#define FRAME_SIZE          sizeof(frame_t)

#define WINDOW_HZERO    0x11 // 0x1A
#define WINDOW_VZERO    0x03 // 0x03
#define WINDOW_HMAX     0x61 // 0xBA
#define WINDOW_VMAX     0x7B // 0xF3

typedef struct {
    uint16_t height;            // height of frame in pixels
    uint16_t width;             // width of fram in pixels
    uint8_t color;              // color model (defined by .h file for OV)
    uint32_t size;              // image size in bytes
    uint32_t time_stamp;        // frame timestamp
    uint8_t type;
} __attribute__ ((packed)) frame_header_t;

enum {
    BUF_TYPE_GRAY_1BYTE=0,
    BUF_TYPE_GRAY_2BYTES=1,   //UYVY
    BUF_TYPE_RGB_2BYTES=2,    //RGB565
    BUF_TYPE_RGB_3BYTES=3,
};

typedef struct {
    frame_header_t *header;     // frame header
    uint32_t size;              // frame buffer size
    uint8_t *buf;               // frame buffer
} frame_t;

typedef struct {
    uint16_t x;
    uint16_t y;
    uint16_t width;
    uint16_t height;
} __attribute__ ((packed)) window_t;

#endif /* _IM2CB_H */
