#!/bin/sh

DIST="$DEVICE_OUT/kitchen"
CORE="$DIST/core"
DRV="$DIST/driver"
pwd=$(pwd)
rm -r $CORE 2>/dev/null
mkdir -p $CORE
cp -r $DEVICE_OUT/package/* $CORE
cat $DEV_ROOT/drivers.txt | while read DRIVER
do
	echo "processing $DRIVER "
	if [ -s "$DEV_ROOT/$DRIVER.txt" ]
	then
		cat "$DEV_ROOT/$DRIVER.txt" | while read DRV_FILE
		do
			#echo "moving file $DRV_FILE"
			fld=$(dirname "$DRV/$DRIVER$DRV_FILE")
			if [ ! -d "$fld" ] 
			then
				mkdir -p $fld
			fi
			mv "$CORE$DRV_FILE" "$DRV/$DRIVER$DRV_FILE"
		done
	else
		echo "no drv files for $DRIVER" > /dev/null
	fi
done
cd $DIST
rm $DIST_ZIP 2>/dev/null
zip -q -r $DIST_ZIP * || exit 1
cd $pwd
export DIST_ZIP
