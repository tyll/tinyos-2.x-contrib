/**
 * Init the port that the RV8564 chip is generating its tics to (TB0 in).
 *
 * @author Henrik Makitaavola
 */
module RV8564AlarmCounterMilli32P
{
  provides interface Init;
  uses interface GeneralIO as IO;
}
implementation
{
  command error_t Init.init()
  {
    call IO.makeInput();
    call IO.clr();
    return SUCCESS;
  }
}
