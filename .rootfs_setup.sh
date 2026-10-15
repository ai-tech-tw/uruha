#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
    build-essential ca-certificates curl git gpg wget python3 dropbear

wget -O /tmp/amdgpu-install.deb https://repo.radeon.com/amdgpu-install/6.4.4/ubuntu/jammy/amdgpu-install_6.4.60404-1_all.deb

apt-get install -y -f \
    /tmp/amdgpu-install.deb &&
    amdgpu-install -y --no-dkms --no-32
rm -f /tmp/amdgpu-install.deb

curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh

tee -a /root/.bashrc <<'EOF'
alias sudo=""
alias run-sshd="dropbear -REFp 2024"
alias amdgpu-install="amdgpu-install --no-dkms --no-32"

export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u [uruha]\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

export HSA_OVERRIDE_GFX_VERSION="10.3.0"
export ROCM_PATH="/opt/rocm"
export PATH="$ROCM_PATH/bin:$PATH"

if command -v uv >/dev/null 2>&1; then
    eval "$(uv generate-shell-completion bash)"
fi
EOF
