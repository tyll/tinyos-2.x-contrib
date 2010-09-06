COMPONENT=BluetoothTesterAppC
BUILD_EXTRA_DEPS += Flurec.h

Flurec.h:
        mig c -target=null -c-prefix=flurec bttester.h flurec_t -o $@

include $(MAKERULES)

