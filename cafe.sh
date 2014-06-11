#!/bin/bash
# devices=()
# export devices
# devices_files=`find ./ -name "cafe_device.sh"`
# for dv in $devices_files
# do
#   echo sourcing $dv
#   source $dv
# done
# 
# for dci in "${devices[@]}"; do
#   echo $dci
# done
$KCLEAN=1
source bin/setup.sh
fpath=`echo $1 | sed  's/_/\//g'`
fpath="device/$fpath/cafe_device.sh"
source $fpath
prepare
print_config
build_kernel
make_bootimage
make_zip
make_dist
print_finals