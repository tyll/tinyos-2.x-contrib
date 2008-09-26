

interface SGWakeup
{
  command result_t wake ();
  event result_t wakeDone ();
  command result_t sleep ();
  event result_t sleepDone (result_t success);
  command bool isawake ();
  command bool isready ();
  command uint16_t getLoad ();
  command result_t upLoad();
  command bool getConnection (uint16_t * idx);
  event result_t pathDone(uint16_t num, uint32_t elapsed);
}
