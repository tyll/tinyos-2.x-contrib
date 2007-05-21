/**
 * @author David Moss (dmm@rincon.com)
 * @author Kevin Klues (klues@tkn.tu-berlin.de)
 */

This directory depends on the tos/lib/extended_storage library.

Extended storage is a proof-of-concept, fully functional library allowing 
structures to extend themselves at compile time based on what is compiled in 
with the system.   It's kind of like dynamic memory allocation, only it's all
done at compile time.

The driving goal was to allow message_t's metadata to extend itself
based on which layers of the radio stack are actually used, although the
concept can be applied anywhere.  When you compile
in a component that requires extra bytes in some structure, those bytes are
allocated at the end, and they can be accessed via the ParameterStorage 
interface using store(...) and load(...).  The interface itself can be renamed 
to resemble the actual variable you're storing or loading.  

To make it work, the structure you're going to be incrementing has to have
a unique reference, which you pass into ExtendedWhateverC().  Take a look
at ComponentA.h:


#define UQ_COMPONENTA_EXTENSION "componentA.ExtendMetadata"

typedef nx_struct cc5000_metadata_t {
  nx_uint8_t tx_power;
  nx_uint8_t rssi;
  nx_uint8_t lqi;
  nx_bool crc;
  nx_bool ack;
  nx_uint16_t time;

  nx_uint8_t extendedParameters[uniqueCount(UQ_COMPONENTA_EXTENSION)];
} cc5000_metadata_t;

That's how you define your structure.  Now to add bytes to that structure,
you simply make new bytes or words in your own component's configuration:

(ComponentAC.nc):
  components  // ...
      new ExtendedByteC(UQ_COMPONENTA_EXTENSION) as ByteOneC,
      new ExtendedWordC(UQ_COMPONENTA_EXTENSION) as WordTwoC,
      new ExtendedByteC(UQ_COMPONENTA_EXTENSION) as ByteThreeC,
      new ExtendedWordC(UQ_COMPONENTA_EXTENSION) as WordFourC;

More information can be found in the readme.txt in tos/lib/extended_storage
      
dmm@rincon.com

