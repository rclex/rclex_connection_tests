#!/bin/bash

cd $1

mix run priv/sub_test.exs &
sleep 1

mix run priv/pub_test.exs &
wait

exPub=`cat ex_pub.txt`
echo "published message : $exPub"
rm ex_pub.txt

exSub=`cat ex_sub.txt`
echo "subscribed message : $exSub"
rm ex_sub.txt

test $exPub = $exSub
result=$?
echo "result : $result"

if [ $result -ne 0 ]; then
    echo "Error: simple_pub_sub"
    exit 1
fi 