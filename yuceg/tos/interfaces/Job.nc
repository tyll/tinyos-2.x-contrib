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

/**
  * The new TinyOS Job interface.
  *
  * @author Meysam Khezri
  * @date   August 1, 2008
  *@email	meysam.khezri@gmail.com
  */ 


#include "TinyError.h"

interface Job {

  /**
   * Post this job to the TinyOS scheduler.
   *
   * @return SUCCESS if job was not in READY state
   * @param pointer to top of job stack
   */
  
  async command error_t postJob(uint16_t * s_addr);

  /**
   * Event from the scheduler to run this job. job could have several
   * exit points with call to yield or cyield commands. if this calls 
   * takes place inside the function , that function MUST be declared inline
   */
  event void runJob();
  
  /**
     *Stop executing the current job and permanently switch CPU context to
     * Scheduler. All functions that issue this command MUST be declared inline.
     */
  command void yield();
  
  /**
     * conditionally yield context to TinyOS Scheduler. if preemption is not
     *required ( there is no task or other job waiting for CPU) the execution of job continued.
     *All functions that issue this command MUST be declared inline.
     */
  command void cyield();
  
  /** @return job ID */
  command uint8_t getID();
}

