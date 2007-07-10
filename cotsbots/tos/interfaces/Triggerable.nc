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

interface Triggerable {

/**
* events triggers and should do someting
* @return nothing, you should tell it what to do when it triggers though 
*/
event void trig(int ID);
}
