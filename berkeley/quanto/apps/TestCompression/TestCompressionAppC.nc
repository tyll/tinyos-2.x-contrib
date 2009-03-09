configuration TestCompressionAppC {
}
implementation {
	components MainC, TestCompressionC;
	TestCompressionC -> MainC.Boot;

	components new MoveToFrontC() as MtF;
	TestCompressionC.MoveToFront -> MtF;
	
	components new BitBufferC(200) as BB;
	components EliasGammaC, EliasDeltaC;
	TestCompressionC.BitBuffer -> BB;
	TestCompressionC.EliasGamma -> EliasGammaC;
	TestCompressionC.EliasDelta -> EliasDeltaC;

   components LedsC;
   TestCompressionC.Leds -> LedsC;

   //components QuantoLogCompressedMyUartWriterC;
}



