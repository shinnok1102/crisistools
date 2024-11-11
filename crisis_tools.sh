#!/bin/bash

# Exit script on any error
set -e

# Update package list
echo "Updating package list..."
sudo apt-get update

# List of packages to install via apt
packages=(
  "git"
  "procps"
  "util-linux"
  "sysstat"
  "iproute2"
  "numactl"
  "linux-tools-common"
  "linux-tools-generic"
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

# Install each package if it is not already installed
echo "Installing packages..."
for package in "${packages[@]}"; do
  if ! dpkg -l | grep -q "$package"; then
    echo "Installing $package..."
    sudo apt-get install -y "$package"
  else
    echo "$package is already installed."
  fi
done

# Clone and install msr-cloud-tools from GitHub
if [ ! -d "msr-cloud-tools" ]; then
  echo "Cloning msr-cloud-tools..."
  git clone https://github.com/brendangregg/msr-cloud-tools.git
else
  echo "msr-cloud-tools is already cloned."
fi

# Clone and install pmc-cloud-tools from GitHub
if [ ! -d "pmc-cloud-tools" ]; then
  echo "Cloning pmc-cloud-tools..."
  git clone https://github.com/brendangregg/pmc-cloud-tools.git
else
  echo "pmc-cloud-tools is already cloned."
fi

echo "All tools and packages are installed."
