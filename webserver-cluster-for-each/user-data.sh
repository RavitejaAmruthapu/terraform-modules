#!/bin/bash
sudo apt update
sudo apt install apache2 -y
#sudo echo "hello terraform"> /var/www/html/index.html


sudo cat > /var/www/html/index.html <<EOF
<h1>${text}</h1>
EOF

sudo systemctl start apache2