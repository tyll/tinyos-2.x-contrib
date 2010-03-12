package org.izra.protomap

import _root_.java.net.InetSocketAddress
import _root_.java.net.Socket
import _root_.java.util.concurrent.BlockingQueue
import _root_.java.util.concurrent.LinkedBlockingQueue
import _root_.java.nio.channels._
import _root_.java.nio.{ByteBuffer, ByteOrder}
import _root_.java.io.EOFException

import _root_.scala.actors.Actor
import _root_.scala.actors.Actor._
import _root_.scala.collection.mutable.HashMap

import _root_.com.google.protobuf

object Client {
  case class Timeout(millis: Int) {
    // Returns the shorter timeout of the two.
    def shorterOf(other: Timeout) = {
      if (other.millis < millis) other else this
    }
  }
  case class Handler(handler: (Message) => Unit, timeout: Option[Timeout])
  
  // Actor messages
  
  case class PacketIn(pkt: Packet)
  case class SendMessage(msg: Message)
  case class Connect(addr: InetSocketAddress, monitor: Option[Actor])
  case class ConnectFailed(addr: InetSocketAddress, e: Throwable)
  case class Connected(client: Actor, addr: InetSocketAddress)
  case class Disconnect(e: Option[Exception], ch: Option[SocketChannel])
  case class Disconnected(e: Option[Exception])
  
  case class MapProto(ident: ResolvedProtoIdent, fn: (Message) => Unit)
  
  case class Send(msg: Message,
                  handler: Option[Handler])
  object Send {
    val DEFAULT_TIMEOUT = 1000 // in millis
    def apply(msg: Message): Send = {
      Send(msg, None)
    }
    def apply(msg: Message, responder: (Message) => Unit): Send = {
      Send(msg, Some(Handler(responder, None)))
    }
    def apply(msg: Message, responder: (Message) => Unit, timeout: Timeout): Send = {
      Send(msg, Some(Handler(responder, Some(timeout))))
    }
  }
}

/**
 * Simple integrated Protomap Client
 */
class Client(localMap: LocalMap) {
  import Client._
  val ASCII = "US-ASCII"
  
  case class ActiveConn(
    channel: SocketChannel,
    monitor: Option[Actor],
    reader: Reader,
    writer: Writer,
    outboundQueue: BlockingQueue[Packet],
    remoteMap: RemoteMap)
  {
    /**
     * NOTE:
     * This assumes that both the reader and the writer are attached to
     * the same channel; disconnect changes are propogated to the threads
     * via closing the channel and then interrupting the threads.
     */
    def disconnect(oe: Option[Exception]) = if (channel.isOpen) {
      try {
        channel.close()
      } catch {
        case _ => ()
      }

      reader.interrupt()
      // for race condition present when interrupt occurs after IO write
      // but before taking the item from the blocking queue
      writePacket(Packet(0, InternedProto(0), ByteBuffer.allocate(0)))
      writer.interrupt()
      
      for (m <- monitor) m ! Disconnected(oe)
    }
    
    def writePacket(pkt: Packet) {
      outboundQueue.put(pkt)
    }
  }
  
  // The single active connection, if present.
  var active: Option[ActiveConn] = None

  /**
   * Write a message.
   * 
   * WARN: Only run from dispatch
   */
  private def write(m: Message) = active match {
    case Some(a) => {
      val proto = a.remoteMap.resolveProto(m)
      val data = m.protomsg.toByteArray
      val buffer = ByteBuffer.wrap(data)
      a.writePacket(Packet(m.trackId getOrElse 0, proto, buffer))
    }
    case _ => println("Attempting to write to innactive connection")
  }
  
  /**
   * Tracked handlers are removed once they are invoked or their timeout
   * expires, whichever happens first.
   */
  val tracker = new Object {
    val MAX_TIMEOUT = Timeout(60 * 1000)
    
    import java.util.{Timer, TimerTask}
    
    val handlerSync = new Object()
    val handlers = HashMap[Short, (TimerTask, (Message) => Unit)]() 
    val reaper = new Timer
    
    // PST- I don't like this, where something can be registered and then
    // if there is some nasty error (which shouldn't happen, but that's another point)
    // the message may be subsequently discarded without ever being sent. On the
    // other hand, the message may be sent and never replied to... so I guess
    // the only "sure" way is to make sure they are reaped.
    def register(handler: Handler): Short = handlerSync.synchronized {
      val trackId = nextId_!
      val timeout = MAX_TIMEOUT shorterOf (handler.timeout getOrElse MAX_TIMEOUT)
      val reaperTask = new TimerTask {
        override def run() = handlerSync.synchronized {
          println("reaping!")
          handlers -= trackId
    	}
      }
      handlers(trackId) = (reaperTask, handler.handler)
      reaper.schedule(reaperTask, timeout.millis)
      trackId
    }
    
    def invokeFor(msg: Message) = handlerSync.synchronized {
      for (trackId <- msg.trackId) {
        for ((reaperTask, handler) <- handlers.get(trackId)) {
          handlers -= trackId
          reaperTask.cancel()
          handler(msg)
    	}
      }
    }
    
    private var id = 0
    
    def nextId_! = {
      id += 1
      id.toShort
    }
  }
  
  
  object MessageHandlers {
    val handlers = new HashMap[String, (Message) => Unit]
  }
  
