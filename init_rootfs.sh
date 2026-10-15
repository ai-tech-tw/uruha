#!/bin/bash

set -e

export URUHA_WORK_DIRECTORY=$PWD

if [ -d "$URUHA_WORK_DIRECTORY/rootfs" ]; then
    echo "rootfs already exists, exits for preventing from unexpected initiating."
    exit 1
fi

if ! command -v bwrap >/dev/null 2>&1; then
    echo "Error: bubblewrap (bwrap) is not installed. Please install it via your package manager (e.g. sudo apt install bubblewrap)." >&2
    exit 1
fi

SUDO=""
if [ "$EUID" != 0 ]; then
    SUDO="sudo"
fi

$SUDO wget -O "$URUHA_WORK_DIRECTORY/rootfs.tar.gz" http://cdimage.ubuntu.com/ubuntu-base/releases/24.04/release/ubuntu-base-24.04.5-base-amd64.tar.gz

$SUDO mkdir "$URUHA_WORK_DIRECTORY/rootfs"

$SUDO tar -zxvf "$URUHA_WORK_DIRECTORY/rootfs.tar.gz" -C "$URUHA_WORK_DIRECTORY/rootfs"
$SUDO rm "$URUHA_WORK_DIRECTORY/rootfs.tar.gz"

$SUDO cp "$URUHA_WORK_DIRECTORY/.rootfs_setup.sh" "$URUHA_WORK_DIRECTORY/rootfs/setup.sh"
$SUDO chmod +x "$URUHA_WORK_DIRECTORY/rootfs/setup.sh"

$SUDO bwrap \
    --bind "$URUHA_WORK_DIRECTORY/rootfs" / \
    --dev-bind /dev /dev \
    --proc /proc \
    --ro-bind /sys /sys \
    --ro-bind /etc/resolv.conf /etc/resolv.conf \
    --bind /tmp /tmp \
    --uid 0 --gid 0 \
    --chdir /root \
    --setenv HOME /root \
    /bin/bash /setup.sh

$SUDO rm "$URUHA_WORK_DIRECTORY/rootfs/setup.sh"
