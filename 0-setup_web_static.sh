#!/usr/bin/env bash

# Check if Nginx is installed
if ! command -v nginx &>/dev/null; then

Install Nginx
apt-get update
apt-get install nginx -y
fi

# Create the /data/ directory if it doesn't exist
if [ ! -d /data ]; then
mkdir /data
fi

# Create the /data/web_static/ directory if it doesn't exist
if [ ! -d /data/web_static ]; then
mkdir /data/web_static
fi

# Create the /data/web_static/releases/ directory if it doesn't exist
if [ ! -d /data/web_static/releases ]; then
mkdir /data/web_static/releases
fi

# Create the /data/web_static/shared/ directory if it doesn't exist
if [ ! -d /data/web_static/shared ]; then
mkdir /data/web_static/shared
fi

# Create the /data/web_static/releases/test/ directory if it doesn't exist
if [ ! -d /data/web_static/releases/test ]; then
mkdir /data/web_static/releases/test
fi

# Create a fake HTML file /data/web_static/releases/test/index.html
echo "This is a test file" > /data/web_static/releases/test/index.html

# Create a symbolic link /data/web_static/current linked to the /data/web_static/releases/test/ folder. If the symbolic link already exists, it should be deleted and recreated every time the script is ran.
if [ -L /data/web_static/current ]; then
unlink /data/web_static/current
fi

ln -s /data/web_static/releases/test /data/web_static/current

# Give ownership of the /data/ folder to the ubuntu user AND group (you can assume this user and group exist). This should be recursive; everything inside should be created/owned by this user/group.
chown -R ubuntu:ubuntu /data

# Update the Nginx configuration
CWD=$(pwd)

#Update the Nginx configuration

echo "
server {
listen 80;
server_name hbnb_static;

location / {
root $CWD/deployments/web_static/current;
}
}
" > /etc/nginx/sites-available/hbnb_static

# Enable the Nginx configuration
ln -s /etc/nginx/sites-available/hbnb_static /etc/nginx/sites-enabled/hbnb_static

#Restart Nginx
service nginx restart
