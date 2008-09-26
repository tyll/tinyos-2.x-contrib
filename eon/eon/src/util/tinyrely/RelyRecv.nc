includes TinyRely;

interface RelyRecv
{
  
  

  event result_t receive(uint8_t connid, RelySegmentPtr msg);
}
