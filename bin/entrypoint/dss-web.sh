#!/bin/sh
source ${workDir}/bin/entrypoint/functions.sh
LINKIS_GATEWAY_URL=$LINKIS_GATEWAY_URL

echo "dss web install start"
PACKAGE_DIR=dss/dss-web
APP_PREFIX="dss-"
SERVER_NAME="web"
SERVER_PATH=${APP_PREFIX}${SERVER_NAME}
SERVER_IP=$DSS_WEB_INSTALL_IP
SERVER_PORT=$DSS_WEB_PORT
SERVER_HOME=$DSS_WORK_HOME
DSS_WEB_HOME=$SERVER_HOME/$SERVER_PATH

# visualis_home
VISUALIS_WEB_HOME=$SERVER_HOME/visualis-web/dss/visualis

#install Dss-Server
installPackage

echo "========================================================================dss-web config======================================================================="
echo "dss-web ip: ${SERVER_IP}"
echo "dss-web port: ${SERVER_PORT}"
echo "linkis-gateway: ${LINKIS_GATEWAY_URL}"
echo "dss-web static file path: ${DSS_WEB_HOME}"
echo "visualis-web static file path: ${DSS_WEB_HOME}"
echo "========================================================================dss-web config======================================================================="

dssConf() {
  s_host='$host'
  s_remote_addr='$remote_addr'
  s_proxy_add_x_forwarded_for='$proxy_add_x_forwarded_for'
  s_http_upgrade='$http_upgrade'
  sudo sh -c "echo '
        server {
              listen       $SERVER_PORT;# 访问端口
              server_name  localhost;
              #charset koi8-r;
              #access_log  /var/log/nginx/host.access.log  main;
              location /dss/visualis {
              root   ${VISUALIS_WEB_HOME}; # 静态文件目录
              autoindex on;
              autoindex_localtime on;
            }
            location / {
              root   ${DSS_WEB_HOME}/dist; # 静态文件目录
              index  index.html index.html;
              autoindex on;
              autoindex_localtime on;
            }
            location /ws {
              proxy_pass $LINKIS_GATEWAY_URL;#后端Linkis的地址
              proxy_http_version 1.1;
              proxy_set_header Upgrade $s_http_upgrade;
              proxy_set_header Connection "upgrade";
            }

            location /api {
              proxy_pass $LINKIS_GATEWAY_URL; #后端Linkis的地址
              proxy_set_header Host $s_host;
              proxy_set_header X-Real-IP $s_remote_addr;
              proxy_set_header x_real_ipP $s_remote_addr;
              proxy_set_header remote_addr $s_remote_addr;
              proxy_set_header X-Forwarded-For $s_proxy_add_x_forwarded_for;
              proxy_http_version 1.1;
              proxy_connect_timeout 4s;
              proxy_read_timeout 600s;
              proxy_send_timeout 12s;
              proxy_set_header Upgrade $s_http_upgrade;
              proxy_set_header Connection upgrade;
            }

            #error_page  404              /404.html;
            # redirect server error pages to the static page /50x.html
            #
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
              root   /usr/share/nginx/html;
            }
        }
    ' > /etc/nginx/conf.d/dss.conf"
}
# config nginx
dssConf

#if ! test -e $VISUALIS_WEB_HOME/visualis-web.zip; then
#  echo "Error*************:用户自行编译安装DSS WEB时，则需要把visualis的前端安装包build.zip放置于$VISUALIS_WEB_HOME/dss/visualis用于自动化安装"
#  exit 1
#fi
#cd $VISUALIS_WEB_HOME
# todo unzip visualis-web
#unzip -o visualis-web.zip >/dev/null

#start and check
startApp
sleep 3
checkServer