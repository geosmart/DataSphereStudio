#!/bin/bash

SERVER_IP=$DSS_WEB_INSTALL_IP
SERVER_PORT=$DSS_WEB_PORT

# config SELinux
sudo sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
sudo setenforce 0

# fix 0.0.0.0:8888
sudo yum -y install policycoreutils-python
sudo semanage port -a -t http_port_t -p tcp $SERVER_PORT

# start nginx
sudo systemctl restart nginx

echo "please visit dss-web at：http://${SERVER_IP}:${SERVER_PORT}"
