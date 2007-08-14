To use these projects setup the following variables:

 TOSDIR (location of T2 tree)
 MAKERULES (location of T2 Makerules)
 TOSMAKE_PATH
   list of directories to search for .target files (separated by spac"
 CONTRIBROOT (root of the contrib directory)
   x.target and x.platform uses this to include nesC source files

Adding a CONTRIBROOT variable as opposed to using relative paths to
locate the appropriate include directories allows compiling
applications in both the contrib dir and in the orriginal T2 tree.

Example:
 export TOSDIR=~/tinyos-2.x/tos
 export MAKERULES=$TOSDIR/../support/make/Makerules
 export CONTRIBROOT=~/tinyos-2.x-contrib
 export TOSMAKE_PATH="$TOSMAKEPATH $CONTRIBROOT/diku/sensinode/support/make $CONTRIBROOT/diku/mcs51/support/make"
