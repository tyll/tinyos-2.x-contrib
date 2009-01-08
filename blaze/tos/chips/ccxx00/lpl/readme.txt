The CCxx00 radio stack is structered to support multiple low power
communication personality plug-ins.  The implementations of these plug-ins
exist in separate directories. 

Only one plug-in should be allowed to compile into your application.
If you make a mistake and attempt to compile multiple low power communication
personalities in at compile time, the BLAZE_LPL_DEFINED preprocessor 
variable will prevent you from compiling.

Your platform MUST select exactly one low power communications personality at
compile time.



LOW POWER COMMUNICATIONS PLUG-IN STATUS
* alwayson works <- recommend.
* bmac works <- recommend.

* xmac works, but receive checks are not very efficient

* boxmac1 shell is complete, needs testing
* boxmac2 shell is complete, needs testing

* WoR has reliability and range issues

