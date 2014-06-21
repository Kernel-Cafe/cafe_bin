#!/bin/bash

source bin/setup.sh
fpath=`echo $1 | sed  's/_/\//g'`
fpath="device/$fpath/cafe_device.sh"
if [[ -e $fpath ]]
then
    source $fpath
    prepare
    print_config
    build_kernel
    make_bootimage
    make_zip
    make_dist
    print_finals
else
    echo "usage ./cafe.sh <device_name>"
fi
