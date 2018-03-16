* 若npm install 成功，运行时出现异常，且异常中有关键字**node-sass**，执行：

```
npm install -g cnpm --registry=https://registry.npm.taobao.org
cnpm install node-sass --save-dev

```
原因：node-sass依赖下载时，其中有文件下载网址被墙了，只能从淘宝镜像上下载