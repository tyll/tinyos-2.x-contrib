package simx.react.gui

import javax.swing.JFrame

import simx.react.guibase.ConnectionPanel
import simx.react.util.Logger

class ConnectionFrame
extends JFrame with Logger.Target {
    
  val connection_panel = new ConnectionPanel() {
    def puts(s: String) {
      logOutput.append(s)
      logOutput.append("\n")
    }
  }
  
  def log(event: Logger.Event) {
    connection_panel.puts(event.text)
  }
  
  setTitle("Starting React Client")
  getContentPane.add(connection_panel)
  setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)
  pack()
  // Center window -- don't ask
  setLocationRelativeTo(null)
      
}
