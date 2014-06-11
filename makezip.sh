#!/bin/sh
ME_ROOT="$DEVICE_OUT/package"
pwd=$(pwd)
export PKG_ZIP
cd $ME_ROOT
cp $DEVICE_OUT/modules_stripped/* $ME_ROOT/system/lib/modules/
zip -q -r pkg.zip * || exit 1
mv pkg.zip $PKG_ZIP
cd $pwd
