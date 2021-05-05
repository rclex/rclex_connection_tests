#!/bin/bash

testDir=`pwd`
root=$1
cd ../rclcpp
colcon build
source install/setup.bash
echo $testDir
cd $testDir
cd ../
ros2 run cpp_pubsub listener &
sleep 1
echo $root
cd $root
mix compile
mix run rclex_connection_tests/rclex/pub_test.exs &
wait
exPub=`cat ex_pub.txt`
cppSub=`cat $root/rclex_connection_tests/cpp_sub.txt`
test $cppSub = $exPub
result=$?
echo "published message : $cppSub"
echo "subscribed message : $exPub"
echo "result : $result"
rm ex_pub.txt
rm $root/rclex_connection_tests/cpp_sub.txt
if [ $result -ne 0 ]; then
    echo "Error: simple_pub_sub"
    exit 1
fi 