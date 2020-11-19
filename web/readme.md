# 部署说明
* `frontend-maven-plugin`插件实现不依赖npm外部环境编译前端代码
* `maven-assembly-plugin`将npm生成的dist目录打包生成zip
    * `mvn package`：将生成target/dss-web.zip文件用于部署