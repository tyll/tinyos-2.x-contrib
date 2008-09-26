configuration DS2770C
{
  provides
  {
    interface DS2770;
  }

}

implementation
{
  components DS2770M, TimerC;

 DS2770 = DS2770M.DS2770;
 DS2770M.Timer -> TimerC.Timer[unique("Timer")];
 
 
}
