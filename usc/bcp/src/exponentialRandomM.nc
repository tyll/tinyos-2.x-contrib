generic module exponentialRandomM(uint32_t mean_g){
  provides interface Random;
  provides interface Set<uint32_t> as setMean;
  uses interface Random as subRandom;
}
implementation{

  uint32_t mean_m = mean_g;

  command void setMean.set( uint32_t mean_p )
  {
    atomic{
      mean_m = mean_p;
    }
  }

  /** 
   * Produces a 32-bit exponential random output. 
   * @return Returns the 32-bit pseudorandom number.
   */
  async command uint32_t Random.rand32()
  {
    uint32_t num_iterations = 0;
    uint32_t init_rand_instance = 0, curr_rand_instance = 0;
    uint32_t exp_rand_variable = 0;
    bool done = FALSE;

    while( !done )
    {
      num_iterations = 1;

      init_rand_instance = call subRandom.rand32();
      curr_rand_instance = init_rand_instance;
      while( curr_rand_instance <= init_rand_instance )
      {
        curr_rand_instance = call subRandom.rand32();
        num_iterations++;
      }

      if( num_iterations % 2 > 0 )
      {
        // Try again
        // The odds of 2^32 attempts are so small that
        //  I'm not going to check for rollover
        exp_rand_variable++;
      } else {
        atomic{
          // Done, add initial random variable
          // Don't have rollover dectection here... hopefully OK
          exp_rand_variable *= mean_m;

          // It's possible that this final addition causes rollover
          //  But this should be far out at the tail of the dist.
          exp_rand_variable += init_rand_instance % mean_m;
        }
        done = TRUE;
      }
    }
    // Scale exponential average
    return exp_rand_variable;
  }

  /** 
   * Produces a 16-bit exponential random output.
   * Note this is only approximately exponential, due to tail
   *  truncation. 
   */
  async command uint16_t Random.rand16()
  {
    uint32_t bigRand = call Random.rand32();
    uint16_t retVal = (uint16_t)(bigRand && 0x00FF);
    if( bigRand > 0xFF )
      return 0xFF;
    else
      return retVal;
  }

}
