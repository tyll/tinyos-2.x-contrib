BouncePacket is a test application for Quanto

To use:
  1. program 2 nodes with ids 1 and 4 (this is important for this
app, they will only listen to the other, respectively)
  2. connect them both to the computer, via UART
  3. fire up the java Listen program for both
  4. press the user button on one of them

If they can communicate, they will bounce two packets back and
forth, either 10 times, or until one of them has its quanto log fill
up.

Using the default values, in Bounce each node sends two packets
successively and receives two packets successively, all these events
separated by 250ms.

This is what it looks like when we press 1's user button:

     1  -S----S----------R----R----S----S---------------------->
         \    \        /    /      \   \  ...
          \    \      /    /        \  ...
     4  ----R----R----S----S----------------------------------->

Bounce tests, beyond Blink, activity propagation across nodes.
It also tracks and records the power states of the cc2420.

