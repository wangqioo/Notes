# 使用Github与本地仓库工作流程
1. 在github创建仓库，并复制HTTPS地址
2. 打开Vscode或PyCharm链接到github仓库
3. 创建并编写完成本地文档后上传至Github仓库

## Vscode链接Github仓库及上传注意事项
- 点击source control，点击Commit
- 此时要注意填写提交说明，并大点击√确认

![alt text](image.png)
- 再点击sync changes并上传所有修改记录至github

![alt text](image-1.png)

## 注意失败现象
1. 点击Commit后未注意到要填写提交说明，导致一直转圈等待提交
2. 由于使用Vpn导致网络端口发生改变，使用不了git。
解决方法是：首先在系统中搜索“代理”，打开如下设置界面，其次编辑代理服务器

![alt text](image-2.png)

查看此时电脑的上网端口，并记住自己的端口号


![alt text](image-3.png)

最后打开git bash，并修改端口号
git config --global http.proxy 127.0.0.1:当前端口号
git config --global https.proxy 127.0.0.1:当前端口号

此方法参考以下网页
[Git 失败，修改端口号](https://blog.csdn.net/qq_40296909/article/details/134285451)