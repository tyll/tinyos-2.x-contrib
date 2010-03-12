package simx.react.message

import net.tinyos.message.Message

/*
 * Message with ID...
 */
abstract trait Tracker { Message =>
  val track_id: Int
}