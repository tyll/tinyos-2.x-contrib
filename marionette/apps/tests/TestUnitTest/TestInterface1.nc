interface TestInterface1 
{
  command void testCommand1();
  command error_t testCommand3(uint8_t something);
  command error_t* testCommand4(uint8_t something, uint16_t* data);
}
