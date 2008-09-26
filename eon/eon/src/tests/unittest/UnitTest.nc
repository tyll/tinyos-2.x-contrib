interface UnitTest
{
	command result_t StartTest();
	event result_t TestDone(result_t test_timedout);
}

