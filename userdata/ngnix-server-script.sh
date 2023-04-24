#! /bin/bash
sudo apt update -y 
sudo apt install -y nginx
sudo apt install -y nginx-core
sudo systemctl start nginx
sudo systemctl enable nginx
sudo apt install certbot python3-certbot-nginx -y
sudo echo "<head><title>Hello World</title></head><body><h1>Welcome!!!.</h1><br>Thank you</body>" | sudo tee /var/www/html/index.nginx-debian.html
sudo nginx -t
