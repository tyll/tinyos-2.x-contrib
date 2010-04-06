 import net.tinyos.message.*;
 import net.tinyos.packet.*;
 import net.tinyos.util.*;
 import java.util.Timer;
 import java.util.TimerTask;
 import java.io.*;


public class SenZipController implements MessageListener {

	static short TOS_BCAST_ADDR = (short)0xffff;
	static byte BASE_ID = 127;
    
	static short num_nodes = 2;
	static byte[] parent = {BASE_ID, 0, 1}; 

	static short dest_node = TOS_BCAST_ADDR;

	private MoteIF moteIF;
	static MoteIF mote;

	static short START = 1;

	static short COEFF_M1 = 1;
	static short RAW = 10;
	static short FULL = 11;

	static PrintWriter rawStream[] = new PrintWriter[20];
	static PrintWriter coeffStream[] = new PrintWriter[20];

	static SenZipController senzipController;

	static String command = "";
    
	// constructor method
	public SenZipController(MoteIF moteIF){
		this.moteIF = moteIF;
		this.moteIF.registerListener(new BaseMsg(), this);
	}

	public synchronized void messageReceived(int to, Message message) {
		System.out.println("Message type of "+(message.getClass()).getName());
        if (((message.getClass()).getName()).equals("BaseMsg")) {
			BaseMsg packet = (BaseMsg)message;
			if ((packet.get_type() == COEFF_M1) || (packet.get_type() == FULL))
			{
				System.out.println("Type is " + packet.get_type());
				System.out.println("Source is " + packet.get_src());
				System.out.println("SeqNum is " + packet.get_seq());
				System.out.println("Max is " + packet.get_max());
				System.out.println("Min is " + packet.get_min());
				short[] readings = packet.get_data();
				for (int i = 0; i < readings.length; i++) {
					System.out.println(readings[i]);
					try{
						coeffStream[packet.get_src()].println(packet.get_type() + " " + packet.get_src() + " " + packet.get_parent() + " " + packet.get_seq() + " " + packet.get_min() + " " + packet.get_max() + " " + readings[i]);
					} catch(Exception ex){
					}
				}
			} else if (packet.get_type() == RAW)
			{
				short[] readings = packet.get_data();
				for (int i = 0; i < readings.length; i++) {
					System.out.println(readings[i]);
					try{
						rawStream[packet.get_src()].println(packet.get_type() + " " + packet.get_src() + " " + packet.get_parent() + " " + packet.get_seq() + " " + packet.get_min() + " " + packet.get_max() + " " + readings[i]);
					} catch(Exception ex){
					}
				}
			}
		} 
	}

	public static void main(String[] args) throws Exception{
		String source = "sf@localhost:9001";
		if (args.length < 2){
			//SenZipController.usage();
			System.exit(1);
		}
		for ( int i = 0; i < args.length - 1 ; i++){
			if (args[i].equals("-c")) {
				i++;
				command = args[i];
			} else if (args[i].equals("-d")){
				i++;
				dest_node = (short)Integer.parseInt(args[i]);
			}
		}

		 for (int i = 1; i <= num_nodes ; i++ ){
			 String fileName = "raw_data_"+i+".txt";
			 try{
					File rawFile = new File(fileName);
					FileOutputStream rawFileStream = new FileOutputStream(rawFile);
					rawStream[i] = new PrintWriter(rawFileStream, true);
			 } catch(FileNotFoundException ex) {
					System.out.println("ERROR!! The file "+fileName+" could not be found"+ex);
			 }
		 }


		 for (int i = 1; i <= num_nodes ; i++ ){
			 String fileName = "coeff_data_"+i+".txt";
			 try{
					File coeffFile = new File(fileName);
					FileOutputStream coeffFileStream = new FileOutputStream(coeffFile);
					coeffStream[i] = new PrintWriter(coeffFileStream, true);
			 } catch(FileNotFoundException ex) {
					System.out.println("ERROR!! The file "+fileName+" could not be found"+ex);
			 }
		 }

		// build phoenix source
		PhoenixSource phoenix;
		if (source == null){
			phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
		} else {
			phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
		}

		mote = new MoteIF(phoenix);
		senzipController = new SenZipController(mote);
		BaseMsg BaseComPkt = new BaseMsg();
		FixRtMsg FixRtPkt = new FixRtMsg();
		if (command.equals("START")) {    
			BaseComPkt.set_type(START); 
			mote.send(dest_node, BaseComPkt);
		} 
		else if (command.equals("ROUTE")) {
			FixRtPkt.set_parent(parent[dest_node]);
			FixRtPkt.set_numHops((short)0);
            mote.send(dest_node, FixRtPkt);
			System.out.println("sent one");
			System.exit(1);
		}
	}
}
