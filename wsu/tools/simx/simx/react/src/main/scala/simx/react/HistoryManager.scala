package simx.react

import scala.collection.mutable

import react.util._

/*
 * Remember a history and maintain an iterator.
 * 
 * There is always at least one history item: the current one.
 * 
 * Event handling/monitoring is done via Bind.
 */
class HistoryManager[T] (
  private val _initial: T,
  private val _default: T
) {
  val list = new mutable.ListBuffer[T]()
  var top: Option[String] = None
  
  // Bind these.
  val hasPrev = new Bind(false)
  val hasNext = new Bind(false)
  val current = new Bind[T](_initial)
  val index = new Bind(0)
  
  addLast(_initial)
  
  // Move the iterator and update Bind parameters
  def updateMovement(requested_index: Int) {
    val new_index = requested_index.max(0).min(list.length - 1)
    index.value = new_index
    current.value = list(new_index)
    hasPrev.value = new_index > 0
    hasNext.value = new_index < (list.length - 1)
  }
  
  /*
   * Adds a new history item to the end.
   */
  def addLast(str: T) {
    list += str
    last()
  }

  /*
   * Commits the "current history" and opens a new one.
   */
  def commitCurrent(str: T) {
    val end = list.length - 1
    list(end) = str
    list += _default
    last()
  }
  
  
  // Navigation
  def prev(): T = {
    updateMovement(index.value - 1)
    current.value
  }
  
  def next(): T = {
    updateMovement(index.value + 1)
    current.value
  }
  
  def last(): T = {
    updateMovement(list.length - 1)
    current.value
  }
  
}


class CommandManager extends HistoryManager[String]("#welcome","")
