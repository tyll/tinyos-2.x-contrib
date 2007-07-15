TOSSIM Live:

To install and use TOSSIM Live set an env variable for the root of your
contrib tree.

    export TOSCONTRIB=$HOME/tinyos-2.x-contrib

Install the sim-sf.extra file:

    cd $TOSCONTRIB/csm/tos/lib/tossim
    make install

Once installed to use TOSSIM Live its as easy as:

    make micaz sim-sf
