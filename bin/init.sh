RUN_ENV=$DSS_RUN_ENV
configDir=${workDir}/conf/${RUN_ENV}

# load config
echo "step1:load config "
export LINKIS_CONFIG_PATH=${LINKIS_CONFIG_PATH:-"${configDir}/config.sh"}
export LINKIS_DB_CONFIG_PATH=${LINKIS_DB_CONFIG_PATH:-"${configDir}/db.sh"}

set -a # export all variables created next
source ${LINKIS_CONFIG_PATH}
source ${LINKIS_DB_CONFIG_PATH}
set +a # stop exporting

##Deal special symbol '#'
HIVE_META_PASSWORD=$(echo ${HIVE_META_PASSWORD//'#'/'\#'})
MYSQL_PASSWORD=$(echo ${MYSQL_PASSWORD//'#'/'\#'})

isSuccess "load config"

# init dir
echo "create hdfs directory and local directory"
if [ "$WORKSPACE_USER_ROOT_PATH" != "" ]; then
  localRootDir=$WORKSPACE_USER_ROOT_PATH
  if [[ $WORKSPACE_USER_ROOT_PATH == file://* ]]; then
    localRootDir=${WORKSPACE_USER_ROOT_PATH#file://}
    mkdir -p $localRootDir/$deployUser
    sudo chmod -R 775 $localRootDir/$deployUser
  elif [[ $WORKSPACE_USER_ROOT_PATH == hdfs://* ]]; then
    localRootDir=${WORKSPACE_USER_ROOT_PATH#hdfs://}
    hdfs dfs -mkdir -p $localRootDir/$deployUser
  else
    echo "does not support $WORKSPACE_USER_ROOT_PATH filesystem types"
  fi
fi
isSuccess "create  $WORKSPACE_USER_ROOT_PATH directory"

if [ "$HDFS_USER_ROOT_PATH" != "" ]; then
  localRootDir=$HDFS_USER_ROOT_PATH
  if [[ $HDFS_USER_ROOT_PATH == file://* ]]; then
    localRootDir=${HDFS_USER_ROOT_PATH#file://}
    mkdir -p $localRootDir/$deployUser
    sudo chmod -R 775 $localRootDir/$deployUser
  elif [[ $HDFS_USER_ROOT_PATH == hdfs://* ]]; then
    localRootDir=${HDFS_USER_ROOT_PATH#hdfs://}
    hdfs dfs -mkdir -p $localRootDir/$deployUser
  else
    echo "does not support $HDFS_USER_ROOT_PATH filesystem types"
  fi
fi
isSuccess "create  $HDFS_USER_ROOT_PATH directory"

if [ "$RESULT_SET_ROOT_PATH" != "" ]; then
  localRootDir=$RESULT_SET_ROOT_PATH
  if [[ $RESULT_SET_ROOT_PATH == file://* ]]; then
    localRootDir=${RESULT_SET_ROOT_PATH#file://}
    mkdir -p $localRootDir/$deployUser
    sudo chmod -R 775 $localRootDir/$deployUser
  elif [[ $RESULT_SET_ROOT_PATH == hdfs://* ]]; then
    localRootDir=${RESULT_SET_ROOT_PATH#hdfs://}
    hdfs dfs -mkdir -p $localRootDir/$deployUser
  else
    echo "does not support $RESULT_SET_ROOT_PATH filesystem types"
  fi
fi
isSuccess "create  $RESULT_SET_ROOT_PATH directory"


if [ "$WDS_SCHEDULER_PATH" != "" ]
then
  localRootDir=$WDS_SCHEDULER_PATH
  if [[ $WDS_SCHEDULER_PATH == file://* ]];then
        localRootDir=${WDS_SCHEDULER_PATH#file://}
        mkdir -p $localRootDir
        sudo chmod -R 775 $localRootDir
  elif [[ $WDS_SCHEDULER_PATH == hdfs://* ]];then
        localRootDir=${WDS_SCHEDULER_PATH#hdfs://}
        hdfs dfs -mkdir -p $localRootDir
        hdfs dfs -chmod -R 775 $localRootDir
  else
    echo "does not support $WDS_SCHEDULER_PATH filesystem types"
  fi
isSuccess "create  $WDS_SCHEDULER_PATH directory"
fi
