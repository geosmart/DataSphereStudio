#!/bin/sh
source ${workDir}/bin/entrypoint/functions.sh
EUREKA_URL=http://$EUREKA_INSTALL_IP:$EUREKA_PORT/eureka/

##visualis-server Install
PACKAGE_DIR=visualis-server
APP_PREFIX=""
SERVER_NAME="visualis-server"
SERVER_PATH=${APP_PREFIX}${SERVER_NAME}
SERVER_IP=$VISUALIS_SERVER_INSTALL_IP
SERVER_PORT=$VISUALIS_SERVER_PORT
SERVER_HOME=$DSS_WORK_HOME
###install visualis-server
installVisualis
###update visualis-server linkis.properties
echo "$SERVER_PATH-update linkis.properties"
SERVER_CONF_PATH=$SERVER_HOME/$SERVER_PATH/conf/linkis.properties
if [ $VISUALIS_NGINX_IP == "127.0.0.1" ] || [ $VISUALIS_NGINX_IP == "0.0.0.0" ]; then
  VISUALIS_NGINX_IP=$ipaddr
fi
if [ $VISUALIS_SERVER_INSTALL_IP == "127.0.0.1" ] || [ $VISUALIS_SERVER_INSTALL_IP == "0.0.0.0" ]; then
  VISUALIS_SERVER_INSTALL_IP=$ipaddr
fi
executeCMD $SERVER_IP "sed -i  \"s#wds.linkis.entrance.config.logPath.*#wds.linkis.entrance.config.logPath=$WORKSPACE_USER_ROOT_PATH#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#wds.linkis.resultSet.store.path.*#wds.linkis.resultSet.store.path=$RESULT_SET_ROOT_PATH#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#wds.dss.visualis.gateway.ip.*#wds.dss.visualis.gateway.ip=$GATEWAY_INSTALL_IP#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#wds.dss.visualis.gateway.port.*#wds.dss.visualis.gateway.port=$GATEWAY_PORT#g\" $SERVER_CONF_PATH"
SERVER_CONF_PATH=$SERVER_HOME/$SERVER_PATH/conf/application.yml
executeCMD $SERVER_IP "sed -i  \"s#address: 127.0.0.1#address: $VISUALIS_SERVER_INSTALL_IP#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#port:  9007#port:  $VISUALIS_SERVER_PORT#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#url: http://0.0.0.0:0000/dss/visualis#url: http://$VISUALIS_NGINX_IP:$VISUALIS_NGINX_PORT/dss/visualis#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#address: 0.0.0.0#address: $VISUALIS_NGINX_IP#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#port: 0000#port: $VISUALIS_NGINX_PORT#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#defaultZone: http://127.0.0.1:20303/eureka/#defaultZone: http://$EUREKA_INSTALL_IP:$EUREKA_PORT/eureka/#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#url: jdbc:mysql://127.0.0.1:3306/xxx?characterEncoding=UTF-8#url: jdbc:mysql://$MYSQL_HOST:$MYSQL_PORT/$MYSQL_DB?characterEncoding=UTF-8#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#username: xxx#username: $MYSQL_USER#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#password: xxx#password: $MYSQL_PASSWORD#g\" $SERVER_CONF_PATH"
isSuccess "subsitution linkis.properties of $SERVER_PATH"
echo "<----------------$SERVER_PATH:end------------------->"

# start and check
startApp
sleep 10
checkServer
