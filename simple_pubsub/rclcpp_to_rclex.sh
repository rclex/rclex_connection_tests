#!/bin/bash

cd $1

mix run priv/sub_test.exs &
sleep 1

ros2 run cpp_pubsub talker &
wait

sleep 1

cppPub=`cat cpp_pub.txt | tr -d "\0"`
echo "TESTINFO: published message  : $cppPub"
rm -f cpp_pub.txt

exSub=`cat ex_sub.txt | tr -d "\0"`
echo "TESTINFO: subscribed message : $exSub"
rm -f ex_sub.txt

test $cppPub = $exSub
result=$?
echo "TESTINFO: result : $result"

if [ $result -ne 0 ]; then
    echo "TESTERROR: $0 failed."
    exit 1
fi
