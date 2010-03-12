package simx.react

import scala.xml.XML

import react.util._

object Configuration {
  
  /*
   * Load the configuration from a specific file.
   * May raise an exception on loading the file.
   */
  def loadFile(filename: String, config: Configuration) = {
    val xml = XML.loadFile(filename)
    // Configuration is updated via side-effects of the schema}
    for (config_xml <- xml \\ "config")
      Marshall.retrieve(config_xml, config.schema)
  }
  
  def saveFile(filename: String, config: Configuration) {
    XML.save(filename, <config>Marshall.store(config.schema)</config>)
  }

}


/*
 * Handles configuration settings and bindings for React.
 */
class Configuration {
  
  def save() = Configuration.saveFile("config.xml", this)
  def load() = Configuration.loadFile("config.xml", this)
  
  // The magic of the schema is that it creates closures and hides the
  // implementation of how to get/set the actual values.
  def schema = List(Rule("console.autoscroll",
                         Console.autoScroll,
                         Marshall.Boolean, true),
                    Rule("console.autoresult",
                         Console.autoResult,
                         Marshall.Boolean, false),
                    Rule("layout.autosave",
                         Layout.autoSave,
                         Marshall.Boolean, true))
  
  object Console {
    val autoScroll = new Bind(true)
    val autoResult = new Bind(false)
  }
  
  object Layout {
    val autoSave = new Bind(true)
  }
    
}
