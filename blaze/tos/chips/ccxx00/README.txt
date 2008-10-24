
Documentation is located in the TinyOS documentation website:
http://docs.tinyos.net/index.php/CC1100/CC2500

This radio stack requires fast SPI bus access. For MSP430 platforms, that
means compiling your applications with:

  CFLAGS+=-DENABLE_SPI0_DMA

This radio stack was developed and funded by Rincon Research Corporation.

