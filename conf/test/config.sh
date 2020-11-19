### deploy user
deployUser=jrsyb

### The install home path of DSS，Must provided
DSS_WORK_HOME=$DSS_WORK_HOME

### Specifies the user workspace, which is used to store the user's script files and log files.
### Generally local directory
WORKSPACE_USER_ROOT_PATH=file:///tmp/dboard/linkis/  ##file:// required
### Path to store job ResultSet：file or hdfs path
RESULT_SET_ROOT_PATH=hdfs:///user/jrsyb/dboard/linkis/result_set

################### The install Configuration of all Micro-Services #####################
#
#    NOTICE:
#       1. If you just wanna try, the following micro-service configuration can be set without any settings.
#            These services will be installed by default on this machine.
#       2. In order to get the most complete enterprise-level features, we strongly recommend that you install
#          the following microservice parameters
#

### DSS_SERVER
### This service is used to provide dss-server capability.
DSS_SERVER_INSTALL_IP=192.168.135.133
DSS_SERVER_PORT=9004

### Appjoint-Entrance
### This service is used to provide Appjoint-Entrance capability.
APPJOINT_ENTRANCE_INSTALL_IP=192.168.135.133
APPJOINT_ENTRANCE_PORT=9005

### Flow-Execution-Entrance
### This service is used to provide flow execution capability.
FLOW_EXECUTION_INSTALL_IP=192.168.135.133
FLOW_EXECUTION_PORT=9006

###  Linkis EUREKA  information.
EUREKA_INSTALL_IP=192.168.135.133         # Microservices Service Registration Discovery Center
EUREKA_PORT=20303

### Linkis Gateway  information
GATEWAY_INSTALL_IP=192.168.135.133
GATEWAY_PORT=9001

### SSH Port
SSH_PORT=22

#Used to store the azkaban project transformed by DSS
WDS_SCHEDULER_PATH=file:///tmp/dboard/wds/scheduler

###The IP address and port are written into the database here, so be sure to plan ahead
## visualis-server
VISUALIS_SERVER_INSTALL_IP=192.168.135.133
VISUALIS_SERVER_PORT=9007
### visualis nginx acess ip,keep consistent with DSS front end
VISUALIS_NGINX_IP=192.168.135.133
VISUALIS_NGINX_PORT=8088

### Eventchecker APPJOINT
### This service is used to provide Eventchecker capability. it's config in db.sh same as dss-server.

#azkaban address for check
AZKABAN_ADRESS_IP=192.168.135.133
AZKABAN_ADRESS_PORT=8081

#qualitis.address for check
QUALITIS_ADRESS_IP=192.168.135.133
QUALITIS_ADRESS_PORT=8090

DSS_VERSION=0.9.0

#dss web
DSS_WEB_INSTALL_IP=192.168.135.133
DSS_WEB_PORT=8088
LINKIS_GATEWAY_URL="http://${GATEWAY_INSTALL_IP}:${GATEWAY_PORT}"