# 自建apt仓库及nginx使用文档

> 吸取初代运维学长没有留下任何文档导致后期控制组成员接手运维事务困难的惨痛教训，特此留下文档，以备不时之需

## 使用reprepro自建本地apt仓库

reprepro是一个强大的debian仓库管理工具。其主要功能包含创建仓库、向仓库中添加、移除包、仓库导出、无用仓库移除等。

### 安装必要程序

```bash
sudo apt install gnupg reprepro nginx
```

### 配置GPG密钥及reprepro

```bash
## 创建GPG密钥
gpg --full-gen
#密钥类型:默认
#RSA长度:默认
#密钥有效期限:默认
#真实姓名:dynamicx
#电子邮件地址:*******@gmail.com
#注释:DynamicX ros 
#密码:dynamicx

##创建仓库目录
mkdir dynamicx_package_hub/wwwroot/ppa/conf
touch dynamicx_package_hub/wwwroot/ppa/conf/distributions

##列出系统中的GPG密钥
gpg --list-keys
##导出GPG密钥
gpg --armor --export *上一步列出的GPG密钥* > dynamicx_package_hub/wwwroot/ppa/key/public.key

##reprepro配置文件
vim /dynamicx/wwwroot/ppa/conf/distributions
##创建仓库树，这步会创建一些文件夹并验证GPG密码
reprepro --ask-passphrase -Vb dynamicx_package_hub/wwwroot/ppa export
##添加deb包到仓库
#需要进入仓库的根目录才能添加软件包
cd dynamicx_package_hub/wwwroot/ppa
#命令格式为[ includedeb 发行版 deb包文件路径 ]
reprepro --ask-passphrase -Vb . includedeb focal /home/ubuntu/dynamicx_package_hub/example.deb
##移除deb包
#这是命令格式，不要照抄！
reprepro --ask-passphrase -Vb PPA_directory remove Codename Package_name
#更多用法可用reprepro -h
```



## distributions配置

- codename：发行版名称，例如ubuntu的bionic，focal等。ubuntu20.04为focal
- Origin和Label：都填项目名字
- Suite：stable
- SignWith：GPG签名密钥

```
Origin: dynamicx-deb
Label: dynamicx-deb
Suite: stable
Codename: focal
Version: 2023
Architectures: amd64 source
Components: main contrib non-free
Description: test
SignWith: 51030BFECF635870F3EF9313FB25C4ECBBF645FE
```



## 使用nginx让其他电脑可用访问仓库

### 配置nginx

如果不了解nginx服务，可以把这个配置文件直接抄过去，
server_name后面带的是你的域名或者IP也可以
root 后面带的是仓库的目录，这两个地方记得修改

```bash
server {
  listen 80;
  server_name dynamicx.com;

  access_log /var/log/nginx/packages-error.log;
  error_log /var/log/nginx/packages-error.log;
  root dynamicx_package_hub/wwwroot/ppa;
  index  index.html index.htm;
 
  location / {
    autoindex on;
  }

  location ~ /(.*)/conf {
    deny all;
  }

  location ~ /(.*)/db {
    deny all;
  }
}
```

nginx的配置文件在`/etc/nginx`目录下面，需要用到的只有两个目录`/etc/nginx/sites-available/` ， `/etc/nginx/sites-enabled/`
配置文件写入`/etc/nginx/sites-available/` 下,用软链接链接到`/etc/nginx/sites-enabled/`下面
顾名思义，site-available下面是可以用的配置文件，site-enabled下面是启用的服务，
以此仓库为例，在available下面新建ppa文件（名字随意取），把上面的配置写进去
然后软连接到enabled下面，重启nginx服务就好了

```shell
#一个完整的示例
touch /etc/nginx/sites-available/ppa
vim /etc/nginx/sites-available/ppa
#建议进入该目录创建软连接，因为不进去和进去ls -l显示的内容不一样，我也不知道为啥，也不想深究了
cd /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/ppa /etc/nginx/sites-enabled/ppa
systemctl restart nginx
```

如果需要测试自己写的配置文件是否有错误,或者上面restart nginx时报错
下面这个命令能帮助你快速排查配置文件的错误所在

```shell
/usr/sbin/nginx -t
```

### 在hosts文件中将本地IP绑定dynamicx.com

> 这一步应该在部署仓库的电脑上进行，要使用这个仓库的电脑不需要设置

打开hosts

```
sudo vim /etc/hosts
```

在上部IPv4的部分加入

```
127.0.0.1	dynamicx.com
```

### 在其他电脑上添加源并使用

在/etc/apt/sources.list添加源

```cpp
deb http://dynamicx.com/ focal main contrib non-free
```

添加公钥

```cpp
wget -O - http://dynamicx.com/key/public.key | sudo apt-key add -
```

\# 更新软件源

```bash
sudo apt update
```