#!/bin/bash
set -euxo pipefail

# Update packages
dnf update -y

# Install NGINX
dnf install -y nginx

# Install CloudWatch Agent
dnf install -y amazon-cloudwatch-agent

# Ensure SSM Agent is enabled
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Enable NGINX
systemctl enable nginx
systemctl start nginx

# Simple application page
cat <<EOF >/usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>AWS Production Platform</title>
</head>
<body>
    <h1>Application Server is Running</h1>
    <p>Environment: dev</p>
    <p>Provisioned by Terraform</p>
</body>
</html>
EOF
