/**
 * WMTP Performance Report Tool.
 *
 * This application retrieves and presents the log events from a running WMTP
 * performance test.
 *
 * @author Luis D. Pedrosa <luis.pedrosa@tagus.ist.utl.pt>
 */

import net.tinyos.util.*;
import net.tinyos.message.*;
import java.io.*;
import java.util.*;

public class TestWmtpPerformanceReport implements MessageListener,Runnable {
	public static byte GroupID = 0x7D;
	MoteIF mote;


	/**
	 * Initializes the class.
	 *
	 * Intitializes the mote communications and registers the message listener.
	 */

	public TestWmtpPerformanceReport() {
		try {
			mote = new MoteIF( PrintStreamMessenger.err );
			mote.registerListener( new EventMsg(), this );
		} catch (Exception e) {
			System.err.println( "Unable to connect to sf@localhost:9001" );
			System.exit( -1 );
		}
	}


	public void messageReceived( int dest_addr, Message msg ) {
		if ( msg instanceof EventMsg ) {
			EventMsg emsg = (EventMsg) msg;

			System.out.print(
				""  + emsg.get_EventRecord_time() +
				";" + emsg.get_EventRecord_nodeAddress() +
				";" + emsg.get_EventRecord_minQueueAvailability() +
				";" + emsg.get_EventRecord_sntWmtpMsgCnt() +
				";" + emsg.get_EventRecord_rcvdWmtpMsgCnt() +
				";" + emsg.get_EventRecord_genMsgCnt() );
				for ( int i = 0; i < emsg.numElements_EventRecord_rcvdMsgCnts(); i++ )
					System.out.print( ";" + emsg.getElement_EventRecord_rcvdMsgCnts( i ) );
				System.out.println();
		} else {
			throw new RuntimeException("messageReceived: Got bad message type: "+msg);
		}
	}


	/**
	 * Starts the application.
	 *
	 * Starts up the main thread.
	 */

	public static void main( String[] args ) throws IOException {
		// Starts the main thread.
		(new Thread(new TestWmtpPerformanceReport())).start();
	}


	/**
	 * Waits for the log events.
	 */

	public void run() {
		System.out.println( "\"Time\";\"Node\";\"MinQueueAvailability\";\"SentWmtpMsgs\";\"ReceivedWmtpMsgs\";\"GeneratedPackets\";\"ReceivedPacketPerConnection\"" );
		/*while( true ) {
			try {
				Thread.sleep( 1000 );
			} catch ( java.lang.InterruptedException e ) {
			}
		}*/
		try {
			System.in.read();
		} catch ( java.io.IOException e ) {
		}
		System.exit( 0 );
	}
}
