# Ubuntu configuration

## 时间设置

```bash
sudo apt install ntpdate
#安装时间同步工具
sudo ntpdate time.windows.com
#与Windows时间服务器同步时间
sudo hwclock --localtime --systohc
#把ubuntu时间模式改为与Windows相同的local time
```


