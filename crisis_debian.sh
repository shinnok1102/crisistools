#!/bin/bash

# Exit script on any error
set -e

# Update package list
echo "Updating package list..."
sudo apt-get update -y

# List of packages to install via apt
packages=(
  "git"
  "procps"
  "util-linux"
  "sysstat"
  "iproute2"
  "numactl"
  "bpfcc-tools"
  "linux-headers-$(uname -r)"
  "bpftrace"
  "perf-tools-unstable"
  "trace-cmd"
  "nicstat"
  "ethtool"
  "tiptop"
  "msr-tools"
)

# Add performance tools package based on kernel version
echo "Detecting kernel version and performance tools dependencies..."
kernel_version="$(uname -r)"
if sudo apt-cache search "linux-tools-${kernel_version}" | grep -q "linux-tools-${kernel_version}"; then
  packages+=("linux-tools-${kernel_version}")
else
  echo "Warning: linux-tools-${kernel_version} package not found. Skipping this package."
fi

# Install each package if it is not already installed
echo "Installing packages..."
for package in "${packages[@]}"; do
  if ! dpkg -l | grep -qw "$package"; then
    echo "Installing $package..."
    sudo apt-get install -y "$package"
  else
    echo "$package is already installed."
  fi
done

# Check if git is installed (it is critical for cloning repositories)
if ! command -v git &> /dev/null; then
  echo "git is not installed. Please install it manually and re-run the script."
  exit 1
fi

# Clone and install msr-cloud-tools from GitHub
if [ ! -d "msr-cloud-tools" ]; then
  echo "Cloning msr-cloud-tools..."
  git clone https://github.com/brendangregg/msr-cloud-tools.git
  echo "msr-cloud-tools cloned successfully."
else
  echo "msr-cloud-tools is already cloned."
fi

# Clone and install pmc-cloud-tools from GitHub
if [ ! -d "pmc-cloud-tools" ]; then
  echo "Cloning pmc-cloud-tools..."
  git clone https://github.com/brendangregg/pmc-cloud-tools.git
  echo "pmc-cloud-tools cloned successfully."
else
  echo "pmc-cloud-tools is already cloned."
fi

echo "All tools and packages are installed."
