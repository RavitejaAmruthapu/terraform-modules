#!/bin/bash
sudo apt update
sudo apt install apache2 -y
#sudo echo "hello terraform"> /var/www/html/index.html


sudo cat > /var/www/html/index.html <<EOF
<h1>Hello, for-each</h1>
EOF

#nohup busybox httpd -f -p ${server_port} &
sudo systemctl start apache2