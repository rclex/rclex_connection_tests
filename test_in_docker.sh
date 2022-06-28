#!/bin/bash

if [ "$(uname)" == 'Darwin' ];
then
  dockercmd="docker"
  dockercmp="docker compose"
else
  dockercmd="docker"
  if docker compose >/dev/null 2>&1;
  then
    dockercmp="docker compose"
  else
    dockercmp="docker-compose"
  fi
fi

if [ $# -ne 0 ];
then
  Tags=()
  for tag in ${@};
  do
    ${dockercmd} pull rclex/rclex_docker:${tag}
    result=$?
    if [ $result -eq 0 ];
    then
      echo "INFO: adding ${tag} as target tags os Docker image"
      Tags+=(${tag})
    else
      echo "ERROR: Docker tag ${tag} does not exist in rclex/rclex_docker"
      exit $result
    fi
  done
else
  ${dockercmd} pull rclex/rclex_docker:latest
  Tags=(latest)
fi

for tag in ${Tags[@]};
do
  echo "INFO: run-test start on rclex/rclex_docker:${tag}"
  export TAG=${tag}
  ${dockercmp} up -d

  ${dockercmp} exec rclex_docker \
    bash -c 'cd /root/rclex_connection_tests &&
    source /opt/ros/${ROS_DISTRO}/setup.bash &&
    ./run-all.sh '

  ${dockercmp} down

done
