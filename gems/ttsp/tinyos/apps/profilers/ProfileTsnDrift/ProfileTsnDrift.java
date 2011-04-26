import java.io.*;
import java.util.*;
import net.tinyos.message.*;
import net.tinyos.util.*;

public class ProfileTsnDrift implements MessageListener {
	private MoteIF mote;
	
	private Map<Integer, PrintStream> streams;
	
	public ProfileTsnDrift () {
		Runtime.getRuntime().addShutdownHook(new RunWhenShuttingDown());
		try {
			mote = new MoteIF(PrintStreamMessenger.err);
			mote.registerListener(new ReportMsg(), this);
		} catch(Exception e) {
			e.printStackTrace();
			System.exit(2);
		}
		
		streams = new HashMap<Integer, PrintStream>();
	}
	
	public float convertTemperature(long temperature) {
		double r1 = 10000;
		double adcfs = 1023;
		double adc = temperature;
		double rthr = r1 * (adcfs -adc) / adc;
		double a = 0.00130705;
		double b = 0.000214381;
		double c = 0.000000093;
		
		return (((float) Math.round( (1 / (a + b * Math.log(rthr) + c * Math.pow( Math.log(rthr), 3 )) - 273.15) * 10 )) / 10);
	}

	public void processMsg(ReportMsg msg) {
		PrintStream stream = null;
		int srcAddr = msg.get_srcAddr();
		if(streams.containsKey(srcAddr)) {
			stream = streams.get(srcAddr);
		} else {
			String name=""+System.currentTimeMillis();
			try {
				stream = new PrintStream(new FileOutputStream(name + "-" + srcAddr + ".csv"));
			} catch(Exception e) {
				e.printStackTrace();
				System.exit(2);
			}				
			streams.put(srcAddr, stream);
		}
		
		Long refId = new Long(msg.get_refId());
		Long offset = msg.get_refTimestamp() - msg.get_localTimestamp();
		float temperature = convertTemperature(msg.get_temperature());
			
		String out = System.currentTimeMillis() + ";" + srcAddr + ";" + refId + ";" + offset + ";" + temperature;
		System.out.println(out);
		stream.println(out);
		stream.flush();
	}


	public void messageReceived(int dest_addr, Message msg) {
		if (msg instanceof ReportMsg) {
			processMsg((ReportMsg)msg);
		}
	}
	
	public class RunWhenShuttingDown extends Thread {

		public void run() {
			Collection c = streams.values();
			Iterator itr = c.iterator();
			while(itr.hasNext()) {
				PrintStream stream = (PrintStream) itr.next();
				stream.close();
			}
		}
	}	

	public static void main(String[] args) {
		new ProfileTsnDrift();
 	}
}
