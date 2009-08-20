
configuration AvailableRadiosC {
  provides {
    interface AvailableRadios;
  }
}

implementation {

  components Ccxx00PlatformInitP;
  components AvailableRadiosP;
  
  AvailableRadios = AvailableRadiosP;
  
  Ccxx00PlatformInitP.RadioPlatformInit -> AvailableRadiosP;
  
  components BlazeSpiC;
  AvailableRadiosP.PARTNUM -> BlazeSpiC.PARTNUM;
  AvailableRadiosP.VERSION -> BlazeSpiC.VERSION;
  
}

