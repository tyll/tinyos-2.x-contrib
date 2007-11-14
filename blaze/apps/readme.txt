These applications are separate from the TinyOS baseline only so they can include
compile path information pointing to the Blaze radio stack.

The Blaze radio stack will compile for any app in the TinyOS baseline because
it's a drop-in replacement for any generic TinyOS radio. But, to get it to compile
you just have to tell the compiler where all the stack information is located.
I do that in these Makefiles.  Until the Blaze radio stack is incorporated
into the baseline, these blaze-specific apps are useful to get basic stuff to
compile.  

If you need other apps to compile, try copying out the CFLAGS+=-I....
lines from these applications' Makefiles.

