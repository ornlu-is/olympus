#!/bin/bash

# Install the prerequisite packages
sudo apt install -y apt-transport-https software-properties-common wget

# Import the GPG key
mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

# Add the Grafana stable release repository
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Update the list of available packages
sudo apt update

# Install Grafana
sudo apt install grafana

# Configure data sources
sudo touch /etc/grafana/provisioning/datasources/datasources.yaml
cat ./infrastructure/grafana/provisioning/datasources/datasources.yaml | sudo tee /etc/grafana/provisioning/datasources/datasources.yaml

# Configure pre-built dashboard
sudo mkdir /var/lib/grafana/dashboards
cat ./infrastructure/grafana/dashboards/dashboard.yaml | sudo tee /etc/grafana/provisioning/dashboards/dashboard.yaml
cat ./infrastructure/grafana/dashboards/nodes.json | sudo tee /var/lib/grafana/dashboards/nodes.json

# Reload systemd, enable and start Grafana
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
