#!/bin/bash

cd $1

mix run priv/sub_test.exs &
sleep 1

mix run priv/pub_test.exs &
wait

exPub=`cat ex_pub.txt`
echo "TESTINFO: published message  : $exPub"
rm -f ex_pub.txt

exSub=`cat ex_sub.txt`
echo "TESTINFO: subscribed message : $exSub"
rm -f ex_sub.txt

test $exPub = $exSub
result=$?
echo "TESTINFO: result : $result"

if [ $result -ne 0 ]; then
    echo "TESTERROR: $0 failed."
    exit 1
fi
