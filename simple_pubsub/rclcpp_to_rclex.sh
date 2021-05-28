#!/bin/bash

cd $1

mix run priv/sub_test.exs &
sleep 1

ros2 run cpp_pubsub talker &
wait

cppPub=`cat cpp_pub.txt`
echo "published message : $cppPub"
rm cpp_pub.txt

exSub=`cat ex_sub.txt`
echo "subscribed message : $exSub"
rm ex_sub.txt

test $cppPub = $exSub
result=$?
echo "result : $result"

if [ $result -ne 0 ]; then
    echo "Error: simple_pub_sub"
    exit 1
fi 