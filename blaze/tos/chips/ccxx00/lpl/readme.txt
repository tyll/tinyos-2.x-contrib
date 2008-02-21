The CCxx00 radio stack is structered to support multiple low power
communication personalities.  The implementations of these personalities
exist in separate directories. 

Only one directory should be allowed to compile into your application.
If you make a mistake and attempt to compile multiple low power communication
personalities in at compile time, the BLAZE_LPL_DEFINED preprocessor 
variable will prevent you from compiling.

Your platform MUST select exactly one low power communications personality at
compile time.
