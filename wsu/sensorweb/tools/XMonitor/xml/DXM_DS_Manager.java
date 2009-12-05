/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package xml;
import java.io.*;
import java.net.*;

public class DXM_DS_Manager  {
    final static byte VERSION[] = {'T', '!'};//final static byte VERSION[] = {'T', '!'};
    private Socket socket;
    private String host;
    private int port;

    byte version;
    protected InputStream is;
    protected OutputStream os;
    protected int platform = 0;
    protected String name;


    public DXM_DS_Manager(String host, int port) {
		this("sf@" + host + ":" + port);
		this.host = host;
		this.port = port;
    }

    public DXM_DS_Manager(String name) {
		this.name = name;
		this.platform = 0;
    }


    public void openSource() throws IOException {

	socket = new Socket(host, port);

	is = socket.getInputStream();
	os = socket.getOutputStream();
	// Assumes streams are open
	os.write(VERSION);
	byte[] partner = readN(2);

	// Check that it's a valid header (min version is ' ')
	if (!(partner[0] == VERSION[0] && (partner[1] & 0xff) >= ' '))
	    throw new IOException("protocol error");
	// Actual version is min received vs our version
	version = partner[1];
	if (VERSION[1] < version)
	    version = VERSION[1];

	// Any connection-time data-exchange goes here
	switch (version) {
	case ' ':
	    if (platform == 0)
		platform = 1;
	    break;
	case '!':
	    byte f[]=new byte[4];
	    f[0] = (byte) (platform       & 0xff);
	    f[1] = (byte) (platform >> 8  & 0xff);
	    f[2] = (byte) (platform >> 16 & 0xff);
	    f[3] = (byte) (platform >> 24 & 0xff);
	    os.write(f);
	    byte[] received = readN(4);
	    if (platform == 0) {
		platform = received[0] & 0xff |
		    (received[1] & 0xff) << 8 |
		    (received[2] & 0xff) <<16 |
		    (received[3] & 0xff) <<24;
		if (platform == 0) {
		    throw new IOException("connecting to unknown platform from " + this);
		}
	    }
	    break;
	}
    }

    protected void closeSource() throws IOException {
	socket.close();
    }

    protected byte[] readSourcePacket() throws IOException {
	// Protocol is straightforward: 1 size byte, <n> data bytes
	byte[] size = readN(1);
	byte[] read = readN(size[0] & 0xff);

	//Dump.dump("reading", read);
	return read;
    }

    protected boolean writeSourcePacket(byte[] packet) throws IOException {
	if (packet.length > 255)
	    throw new IOException("packet too long");
	os.write((byte)packet.length);
	os.write(packet);
	os.flush();
	return true;
    }

    protected byte[] readN(int n) throws IOException {
	byte[] data = new byte[n];
	int offset = 0;
	while (offset < n) {
	  int count = is.read(data, offset, n - offset);
	  if (count == -1)
	    throw new IOException("end-of-stream");
	  offset += count;
	}
	return data;
    }


   public byte[] readPacket() throws IOException {
	try {
	    return readSourcePacket();
	}
	catch (IOException e) {
	    throw e;
	}
    }

   public boolean writePacket(byte[] packet) throws IOException {
	try {
	    return writeSourcePacket(packet);
	}
	catch (IOException e) {
	    throw e;
	}
    }
}
