/* Copyright (c) 2008, Computer Engineering Group, Yazd University , Iran .
*  All rights reserved.
*
*  Permission to use, copy, modify, and distribute this software and its
*  documentation for any purpose, without fee, and without written
*  agreement is hereby granted, provided that the above copyright
*  notice, the (updated) modification history and the author appear in
*  all copies of this source code.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifndef JOB_H
#define JOB_H

enum {
	NULL_STATE = 0,     //Initial state
	READY_STATE = 1,    //ready for execution
	RUNNING_STATE = 2,	// running job
};

/** @brief job structure definition */
typedef struct job_s {
   /** @brief Stack pointer */
   volatile uint16_t *sp;
   /** @brief  job state */
   volatile uint8_t state;
   /**@brief job ID */
   volatile uint8_t id;
} job_t;

#define STACK_TOP(stack)    \
  (&(((uint16_t *)stack)[(sizeof(stack) / sizeof(uint16_t)) - 1]))

#endif
