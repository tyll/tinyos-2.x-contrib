import java.io.IOException;

import net.tinyos.message.MoteIF;
import net.tinyos.packet.BuildSource;
import net.tinyos.packet.PhoenixSource;
import net.tinyos.util.PrintStreamMessenger;

public class Analysis {

  private AnalysisMsg analysisMsg;

  public Analysis(String[] args) {
    analysisMsg = new AnalysisMsg();

    PhoenixSource phoenix;
    
    phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
    
    MoteIF mif = new MoteIF(phoenix);

    
    
    if(args.length % 2 != 0 || args.length == 0) {
      printSyntax();
      System.exit(1);
    }
    
    for(int i = 0; i < args.length; i++) {
      if(args[i].equalsIgnoreCase("-wor")) {
        i++;
        analysisMsg.set_worInterval(Integer.decode(args[i]).intValue());
        
      } else if(args[i].equalsIgnoreCase("-int")) {
        i++;
        analysisMsg.set_intervalBetweenMessagesMs(Integer.decode(args[i]).intValue());
      
      } else if(args[i].equalsIgnoreCase("-nodes")) {
        i++;
        analysisMsg.set_nodesInSurroundingNetwork(Short.decode(args[i]).shortValue());
      }
    }
    
    System.out.println("WoR Interval [ms]: " + analysisMsg.get_worInterval());
    System.out.println("Interval between messages per node [bms]: " + analysisMsg.get_intervalBetweenMessagesMs());
    System.out.println("Surrounding nodes in network: " + analysisMsg.get_nodesInSurroundingNetwork());
    
    try {
      mif.send(0xFFFF, analysisMsg);
      
    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    
    System.exit(0);
  }

  private void printSyntax() {
    System.out.println("Network energy analysis syntax");
    System.out.println("_______________________________________________________________");
    System.out.println("\t-wor [#]    Wake-on Radio Receive Check Interval, in MS");
    System.out.println("\t-int [#]    Interval between msgs, per node, in BMS");
    System.out.println("\t-nodes [#]  Number of nodes in the surround network");
  }

  public static void main(String[] args) throws Exception {
    new Analysis(args);
  }

}
