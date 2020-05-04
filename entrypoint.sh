#!/bin/sh

# Git config
if [ ! -z "$GIT_USER_NAME" ] && [ ! -z "$GIT_USER_EMAIL" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
fi

groupadd -g 5000 localusers
useradd -u 5000 -g 5000 user

chown -R user: /home/user

# Give user `user` permission to use docker!
if [ -S "/var/run/docker.sock" ]; then
    # Find the hosts group ID for the docker socket
    HOST_DOCKER_SOCKET_GROUP_ID=`stat -c %g /var/run/docker.sock`
    # create the group `docker`
    groupadd --non-unique -g "$HOST_DOCKER_SOCKET_GROUP_ID" docker
    # add `me` to the `docker` group
    adduser user docker
fi

export PROJECT_NAME=${PROJECT_NAME:-"Standalone"}
exec /sbin/su-exec me tmux -u -2 new -s ${PROJECT_NAME}