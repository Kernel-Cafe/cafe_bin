#!/bin/sh
BIN_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export BIN_ROOT
DEV_ROOT=''
KERNEL_SOURCE=''
KERNEL_OUT=''
KERNEL_CMDLINE=''
DEVICE_NAME=''
MOD_DIR=''
KTHREAD=10
CC='/android/omni/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-'
KERNEL_CONFIG=''
KIMG_HOOK=''
KCLEAN=0
MAKE_BOOTIMG=''
prepare() {
  export DEVICE_OUT=`pwd`/build/$DEVICE_NAME
  #rm -rf $DEVICE_OUT
  mkdir -p $DEVICE_OUT/kout
  mkdir -p $DEVICE_OUT/modules
  mkdir -p $DEVICE_OUT/modules_stripped
  mkdir -p $DEVICE_OUT/package
  KERNEL_OUT=$DEVICE_OUT/kout
  MOD_DIR=$DEVICE_OUT/modules
  PKG_ZIP=$DEVICE_OUT/$DEVICE_NAME-`date +%Y%m%d`.zip
  DIST_ZIP=$DEVICE_OUT/${DEVICE_NAME}-`date +%Y%m%d`_dist.zip
  export KERNEL_SOURCE
  export KERNEL_OUT
  export MOD_DIR
  export CC
  export KERNEL_CONFIG
  export KTHREAD
  export KCLEAN
  export MOD_DIR
  export MAKE_BOOTIMG
  export KIMG_HOOK
  export DEV_ROOT
  export DEVICE_NAME
  export PKG_ZIP
  export DIST_ZIP
}
print_config(){
  echo "KERNEL_SOURCE $KERNEL_SOURCE"
  echo "KERNEL_OUT $KERNEL_OUT"
  echo "CC $CC"
  echo "KERNEL_CONFIG $KERNEL_CONFIG"
  echo "DEVICE_NAME $DEVICE_NAME"
  echo "MOD_DIR $MOD_DIR"
  
}

build_kernel(){
  source $BIN_ROOT/build_kernel.sh
}
make_bootimage(){
  source $BIN_ROOT/make_bootimg.sh
}
make_zip(){
  source $BIN_ROOT/makezip.sh
}
make_dist(){
  source $BIN_ROOT/dist.sh
}
print_finals(){
  if [ -e "$DIST_ZIP" ]
  then
    echo kitchen dist : $DIST_ZIP
  else
    echo No kitchen dist
  fi
  if [ -e $PKG_ZIP ]
  then
    echo package dist : $PKG_ZIP
  else
    echo No package dist
  fi
}
