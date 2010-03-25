TOSCONTRIB=/opt/tinyos-2.x-contrib
INTERFACES=`ls $TOSCONTRIB/crypto/tos/interfaces | egrep -v "CVS|README"`
SYSTEM=`ls $TOSCONTRIB/crypto/tos/system | grep -v "^CVS"`


for i in $INTERFACES
	do
	rm -rf $TOSDIR/interfaces/$i
done

for i in $SYSTEM
	do
	rm -rf $TOSDIR/system/$i
done
