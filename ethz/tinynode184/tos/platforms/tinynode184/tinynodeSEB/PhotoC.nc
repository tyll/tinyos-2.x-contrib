
#include "tinynodeSEB.h"

generic configuration PhotoC() {
    provides {	
	interface Read<uint16_t>;
	interface ReadStream<uint16_t>;
    }
}

implementation {
    
    components new AdcReadClientC();
    Read = AdcReadClientC;
    
    components new AdcReadStreamClientC();
    ReadStream = AdcReadStreamClientC;
    
    components PhotoDeviceP;
    components new PhotoAdcP();
    AdcReadClientC.AdcConfigure -> PhotoAdcP;
    AdcReadStreamClientC.AdcConfigure -> PhotoAdcP;
    
    components MainC;
    MainC.SoftwareInit -> PhotoDeviceP;
    /*
      Photo = PhotoDeviceP;
      PhotoStream = PhotoDeviceP;
      PhotoDeviceP.ADCRead -> AdcReadClient;
      PhotoDeviceP.ADCReadStream -> AdcReadClient;
    */
}
