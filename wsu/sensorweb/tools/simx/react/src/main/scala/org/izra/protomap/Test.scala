package org.izra.protomap

import java.net.InetSocketAddress
import CoreMessages.MessageRejected

object Test {
  def main(argv: Array[String]) {
    val local_map = new LocalMap()
    val c = new Client(local_map)
    val p = MessageRejected.newBuilder().setId(0).setReason(MessageRejected.Reason.OTHER).setMessage("foo").build()
    c ! Client.Connect(new InetSocketAddress("127.0.0.1", 7800),
                                Some(c.dispatch))
//    c.dispatch ! Client.Connect(new InetSocketAddress("127.0.0.1", 7800),
                                //Some(c.dispatch))
    c ! Client.Send(Message(p), (x) => println("response!"), Client.Timeout(1000))
    
    synchronized {
    	while (true) {
    		wait(10000)
    	}
    }
  }
}
