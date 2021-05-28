#!/bin/bash

cd $1

mix run priv/sub_test.exs &
sleep 1

ros2 run cpp_pubsub talker &
wait

cppPub=`cat cpp_pub.txt`
echo "TESTINFO: published message  : $cppPub"
rm cpp_pub.txt

exSub=`cat ex_sub.txt`
echo "TESTINFO: subscribed message : $exSub"
rm ex_sub.txt

test $cppPub = $exSub
result=$?
echo "TESTINFO: result : $result"

if [ $result -ne 0 ]; then
    echo "TESTERROR: $0 failed."
    exit 1
fi
