#!/bin/bash

cd $1

ros2 run cpp_pubsub listener &
PID1=$!

echo "TESTINFO: wait for creating subscriber"
while :
do
  if [ -e sub_ready.txt ]; then
    echo "TESTINFO: subscriber has created"
    rm -f sub_ready.txt
    break
  fi
  sleep 0.1
done

mix run priv/pub_test.exs &
PID2=$!

wait $PID1 $PID2

exPub=`cat ex_pub.txt | tr -d "\0"`
echo "TESTINFO: published message  : $exPub"
rm -f ex_pub.txt

cppSub=`cat cpp_sub.txt | tr -d "\0"`
echo "TESTINFO: subscribed message : $cppSub"
rm -f cpp_sub.txt

test $cppSub = $exPub
result=$?
echo "TESTINFO: result : $result"

if [ $result -ne 0 ]; then
    echo "TESTERROR: $0 failed."
    exit 1
fi
