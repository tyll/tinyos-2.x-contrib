/* ADE7753 power chip wiring; to be used on powerNet board
* @author Maria Kazandjieva <mariakaz@cs.stanford.edu>
* @date Nov 18, 2008
*/ 

configuration ADE7753C {
    provides interface ADE7753;
}

implementation {
    
    components LedsC;
    components ADE7753P;
    components new Msp430Spi1C() as SpiC;
    components HplMsp430GeneralIOC;
    components MainC;
   
    ADE7753 = ADE7753P; 
    MainC.SoftwareInit -> ADE7753P.Init;
    ADE7753P.CS -> HplMsp430GeneralIOC.Port54;
    ADE7753P.ONOFF -> HplMsp430GeneralIOC.Port21;
    ADE7753P.Resource -> SpiC.Resource;
    ADE7753P.SpiPacket -> SpiC.SpiPacket;
    ADE7753P.Leds -> LedsC;

    // wire Msp430SpiConfigure to us;
    // we provide the settings for the TCTL register
    SpiC.Msp430SpiConfigure -> ADE7753P; 
}
