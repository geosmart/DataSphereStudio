#!/bin/sh
function install_appjoint_schedulis() {
  echo "<----------------schedulis  appjoint install start------------------->"
  APPJOINT_PARENT=dss-appjoints
  APPJOINT_NAME=schedulis
  #schedulis  appjoint install
  installAppjoints
  isSuccess "subsitution conf of schedulis"
  echo "<----------------$APPJOINT_NAME:end------------------->"
}

function install_appjoint_visualis() {
  echo "<----------------visualis  appjoint install start------------------->"
  APPJOINT_PARENT=dss-appjoints
  APPJOINT_NAME=visualis

  #visualis  appjoint install
  installAppjoints
  echo "<----------------$APPJOINT_NAME:end------------------->"
}

function install_appjoint_qualitis() {
  echo "<----------------qualitis  appjoint install start------------------->"
  APPJOINT_PARENT=dss-appjoints
  APPJOINT_NAME=qualitis

  #qualitis  appjoint install
  installAppjoints
  APPJOINT_NAME_CONF_PATH_PATENT=$SERVER_HOME/$APPJOINT_PARENT/$APPJOINT_NAME/appjoint.properties
  executeCMD $SERVER_IP "sed -i  \"s#baseUrl=http://127.0.0.1:8090#baseUrl=http://$QUALITIS_ADRESS_IP:$QUALITIS_ADRESS_PORT#g\" $APPJOINT_NAME_CONF_PATH_PATENT"
  isSuccess "subsitution conf of qualitis"
  echo "<----------------$APPJOINT_NAME:end------------------->"
  echo ""
  echo "<----------------schedulis  appjoint install start------------------->"
  APPJOINT_PARENT=dss-appjoints
  APPJOINT_NAME=schedulis
  #schedulis  appjoint install
  installAppjoints
  isSuccess "subsitution conf of schedulis"
  echo "<----------------$APPJOINT_NAME:end------------------->"
}

function install_appjoint_eventchecker() {
  echo "<----------------eventchecker appjoint install start------------------->"
  APPJOINT_PARENT=dss-appjoints
  APPJOINT_NAME=eventchecker
  installAppjoints
  echo "$APPJOINT_NAME:subsitution conf"
  APPJOINT_NAME_CONF_PATH_PATENT=$SERVER_HOME/$APPJOINT_PARENT/$APPJOINT_NAME/appjoint.properties
  executeCMD $SERVER_IP "sed -i  \"s#msg.eventchecker.jdo.option.url.*#msg.eventchecker.jdo.option.url=jdbc:mysql://${MYSQL_HOST}:${MYSQL_PORT}/${MYSQL_DB}?characterEncoding=UTF-8#g\" $APPJOINT_NAME_CONF_PATH_PATENT"
  executeCMD $SERVER_IP "sed -i  \"s#msg.eventchecker.jdo.option.username.*#msg.eventchecker.jdo.option.username=$MYSQL_USER#g\" $APPJOINT_NAME_CONF_PATH_PATENT"
  executeCMD $SERVER_IP "sed -i  \"s#msg.eventchecker.jdo.option.password.*#msg.eventchecker.jdo.option.password=$MYSQL_PASSWORD#g\" $APPJOINT_NAME_CONF_PATH_PATENT"
  isSuccess "subsitution conf of eventchecker"
  echo "<----------------$APPJOINT_NAME:end------------------->"
}

function install_appjoint_datachecker() {
  echo "<----------------datachecker appjoint install start------------------->"
  APPJOINT_PARENT=dss-appjoints
  APPJOINT_NAME=datachecker
  #datachecker  appjoint install
  installAppjoints
  echo "$APPJOINT_NAME:subsitution conf"
  APPJOINT_NAME_CONF_PATH_PATENT=$SERVER_HOME/$APPJOINT_PARENT/$APPJOINT_NAME/appjoint.properties
  executeCMD $SERVER_IP "sed -i  \"s#job.datachecker.jdo.option.url.*#job.datachecker.jdo.option.url=$HIVE_META_URL#g\" $APPJOINT_NAME_CONF_PATH_PATENT"
  executeCMD $SERVER_IP "sed -i  \"s#job.datachecker.jdo.option.username.*#job.datachecker.jdo.option.username=$HIVE_META_USER#g\" $APPJOINT_NAME_CONF_PATH_PATENT"
  executeCMD $SERVER_IP "sed -i  \"s#job.datachecker.jdo.option.password.*#job.datachecker.jdo.option.password=$HIVE_META_PASSWORD#g\" $APPJOINT_NAME_CONF_PATH_PATENT"
  isSuccess "subsitution conf of datachecker"
  echo "<----------------datachecker appjoint install end------------------->"
}

function installAppjoints() {
  echo "start to install $APPJOINT_NAME to $SERVER_HOME/$APPJOINT_PARENT"
  echo "$APPJOINT_NAME Install-step1: create dir"
  if test -z "$SERVER_IP"; then
    SERVER_IP=$local_host
  fi

  if ! executeCMD $SERVER_IP "test -e $SERVER_HOME/$APPJOINT_PARENT"; then
    executeCMD $SERVER_IP "sudo mkdir -p $SERVER_HOME/$APPJOINT_PARENT;sudo chown -R $deployUser:$deployUser $SERVER_HOME/$APPJOINT_PARENT"
    isSuccess "create the dir of  $SERVER_HOME/$APPJOINT_PARENT;"
  fi

  echo "$APPJOINT_NAME-step2:copy install package"
  copyFile $SERVER_IP $workDir/share/appjoints/$APPJOINT_NAME/*.zip $SERVER_HOME/$APPJOINT_PARENT
  isSuccess "copy  ${APPJOINT_NAME}.zip"
  executeCMD $SERVER_IP "cd $SERVER_HOME/$APPJOINT_PARENT/;unzip -o dss-*-appjoint.zip > /dev/null;rm -rf dss-*-appjoint.zip"
  isSuccess "install  ${APPJOINT_NAME}.zip"
}
