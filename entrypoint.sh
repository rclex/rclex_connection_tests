#!/bin/bash

dirs=`find . -maxdepth 1 -type d `
testRoot=`pwd`
cd ../
projectRoot=`pwd`

cd $testRoot

for dir in $dirs;
do
    if test $dir = '.' -o $dir = './rclcpp' -o $dir = './rclex' -o $dir = './git'; then
        continue
    fi
    echo $dir
    cd $dir
    for testScript in *.sh; do
        if test $testScript = '*.sh'; then
            continue
        fi
        ./$testScript $projectRoot
        result=`echo $?`
        if test $result -ne 0; then
            echo "Error: {$testScript}"
            exit 1
        fi
    done
    cd $testRoot
done