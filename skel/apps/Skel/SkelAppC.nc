/* 
*/

configuration SkelAppC {
}
implementation {
  components MainC, SkelC;

  SkelC -> MainC.Boot;
}
