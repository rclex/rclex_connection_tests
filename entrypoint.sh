#!/bin/bash

testScripts=()
testScripts+=(simple_pubsub/rclcpp_to_rclex.sh)
testScripts+=(simple_pubsub/rclex_to_rclcpp.sh)
testScripts+=(simple_pubsub/rclex_to_rclex.sh)

testRoot=`pwd`
rclcppRoot=${testRoot}/rclcpp_node
rclexRoot=${testRoot}/rclex_node

# Rebuild Rclcpp node
cd $rclcppRoot
if [ "$(uname)" == 'Darwin' ];
then
    rm -rf build install log
else
    sudo rm -rf build install log
fi
colcon build
result=$?
if [ $result -ne 0 ]; then
    echo "ERROR: \`colcon build\` for Rclcpp failed: $result"
    exit $result
else
    source install/setup.bash
fi

# Rebuild Rclex node
cd $rclexRoot
if [ "$(uname)" == 'Darwin' ];
then
    rm -rf _build deps
else
    sudo rm -rf _build deps
fi
mix deps.get
result=$?
if [ $result -ne 0 ]; then
    echo "ERROR: \`mix deps.get\` for Rclex failed: $result"
    exit $result
fi
mix compile
if [ $result -ne 0 ]; then
    echo "ERROR: \`mix compile\` for Rclex failed: $result"
    exit $result
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
