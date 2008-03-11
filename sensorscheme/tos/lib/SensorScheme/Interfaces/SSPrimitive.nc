/*
 * Authors:		Leon Evers
 * Date last modified:  25/10/07
 */

/**
 * @author Leon Evers
 */


includes SensorScheme;

/**
 * Interface for evaluating SensorScheme primitives
 *
 */

interface SSPrimitive {

  /**
   * Evaluate a primitive
   *
   * @return the result of calling this primitive, or the new value of args 
   * in case it its used as an evalPrim or applyPrim.
   */
  
  command ss_val_t eval();

}
