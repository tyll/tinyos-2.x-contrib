package simx.react.gui.console

import javax.swing._
import java.awt.event._
import javax.swing.text._


object Output {

  def normalizeStr(str: String) =
    if (str.size > 0 && str.last == '\n') str else str + "\n"
}	
  
abstract case class Output() {
  def text: String
  def style: String
}

case class Error(text: String) extends Output {
  val style = "bold"
}

case class Result(text: String) extends Output {
  val style = "italic"
  
}

case class Warning(text: String) extends Output {
  val style = "italic"
}


class ConsoleStyledDocument extends DefaultStyledDocument {
  {
    val default_style = StyleContext.getDefaultStyleContext().
      getStyle(StyleContext.DEFAULT_STYLE)
    
    val regular = addStyle("regular", default_style)
    StyleConstants.setFontFamily(regular, "SansSerif")

    val italic = addStyle("italic", regular)
    StyleConstants.setItalic(italic, true)
    
    val bold = addStyle("bold", regular)
    StyleConstants.setBold(bold, true)
      
    // this doesn't work, it just moves the JSeparator, see makeDivStyle
    val div = addStyle("div", regular)
    val div_comp = new JSeparator
    StyleConstants.setComponent(div, div_comp)
  }
  
  val sc = new StyleContext // like, wtf mate
  def makeDivStyle = {
    // PST-- 2.7.2.RC1 has a bug wrt inner classes. This is fixed in trunk.
    //val style = new sc.NamedStyle()
    //StyleConstants.setComponent(style, new JSeparator)
    //style
    getStyle("div")
  }
  
  def append(str: String, style_str: String) {
    val style = if (style_str == "div") makeDivStyle
                else getStyle(style_str)
    append(str, style)
  }
    
  def append(str: String, style: Style) {
    val len = getLength()	
    insertString(len, str, style)
  }
}
