This is a memory stick application that lets you upload/download/delete/dir
files on the mote.

One thing to note is the mote doesn't respond back with its status during
operations that take a long time.  So if you have uploaded a huge file,
for example, and then want to check if that file is corrupted with an
-isCorrupt command, the mote is going to take a long time to read through
that file and find if it's corrupted anywhere.  And you're not going to see
any updates on the screen.  If you exit out of the app on your computer,
the mote is still going to be doing its thing and won't let you mess with
it till it's done.  

