#!/bin/bash -ex

su - $USER <<-SHELL
    # [[ ! -f /home/$USER/swarm-client.jar ]] && curl -s0 ${JENKINS_URL}/swarm/swarm-client.jar
    curl -s0 ${JENKINS_URL}/swarm/swarm-client.jar -O swarm-client.jar
    if ps x | grep -v grep | grep swarm >/dev/null
    then
        pkill java
        echo "Killing process if exists..."
        sleep 2
    fi
    java -jar swarm-client.jar \
        -url ${JENKINS_URL} \
        -username ${USERNAME} \
        -password ${PASSWORD} \
        -executors $NPROCS \
        -labels ${HOSTNAME} &

SHELL