module HplStm25pSpiConfigC {
	provides interface Msp430SpiConfigure;
}
implementation {
	msp430_spi_union_config_t msp430_spi_sib_config = { 
	  { 
	    ubr : 0x0005, // /5, -> about 4Mhz
	    clen : 0, 
	    mm : 1, 
	    ckph : 1, 
	    ckpl : 0, 
	    sync : 1,
	    mode : 0,
	    msb : 1,
	    ssel : 0x02, // SMCLK 
	  } 
	};
	
	async command msp430_spi_union_config_t* Msp430SpiConfigure.getConfig() {
		return &msp430_spi_sib_config;
	}

}
