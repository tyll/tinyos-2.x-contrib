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
