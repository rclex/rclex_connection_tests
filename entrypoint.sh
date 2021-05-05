#!/bin/bash

dirs=`find . -maxdepth 1 -type d `
testRoot=`pwd`
cd ../
projectRoot=`pwd`
cd $testRoot

for dir in $dirs;
do
    if test $dir = '.' -o $dir = './rclcpp' -o $dir = './rclex'; then
        continue
    fi
    echo $dir
    cd $dir
    ./*.sh $projectRoot
    result=`echo $?`
    if test $result -ne 0; then
        echo "Error: {$dir}"
        exit 1
    fi
    cd $testRoot
done