/******************************************************************
    CC2420RssiC.nc created by HyungJune Lee (abbado@stanford.edu)
 ******************************************************************/

generic configuration CC2420RssiC()
{
	provides interface Resource;
	provides interface CC2420Register as RSSI;
}

implementation
{
	enum
	{
		SPI_ID = unique("CC2420Spi.Resource")
	};
	components CC2420SpiP as Spi;

	Resource = Spi.Resource[SPI_ID];
	RSSI = Spi.Reg[CC2420_RSSI];	
}

