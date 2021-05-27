#!/bin/bash

dirs=`find . -maxdepth 1 -type d `
testRoot=`pwd`
cd ../
projectRoot=`pwd`
failedTestNames=""
testCount=0
passedTestCount=0

cd $testRoot

for dir in $dirs;
do
    if test $dir = '.' -o $dir = './rclcpp' -o $dir = './rclex' -o $dir = './.git'; then
        continue
    fi
    echo $dir
    cd $dir
    for testScript in *.sh; do
        if test $testScript = '*.sh'; then
            continue
        fi
        testCount=$(($testCount + 1))
        echo "run $dir/$testScript"
        ./$testScript $projectRoot
        result=`echo $?`
        if test $result -eq 0; then
            echo -e "$testScript passed!\n"
            passedTestCount=$(($passedTestCount + 1))
        else
            echo -e "$testScript failed!\n"
            failedTestNames+="  $testScript\n"
        fi
    done
    cd $testRoot
done

echo "Complete All Tests"
echo "Passed Tests: $passedTestCount / $testCount"
if test $testCount -ne $passedTestCount; then
    echo -e "Failed Tests: \n$failedTestNames"
    exit 1
fi