
TRAFFIC=traffic/traffic-10-2048-50
OUTDIR=flow-table-25/failures-10
FAILUREDIR=failures/

for i in $(find $FAILUREDIR -type f -printf "%f\n"); do
    THISOUTDIR=$OUTDIR/$i
    echo $i $THISOUTDIR

    cat /dev/null > flows.txt
    # MOTECOM=sf@localhost:9001 python TestDriver.py ping $TRAFFICDIR/$i dontwait

    for MOTE in $(cat $i); do
        echo MOTECOM=sf@localhost:9001 python TestDriver.py stop $MOTE
    done

    # MOTECOM=sf@localhost:9001 python TestDriver.py wait 10

    # wait for any late messages to settle before continuing
    # sleep 20
    # MOTECOM=sf@localhost:9001 python TestDriver.py clear all
    mkdir -p $THISOUTDIR
    cp flows.txt $THISOUTDIR/
    
done