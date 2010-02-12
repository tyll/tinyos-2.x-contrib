generic configuration SHT15C() {
  provides interface Read<uint16_t> as Temperature;
  provides interface Read<uint16_t> as Humidity;
}
implementation { 
components ArbitratedSHT15P;

  Temperature = ArbitratedSHT15P.Temperature[];  
  Humidity = ArbitratedSHT15P.Humidity[];
}
