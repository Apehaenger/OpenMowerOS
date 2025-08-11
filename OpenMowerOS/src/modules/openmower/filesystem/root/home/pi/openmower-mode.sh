#!/bin/bash
# Change OpenMower mode and restart the service

ENV_FILE="/home/pi/openmower_mode.env"
SERVICE="openmower.service"

if [[ "$1" == "debug" || "$1" == "normal" ]]; then
    sed -i "s/^OM_MODE=.*/OM_MODE=$1/" "$ENV_FILE"
    echo "Set OM_MODE=$1 in $ENV_FILE"
    sudo systemctl daemon-reload
    sudo systemctl restart "$SERVICE"
    # Refresh branding (issue & motd)
    if command -v sudo >/dev/null; then
        sudo /usr/local/bin/openmower-refresh-branding || true
    else
        /usr/local/bin/openmower-refresh-branding || true
    fi
    echo "Service $SERVICE restarted."
else
    echo "Usage: $0 [normal|debug]"
    exit 1
fi