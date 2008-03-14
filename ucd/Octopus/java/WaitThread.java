// $Id: WaitThread.java



/*

 * Copyright (c) 2007 University College Dublin.

 * All rights reserved.

 *

 * Permission to use, copy, modify, and distribute this software and its

 * documentation for any purpose, without fee, and without written agreement is

 * hereby granted, provided that the above copyright notice and the following

 * two paragraphs appear in all copies of this software.

 *

 * IN NO EVENT SHALL UNIVERSITY COLLEGE DUBLIN BE LIABLE TO ANY

 * PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES

 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF 

 * UNIVERSITY COLLEGE DUBLIN HAS BEEN ADVISED OF THE POSSIBILITY OF

 * SUCH DAMAGE.

 *

 * UNIVERSITY COLLEGE DUBLIN SPECIFICALLY DISCLAIMS ANY WARRANTIES,

 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY

 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS

 * ON AN "AS IS" BASIS, AND UNIVERSITY COLLEGE DUBLIN HAS NO

 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR

 * MODIFICATIONS.

 *

 * Author: Conor Muldoon

 *

 */



/**

 * @author Conor Muldoon

 */



public class WaitThread extends Thread{
	MsgSender msgS;
	MoteDatabase moteD;
	public WaitThread(MsgSender ms,MoteDatabase md){
		msgS=ms;
		moteD=md;
	}

	public void run(){
		try{
			sleep(Constants.WAIT_TIME);
			moteD.sendMax(msgS);
		}catch(InterruptedException e){
			e.printStackTrace();
		}
	}
}