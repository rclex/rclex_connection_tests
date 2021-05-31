#!/bin/bash

if [ "$(uname)" == 'Darwin' ];
then
  dockercmd="docker compose"
else
  dockercmd="sudo docker-compose"
fi

${dockercmd} pull
${dockercmd} up -d

${dockercmd} exec rclex_docker \
  bash -c 'cd /root/rclex_connection_tests &&
  source /opt/ros/${ROS_DISTRO}/setup.bash &&
  ./entrypoint.sh '

${dockercmd} down
