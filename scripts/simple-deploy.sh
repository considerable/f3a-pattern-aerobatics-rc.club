#!/bin/bash
# Simple deployment script for F3A microservice

set -e

echo "🚀 Deploying F3A Microservice..."

# Create application files on instance
cat > /tmp/server.js << 'EOF'
const express = require('express');
const app = express();
const PORT = 3000;

app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/api/club', (req, res) => {
  res.json({
    name: 'F3A Pattern Aerobatics RC Club',
    description: 'Precision aerobatic flying with radio-controlled aircraft',
    location: 'Pacific Northwest'
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 F3A Microservice running on port ${PORT}`);
});
EOF

# Install Node.js if not present
if ! command -v node &> /dev/null; then
    curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
    sudo yum install -y nodejs
fi

# Install dependencies and start
cd /tmp
npm init -y
npm install express
nohup node server.js > app.log 2>&1 &

echo "✅ Application deployed on port 3000"
