#!/bin/bash
yum -y update
yum -y install httpd
PRIVATE_IP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo “Web Server has $PRIVATE_IP “ > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
