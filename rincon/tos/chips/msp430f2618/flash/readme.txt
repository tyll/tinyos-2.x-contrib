The internal flash on the msp430f1611 is 256 bytes long, divided into
two erasable segments of 128 bytes each.  The flash is mass erased
automatically when you install an application through bsl.

Writing will make bits go from 1->0, erase will make bits go from 0->1.
If you try to write over the top of existing data, the resulting
byte will == (existing byte NOR new byte), i.e. any 0's in either
the existing byte or the new byte will end up as 0's on flash.  
This property can be useful in some cases. 

Flush is not implemented, but it is on other platforms.  If the msp430
is the only flash you plan on running your application on, then there
is no need to call flush().  Otherwise, calling flush() after you have
written data will support cross-platform compatibility.

Msp430StorageModifyC_NFT is the version of StorageModify that does not
support fault tolerance, and is not in use.  However, you get access to the 
full 256 bytes of internal flash at the expense of RAM.

@author David Moss

