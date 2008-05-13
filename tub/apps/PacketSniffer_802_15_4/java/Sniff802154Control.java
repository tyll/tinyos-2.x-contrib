/** based upon Oscilloscope.java */

import net.tinyos.message.*;
import net.tinyos.util.*;
import java.lang.*;
import java.io.*;
import java.awt.event.*;
import javax.swing.Timer;


public class Sniff802154Control implements MessageListener
{
    MoteIF mote;
    SniffControlMsg ctrlMsg = new SniffControlMsg();
    boolean ack = false;
    
    
    final Timer ackTimer = new Timer(0, new ActionListener() 
	{
	    public void actionPerformed(ActionEvent event) {
		if (!ack) {
		    try {
			System.out.println(">> trying to set channel to " + ctrlMsg.get_channel());
			mote.send(MoteIF.TOS_BCAST_ADDR, ctrlMsg);
		    }
		    catch (IOException error) {
			// print out error...
		    }
		}
	    }
  	});
    
    
    /* class for writing to named ouput pipe  */
    class PipeReader extends Thread {
	FileInputStream pipe;
	BufferedReader ipsr;
        
	public PipeReader(String str) { 
	    super(str); 
	}

	// needed for extracting numbers after from strings (e.g. "setChannel 15")
	public int extract(String s) {
	    int j = s.length()-1;
	    int result = -1;
	    while (j >= 0 && Character.isDigit(s.charAt(j))) {
		j--;
	    }
	    try {
		result = Integer.parseInt(s.substring(j+1,s.length()));
	    } catch (NumberFormatException error) {
         	result = -1; 
	    }
	    return  result;
	}
      
	public void run() {
	    try {
        	pipe = new FileInputStream("sniffControlPipeIn");	
		ipsr = new BufferedReader(new InputStreamReader(pipe));
	    } catch (IOException error) {
		System.out.println("error opening pipe sniffControlPipeIn");
		System.exit(0);
	    }
	    while (true) { 
		try {
		    String cmd;
		    cmd = ipsr.readLine();
		    if (cmd != null)
			if(cmd.indexOf("setChannel") != -1) {
			    // try to parse
			    int result = extract(cmd);
			    if ((result > 0) && (result < 27)) sendControl((byte)result);
			} else {
			    System.out.println("unknown command: " + cmd);
			}
		    sleep(50);
		} catch (IOException error) {
		    // print out error...
		} catch (InterruptedException ie) {
		}
	    }
	}
        
    }
    
    
    /* Main entry point */
    void run() {
	mote = new MoteIF(PrintStreamMessenger.err);
	mote.registerListener(new SniffControlMsg(), this);
	new PipeReader("Read Control Pipe").start();
    }

    synchronized public void messageReceived(int dest_addr, Message msg) {
        SniffControlMsg ctrlAck = (SniffControlMsg)msg;
        ack = true;
        ackTimer.stop();
        System.out.println("<< channel set to " + ctrlAck.get_channel());
    }

    /* send control message to node */
    void sendControl(byte p_channel) {
	ctrlMsg.set_channel(p_channel);
	ack = false;
      
	ackTimer.setDelay(1000);
	ackTimer.setRepeats(true);
	ackTimer.restart();
    }

    public static void main(String[] args) {
	Sniff802154Control me = new Sniff802154Control();
	me.run();
    }
}

/* thread/class for reading from named input pipe */




