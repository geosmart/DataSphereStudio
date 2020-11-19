#!/bin/sh
source ${workDir}/bin/entrypoint/functions.sh
EUREKA_URL=http://$EUREKA_INSTALL_IP:$EUREKA_PORT/eureka/

##Flow execution Install
PACKAGE_DIR=dss/dss-flow-execution-entrance
APP_PREFIX="dss-"
SERVER_NAME="flow-execution-entrance"
SERVER_PATH=${APP_PREFIX}${SERVER_NAME}
SERVER_IP=$FLOW_EXECUTION_INSTALL_IP
SERVER_PORT=$FLOW_EXECUTION_PORT
SERVER_HOME=$DSS_WORK_HOME

#Install flow execution
installPackage

#Update flow execution linkis.properties
echo "$SERVER_PATH-update linkis.properties"
SERVER_CONF_PATH=$SERVER_HOME/$SERVER_PATH/conf/linkis.properties
executeCMD $SERVER_IP  "sed -i  \"s#wds.linkis.entrance.config.logPath.*#wds.linkis.entrance.config.logPath=$WORKSPACE_USER_ROOT_PATH#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP  "sed -i  \"s#wds.linkis.resultSet.store.path.*#wds.linkis.resultSet.store.path=$RESULT_SET_ROOT_PATH#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP  "sed -i  \"s#wds.linkis.gateway.url.*#wds.linkis.gateway.url=http://${GATEWAY_INSTALL_IP}:${GATEWAY_PORT}#g\" $SERVER_CONF_PATH"
isSuccess "subsitution linkis.properties of $SERVER_PATH"
echo "<----------------$SERVER_PATH:end------------------->"

echo "$SERVER_PATH-update application.yml"
SERVER_CONF_PATH=$SERVER_HOME/$SERVER_PATH/conf/application.yml
executeCMD $SERVER_IP "sed -i  \"s#port:.*#port: $SERVER_PORT#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#defaultZone:.*#defaultZone: $EUREKA_URL#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#hostname:.*#hostname: $SERVER_IP#g\" $SERVER_CONF_PATH"
isSuccess "subsitution conf of $SERVER_PATH"

# start and check
startApp
sleep 10
checkServer
