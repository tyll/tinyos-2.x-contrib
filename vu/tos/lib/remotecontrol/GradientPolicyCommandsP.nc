module GradientPolicyCommandsP {
  provides interface IntCommand;
  uses interface GradientField;
} implementation {

	/**** remote command ****/

	command void IntCommand.execute(uint16_t param)
	{
		uint16_t ret = 0xFFFF;

		if( param == 0 )
			ret = call GradientField.rootAddress();
		else if( param == 1 )
			ret = call GradientField.hopCount();
		else if( param == 2 )
		{
			call GradientField.beacon();
			ret = SUCCESS;
		}

		signal IntCommand.ack(ret);
	}

}
