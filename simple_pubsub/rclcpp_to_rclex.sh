#!/bin/bash

testDir=`pwd`
root=$1
cd ../rclcpp
colcon build
source install/setup.bash
cd $root
echo $root
mix compile
mix run rclex_connection_tests/rclex/sub_test.exs &
sleep 1
cd $testDir
cd ../
ros2 run cpp_pubsub talker &
wait
cppPub=`cat cpp_pub.txt`
exSub=`cat $root/ex_sub.txt`
test $cppPub = $exSub
result=$?
echo "published message : $cppPub"
echo "subscribed message : $exSub"
echo "result : $result"
rm cpp_pub.txt
rm $root/ex_sub.txt
if [ $result -ne 0 ]; then
    echo "Error: simple_pub_sub"
    exit 1
fi 