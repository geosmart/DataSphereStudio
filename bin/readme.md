# linkis docker deploy

## entrypoint
`startup.sh ${command}`

`command`支持列表
* dss-web
* dss-server
* dss-flow-execution-entrance
* linkis-appjoint-entrance
* dss-init-db：仅用于第一次初始化数据库

## environment variable
* DSS_RUN_ENV：运行环境，可选值：[dev,test,bprod]
* DSS_WORK_HOME：linkis运行目录，绝对路径

## mount path
* wedatasphere-dss-{version}-dist：linkis部署包目录，可删除/覆盖
* DSS_WORK_HOME：dss运行目录，可覆盖
* /var/log/${command}：服务日志目录
* INSTALL_APPJOINTS：需要启用的appjoint列表，逗号分割，如：schedulis,visualis,qualitis,eventchecker,datachecker
