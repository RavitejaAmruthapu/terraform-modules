#!/bin/bash
sudo apt update
sudo apt install apache2 -y
#sudo echo "hello terraform"> /var/www/html/index.html


sudo cat > /var/www/html/index.html <<EOF
<h1>Hello, World</h1>
<p>DB address: ${db_address}</p>
<p>DB port: ${db_port}</p>
EOF

#nohup busybox httpd -f -p ${server_port} &
sudo systemctl start apache2