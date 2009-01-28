The CCxx00 radio stack is structered to support multiple low power
communication personality plug-ins.  The implementations of these plug-ins
exist in separate directories. 

Only one plug-in should be allowed to compile into your application.
If you make a mistake and attempt to compile multiple low power communication
personalities in at compile time, the BLAZE_LPL_DEFINED preprocessor 
variable will prevent you from compiling.

Your platform MUST select exactly one low power communications personality at
compile time - except BOXMAC, which relies on the existence of BMAC.



LOW POWER COMMUNICATIONS PLUG-IN STATUS
* bmac + boxmac <-- works best for low power communications.
* alwayson works <- works
* bmac works <- works
* WoR has reliability and range issues and is no longer ccxx00 stack compatible.

