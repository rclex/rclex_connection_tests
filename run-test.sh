#!/bin/bash

# define testScripts (need to edit when test case was added)
testScripts=()
testScripts+=(simple_pubsub/rclcpp_to_rclex.sh)
testScripts+=(simple_pubsub/rclex_to_rclcpp.sh)
testScripts+=(simple_pubsub/rclex_to_rclex.sh)


testRoot=`pwd`
rclcppRoot=${testRoot}/rclcpp_node
rclexRoot=${testRoot}/rclex_node

if [ ! -d ${rclcppRoot}/build ];
then
    echo "ERROR: ${rclcppRoot} has not been built"
    echo "ERROR: please do ./run-rebuild.sh before this"
    exit 1
else
    source ${rclcppRoot}/install/setup.bash
fi
if [ ! -d ${rclexRoot}/_build ];
then
    echo "ERROR: ${rclexRoot} has not been built"
    echo "ERROR: please do ./run-rebuild.sh before this"
    exit 1
fi


failedTestNames=""
testCount=0
passedTestCount=0

for testScript in ${testScripts[@]};
do
    cd $testRoot
    if test $testScript = '*.sh'; then
        continue
    fi
    testCount=$(($testCount + 1))
    echo "INFO: running test scrpit: $testScript"
    ./$testScript $rclexRoot
    result=$?
    if test $result -eq 0; then
        echo -e "INFO: $testScript passed!\n"
        passedTestCount=$(($passedTestCount + 1))
    else
        echo -e "WARN: $testScript failed!\n"
        failedTestNames+="  $testScript\n"
    fi
done

echo "INFO: Complete all tests"
echo "INFO: number of passed tests: $passedTestCount / $testCount"
if test $testCount -ne $passedTestCount; then
    echo -e "ERROR: Failed tests: \n$failedTestNames"
    exit $testCount
else
    echo "INFO: All Tests passed."
    exit 0
fi
