TOSCONTRIB=/opt/tinyos-2.x-contrib
INTERFACES=`ls $TOSCONTRIB/crypto/tos/interfaces | grep -v "^CVS"`
SYSTEM=`ls $TOSCONTRIB/crypto/tos/system | grep -v "^CVS"`


for i in $INTERFACES
	do
	cp $TOSCONTRIB/crypto/tos/interfaces/$i $TOSDIR/interfaces/
done

for i in $SYSTEM
	do
	cp $TOSCONTRIB/crypto/tos/system/$i $TOSDIR/system/
done
