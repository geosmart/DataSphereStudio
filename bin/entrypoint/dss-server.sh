#!/bin/sh
source ${workDir}/bin/entrypoint/functions.sh
EUREKA_URL=http://$EUREKA_INSTALL_IP:$EUREKA_PORT/eureka/

#dss-Server install
PACKAGE_DIR=dss/dss-server
APP_PREFIX="dss-"
SERVER_NAME="server"
SERVER_PATH=${APP_PREFIX}${SERVER_NAME}
SERVER_IP=$DSS_SERVER_INSTALL_IP
SERVER_PORT=$DSS_SERVER_PORT
SERVER_HOME=$DSS_WORK_HOME

#install Dss-Server
installPackage

#update Dss-Server linkis.properties
echo "$SERVER_PATH-update linkis.properties"
SERVER_CONF_PATH=$SERVER_HOME/$SERVER_PATH/conf/linkis.properties
executeCMD $SERVER_IP "sed -i  \"s#wds.linkis.server.mybatis.datasource.url.*#wds.linkis.server.mybatis.datasource.url=jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${MYSQL_DB}?characterEncoding=UTF-8#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#wds.linkis.server.mybatis.datasource.username.*#wds.linkis.server.mybatis.datasource.username=$MYSQL_USER#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#wds.linkis.server.mybatis.datasource.password.*#wds.linkis.server.mybatis.datasource.password=$MYSQL_PASSWORD#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#wds.dss.appjoint.scheduler.azkaban.address.*#wds.dss.appjoint.scheduler.azkaban.address=http://${AZKABAN_ADRESS_IP}:${AZKABAN_ADRESS_PORT}#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#wds.linkis.gateway.ip.*#wds.linkis.gateway.ip=$GATEWAY_INSTALL_IP#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#wds.linkis.gateway.port.*#wds.linkis.gateway.port=$GATEWAY_PORT#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#wds.dss.appjoint.scheduler.project.store.dir.*#wds.dss.appjoint.scheduler.project.store.dir=$WDS_SCHEDULER_PATH#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "echo "$deployUser=$deployUser" >> $SERVER_HOME/$SERVER_PATH/conf/token.properties"
isSuccess "subsitution linkis.properties of $SERVER_PATH"
echo "<----------------$SERVER_PATH:end------------------->"

echo "$SERVER_PATH-update application.yml"
SERVER_CONF_PATH=$SERVER_HOME/$SERVER_PATH/conf/application.yml
executeCMD $SERVER_IP "sed -i  \"s#port:.*#port: $SERVER_PORT#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#defaultZone:.*#defaultZone: $EUREKA_URL#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#hostname:.*#hostname: $SERVER_IP#g\" $SERVER_CONF_PATH"
isSuccess "subsitution conf of $SERVER_PATH"

#start and check
startApp
sleep 10
checkServer
