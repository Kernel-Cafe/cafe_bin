#!/bin/sh
cleanup(){
  rm $DEVICE_OUT/zImage 2> /dev/null
  rm $ME_ROOT/boot.img 2> /dev/null
  rm $DEVICE_OUT/initrd.img 2> /dev/null
}
ramdisk_default(){
  $BIN_ROOT/mkbootfs $DEV_ROOT/img/ramdisk > $DEVICE_OUT/ramdisk.cpio || exit 1
  cat $DEVICE_OUT/ramdisk.cpio | gzip > $DEVICE_OUT/ramdisk.cpio.gz || exit 1
}
cp -R $DEV_ROOT/img/ota/* $DEVICE_OUT/package
ME_ROOT="$DEVICE_OUT/package"

#rm $ME_ROOT/ota/system/lib/modules/*
#find $MOD_DIR -name *.ko -exec cp {} $ME_ROOT/ota/system/lib/modules/ \; 
if [ -z $KERNEL_OUT ] 
then
 echo "out to source"
 KERNEL_OUT=$KERNEL_SOURCE
fi
if [ $KIMG_HOOK ]
then
  echo "running kimg hook"
  source $KIMG_HOOK
   echo "done kimg hook"
fi
if [ $MAKE_BOOTIMG ]
then
  echo "mkimg hook"
  source $MAKE_BOOTIMG
  echo "done hook"
else
  echo "source is " $KERNEL_OUT
  cleanup
  ramdisk_default
  cp $KERNEL_OUT/arch/arm/boot/zImage $DEVICE_OUT/zImage || exit 1
  $CM
  if [[ -z "$KERNEL_CMDLINE" ]] 
  then
    CM=" --cmdline $KERNEL_CMDLINE"	
  fi
  $BIN_ROOT/mkbootimg $CM --kernel $DEVICE_OUT/zImage --ramdisk $DEVICE_OUT/ramdisk.cpio.gz -o $ME_ROOT/boot.img || exit 1
fi

