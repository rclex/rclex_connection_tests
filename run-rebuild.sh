#!/bin/bash

testRoot=`pwd`
rclcppRoot=${testRoot}/rclcpp_node
rclexRoot=${testRoot}/rclex_node


# Rebuild Rclcpp node
cd $rclcppRoot
if [ "$(uname)" == 'Darwin' ];
then
    rm -rf build install log
else
    sudo rm -rf build install log
fi

colcon build
if [ $? -ne 0 ]; then
    echo "ERROR: \`colcon build\` for Rclcpp failed: $result"
    exit $result
fi


# Rebuild Rclex node
cd $rclexRoot
if [ "$(uname)" == 'Darwin' ];
then
    rm -rf _build deps
else
    sudo rm -rf _build deps
fi

mix deps.get
if [ $? -ne 0 ]; then
    echo "ERROR: \`mix deps.get\` for Rclex failed: $result"
    exit $result
fi

mix compile
if [ $? -ne 0 ]; then
    echo "ERROR: \`mix compile\` for Rclex failed: $result"
    exit $result
fi
