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
sudo rm -rf build install log
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
sudo rm -rf _build deps
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
    result=`echo $?`
    if test $result -eq 0; then
        echo -e "$testScript passed!\n"
        passedTestCount=$(($passedTestCount + 1))
    else
        echo -e "$testScript failed!\n"
        failedTestNames+="  $testScript\n"
    fi
done

echo "Complete All Tests"
echo "Passed Tests: $passedTestCount / $testCount"
if test $testCount -ne $passedTestCount; then
    echo -e "Failed Tests: \n$failedTestNames"
    exit 1
fi