

interface GPRS
{
	event void ready();
	command result_t ATCmd(char *cmd, char *match, uint32_t waitms);
	event void ATCmdDone(result_t result, char *response);
}
