# Ubuntu configuration

## Ubuntu Server

### 安装
重启到BIOS，关闭安全启动，设置从USB启动。插入装有Ubuntu服务器版的U盘，进入u盘启动后，正常安装即可

> 对于工程组内的u盘，内部带有服务器版和桌面版两个版本的安装包，按照提示选择服务器版本即可

给/swap分配16g，/efi分配512m，剩下的硬盘空间全部挂载到/目录下。设备名看这台nuc给哪个机器人用，用户名dynamicx，密码dynamicx。安装完成后按提示移除u盘，重启。

### 安装ssh，并通过ssh用你的电脑操控nuc

1. 把自己的电脑连上WiFi，然后用一根网线连接nuc和你的电脑。这时电脑右上方会出现有线连接的图标。进入有线连接，点击设置，点击IPv4,设置`与其他计算机共享网络`（类似的意思）。这样nuc就可以上网了。可用`ping baidu.com`,来检查nuc是否联网。

2. 安装ssh服务器端

   ```
   sudo apt install openssh-server
   ```

   > 如果需要安装依赖，按照提示安装即可

3. 在nuc上使用`ip a`查看nuc的ip地址。在你的电脑上输入指令`ssh dynamicx@“nuc的ip地址”`，这样你就能在你的电脑上操控nuc了。

### 换源

可以网上搜索国内的Ubuntu源，例如清华源，阿里源。也可以利用鱼香ros工具快速换源

```
wget http://fishros.com/install -O fishros && . fishros
```

终端输入后按提示换源

> 在这一步也可以设置rosdepc，便于后续安装软件包依赖

### 安装easywifi

1. 从Github上搜索easywifi，第一个就是，把源码clone到车上，注意使用**http**

2. 安装easywifi依赖

   ```
   sudo apt-get install network-manager-config-connectivity-ubuntu
   ```

3. 进入easywifi文件夹，输入

   ```
   sudo python3 easywifi.py
   ```

4. 成功运行easywifi后，运行 `*1*<!--Scan for networks-->`搜索WiFi，然后运行`*5*<!--Setup new network-->`输入WiFi名称和密码，让nuc连上WiFi

5. 和nuc连上同一个WiFi，继续用ssh操控nuc

### 安装ros

安装ros请主要参考ros_wiki上的安装教程。请注意安装**base**版本而不是**full-desktop**

#### 安装catkin tools



## 安装Ubuntu Desktop


## 时间设置

```bash
sudo apt install ntpdate
#安装时间同步工具
sudo ntpdate time.windows.com
#与Windows时间服务器同步时间
sudo hwclock --localtime --systohc
#把ubuntu时间模式改为与Windows相同的local time
```
