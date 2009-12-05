


import java.io.*;
import java.net.*;
import net.tinyos.packet.*;

/**
 * Packet source (tcp/ip client) for the new serial forwarder protocol
 */
class TCPServer extends SFProtocol {
    private Socket socket;
    private String host;
    private int port;
	int i = 0;
	



    /**
     * Packetizers are built using the makeXXX methods in BuildSource
     */
    TCPServer(String host, int port) throws IOException{
	super("sf@" + host + ":" + port);
	this.host = host;
	this.port = port;
	openSource();
	byte[] a,b;
	//OnlineDecoder d = new OnlineDecoder();
	//d.start();
	boolean fff = false;
	while(true){
		a = readSourcePacket();
		//System.out.println(a.length);
		
		OctopusCollectedMsg rMsg = new OctopusCollectedMsg(a,8);
		
		
		for(int i = 0; i < a.length; i++)
			System.out.print(" "+unsign(a[i]));
		System.out.println();
		System.out.println(rMsg);
	//int[] array = rMsg.get_packetIdList();
	//	for(int i = 0; i < array.length; i++)
		//	System.out.print(" ["+i+"]: "+unsign((byte)(array[i]>>8))+":" +unsign((byte)((array[i]<<8)>>8)));
		//System.out.println("\ndata: "+ rMsg.get_Data() );
		
	//	if(fff == false){
		//Formula f = new Formula(rMsg.get_packetIdList(),rMsg.get_Data());
		//d.insert(f);
	//d.printResult();
		fff=true;
	//	}
		
		
		//System.out.println("pkg id: "+(rMsg.getElement_packetIdList(0)));
		/*
		for(int i =0; i < a.length; i++){
			System.out.print(unsign(a[i])+" ");
		
		}
		System.out.println();
		
		System.out.println(rMsg.get_myId());
		*/
	}
		
    }

    protected void openSource() throws IOException {
	socket = new Socket(host, port);
	is = socket.getInputStream();
	os = socket.getOutputStream();
	super.openSource();
    }

    protected void closeSource() throws IOException {
	socket.close();
    }
	public static void main(String[] args){
		try{
		TCPServer server = new TCPServer("localhost",9006);
		}catch(IOException e){}
	}

	public int unsign(byte i){
		int readUnsignedByte = (0x000000FF & ((int)i));
		return readUnsignedByte;
	
	}

}
