#!/usr/bin/env bash

# Install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    apt-get update
    apt-get install -y nginx
fi

# Create necessary directories
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

# Create a fake HTML file for testing
echo "This is a test" > /data/web_static/releases/test/index.html

# Create or recreate the symbolic link
if [[ -L /data/web_static/current ]]; then
    unlink /data/web_static/current
fi
ln -s /data/web_static/releases/test/ /data/web_static/current

# Set ownership of /data/ folder to ubuntu user and group recursively
chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_file="/etc/nginx/sites-available/default"
sed -i '/^# Static site configuration/,$d' "$config_file"  # Remove previous configuration
echo "server {
    location /hbnb_static {
        alias /data/web_static/current/;
        index index.html;
    }
}" >> "$config_file"

# Restart Nginx
service nginx restart
