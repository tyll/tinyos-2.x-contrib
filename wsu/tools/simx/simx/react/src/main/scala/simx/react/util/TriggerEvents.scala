package simx.react.util

import scala.collection.mutable

import simx.react._

case class TriggerEvent()

// Todo:: Move these to appropriate locations
case class UseTemplate(template: Template, send: Boolean) extends TriggerEvent
case class TemplateUpdated(template: Template) extends TriggerEvent

/*
 * Trait to respond to events.
 */
trait EventHandler {
  def respond(event: TriggerEvent)
}

/*
 * Trait to add triggers.
 */
trait EventTrigger {
  val event_handlers = new mutable.HashSet[EventHandler]()
  
  def addHandler(handler: EventHandler) {
    event_handlers += handler
  }
  
  def removeHandler(handler: EventHandler) {
    event_handlers -= handler
  }
  
  def trigger(event: TriggerEvent) {
    for (l <- event_handlers)
      l.respond(event)
  }
}