#!/bin/bash


root=$1
cd $root
mix compile
mix run rclex_connection_tests/rclex/sub_test.exs &
sleep 1
mix run rclex_connection_tests/rclex/pub_test.exs &
wait
exPub=`cat ex_pub.txt`
exSub=`cat ex_sub.txt`
test $exPub = $exSub
result=$?
echo "published message : $exPub"
echo "subscribed message : $exSub"
echo "result : $result"
rm ex_pub.txt
rm ex_sub.txt
if [ $result -ne 0 ]; then
    echo "Error: simple_pub_sub"
    exit 1
fi 