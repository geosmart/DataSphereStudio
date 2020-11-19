#!/bin/sh
source ${workDir}/bin/entrypoint/functions.sh
source ${workDir}/bin/entrypoint/dss-appjoint.sh
EUREKA_URL=http://$EUREKA_INSTALL_IP:$EUREKA_PORT/eureka/

#Appjoint entrance Install
PACKAGE_DIR=plugins/linkis/linkis-appjoint-entrance
APP_PREFIX="linkis-"
SERVER_NAME="appjoint-entrance"
SERVER_PATH=${APP_PREFIX}${SERVER_NAME}

SERVER_IP=$APPJOINT_ENTRANCE_INSTALL_IP
SERVER_PORT=$APPJOINT_ENTRANCE_PORT
SERVER_HOME=$DSS_WORK_HOME
#Install appjoint entrance
installPackage

#Update appjoint entrance linkis.properties
echo "$SERVER_PATH-update linkis.properties"
SERVER_CONF_PATH=$SERVER_HOME/$SERVER_PATH/conf/linkis.properties
executeCMD $SERVER_IP "sed -i  \"s#wds.linkis.entrance.config.logPath.*#wds.linkis.entrance.config.logPath=$WORKSPACE_USER_ROOT_PATH#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#wds.linkis.resultSet.store.path.*#wds.linkis.resultSet.store.path=$RESULT_SET_ROOT_PATH#g\" $SERVER_CONF_PATH"
isSuccess "subsitution linkis.properties of $SERVER_PATH"
echo "<----------------$SERVER_PATH:end------------------->"

echo "$SERVER_PATH-update application.yml"
SERVER_CONF_PATH=$SERVER_HOME/$SERVER_PATH/conf/application.yml
executeCMD $SERVER_IP "sed -i  \"s#port:.*#port: $SERVER_PORT#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#defaultZone:.*#defaultZone: $EUREKA_URL#g\" $SERVER_CONF_PATH"
executeCMD $SERVER_IP "sed -i  \"s#hostname:.*#hostname: $SERVER_IP#g\" $SERVER_CONF_PATH"
isSuccess "subsitution conf of $SERVER_PATH"

# install_appjoints set by user,split by comma
install_appjoints=${INSTALL_APPJOINTS:='schedulis,visualis,qualitis,eventchecker,datachecker'}
echo "install_appjoints:${install_appjoints}"
IFS=',' read -r -a appjoints <<<"$install_appjoints"
echo "appjoints:${appjoints}"

for appjoint in "${appjoints[@]}"; do
  #APPJOINTS INSTALL
  case $appjoint in
  'datachecker') install_appjoint_datachecker ;;
  'eventchecker') install_appjoint_eventchecker ;;
  'visualis') install_appjoint_visualis ;;
  'qualitis') install_appjoint_qualitis ;;
  'schedulis') install_appjoint_schedulis ;;
  *) echo "unsupported appjoint" ;;
  esac
done

# start and check
startApp
sleep 10
checkServer
