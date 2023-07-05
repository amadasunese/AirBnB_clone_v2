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
=======
#This is a Bash script that sets up your web servers for the deployment of web_static. It must:

#Install Nginx if it not already installed
#Create the folder /data/ if it doesn’t already exist
#Create the folder /data/web_static/ if it doesn’t already exist
#Create the folder /data/web_static/releases/ if it doesn’t already exist
#Create the folder /data/web_static/shared/ if it doesn’t already exist
#Create the folder /data/web_static/releases/test/ if it doesn’t already exist
#Create a fake HTML file /data/web_static/releases/test/index.html (with simple content, to test your Nginx configuration)
#Create a symbolic link /data/web_static/current linked to the /data/web_static/releases/test/ folder. If the symbolic link already exists, it should be deleted and recreated every time the script is ran.
#Give ownership of the /data/ folder to the ubuntu user AND group (you can assume this user and group exist). This should be recursive; everything inside should be created/owned by this user/group.
#Update the Nginx configuration to serve the content of /data/web_static/current/ to hbnb_static (ex: https://mydomainname.tech/hbnb_static). Don’t forget to restart Nginx after updating the configuration:
#Use alias inside your Nginx configuration

sudo apt-get update
sudo apt-get -y install nginx

sudo mkdir -p /data/
sudo mkdir -p /data/web_static/
#sudo ln -sf /data/web_static/releases/test /data/web_static/current
#sudo mkdir -p /data/web_static/current/
sudo mkdir -p /data/web_static/releases/
sudo mkdir -p  /data/web_static/shared/
sudo mkdir -p /data/web_static/releases/test/
sudo touch /data/web_static/releases/test/index.html
sudo touch /var/www/html/404.html
echo "Ceci n'est pas une page" > /var/www/html/404
content='<!DOCTYPE html>
<html lang="en">
        <head>
                <title>Fake website</title>
        </head>
        <body>Just testing</body>
</html>'
echo "$content" > /data/web_static/releases/test/index.html
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
chown -R ubuntu:ubuntu /data/

config="server {
        listen 80 default_server;
        listen [::]:80 default_server;
	root /var/www/html;
	# Add index.php to the list if you are using PHP
	index index.html index.htm index.nginx-debian.html;

	server_name _;
	add_header X-Served-By $HOSTNAME;

	location / {
		try_files \$uri \$uri/ =404;
	}
	if (\$request_filename ~ redirect_me){
			rewrite ^ https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;
	}
        location /hbnb_static {
                alias /data/web_static/current;
        }
	error_page 404 /404.html;
	location = /404.html{
		internal;
	}
}"

echo -e "$config" > /etc/nginx/sites-enabled/default
sudo service nginx restart
