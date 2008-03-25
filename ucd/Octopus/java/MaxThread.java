public class MaxThread extends Thread {

	MoteDatabase moteDB;

	MsgSender ms;

	

	public MaxThread(MoteDatabase md, MsgSender sender) {
		moteDB = md;
		ms = sender;
		
	}

	public void run() {
		try {
			sleep(Constants.MX_RATE * 5);
			moteDB.send(ms);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}
