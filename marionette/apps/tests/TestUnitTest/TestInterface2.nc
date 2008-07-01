interface TestInterface2
{
  event void testEvent1();
  event error_t testEvent3(uint8_t something);
  event error_t* testEvent4(uint8_t something, uint16_t* data);
}