  /*
   * Send a message -- possibly add handlers for such. If handlers are
   * added a new tracking number will be used.
   * 
   * WARN: Only run from actor.
   */
  private def send(msg: Message, handlerOpt: Option[Handler]) = {
    val trackedMsg = for (handler <- handlerOpt) yield {
      msg.withTracking(tracker.register(handler))
    }
    write(trackedMsg getOrElse msg)
  }
  
  /**
   * Connect the client to a particular address.
   * Any previous connection is disconnected.
   * 
   * WARN: Only run from dispatch
   */
  private def connect(addr: InetSocketAddress, monitor: Option[Actor]) = try {
    disconnect(None, None)
    val c = SocketChannel.open(addr)
    val outbound = new LinkedBlockingQueue[Packet]()
    val r = new Reader(c)
    val w = new Writer(c, outbound)
    val remoteMap = new RemoteMap()
    active = Some(ActiveConn(c, monitor, r, w, outbound, remoteMap))
    for (m <- monitor) m ! Connected(self, addr)
  } catch {
    case e => for (m <- monitor) m ! ConnectFailed(addr, e)
  }
  
  /**
   * Disconnect the current connection, if it exists.
   * 
   * WARN: Only run from dispatch
   */
  private def disconnect(oe: Option[Exception], och: Option[SocketChannel]) {
    // Closes active if 1) a non-specified channel 2) the same channel.
    // This prevents late-disconnect requests from closing the active channel
    // if they do not apply.
    def closesActive(c: SocketChannel) = och match {
      case None => true
      case Some(_c) => c eq _c
    }
    for (a <- active if closesActive(a.channel)) {
      a.disconnect(oe)
      active = None
    }
  }
  
  /**
   * Actor that sits between IO and application.
   */
  val dispatch_ = {
    case PacketIn(_) => println("packet in!")
    // Send
    case Send(proto, handlerOpt) => send(proto, handlerOpt)
    case SendMessage(m) => write(m)
    case Connect(addr, monitor) => connect(addr, monitor)
    case Disconnect(oe, och) => disconnect(oe, och)
    
    // Default monitor handlers
    case ConnectFailed(a, e) => {
      println("Connection failed " + a + ": " + e)
    }
    case Connected(_, _) => {
      println("Connected")
    }
    case Disconnected(eOpt) => {
      println("Disconnected: " + {eOpt getOrElse "(client requested)"})
      for (e <- eOpt) {
    	  e.printStackTrace()
      }
    }
  }: PartialFunction[Any, Unit]
  
  // might be good in contention, but loop slow normally
  //val dispatch = actor(loop(receive(dispatch_)))
  //val dispatch = actor(loop(react(dispatch_)))
  val dispatch = actor {
    while(true) receive(dispatch_)
  }
  
  // pass-through to make life simpler
  val ! = dispatch.! _
  
  /**
   * A simple threaded reader.
   */
  class Reader(s: SocketChannel) extends Thread("Reader") {
    start() // begin started
    
    override def run() = try {
      handshake()
      while (true) processPacket()
    } catch {
      case e:Exception => dispatch ! Disconnect(Some(e), Some(s))
    }
    
    /**
     * Read all until the buffer is full.
     * Raises an EOFException if the buffer can not be filled.
     * Only use this for blocking IO.
     */
    def readFull(buffer: ByteBuffer) {
      while (buffer.hasRemaining && s.read(buffer) > 0) {}
      if (buffer.hasRemaining) throw new EOFException()
    }
    
    def handshake() {
      val REQUIRED_MAGIC = "PROTOMAPa"
      // siphon off the initial protocol handshake
      val magic = ByteBuffer.allocate(REQUIRED_MAGIC.length)
      readFull(magic)
      // verify
      val magicStr = new String(magic.array, ASCII)
      if (magicStr != REQUIRED_MAGIC) {
        throw new RuntimeException("invalid magic: found='" + magicStr + "'")
      }
    }
   
    def processPacket() {
      // read header
      val header = ByteBuffer.allocate(4).order(ByteOrder.BIG_ENDIAN)
      readFull(header)
      header.flip()
        
      // find length and read rest of message
      val len = Packet.packetLength(header)
      val pkt = ByteBuffer.allocate(len).order(ByteOrder.BIG_ENDIAN)
      pkt.put(header)
      readFull(pkt)
      pkt.flip()
      
      dispatch ! PacketIn(Packet.decode(pkt))
    }
  }
  
  /**
   * A simple threader writer.
   */
  class Writer(s: SocketChannel, queue: BlockingQueue[Packet]) extends Thread("Writer") {
    start() // begin started
    
    override def run() = try {
      handshake()
      while (true) processPacket()
    } catch {
      case e:Exception => dispatch ! Disconnect(Some(e), Some(s))
    }
    
    def handshake() {
      val bytes = "PROTOMAP".getBytes(ASCII)
      val buffer = ByteBuffer.wrap(bytes)
      while (buffer.remaining > 0) {
        s.write(buffer)
      }
    }

    def processPacket() {
      val pkt = queue.take()
      val encoded = pkt.encode
      println(encoded(0).remaining + "." + encoded(1).remaining)
      // write all parts -- this /could/ be handled by NIO
      for (e <- encoded) {
        while (e.remaining > 0) {
    	  s.write(e)
        }
      }
    }
  }
  
}
