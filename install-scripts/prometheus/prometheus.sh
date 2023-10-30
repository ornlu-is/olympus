#!/bin/bash

# Download and extract most recent Prometheus version
VERSION=$(curl https://raw.githubusercontent.com/prometheus/prometheus/master/VERSION)
wget https://github.com/prometheus/prometheus/releases/download/v${VERSION}/prometheus-${VERSION}.linux-amd64.tar.gz
tar xvzf prometheus-${VERSION}.linux-amd64.tar.gz

# Create directories and files for Prometheus configuration
sudo mkdir /etc/prometheus
sudo mkdir /var/lib/prometheus
sudo touch /etc/prometheus/prometheus.yaml

# Copy the Prometheus binary to the appropriate location
sudo cp prometheus-${VERSION}.linux-amd64/prometheus /usr/local/bin/

# Write the configuration file
cat ./infrastructure/prometheus/prometheus.yaml | sudo tee /etc/prometheus/prometheus.yaml

# Write the systemd unit file for Prometheus
cat ./install-scripts/prometheus/prometheus.service | sudo tee /etc/systemd/system/prometheus.service

# Reload systemd, enable and start Prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Cleanup installation files
rm prometheus-${VERSION}.linux-amd64.tar.gz
rm -rf prometheus-${VERSION}.linux-amd64