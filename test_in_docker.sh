#!/bin/bash

sudo docker-compose exec rclex_docker bash -c 'cd /root/rclex_connection_tests && \
    source /opt/ros/${ROS_DISTRO}/setup.bash && \ 
    ./entrypoint.sh '
