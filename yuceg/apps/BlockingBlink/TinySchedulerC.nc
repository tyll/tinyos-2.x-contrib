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
 * The new Cooperative TinyOS scheduler. It provides three interfaces: Scheduler,
 * for TinyOS to initialize and run tasks, TaskBasic for the simplext
 * class of TinyOS tasks (reserved always at-most-once posting,
 * FIFO, parameter-free) and Job interface suitable for long running computations
 *
 * @author  Meysam Khezri
 * @date    August 1 2008
 * @email	meysam.khezri@gmail.com
 */

configuration TinySchedulerC {
  provides interface Scheduler;
  provides interface TaskBasic[uint8_t id];
  provides interface Job[uint8_t id];
  provides interface JobControl;
}
implementation {
  components SchedulerP as Sched;
  components McuSleepC as Sleep;
  
  Scheduler = Sched;
  TaskBasic = Sched;
  Job = Sched;
  JobControl = Sched;

  Sched.McuSleep -> Sleep;
}

