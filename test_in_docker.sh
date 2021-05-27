#!/bin/bash

sudo docker-compose exec rclex_docker bash -c 'cd rclex && \ 
    MIX_ENV=test mix deps.get && \ 
    MIX_ENV=test mix compile && \ 
    cd rclex_connection_tests && \ 
    rm rclcpp/build/cpp_pubsub/CMakeCache.txt && \ 
    source /opt/ros/dashing/setup.bash && \ 
    ./entrypoint.sh'