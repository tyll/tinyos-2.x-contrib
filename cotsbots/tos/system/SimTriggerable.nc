/*
* Triggerable.nc
* Interface for an CotsBots attachment that offers at LEAST a way to
* trigger it to return a message or act out an event.
*
* e.g. Whiskers
*
* Created by:
* Jameson J Lee
* 2007 - Fed - 21
*
*/

module SimTriggerable {
 uses interface Triggerable;
}

implementation{
/**
* events triggers and should do someting
* @return nothing, you should tell it what to do when it triggers though 
*/
event void Triggerable.trig(){
    dbg("Trig", "Triggerable Triggered! Sucess go to sleep now!\n");
    dbg("Trig", "Triggerable Triggered! Sucess go to sleep now!\n");
    dbg("Trig", "Triggerable Triggered! Sucess go to sleep now!\n");
    dbg("Trig", "Triggerable Triggered! Sucess go to sleep now!\n");
    dbg("Trig", "Triggerable Triggered! Sucess go to sleep now!\n");
}
   void sim_trig_signal(int itemID) __attribute__ ((C, spontaneous)){
  signal Triggerable.trig();
}

}
