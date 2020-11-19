#!/bin/bash

# load config and init
RUN_ENV=${DSS_RUN_ENV:=dev}
shellDir=$(dirname $0)
echo "shellDir:${shellDir}"
# tar package path
workDir=$(
  cd ${shellDir}/..
  pwd
)
export workDir=$workDir
echo 'workDir' ${workDir}

# need mount to persisit
# eg. export DSS_WORK_HOME=/mnt/hgfs/servyou/linkis/assembly/target
DSS_WORK_HOME=${DSS_WORK_HOME:=${workDir}}
export DSS_WORK_HOME=$DSS_WORK_HOME
echo 'DSS_WORK_HOME' ${DSS_WORK_HOME}

# init directories and log dir
export LOG_DIR=/var/log/$1
mkdir -p ${LOG_DIR}
touch $LOG_DIR/linkis.out
echo "LOGDIR:${LOG_DIR}"


# replace default SERVER_HEAP_SIZE
if test -z "$HEAP_SIZE"; then
  export SERVER_HEAP_SIZE=$HEAP_SIZE
fi

# dos2unix
#find ${workDir}/bin -type f -print0 | xargs -0 dos2unix >/dev/null 2>&1
#find ${workDir}/conf -type f -print0 | xargs -0 dos2unix >/dev/null 2>&1

source ${workDir}/bin/common.sh

echo "start by command $1 ,steps:[copy zip]>>[unzip]>>[change config]>>[start service]>>[check service]"
source entrypoint/$1.sh

echo "tail begin"
exec bash -c "tail -n 1 -f $LOG_DIR/linkis.out"