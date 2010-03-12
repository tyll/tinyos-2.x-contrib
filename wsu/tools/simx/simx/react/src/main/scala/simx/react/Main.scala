package simx.react

import packet._

import javax.swing.event._
import java.awt._
import java.awt.event._
import java.io._

import net.tinyos.message._

import gui._
import util._
import bridge._
import actor.MoteActor

object Log extends react.util.Logger()

object Boot {
  val DEFAULT_POST_DELAY = 4000
  val DEFAULT_ACT_SERVER = "sf@localhost:9091"
  
  def main(args: Array[String]) {
    val connection_delay = DEFAULT_POST_DELAY
    
    val target = if (args.length > 0) {
      args(0)
    } else {
      DEFAULT_ACT_SERVER
    }
    
    LayoutGap.useThinGaps(0.3f)
    
    val conn = new ConnectionFrame()
    Log.add(conn)
    conn.setVisible(true)

    {
      val m = Log.debug _
      m("======================================================")
      m("Welcome to React")
      m("------------------------------------------------------")
      m("Establishing a connection to the Act server;")
      m("when connected the main UI will open.")
      m("Close this window to abort.")
      m("======================================================")
      m("Connecting to " + target + "...")
    }
    
    // Blocks until a connection can be established
    // (and the start of the problems :-/)
    val phoenixBridge = new PhoenixManager(target)
    
    Log.debug("Connected to " + target)
    
    val main = new Main(phoenixBridge)
    Log.debug("create main")
    // After all the components are wired wait for a period of time
    // and change displayed frames.
    import javax.swing.Timer
    val timer = new Timer(connection_delay, new ActionListener {
      def actionPerformed(ae: ActionEvent) {
        main.mainFrame.show()
        conn.dispose()
        Log.remove(conn)
      }
    })
    timer.setRepeats(false)
    timer.start()
    
    Log.debug("[Pausing " + connection_delay + "ms]")
  }
}

case class RestoreFrame(s: Symbol) extends TriggerEvent

class Main(phoenix_bridge: PhoenixManager)
extends EventHandler with EventTrigger {
  import Boot._
  
  val config = new Configuration()
  try {
    Log.debug("Loading config...")
    config.load()
  } catch {
    case e =>
      Log.debug("Failed to load configuration: " + e.getMessage)
  }

  Log.debug("Starting actors"+phoenix_bridge.mote)
  val mote_actor = new MoteActor(phoenix_bridge.mote)
  Log.debug("new actors")
  mote_actor.start()
  Log.debug("Attaching dispatch")

  PacketDispatch.connect(phoenix_bridge.mote, mote_actor)

  val cmd_bridge = new CommandBridge(mote_actor)
  val topo_bridge = new TopoBridge(mote_actor)
  val watch_bridge = new WatchBridge(mote_actor)
  val probe_bridge = new ProbeBridge(mote_actor)
  val time_bridge = new TimeControlBridge(mote_actor)


  Log.debug("******building bridge");



  Log.debug("Creating interface...")
  
  val mainFrame = new MainFrame(config)
  
  // When main window terminates, so do we ...
  mainFrame.addWindowListener(new WindowAdapter {
    override def windowClosed(we: WindowEvent) = exit()
  })

  /*
   * Perform exit activies and terminate with 0.
   */
  def exit() {
    import java.io.IOException
    Log.debug("Saving configuration")
    try {
      config.save()
    } catch {
      case e: IOException =>
        Log.error("Failed to save configuration: " + e.getMessage)
    }
    System.exit(0)
  }
  
  def setConnectedTitle() {
    mainFrame.setTitle("React: " + phoenix_bridge.name)
  }
  
  def setDisconnectedTitle(str: String) {
    mainFrame.setTitle("React: " 
                       + phoenix_bridge.name
                       + " (DISCONNECTED: " + str + ")")	
  }

  // Set connection listener
  phoenix_bridge.addHandler(this)
  
  setConnectedTitle()
  
  val manager = TemplateManager.loadFromPath("templates")
  val templateFrame = new TemplateFrame(manager)
  templateFrame setVisible true
    
  val consoleFrame = new gui.console.ConsoleFrame(cmd_bridge, templateFrame, config)
  consoleFrame setVisible true
  
  // Links templates to console input
  templateFrame.addHandler(consoleFrame)

  val timeFrame = new TimeControlFrame(time_bridge)
  timeFrame setVisible true
  
  val topoFrame = new TopoFrame(topo_bridge)
  topoFrame setVisible true
   
  val watchFrame = new WatchFrame(watch_bridge)
  watchFrame setVisible true

  val probeBindFrame = new ProbeBindFrame(probe_bridge)
  probeBindFrame setVisible true
  
  val probeWatchFrame = new ProbeWatchFrame(probe_bridge)
  probeWatchFrame setVisible true

  val valueWatchFrame = new ValueWatchFrame(probe_bridge,watch_bridge)
  valueWatchFrame setVisible true
  
  {
    import mainFrame.{desktopPane => desktop}
    val frames = scala.List(timeFrame, consoleFrame, topoFrame,
                            templateFrame,watchFrame,
                            probeBindFrame, probeWatchFrame,valueWatchFrame)
    for (frame <- frames)
      desktop.add(frame)
  }
  
    /*
  watchFrame setVisible true

  {
    import mainFrame.{desktopPane => desktop}
    val frames = scala.List(timeFrame, consoleFrame, topoFrame,
                            watchFrame, templateFrame,
                            probeBindFrame, watchFrame)
    for (frame <- frames)
      desktop.add(frame)
  }
  */
  /*
   * Iconify/deiconify frame -- bring to front when deiconified.
   */
  def toggleFrame(frame: javax.swing.JInternalFrame) = if (frame.isIcon) {
    frame.setIcon(false)
    frame.moveToFront()
  } else {
    frame.setIcon(true)
  }
  
  def respond(event: TriggerEvent) = event match {
    case RestoreFrame('time) => toggleFrame(timeFrame)
    case RestoreFrame('console) => toggleFrame(consoleFrame)
    case RestoreFrame('topo) => toggleFrame(topoFrame)
    case RestoreFrame('watch) => toggleFrame(watchFrame)
    case RestoreFrame('probeBind) => toggleFrame(probeBindFrame)
    case RestoreFrame('probeWatch) => toggleFrame(probeWatchFrame)
    case RestoreFrame('valueWatch) => toggleFrame(valueWatchFrame)
    //case RestoreFrame('probeWatch) => toggleFrame(watchFrame)
    case RestoreFrame('template) => toggleFrame(templateFrame)
    case RestoreFrame(x) => Log.debug("Don't know how to restore: " + x)
    case PhoenixSourceUp() => setConnectedTitle()
    case PhoenixSourceDown(msg) => setDisconnectedTitle(msg)
  }
  
  // For "RestoreFrame"
  mainFrame.addHandler(this)
            
}
