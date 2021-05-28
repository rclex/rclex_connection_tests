#!/bin/bash

cd $1

ros2 run cpp_pubsub listener &
sleep 1

mix run priv/pub_test.exs &
wait

exPub=`cat ex_pub.txt`
echo "published message : $exPub"
rm ex_pub.txt

cppSub=`cat cpp_sub.txt`
echo "subscribed message : $cppSub"
rm cpp_sub.txt

test $cppSub = $exPub
result=$?
echo "result : $result"

if [ $result -ne 0 ]; then
    echo "Error: simple_pub_sub"
    exit 1
fi 