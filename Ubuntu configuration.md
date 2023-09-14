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

catkin tools官方文档：https://catkin-tools.readthedocs.io/en/latest/ 

首先添加软件源

```bash
$ sudo sh \
    -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" \
        > /etc/apt/sources.list.d/ros-latest.list'
$ wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
```

然后安装`catkin_tools`

```
$ sudo apt-get update
$ sudo apt-get install python3-catkin-tools
```

#### rosdep

rosdep update 失败的参考解决方法：https://github.com/SparkChen927/rosdep

> 也可以使用鱼香ros中的rosdepc

rosdep update完成后，进入rm_ws，安装依赖

```bash
rosdep install --from-paths src --ignore-src -r -y
```

### 从主仓里clone代码

 > **一定要使用ssh来clone仓库**

​		[rm_manual](https://github.com/rm-controls/rm_manual)：实现键鼠操作

​		[rm_config](https://github.com/gdut-dynamic-x/rm_config)：放参数的地方，也是最常修改的地方

​		[rm_engineer](https://github.com/rm-controls/rm_engineer)：工程专用的包，主要实现.action类型的消息以及和manual的交互

​		[rm_bringup](https://github.com/gdut-dynamic-x/rm_bringup)：开机自启，硬件映射

​		[rm_control](https://github.com/rm-controls/rm_control)：一些代码中可用的工具，比如滤波器，从yaml拿参数等

​		[rm_description](https://github.com/gdut-dynamic-x/rm_description)：放置仿真用的stl模型和urdf文件

​		[rm_controllers](https://github.com/rm-controls/rm_controllers)：各种控制器

有些软件包可能不在上面，可以在`rm_controls`或`gdut-dynamic-x`中自行寻找并clone

### 优化

1. 你会发现开机很慢，这是一个系统服务导致的，可以设置将其跳过。

   ```
   $ sudo vim /etc/netplan/01-netcfg.yaml`
   ```

   > 这个文件可能不叫这个名字，可能需要转到/etc/netplan这个目录下看看。

   在网卡的下一级目录中增加

   ```
   optional: true
   ```

   修改完后生效设置

   ```
   $ sudo netplan apply
   ```

2. 阻止nuc休眠

   nuc长时间不用会休眠，会给工作带来一定麻烦。因此需要设置阻止nuc休眠。输入以下指令：

   ```
   sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
   ```

### 换内核

1. 使用搜索引擎搜索xanmod，通常搜索结果第一个就是，打开 [此网站](https://xanmod.org/) 。
2. 我们需要更换一个实时性更强的内核，这样的内核通常名字里会带有“rt”（realtime）。在这个网站往下拉会看到“Install via Terminal”(通过命令行安装)。根据提示安装自己想要的内核。
3. 使用指令 `sudo dpkg --get-selections | grep linux-image` 来查看你想要安装的内核是否安装成功。
4. 重启，按F2进入BIOS模式。在boot->Boot Priority勾选Fast boot。Power选项里勾选Max Performance Enabled,Dynamic Power Technology设为最长的那个，Power->Secondary Power Settings将After Power Failure设为Power on。cooling选项里将Fan Control Mode设置为Fixed，Fixed Duty Cycle设为100。**关闭安全启动**然后退出BIOS，正常启动。
5. 测试新内核的实时性和can总线传输速率

> 如果无法进入BIOS可以在终端输入
>
> ```
> sudo systemctl reboot --firmware-setup
> ```
>
> 会直接重启到BIOS中


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
