#!/bin/bash

cd $1

ros2 run cpp_pubsub listener &
sleep 1

mix run priv/pub_test.exs &
wait

exPub=`cat ex_pub.txt`
echo "TESTINFO: published message  : $exPub"
rm ex_pub.txt

cppSub=`cat cpp_sub.txt`
echo "TESTINFO: subscribed message : $cppSub"
rm cpp_sub.txt

test $cppSub = $exPub
result=$?
echo "TESTINFO: result : $result"

if [ $result -ne 0 ]; then
    echo "TESTERROR: $0 failed."
    exit 1
fi
