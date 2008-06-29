package nescdt.completor;

/**
 * It represents a string somewhere in the program that can be used for 
 * auto completion (pressing CTRL + SPACE)
 */
public class CompletionToken {
  String key;
  String val;
  
  /**
   * The properties are set in the constructor.
   * @param key
   * @param val
   */
  public CompletionToken(String key, String val){
	this.key = key;
	this.val = val;
  }
  
  public String getKey(){
	  return this.key;
  }

  public String getVal(){
	  return this.val;
  }
}
