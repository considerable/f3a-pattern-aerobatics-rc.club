.PHONY: setup security deploy-infra deploy-app setup-pages test clean

# Setup development environment
setup:
	pip3 install pre-commit detect-secrets
	python3 -m pre_commit install
	python3 -m detect_secrets scan . > .secrets.baseline

# Run security scans
security:
	python3 -m pre_commit run --all-files
	python3 -m detect_secrets scan .

# Deploy infrastructure
deploy-infra:
	cd iac && terraform init && terraform apply -auto-approve

# Deploy application
deploy-app:
	cd k8s && ./deploy.sh

# Full deployment
deploy: deploy-infra deploy-app

# Setup GitHub Pages
setup-pages:
	@echo "Setting up GitHub Pages..."
	echo "f3a-pattern-aerobatics-rc.club" > app/public/v2/CNAME
	git add app/public/v2/CNAME
	git commit -m "Add CNAME for GitHub Pages custom domain" || true
	git push
	@echo "Updating DNS records..."
	aws route53 change-resource-record-sets --hosted-zone-id Z00071653MWP8XE0V1MUU --change-batch '{ "Changes": [{ "Action": "UPSERT", "ResourceRecordSet": { "Name": "f3a-pattern-aerobatics-rc.club", "Type": "A", "TTL": 300, "ResourceRecords": [{ "Value": "185.199.108.153" }, { "Value": "185.199.109.153" }, { "Value": "185.199.110.153" }, { "Value": "185.199.111.153" }] } }] }'
	@echo "GitHub Pages setup complete!"

# Test endpoints
test:
	@echo "Testing health endpoint..."
	@curl -s http://localhost:3000/health | jq
	@echo "Testing club API..."
	@curl -s http://localhost:3000/api/club | jq
	@echo "Testing GitHub Pages..."
	@curl -siL https://considerable.github.io/f3a-microservice/ | head -1
	@curl -siL https://f3a-pattern-aerobatics-rc.club | head -1

# Clean up resources
clean:
	cd iac && terraform destroy -auto-approve
