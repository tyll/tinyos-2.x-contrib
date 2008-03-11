/*
 * Authors:		Leon Evers
 * Date last modified:  25/10/07
 */

/**
 * @author Leon Evers
 */


includes SensorScheme;

/**
 * Interface to the SensorScheme runtime engine
 *
 */

interface SSRuntime {

  /**
   * Evaluate a primitive
   *
   * @param prim the primitive
   *
   * @return the result of calling this primitive.
   */
  command ss_val_t getArgs();
  command void setArgs(ss_val_t val);

  command ss_val_t getValue();
  command void setValue(ss_val_t val);
  
  command ss_val_t getStack();
  command void setStack(ss_val_t val);

  command ss_val_t getEnvir();
  command void setEnvir(ss_val_t val);
  
  command ss_val_t makeNum(int32_t n);  
  command int32_t numVal(ss_val_t c);  
  command int32_t ckNumVal(ss_val_t c);
  
  command ss_val_t ckArg1();
  command ss_val_t ckArg2();  
  
  command void error(int16_t v);

  command ss_val_t cons(ss_val_t a, ss_val_t b);

  command ss_val_t getTimerQueue();
  command void setTimerQueue(ss_val_t val);

  command uint32_t now();
  command void startTimer(uint32_t t);

}
