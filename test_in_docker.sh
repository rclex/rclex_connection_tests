#!/bin/bash

sudo docker-compose exec rclex_docker bash -c 'cd /root/rclex_connection_tests && \
    rm rclcpp_node/build/cpp_pubsub/CMakeCache.txt && \ 
    source /opt/ros/${ROS_DISTRO}/setup.bash && \ 
    ./entrypoint.sh '
