
Turns out the generic Msp430RefVoltGeneratorP uses up quite a bit of 
ROM. If you know you're only going to be using a 1.5V reference or a 2.5V 
reference and not both, you can compile in whichever specific version you'd
like and it will slim down the ROM by not being so generic.

