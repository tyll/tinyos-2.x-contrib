generic configuration exponentialRandomC(uint32_t mean_g){
  provides interface Random;
  provides interface Set<uint32_t> as setMean;
}
implementation{
  components new exponentialRandomM( mean_g );
  components RandomC;

  exponentialRandomM.subRandom -> RandomC;
  exponentialRandomM = Random;
  exponentialRandomM = setMean;
}
