TOSCONTRIB=/opt/tinyos-2.x-contrib
INTERFACES=`ls $TOSCONTRIB/crypto/tos/interfaces`
SYSTEM=`ls $TOSCONTRIB/crypto/tos/system`


for i in $INTERFACES
	do
	cp $TOSCONTRIB/crypto/tos/interfaces/$i $TOSDIR/interfaces/
done

for i in $SYSTEM
	do
	cp $TOSCONTRIB/crypto/tos/system/$i $TOSDIR/system/
done
