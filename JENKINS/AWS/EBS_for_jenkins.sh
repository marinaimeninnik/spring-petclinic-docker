#!/bin/bash

# Check available disks (the newly attached EBS volumes)
lsblk

# Format the EBS volumes (example: /dev/xvdf and /dev/xvdg)
sudo mkfs -t ext4 /dev/xvdf
sudo mkfs -t ext4 /dev/xvdg

# Create directories for mounting
sudo mkdir /jenkins_home
sudo mkdir /jenkins_data

# Mount the EBS volumes to the directories
sudo mount /dev/xvdf /jenkins_home
sudo mount /dev/xvdg /jenkins_data

# Add entries to /etc/fstab to auto-mount on boot
echo '/dev/xvdf /jenkins_home ext4 defaults 0 0' | sudo tee -a /etc/fstab
echo '/dev/xvdg /jenkins_data ext4 defaults 0 0' | sudo tee -a /etc/fstab

# Verify mounts
df -h
