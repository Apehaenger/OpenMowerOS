#!/bin/bash
# Mode wrapper for openmower.service: sets all runtime options based on OM_MODE

set -e

# Load version and mode
source /boot/openmower/openmower_version.txt
source /home/pi/openmower_mode.env

# Set all options based on OM_MODE
if [[ "$OM_MODE" == "debug" ]]; then
  exec /usr/bin/podman run --conmon-pidfile "$1" --cidfile "$2" --cgroups=no-conmon \
    --replace --detach --tty --privileged \
    --name openmower \
    --network=host \
    --volume /dev:/dev \
    --volume /boot/openmower/mower_config.txt:/config/mower_config.sh \
    --volume /root/ros_home:/root \
    --label io.containers.autoupdate="image" \
    ghcr.io/clemenselflein/open_mower_ros:${OM_VERSION}
else
  # Normal mode
  exec /usr/bin/podman run --conmon-pidfile "$1" --cidfile "$2" --cgroups=no-conmon \
    --replace --detach --tty --privileged \
    --name openmower \
    --network=host \
    --volume /dev:/dev \
    --volume /boot/openmower/mower_config.txt:/config/mower_config.sh \
    --volume /root/ros_home:/root \
    --volume /root/rosconsole.config:/config/rosconsole.config \
    --env ROSCONSOLE_CONFIG_FILE=/config/rosconsole.config \
    --env ROSOUT_DISABLE_FILE_LOGGING="True" \
    --label io.containers.autoupdate="registry" \
    ghcr.io/clemenselflein/open_mower_ros:${OM_VERSION}
fi
