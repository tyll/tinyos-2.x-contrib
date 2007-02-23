COMPONENT = DSNBootC

CFLAGS += -Wl,--section-start
CFLAGS += -Wl,.text=0xf200
CFLAGS += -Wl,--defsym=_reset_vector__=0xf200
// POST_BUILD_EXTRA_DEPS += strip_iv

strip_iv: FORCE
	@echo "    removing interrupt vector from binary"
	msp430-objcopy -j .text -j .data -O ihex $(BUILDDIR)/main.exe $(BUILDDIR)/main.ihex

include $(MAKERULES)


