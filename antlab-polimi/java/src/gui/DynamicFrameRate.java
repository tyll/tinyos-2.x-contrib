package gui;

import java.util.TimerTask;

public class DynamicFrameRate extends TimerTask{

	ReceiverThread receiverThread;
	DisplayThread displayThread;
	int rate=0;
	
	public DynamicFrameRate(ReceiverThread rcvThread,DisplayThread dspThread){
		receiverThread=rcvThread;
		displayThread=dspThread;
	}
	
	@Override
	public void run() {
		
		rate=receiverThread.getFrameRate();
		displayThread.setFrameRate(rate);
	}

}
