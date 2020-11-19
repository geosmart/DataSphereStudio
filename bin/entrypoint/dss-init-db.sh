#!/bin/sh
source ${workDir}/bin/entrypoint/functions.sh

##init db

mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD -D$MYSQL_DB --default-character-set=utf8 -e "source ${workDir}/db/dss_ddl.sql"
isSuccess "source dss_ddl.sql"
LOCAL_IP=$ipaddr
if [ $GATEWAY_INSTALL_IP == "127.0.0.1" ]; then
  echo "GATEWAY_INSTALL_IP is equals 127.0.0.1 ,we will change it to ip address"
  GATEWAY_INSTALL_IP_2=$LOCAL_IP
else
  GATEWAY_INSTALL_IP_2=$GATEWAY_INSTALL_IP
fi

#echo $GATEWAY_INSTALL_IP_2
sed -i "s/GATEWAY_INSTALL_IP_2/$GATEWAY_INSTALL_IP_2/g" ${workDir}/db/dss_dml.sql
sed -i "s/GATEWAY_PORT/$GATEWAY_PORT/g" ${workDir}/db/dss_dml.sql
mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD -D$MYSQL_DB --default-character-set=utf8 -e "source ${workDir}/db/dss_dml.sql"
isSuccess "source dss_dml.sql"

echo "visualis support,visualis database will be initialized !"
if [ $VISUALIS_NGINX_IP == "127.0.0.1" ] || [ $VISUALIS_NGINX_IP == "0.0.0.0" ]; then
  echo "VISUALIS_NGINX_IP is equals $VISUALIS_NGINX_IP ,we will change it to ip address"
  VISUALIS_NGINX_IP_2=$LOCAL_IP
else
  VISUALIS_NGINX_IP_2=$VISUALIS_NGINX_IP
fi

#echo $VISUALIS_NGINX_IP_2
sed -i "s/VISUALIS_NGINX_IP_2/$VISUALIS_NGINX_IP_2/g" ${workDir}/db/visualis.sql
sed -i "s/VISUALIS_NGINX_PORT/$VISUALIS_NGINX_PORT/g" ${workDir}/db/visualis.sql
mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD -D$MYSQL_DB --default-character-set=utf8 -e "source ${workDir}/db/visualis.sql"
isSuccess "source visualis.sql"
mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD -D$MYSQL_DB --default-character-set=utf8 -e "source ${workDir}/db/davinci.sql"
isSuccess "source davinci.sql"

echo "azkaban and qualitis support, azkaban and qualitis database will be initialized !"

#azkaban
if [ $AZKABAN_ADRESS_IP == "127.0.0.1" ]; then
  echo "AZKABAN_ADRESS_IP is equals 127.0.0.1 ,we will change it to ip address"
  AZKABAN_ADRESS_IP_2=$LOCAL_IP
else
  AZKABAN_ADRESS_IP_2=$AZKABAN_ADRESS_IP
fi
echo $AZKABAN_ADRESS_IP_2
sed -i "s/AZKABAN_ADRESS_IP_2/$AZKABAN_ADRESS_IP_2/g" ${workDir}/db/azkaban.sql
sed -i "s/AZKABAN_ADRESS_PORT/$AZKABAN_ADRESS_PORT/g" ${workDir}/db/azkaban.sql
mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD -D$MYSQL_DB --default-character-set=utf8 -e "source ${workDir}/db/azkaban.sql"
isSuccess "source azkaban.sql"

#qualitis
if [ $QUALITIS_ADRESS_IP == "127.0.0.1" ]; then
  echo "QUALITIS_ADRESS_IP is equals 127.0.0.1 ,we will change it to ip address"
  QUALITIS_ADRESS_IP_2=$LOCAL_IP
else
  QUALITIS_ADRESS_IP_2=$QUALITIS_ADRESS_IP
fi
echo $QUALITIS_ADRESS_IP_2
sed -i "s/QUALITIS_ADRESS_IP_2/$QUALITIS_ADRESS_IP_2/g" ${workDir}/db/qualitis.sql
sed -i "s/QUALITIS_ADRESS_PORT/$QUALITIS_ADRESS_PORT/g" ${workDir}/db/qualitis.sql
mysql -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD -D$MYSQL_DB --default-character-set=utf8 -e "source ${workDir}/db/qualitis.sql"
isSuccess "source qualitis.sql"
