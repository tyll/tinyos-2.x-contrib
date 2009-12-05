package org.izra.protomap

import _root_.scala.collection.mutable.HashMap

abstract class Handler {
  val timeout = 1000
  def success(msg: Message) {}
  def failure(msg: Message) {}
}

class MessageHandler {
  val lookup_id = new HashMap[Short, Handler]()
  
  var defaultHandler = new Handler {
    override def failure(msg: Message) {
      println("Have unhandled message")
    }
  }
  
  /**
   * The id used here /must/ correspond to the correct id in the associated
   * LocalMap.
   */
  def add(id: Short, fn: Handler) {
    lookup_id(id) = fn
  }
  
  /**
   * Handle an incoming message.
   */
  def handleMessage(id: Short, message: Message) {
    lookup_id.get(id) match {
      case Some(h) => h.success(message)
      case None => defaultHandler.failure(message) 
    }
  }
  
}
