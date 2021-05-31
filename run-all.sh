#!/bin/bash

bash run-rebuild.sh
result=$?
if [ $result -eq 0 ];
then
    bash run-test.sh
else
    echo "ERROR: run-rebuild.sh failed."
    exit $result
fi
