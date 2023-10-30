salt-highstate:
	sudo salt '*' state.highstate

install-prometheus:
	sudo sh ./install-scripts/prometheus/prometheus.sh

install-grafana:
	sudo sh ./install-scripts/grafana/grafana.sh

apply-grafana:
	sudo mkdir /var/lib/grafana/dashboards
	sudo touch /etc/grafana/provisioning/datasources/datasources.yaml /etc/grafana/provisioning/dashboards/dashboard.yaml
	cat ./infrastructure/grafana/provisioning/datasources/datasources.yaml | sudo tee /etc/grafana/provisioning/datasources/datasources.yaml
	cat ./infrastructure/grafana/dashboards/dashboard.yaml | sudo tee /etc/grafana/provisioning/dashboards/dashboard.yaml
	cat ./infrastructure/grafana/dashboards/nodes.json | sudo tee /var/lib/grafana/dashboards/nodes.json
	sudo systemctl restart grafana-server

apply-prometheus:
	sudo touch /etc/prometheus/prometheus.yaml
	cat ./infrastructure/prometheus/prometheus.yaml | sudo tee /etc/prometheus/prometheus.yaml
	sudo systemctl restart prometheus