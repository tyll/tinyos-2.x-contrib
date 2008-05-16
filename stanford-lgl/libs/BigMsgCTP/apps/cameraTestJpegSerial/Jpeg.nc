/*
* Copyright (c) 2006 Stanford University.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/ 

/**
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 
 
interface Jpeg{
	//- we do DCT on the raw image (dataIn), quantize the resulting DCT matrix,
	//  encode and reindex values of this matrix, zero run-length encode the
	//  reindexed sequence and store the resulting code at the output (dataOut)
	//- dataIn contains raw image pixels
	//- dataOut is a placeholder for the encoded image
	//- bandwidth limit specifies how much space is allocated in dataOut buffer
	//- width and height are image dimensions (ie. size of dataIn is width*height)
	//- qual specifies the quality level of the image, the smaller qual, the better
	//  the quality (but bigger space requirements), qual must be over certain
	//  level, so that quantized DCT values can be encoded in 7 bits (error won't
	//  be thrown, but the encoded image will be distorted due to overflows!!!)
	//- command returns the length of the encoded sequence, 0 means and error
	//  (probably JtegM is still busy coding previous image)
	//- dataInBufferFix is a stupid way to fix buffer when we only care about every
	//  second byte
	
	command void init();
	command uint16_t encodeJpeg(uint8_t *dataIn, uint8_t *dataOut, uint16_t bandwidthLimit,
    uint16_t width, uint16_t height, uint8_t qual, uint8_t bufFix, uint8_t color);
	command uint32_t encodeColJpeg(uint8_t *dataIn, uint8_t *dataOut, uint32_t bandwidthLimit, 
		uint16_t width, uint16_t height, uint8_t qual, uint8_t bufFix);
}
