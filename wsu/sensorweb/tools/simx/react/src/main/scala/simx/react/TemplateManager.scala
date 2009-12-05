package simx.react

import scala.xml._
import java.io.{File, FilenameFilter}
import java.util.regex._
import scala.xml

object Template {
  
  var defaultPath = "templates"
  
  // Characters to strip during normalization
  val illegalChar = Pattern.compile("[^a-zA-Z0-9]")
  
  def fromXML(source: xml.Node): Seq[Template] = {
    for (t <- (source \\ "template").take(1)) yield {
      val category = (t \\ "@category").map(_.text).mkString("")
      val description = (t \\ "@description").map(_.text).mkString("")
      val body: String = (t \\ "line").map(_.text).mkString("\n")
      new Template(category, description, body)
    }
  }
  
  def fromFile(f: File): Seq[Template] = {
    val templates = fromXML(XML.loadFile(f))
    if (templates.size > 1) {
      Log.error("This is not good")
    }
    for (t <- templates) yield
      t withFile Some(f)
  }
  
}

class DummyTemplate extends Template("none", "dummy") {
  text = "this template should not exist"
}

class Template(_category: String, _short: String) extends {
  val category = _category.trim.toLowerCase
  val short = _short.trim
} with Object {
  
  var text = ""
  var file: Option[File] = None
  
  def this(_category: String, _descr: String, _body: String) {
    this(_category, _descr)
    text = _body
  }
  
  def withFile(f: Option[File]) = {
    file = f
    this
  }
  
  lazy val normalizedName: String = {
    val c = Template.illegalChar.matcher(category)
    val s = Template.illegalChar.matcher(short)
    c.replaceAll("").toLowerCase + "_" + s.replaceAll("").toLowerCase
  }
  
  /**
   * Is the template "valid"?
   * Only templates with correctly normalized names are valid
   */
  def valid: Boolean = {
    val i = normalizedName.indexOf("_")
    i > 0 && i < (normalizedName.length - 1)
  }
  
  /**
   * Generate a default file for a template using some heuristic.
   */
  def defaultFile: File = {
    file getOrElse (new File(Template.defaultPath, normalizedName + ".xml"))
  }
  
  /**
   * Returns XML for template.
   */
  def toXML(): xml.Node = {
    <template category={category} description={short}>{
      for (l <- text.split("\n")) yield <line>{l}</line>
    }</template>
  }
  
  /**
   * Save a template.
   */
  def save: Unit = save(defaultFile)
  def save(f: File) {
    XML.save(f.getPath, toXML)
  }
  
  def xml_ext_?(f: File) = f.getName.toLowerCase.endsWith(".xml")
  
  /**
   * Delete the file associated with this template.
   * 
   * Returns true iff the file was deleted. Refuses to delete files that
   * do not end in '.xml'
   */
  def delete = file match {
    case Some(file) => if (!xml_ext_?(file)) {
      Log.warn("Refusing to delete non-XML file")
      false
    } else {
      file.delete()
      true
    }
    case None => false
  }
  
}


object TemplateManager {
  
  /**
   * Returns list of files which have a specific extension.
   * The extension should not include the dot, for example,
   * "xml" or "html" suffice for ext.
   */
  def filesInDirectory(path: File, ext: String): Seq[File] = {
    val filter = new FilenameFilter {
      def accept(dir: File, name: String): Boolean =
        name.toLowerCase.endsWith("." + ext)
    }
    path.list(filter).toList.map(new File(_))
  }
    
  /**
   * Create a template manager and load templates from the given path.
   */
  def loadFromPath(path: String): TemplateManager = {
    val dir = new File(path)
    if (dir.isDirectory) {
      new TemplateManager(
        for {
          x <- filesInDirectory(dir, "xml")
          t <- Template.fromFile(new File(dir.getName, x.getName))
        } yield {
          t
        })
    } else {
      new TemplateManager
    }
  }
  
}
  

import scala.collection.mutable
class TemplateManager() {

  val change_hook = new mutable.ListBuffer[() => Unit]()
  
  val templates = new mutable.ListBuffer[Template]()
  
  def this(initial: Seq[Template]) = {
    this()
    for (t <- initial)
      add(t)
  }
        
  def forCategory(c: String): Seq[Template] = {
    null
  }
  
  /**
   * Add a template to the template manager.
   * If adding the template would cause duplication, it is not added and
   * false is returned. Invalid templates are also not added.
   */
  def add(new_t: Template): Boolean = {
    if (!new_t.valid) {
      Log.error("Refusing to add invalid template")
      return false
    }
    for (t <- templates) {
      if (t.normalizedName == new_t.normalizedName) {
        Log.error("Refusing to add duplicate template")
        return false
      }
    }
    templates += new_t
    for (h <- change_hook)
      h()
    true
  }
  
  /**
   * Remove a template from the manager
   */
  def remove(t: Template) = {
    templates -= t
    for (h <- change_hook)
      h()
  }
  
}
