#Actively load user env
source /etc/profile
source ~/.bash_profile
source ${workDir}/bin/common.sh
source ${workDir}/bin/init.sh

APP_PREFIX="linkis-"

function installPackage() {
  SERVER_PATH=${APP_PREFIX}${SERVER_NAME}
  echo "start to install $SERVER_NAME"
  echo "$SERVER_PATH-step1: create dir"
  if test -z "$SERVER_IP"; then
    SERVER_IP=$local_host
  fi

  if ! executeCMD $SERVER_IP "test -e $SERVER_HOME"; then
    executeCMD $SERVER_IP "sudo mkdir -p $SERVER_HOME;sudo chown -R $deployUser:$deployUser $SERVER_HOME"
    isSuccess "create the dir of  $SERVER_HOME"
  fi

  echo "$SERVER_PATH-step2:copy install package"
  copyFile $SERVER_IP ${workDir}/share/$PACKAGE_DIR/$SERVER_PATH.zip $SERVER_HOME

  isSuccess "copy  $SERVER_PATH.zip"

  #copyFile $SERVER_IP   ${workDir}/lib $SERVER_HOME
  echo "remove exist install path:$SERVER_PATH"
  rm -rf $SERVER_HOME/$SERVER_PATH

  executeCMD $SERVER_IP "cd $SERVER_HOME/;unzip $SERVER_PATH.zip > /dev/null"
  isSuccess "unzip  ${SERVER_PATH}.zip"

  # copy base lib to service lib
  if test -e "$SERVER_HOME/$SERVER_PATH/lib/"; then
    echo "cp -r ${workDir}/lib/* $SERVER_HOME/$SERVER_PATH/lib/"
    cp -r ${workDir}/lib/* $SERVER_HOME/$SERVER_PATH/lib/
  fi
}

function installVisualis() {
  SERVER_PATH=${APP_PREFIX}${SERVER_NAME}
  echo "start to install $SERVER_PATH"
  echo "$SERVER_PATH-step1: create dir"
  if test -z "$SERVER_IP"; then
    SERVER_IP=$local_host
  fi

  if ! executeCMD $SERVER_IP "test -e $SERVER_HOME"; then
    executeCMD $SERVER_IP "sudo mkdir -p $SERVER_HOME;sudo chown -R $deployUser:$deployUser $SERVER_HOME"
    isSuccess "create the dir of  $SERVER_PATH"
  fi

  echo "$SERVER_PATH-step2:copy install package"
  copyFile $SERVER_IP ${workDir}/share/$PACKAGE_DIR/$SERVER_PATH.zip $SERVER_HOME
  isSuccess "copy  ${SERVERNAME}.zip"

  #copyFile $SERVER_IP   ${workDir}/lib $SERVER_HOME
  echo "remove exist install path:$SERVER_PATH"
  rm -rf $SERVER_HOME/$SERVER_PATH

  executeCMD $SERVER_IP "cd $SERVER_HOME/;unzip $SERVER_PATH.zip > /dev/null"
  isSuccess "unzip  ${SERVERNAME}.zip"
}

##cp module to em lib
function emExtraInstallModule() {
  SERVER_PATH=${APP_PREFIX}${SERVER_NAME}

  cd $SERVER_HOME/
  cp -f module/lib/* $SERVER_HOME/$SERVER_PATH/lib/
  cd -
  isSuccess "copy module"
}
##replace conf  1. replace if it exists 2.not exists add
function replaceConf() {
  option=$1
  value=$2
  file=$3
  executeCMD $SERVER_IP "grep -q '^$option' $file && sed -i ${txt} 's/^$option.*/$option=$value/' $file || echo '$option=$value' >> $file"
  isSuccess "copy module"
}

function startApp() {
  echo "<-------------------------------->"
  SERVER_PATH=${APP_PREFIX}${SERVER_NAME}
  echo "Begin to start $SERVER_PATH"

  SERVER_BIN=${DSS_WORK_HOME}/${SERVER_PATH}/bin
  SERVER_LOCAL_START_CMD="dos2unix ${SERVER_BIN}/* > /dev/null 2>&1; dos2unix ${SERVER_BIN}/../conf/* > /dev/null 2>&1; sh ${SERVER_BIN}/start-${SERVER_PATH}.sh"

  eval $SERVER_LOCAL_START_CMD
  isSuccess "End to start $SERVER_PATH"
  echo "<-------------------------------->"
  sleep 3
}

function checkServer() {
  MICRO_SERVICE_NAME=${APP_PREFIX}${SERVER_NAME}
  MICRO_SERVICE_IP=$SERVER_IP
  MICRO_SERVICE_PORT=$SERVER_PORT

  echo "Start to Check if your microservice:$MICRO_SERVICE_NAME is normal via telnet"
  echo "--------------------------------------------------------------------------------------------------------------------------"
  echo $MICRO_SERVICE_NAME
  echo $MICRO_SERVICE_IP
  echo $MICRO_SERVICE_PORT
  echo "--------------------------------------------------------------------------------------------------------------------------"
  result=$(echo -e "\n" | telnet $MICRO_SERVICE_IP $MICRO_SERVICE_PORT 2>/dev/null | grep Connected | wc -l)
  if [ $result -eq 1 ]; then
    echo "$MICRO_SERVICE_NAME is ok."
  else
    echo "ERROR your $MICRO_SERVICE_NAME microservice is not start successful !!! ERROR logs as follows :"
    echo '<---------------------------------------------------->'
    tail -n 50 $LOG_DIR/*.out
    echo '<---------------------------------------------------->'
    echo "PLEAESE CHECK DETAIL LOG,LOCATION:$LOG_DIR/linkis.out"
    exit 1
  fi

}
