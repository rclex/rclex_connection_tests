#!/bin/bash

testDir=`pwd`
root=$1
cd ../rclcpp_node
colcon build
source install/setup.bash
echo $testDir
cd $testDir
cd ../
ros2 run cpp_pubsub listener &
sleep 1
echo $root
cd $root
mix deps.get
mix compile
mix run priv/pub_test.exs &
wait
exPub=`cat ex_pub.txt`
cppSub=`cat ../cpp_sub.txt`
test $cppSub = $exPub
result=$?
echo "published message : $exPub"
echo "subscribed message : $cppSub"
echo "result : $result"
rm ex_pub.txt
rm ../cpp_sub.txt
if [ $result -ne 0 ]; then
    echo "Error: simple_pub_sub"
    exit 1
fi 