#!/bin/sh
#export USE_CCACHE=1
#export CCACHE_DIR=/cjb/jcache
#/cyg/system/prebuilts/misc/linux-x86/ccache/ccache -M 30G
rm $DEVICE_OUT/modules/* 2> /dev/null
rm $DEVICE_OUT/package/system/lib/modules/* 2> /dev/null
rm $DEVICE_OUT/modules_stripped/* 2> /dev/null
STRIP=${CC}strip
rm -r $MOD_DIR 2>/dev/null
#cd $KERNEL_SOURCE
if [ ! -d $KERNEL_OUT ]
then
	mkdir -p $KERNEL_OUT
fi

if [ -z $KCLEAN ] 
then
 echo "mr propering"
 make ARCH=arm CROSS_COMPILE="$CC" -C $KERNEL_SOURCE O=$KERNEL_OUT mrproper|| exit 1
fi
if [[ -z "$KTHREAD" ]] 
then
 echo "setting kthreadd to 16"
 KTHREAD=16 
fi
nice -n 10 make -j$KTHREAD -C $KERNEL_SOURCE O=$KERNEL_OUT ARCH=arm CROSS_COMPILE="$CC" LOCALVERSION="-MAXMOD" $KERNEL_CONFIG || exit 1
#make -C $KERNEL_DIR O=$KERNEL_OUT ARCH=arm CROSS_COMPILE="$CC" $K_CONFIG xconfig
nice -n 10 make -j$KTHREAD  -C $KERNEL_SOURCE O=$KERNEL_OUT ARCH=arm CROSS_COMPILE="$CC" LOCALVERSION="-MAXMOD" || exit 1
nice -n 10 make -j$KTHREAD  -C $KERNEL_SOURCE O=$KERNEL_OUT ARCH=arm CROSS_COMPILE="$CC" INSTALL_MOD_PATH=$MOD_DIR modules_install || echo  1
mdpath=`find $MOD_DIR -type f -name modules.order`;\
if [ "$$mdpath" != "" ];then\
        mpath=`dirname $mdpath`;\
        ko=`find $mpath/kernel -type f -name *.ko`;\
        for i in $ko; \
        do \
	  $STRIP --strip-unneeded $i;\
	  mv $i $DEVICE_OUT/modules_stripped > /dev/null; \
	  #echo installing `basename $i`; \
	done;\
fi
