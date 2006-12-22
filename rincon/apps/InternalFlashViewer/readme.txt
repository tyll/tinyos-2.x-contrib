This FlashBridgeViewer is similar to the FlashViewer application
previously uploaded to tinyos-1.x/contrib/rincon/apps/FlashViewer,
except it doesn't use the BlockStorage interface.

It uses the FlashBridge interface, which is a general
flash interface designed to minimize behavior differences between 
many different flash chips, allowing apps that use the flash to 
be compatible with many different motes.

You can use the FlashBridge for any app that requires access to flash 
and should expect it to work the same across all mote types.  Developers
are encouraged to port the FlashBridge to other flash types as needed.

Although you can compile and install this application on the mote
alone from this directory, you can also include the FlashBridgeViewerC 
component in any application where you want to dig down into the flash.
Take a look at that BlackbookConnect, for example.  I just 
added in the component FlashBridgeViewerC (and made sure the
Makefile knew where it was) and then wired up Main.StdControl to it.
Whammo.  BlackbookConnect doubled its effectiveness, and people can
compile in BlackbookConnect to the mote, make changes to the file
system, and see those changes on the flash.

Below are some examples to show you what this puppy does.
You'll also need the com.rincon.flashbridgeviewer Java application
to be located in your own tools/java directory.

Finally, one more thing to mention is you'll need to specify
which flash type you're compiling for in the Makefile.
If you're working with a mica- type mote, you've got an AT45DB flash,
and with a tmote, you've got an ST M25P80 flash (STM25P).

@author David Moss (dmm@rincon.com)



I always alias "flashbridge" to "java com.rincon.flashbridgeviewer.FlashViewer"
just so you know what's going on...


First let's take a look at what commands we have available from the
FlashBridge.  Compile FlashBridgeViewerTest or BlackbookConnect or something
to the mote and connect to the mote with your serial forwarder.  Then...


$ flashbridge
No arguments found
Usage: java com.rincon.flashviewer [mote] [command]
  COMMANDS
    -read [start address] [range]
    -write [start address] [22 characters]
    -erase [sector]
    -flush
    -crc [start address] [range]
    -ping


Let's ping the mote to see if we have FlashBridgeViewer installed:
$ flashbridge -ping
Pong! The mote has FlashViewer installed.


Great, now let's read a page of data:
$ flashbridge -read 0 0x100
0x0 to 0x100
_________________________________________________
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |   
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |


Let's write some data.  The FlashBridge itself lets you
write as much data at a time as you want, but our TOS_Msg's being
passed back and forth over UART only hold so much.  And there's
not much you can specify on the command line anyway, so here's what 
happens:

$ flashbridge -write 0x0 hello_flashbridge!
Writing data
0x68 0x65 0x6c 0x6c 0x6f 0x5f 0x66 0x6c 0x61 0x73 0x68 0x62 0x72 0x69 0x64 0x67
0x65 0x21
SUCCESS: 18 bytes written to 0x0


We'll read 0x20 bytes back from 0x0 to make sure what we wrote exists:
$ flashbridge -read 0 0x20
0x0 to 0x20
_________________________________________________
68 65 6C 6C 6F 5F 66 6C   61 73 68 62 72 69 64 67   |  hello_fl  ashbridge
65 21 FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |   !                

Keep in mind that the AT45DB flash doesn't necessarily put what you wrote
onto the physical flash until you flush it out, so here's how you flush:

$ flashbridge -flush
SUCCESS: Flush complete


We can take the CRC of the data we just wrote:
$ flashbridge -crc 0x0 18
SUCCESS: CRC is 0x6D3F


And we can erase the entire sector.  FlashBridge was designed for sector
erases, which you can actually go in and edit if you want - but it's not
entirely recommended.  The ST M25P80 flash erases in sector-lengths, which 
is 64kB at a time.  Atmel's AT45DB flash chip erases in page-lengths, which
is 256B at a time.  To maintain compatibility between the two chips,
FlashBridge erases the full 64kB at a time on both the AT45DB and the STM25P
chips.  It can probably be done faster on the AT45DB implementation
than it is right now, but I haven't programmed any of the block erase
stuff that the chip actually supports.

Another option would be to go in and edit the FlashSettings.h
file for the AT45DB and define smaller sector sizes and readjust
all those flash parameters, and that should maintain compatibility as well.

So let's erase.  It takes about 1 second/sector - which is 1 second per erase.
$ flashbridge -erase 0             
SUCCESS: Sector 0 erase complete   

And for that AT45DB you'll want to flush after that as well to make sure
changes are commmited to flash.



Now let's read back address 0x0:
$ flashbridge -read 0 0x100
0x0 to 0x100
_________________________________________________
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                     
FF FF FF FF FF FF FF FF   FF FF FF FF FF FF FF FF   |                    


Cool.

