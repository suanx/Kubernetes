#!/bin/bash

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install snapd (if it's not already installed)
if ! command -v snap &> /dev/null
then
    echo "snapd not found, installing it..."
    sudo apt install snapd -y
else
    echo "snapd is already installed."
fi

# Ensure snapd is up to date and refreshed
sudo snap install core
sudo snap refresh core

# Install MicroK8s using snap
echo "Installing MicroK8s..."
sudo snap install microk8s --classic

# Add the current user to the 'microk8s' group to avoid sudo for kubectl
echo "Adding user to microk8s group..."
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube

# Enable useful MicroK8s add-ons like DNS, Dashboard, and Storage
echo "Enabling MicroK8s add-ons..."
microk8s enable dns dashboard storage

# Create kubectl alias
echo "Creating kubectl alias..."
echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc
source ~/.bashrc

# Update permissions and refresh the shell for group changes
newgrp microk8s

# Wait for MicroK8s to start and check status
echo "Waiting for MicroK8s to start..."
sleep 10
microk8s status --wait-ready

# Final message indicating successful installation
echo "✅ MicroK8s installed and ready!"
