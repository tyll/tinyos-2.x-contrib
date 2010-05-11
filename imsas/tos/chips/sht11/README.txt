@author Philipp Sommers
@author Chanaka Lloyd <chanakalloyd@gmail.com>

================================================================================
 SHT11 Humidity/Temperature Sensor on pixie/meshbean-P1/meshbean 900 platforms
================================================================================

--------------------------------------------------------------------------------
 SHT 11        Pixie                 Atmega1281(ZigBit900)	Zigbit Amp
--------------------------------------------------------------------------------
 SCK  (1)      GPIO8    (P10.7)      PE3 (48)			GPIO6,PD6 (17)
 VDD  (2)      GPIO_1WR (P10.2)      PG5 (36)			GPIO7,PD7 (18)
 GND  (3)      DGND     (P10.10)     any			any
 DATA (4)      IRQ_7    (P10.8)      PE7 (42)			IRQ_7,KE2 (42)
--------------------------------------------------------------------------------

Notes:

1. Meshbean (Development kit on P1 board): PE3, PG5, and PE7 are used for 
   battery monitor, UID (for unique MAC addresses), and SW2 (as a switch for 
   user input). So, new pins had to be used.
2. Pin 17 and 18 are not connected on the Meshbean P1 board. So, they
   present no issue! If one need not use SW2 on the board, then Pin 42 can be
   used, too.
3. Although the name suggests Sht11, these codes can be applied to Sht7x, too.
