#!/bin/bash

testRoot=`pwd`
rclcppRoot=${testRoot}/rclcpp_node
rclexRoot=${testRoot}/rclex_node


if [ $# -eq 0 ];
then
    build_rclcpp=1
    build_rclex=1
else
    if [ "$1" == "rclcpp" ];
    then
        build_rclcpp=1
        build_rclex=0
    elif [ "$1" == "rclex" ];
    then
        build_rclcpp=0
        build_rclex=1
    else
        echo "ERROR: invalid option: ${1}"
        exit 1
    fi
fi


# Rebuild Rclcpp node
if [ ${build_rclcpp} -eq 1 ];
then
    echo "INFO: building rclcpp node in ${rclcppRoot}"
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
fi


# Rebuild Rclex node
if [ ${build_rclex} -eq 1 ];
then
    echo "INFO: building rclcpp node in ${rclexRoot}"
    cd $rclexRoot
    if [ "$(uname)" == 'Darwin' ];
    then
        rm -rf _build deps
    else
        sudo rm -rf _build deps
    fi
    
    mix deps.get
    if [ $? -ne 0 ];
    then
        echo "ERROR: \`mix deps.get\` for Rclex failed: $result"
        exit $result
    fi
    
    mix compile
    if [ $? -ne 0 ];
    then
        echo "ERROR: \`mix compile\` for Rclex failed: $result"
        exit $result
    fi
fi
