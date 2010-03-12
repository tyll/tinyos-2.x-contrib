package simx.react.util

import javax.swing.JOptionPane
import simx.react.message.ReactReply

object StatusDisplay {

  def showError(body: String, title: String) {
    JOptionPane.showMessageDialog(null, body, title, JOptionPane.ERROR_MESSAGE)
  }
    
  def showReply(re: ReactReply.Msg) = EDT.run {
    import JOptionPane.{INFORMATION_MESSAGE, ERROR_MESSAGE}
    val (title, style) = re.get_status match {
      case ReactReply.SUCCESS => ("Success", INFORMATION_MESSAGE)
      case ReactReply.FAILURE => ("Failure", ERROR_MESSAGE)
      case ReactReply.UNSOLICITED => ("Announcement", INFORMATION_MESSAGE)
      case x => ("Unknown status: " + x, ERROR_MESSAGE)
    }
    //PST-- makes message look funny
    val body = re.refinements.mkString("\n\r")
   // println(body)
    JOptionPane.showMessageDialog(null, body, title, style)
  }

}
