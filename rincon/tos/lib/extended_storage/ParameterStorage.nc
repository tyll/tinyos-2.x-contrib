
/**
 * @author David Moss
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */
 
interface ParameterStorage {

  /**
   * Get the data from the correct location from an extended structure
   * @param *extendedParameters Location of the extendedParameters array
   *     in the struct of interest
   */
  command void *load(void *extendedParameters);
  
  /**
   * Set the data in the correct location in an extended structure
   * @param *extendedParameters Location of the extended structure array
   *     in the struct of interest
   * @param *parameter the parameter to store
   */
  command void store(void *extendedParameters, void *parameter);
  
}

