#ifndef TOSSIM
#error SimX/Sensor is only for use with TOSSIM
#else

#include <stdio.h>

/*
 * Create a component for the specified channel reading at the
 * specified read size.
 *
 * Up to 256 discreet channels are supported. Read sizes of up to 32
 * bits (uint32_t, int32_t) are supported.
 *
 * The same channels are used internally for all instantiations. That
 * is, new SensorC(0, <uint32_t>) and new SensorC(0, <uint8_t>) share
 * the same data source. Make sure the wires don't cross.
*/
/*
generic configuration SimxSensorC(uint8_t chan, typedef val_t @integer()) {
  provides interface Read<val_t>;
}
implementation {

  components
    new SimxSensorP(val_t) as Sensor,
    SimxSensorImpl32P as Sensor32,
    SimxPushbackC as Pushback;

  Sensor32.Pushback -> Pushback;
  Sensor.SubRead -> Sensor32.Read;
  Read = Sensor.Read[chan];
}*/



generic configuration SimxSensorC(typedef val_t @integer()){
    provides interface Read<val_t>[uint16_t id];
    provides interface SensorControl;
}
implementation {
    components
    new SimxSensorP(val_t) as Sensor,
    SimxSensorImpl32P as Sensor32,
    SimxPushbackC as Pushback;
    Sensor32.Pushback -> Pushback;
    Sensor.SubRead -> Sensor32.Read;
    Read = Sensor.Read;
    SensorControl=Sensor;
}



#endif
