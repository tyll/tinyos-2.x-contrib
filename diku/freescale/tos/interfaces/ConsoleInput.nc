interface ConsoleInput
{
  /** Get data from "stdin".
      We need this method to be able to use the Uarts and you can connect to
      it to get any data send remotely to the uart/pipe/whatever. 
      @param data Value received
      @return Just return SUCCESS */
  async event void get(uint8_t data);

}
