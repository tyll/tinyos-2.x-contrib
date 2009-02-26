interface Stats
{
  /**
   * Reset (forget all sample pairs) statistics package 
   */
  command void reset();

  /**
   * Get number of sample pairs
   * @return Sample pair count
   */
  command uint32_t count();
  /**
   * Add a new sample pair
   * @param x X sample
   * @param y Y sample
   */
  command void data(uint32_t x, uint32_t y);

  /**
   * Estimate Y value for a given X
   * @param x X value to estimate Y for
   * @return estimated Y value
   */
  command float estimateY(uint32_t x);

  /**
   * Estimate X value for a given Y
   * @param y Y value to estimate X for
   * @return estimated X value
   */
  command float estimateX(uint32_t y);
}
