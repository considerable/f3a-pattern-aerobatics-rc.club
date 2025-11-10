#!/bin/bash
# F3A Microservice Full Deployment Script

set -e

echo "🚀 F3A Microservice Deployment Starting..."

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IAC_DIR="$PROJECT_DIR/iac"
K8S_DIR="$PROJECT_DIR/k8s"
APP_DIR="$PROJECT_DIR/app"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."

    command -v terraform >/dev/null 2>&1 || error "Terraform not found. Please install Terraform."
    command -v aws >/dev/null 2>&1 || error "AWS CLI not found. Please install AWS CLI."
    command -v docker >/dev/null 2>&1 || error "Docker not found. Please install Docker."

    # Check AWS credentials
    aws sts get-caller-identity >/dev/null 2>&1 || error "AWS credentials not configured."

    success "Prerequisites check passed"
}

# Deploy infrastructure
deploy_infrastructure() {
    log "Deploying infrastructure with Terraform..."

    cd "$IAC_DIR"

    # Check if terraform.tfvars exists
    if [ ! -f "terraform.tfvars" ]; then
        warning "terraform.tfvars not found. Creating from example..."
        cp terraform.tfvars.example terraform.tfvars
        warning "Please edit terraform.tfvars with your configuration and run again."
        exit 1
    fi

    terraform init
    terraform plan
    terraform apply -auto-approve

    # Get instance IP
    INSTANCE_IP=$(terraform output -raw instance_ip)
    INSTANCE_ID=$(terraform output -raw instance_id)

    success "Infrastructure deployed. Instance IP: $INSTANCE_IP"

    # Wait for instance to be ready
    log "Waiting for instance to be ready..."
    aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"
    sleep 60  # Additional wait for user-data script

    success "Instance is ready"
}

# Build and deploy application
deploy_application() {
    log "Building and deploying application..."

    cd "$APP_DIR"

    # Build Docker image
    log "Building Docker image..."
    docker build -t f3a-microservice:latest .

    # Save image to tar file for transfer
    docker save f3a-microservice:latest > /tmp/f3a-microservice.tar

    # Get instance details
    cd "$IAC_DIR"
    INSTANCE_IP=$(terraform output -raw instance_ip)

    # Copy application files to instance
    log "Copying application to instance..."

    # Create deployment script
    cat > /tmp/deploy-to-instance.sh << 'EOF'
#!/bin/bash
set -e

# Load Docker image
sudo docker load < /tmp/f3a-microservice.tar

# Apply Kubernetes manifests
sudo kubectl apply -f /tmp/k8s/

# Wait for deployment
sudo kubectl wait --for=condition=available --timeout=300s deployment/f3a-app -n f3a-microservice

echo "✅ Application deployed successfully!"
EOF

    chmod +x /tmp/deploy-to-instance.sh

    # Use AWS SSM to deploy (no SSH key required)
    log "Deploying via AWS SSM..."

    # Copy files using SSM
    aws ssm send-command \
        --instance-ids "$INSTANCE_ID" \
        --document-name "AWS-RunShellScript" \
        --parameters 'commands=["mkdir -p /tmp/k8s"]' \
        --output text --query "Command.CommandId" > /tmp/command-id.txt

    # Wait for command to complete
    sleep 10

    # Copy Kubernetes manifests
    for file in "$K8S_DIR"/*.yaml; do
        filename=$(basename "$file")
        aws ssm send-command \
            --instance-ids "$INSTANCE_ID" \
            --document-name "AWS-RunShellScript" \
            --parameters "commands=[\"cat > /tmp/k8s/$filename << 'EOFK8S'\n$(cat "$file")\nEOFK8S\"]" \
            --output text --query "Command.CommandId" > /tmp/command-id-$filename.txt
        sleep 5
    done

    # Deploy application
    aws ssm send-command \
        --instance-ids "$INSTANCE_ID" \
        --document-name "AWS-RunShellScript" \
        --parameters "commands=[\"$(cat /tmp/deploy-to-instance.sh)\"]" \
        --output text --query "Command.CommandId" > /tmp/deploy-command-id.txt

    success "Application deployment initiated"

    # Show access information
    echo ""
    echo "🌐 Access URLs:"
    echo "   Website: http://$INSTANCE_IP:30080"
    echo "   Health Check: http://$INSTANCE_IP:30080/health"
    echo "   Club API: http://$INSTANCE_IP:30080/api/club"
    echo ""
}

# Main deployment flow
main() {
    log "Starting F3A Microservice deployment..."

    check_prerequisites
    deploy_infrastructure
    deploy_application

    success "🎉 F3A Microservice deployment completed!"

    echo ""
    echo "📋 Next Steps:"
    echo "1. Test the application endpoints"
    echo "2. Configure DNS if needed"
    echo "3. Set up monitoring and alerts"
    echo "4. Configure SSL certificates for production"
    echo ""
}

# Run main function
main "$@"
