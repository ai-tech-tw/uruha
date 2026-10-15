#!/bin/bash

set -e

export URUHA_WORK_DIRECTORY=$PWD

if [ ! -d "$URUHA_WORK_DIRECTORY/rootfs" ]; then
    echo "Error: rootfs directory not found in $URUHA_WORK_DIRECTORY." >&2
    exit 1
fi

if ! command -v bwrap >/dev/null 2>&1; then
    echo "Error: bubblewrap (bwrap) is not installed. Please install it via your package manager (e.g. sudo apt install bubblewrap)." >&2
    exit 1
fi

SUDO=""
if [ "$EUID" != 0 ]; then
    if [ ! -r "$URUHA_WORK_DIRECTORY/rootfs/root" ]; then
        SUDO="sudo"
    fi
fi

EXEC_CMD=("$@")
if [ ${#EXEC_CMD[@]} -eq 0 ]; then
    EXEC_CMD=(/bin/bash)
fi

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
    "${EXEC_CMD[@]}"
