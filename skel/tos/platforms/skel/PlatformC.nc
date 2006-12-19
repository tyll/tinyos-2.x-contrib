/*
 * @author Martin Leopold
 */

configuration PlatformC
{
  provides interface Init;
}
implementation
{
 components PlatformP;

 Init = PlatformP;
}
