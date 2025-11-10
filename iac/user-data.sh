#!/bin/bash
# F3A Microservice - EC2 User Data Script with Full Deployment

set -e

# Update system
yum update -y

# Install required packages (skip curl as it's already installed)
yum install -y wget git docker gcc-c++ make

# Start Docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install Node.js
wget -qO- https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Clone and deploy microservice
cd /home/ec2-user
git clone https://github.com/considerable/f3a-microservice.git
chown -R ec2-user:ec2-user f3a-microservice

# Install dependencies and start app
cd f3a-microservice/app
npm install

# Create systemd service for the app
cat > /etc/systemd/system/f3a-microservice.service << EOF
[Unit]
Description=F3A Microservice
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/f3a-microservice/app
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=PORT=3000

[Install]
WantedBy=multi-user.target
EOF

# Start the service
systemctl daemon-reload
systemctl enable f3a-microservice
systemctl start f3a-microservice

# Set up port forwarding from 30080 to 3000 using iptables
iptables -t nat -A PREROUTING -p tcp --dport 30080 -j REDIRECT --to-port 3000
iptables-save > /etc/sysconfig/iptables

# Log deployment status
echo "=== F3A Microservice Deployment Complete ===" > /var/log/user-data.log
echo "Timestamp: $(date)" >> /var/log/user-data.log
echo "" >> /var/log/user-data.log
echo "Service Status:" >> /var/log/user-data.log
systemctl status f3a-microservice >> /var/log/user-data.log
echo "" >> /var/log/user-data.log
echo "Test: curl http://localhost:3000/health" >> /var/log/user-data.log
sleep 10
curl -s http://localhost:3000/health >> /var/log/user-data.log 2>&1 || echo "Service not ready yet" >> /var/log/user-data.log
