


configuration SimEnergyC
{
  provides
  {
    interface Energy;
  }

}

implementation
{
  components SimEnergyM;
  
  Energy = SimEnergyM.Energy;

}
