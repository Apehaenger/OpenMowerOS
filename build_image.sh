#!/bin/bash
# Call this script to build the image

if compgen -G "./OpenMowerOS/src/image/*" > /dev/null; then
    echo "Image exists, skipping download."
else
    echo "No image found, downloading latest Raspbiann image."
    bash -c "cd OpenMowerOS/src && mkdir -p image && cd image && wget -c --trust-server-names 'https://downloads.raspberrypi.org/raspios_lite_arm64_latest'"
fi

echo "Capturing build metadata"
BUILD_DATE_UTC=$(date -u +%Y-%m-%dT%H:%M:%SZ)
GIT_COMMIT_FULL=$(git rev-parse HEAD 2>/dev/null || echo unknown)
GIT_COMMIT_SHORT=$(echo "$GIT_COMMIT_FULL" | cut -c1-8)
META_DIR="OpenMowerOS/src/modules/openmower/filesystem/root/etc"
mkdir -p "$META_DIR"
cat > "$META_DIR/openmower-buildinfo" <<EOF
OPENMOWER_BUILD_DATE="$BUILD_DATE_UTC"
OPENMOWER_GIT_COMMIT="$GIT_COMMIT_FULL"
OPENMOWER_GIT_SHORT="$GIT_COMMIT_SHORT"
EOF

echo "Starting Image Build (commit $GIT_COMMIT_SHORT at $BUILD_DATE_UTC)"
sudo bash -c "./OpenMowerOS/src/build_dist"

