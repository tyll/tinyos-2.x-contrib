import java.util.*;
import java.io.*;

public class Ping {
  int pinger;
  long ping_counter;
  short ping_tx_timestamp_is_valid;
  long ping_tx_timestamp;
  PingMsg pingMsg;
  List pongs = new ArrayList();

  public Ping(PingMsg m) {
    setPingMsg(m);
  }

  public Ping(int pinger, long ping_counter) {
    this.pinger = pinger;
    this.ping_counter = ping_counter;
  }

  public int get_pinger() {
    if(pingMsg == null)
      return pinger;
    else
      return pingMsg.get_pinger();
  }

  public long get_ping_counter() {
    if(pingMsg == null)
      return ping_counter;
    else
      return pingMsg.get_ping_counter();
  }

  public short get_ping_tx_timestamp_is_valid() {
    return ping_tx_timestamp_is_valid;
  }

  public void set_ping_tx_timestamp_is_valid(short s) {
    ping_tx_timestamp_is_valid = s;
  }

  public long get_ping_tx_timestamp() {
    return ping_tx_timestamp;
  }

  public void set_ping_tx_timestamp(long l) {
    ping_tx_timestamp = l;
  }

  public void setPingMsg(PingMsg m) {
    this.pingMsg = m;
  }

  public PingMsg getPingMsg() {
    return this.pingMsg;
  }

  public void addPong(Pong p) {
    pongs.add(p);
  }

  public void printHeader(PrintStream out) {
      out.print("#pinger\t");
      out.print("counter\t");
      out.print("Ttx_vld\t");
      out.print("Ttx\t");

      out.print("ponger\t");
      out.print("Trx_vld\t");
      out.print("Trx\t");

      out.print("Trx-Ttx\n");
  }

  public void print(PrintStream out) {
    Iterator it = pongs.iterator();
    printHeader(out);
    while(it.hasNext()) {
      Pong pong = (Pong)it.next();

      out.print(get_pinger()+"\t");
      out.print(get_ping_counter()+"\t");
      out.print(get_ping_tx_timestamp_is_valid()+"\t");
      out.print(get_ping_tx_timestamp()+"\t");

      out.print(pong.getPongMsg().get_ponger()+"\t");
      out.print(pong.getPongMsg().get_ping_rx_timestamp_is_valid()+"\t");
      out.print(pong.getPongMsg().get_ping_rx_timestamp()+"\t");

      long offset = pong.getPongMsg().get_ping_rx_timestamp()-get_ping_tx_timestamp();
      // for 16-bit timestamping
      //if(offset<0) offset+=Math.pow(2,16);
      // for 32-bit timestamping
      if(offset<0) offset+=Math.pow(2,32);

      out.print(offset+"\n");

    }
    out.print("\n");
  }
}