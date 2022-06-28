#!/bin/bash

if docker compose >/dev/null 2>&1;
then
  :
else
  echo "\`docker compose\` a.k.a Docker Compose V2 is not installed in this environment"
  exit 1
fi

if [ $# -ne 0 ];
then
  Tags=()
  for tag in ${@};
  do
    echo "INFO: adding ${tag} as target tags os Docker image"
    Tags+=(${tag})
  done
else
  Tags=(latest)
fi

for tag in ${Tags[@]};
do
  echo "INFO: run-test start on rclex/rclex_docker:${tag}"
  export TAG=${tag}

  docker compose pull
  if [ $? -ne 0 ];
  then
    echo "ERROR: Docker tag \"${tag}\" does not exist in rclex/rclex_docker"
    exit $result
  fi

  docker compose up -d

  docker compose exec rclex_docker \
    bash -c 'cd /root/rclex_connection_tests &&
    source /opt/ros/${ROS_DISTRO}/setup.bash &&
    ./run-all.sh '

  docker compose down

done
