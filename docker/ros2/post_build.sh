#!/bin/bash
set -e
# set -x

ROS_WS="${ROS_WS:-/home/dockeruser/dev_ws}"

if [ ! -d "$ROS_WS" ]; then
  echo "post_build: $ROS_WS does not exist, nothing to patch" >&2
  exit 0
fi
echo "post_build: patching ogre2 to ogre"

find "$ROS_WS" -type f -name '*.sdf' -exec sed -i 's/ogre2/ogre/g' {} +