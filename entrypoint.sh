#!/bin/bash

testDirs=(simple_pubsub)
testRoot=`pwd`
projectRoot="`pwd`/.."
#rclexRoot=${projectRoot}/rclex
rclexRoot=${testRoot}/rclex_node

failedTestNames=""
testCount=0
passedTestCount=0

for dir in $testDirs;
do
    echo -e "entering testDir: $dir"
    cd $dir
    for testScript in *.sh; do
        if test $testScript = '*.sh'; then
            continue
        fi
        testCount=$(($testCount + 1))
        echo "run $dir/$testScript"
        ./$testScript $rclexRoot
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