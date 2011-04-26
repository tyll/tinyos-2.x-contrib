#include "Sensors.h"

generic configuration SensorsC() {
	provides interface Read<uint16_t>[uint8_t type];
} implementation {
	components new PhotoC() as Photo;
	components new TempC() as Temp;
	components new VoltageC() as Voltage;
	components new SineSensorC() as Sine;

	Read[SENSOR_TYPE_PHOTO] = Photo;
	Read[SENSOR_TYPE_TEMP] = Temp;
	Read[SENSOR_TYPE_VOLTAGE] = Voltage;
	Read[SENSOR_TYPE_SINE] = Sine;
}
