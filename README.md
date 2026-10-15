# Uruha

The bubblewrap-based machine learning environment for amdgpu with ROCm.

## Prerequisites

Ensure `bubblewrap` (`bwrap`) is installed on your host system:

- **Debian / Ubuntu**: `sudo apt install bubblewrap`
- **Fedora / RHEL / Rocky Linux**: `sudo dnf install bubblewrap`
- **Arch Linux**: `sudo pacman -S bubblewrap`
- **openSUSE**: `sudo zypper install bubblewrap`

## Installation

Choose the directory you prefer to store your rootfs.

For example, a dedicated mounted drive directory is recommended because ROCm suites will take more than 16GB:

```sh
git clone https://github.com/supersonictw/uruha.git . # Checkout the repository
bash init_rootfs.sh # Initialize rootfs and setup ROCm + uv
```

## Usage

Start an interactive shell in the container:

```sh
bash activate.sh
```

Or run any command directly:

```sh
bash activate.sh rocm-smi
bash activate.sh uv run python train.py
```

The script will launch the container using `bubblewrap` with GPU devices (`/dev/kfd`, `/dev/dri`) mapped automatically.

The default shell is `bash` with ["uv"](https://github.com/astral-sh/uv) pre-installed. You can use `uv` to manage Python versions and packages easily:

```sh
# Install a specific Python version
uv python install 3.10

# Create a virtual environment
uv venv

# Install PyTorch with ROCm
uv pip install torch --index-url https://download.pytorch.org/whl/rocm6.4
```

The script's default setup defines `HSA_OVERRIDE_GFX_VERSION=10.3.0` in `/root/.bashrc` to support RX6XXX series RDNA2 GPUs. For RDNA3 (e.g. RX 7900 series, gfx1100) or other supported cards, ROCm works natively and you can comment out or adjust the variable.
