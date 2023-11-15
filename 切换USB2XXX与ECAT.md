# 工程切换USB2XXX或ECAT

记录切换USB2XXX与ECAT时需要更改的事项

## rm_bringup/launch/engineer.launch

根据需要切换使用USB2CAN或ECAT

当使用其中一个时需要注释掉另一个方案

- 使用ECAT时

```text
<!--    use for usb2can-->
<!--    <include if="$(arg load_rm_hw)" file="$(find rm_config)/launch/rm_hw.launch"/>-->

<!--    use for ecat-->
    <include if="$(arg load_rm_hw)" file="$(find rm_config)/launch/rm_ecat_hw.launch"/>
```

- 使用USB2CAN时

```text
<!--    use for usb2can-->
<include if="$(arg load_rm_hw)" file="$(find rm_config)/launch/rm_hw.launch"/>

<!--    use for ecat-->
 <!--<include if="$(arg load_rm_hw)" file="$(find rm_config)/launch/rm_ecat_hw.launch"/>-->
```

## 切换自启脚本

进入`/rm_ws/src/rm_bringup/scripts/autostart/`中，使用`delete_specific_server.sh`和`create_specific_server.sh`来删除和创建对应自启服务。

- 使用ECAT时

  ```bash
  ./delete_specific_service.sh rm_can_start
  ./create_specific_service.sh rm_ecat_start
  ```

- 使用USB2CAN时

  ```
  ./delete_specific_service.sh rm_ecat_start
  ./create_specific_service.sh rm_can_start
  ```

## 修改2006电机减速比

切换不同方案会导致2006电机的减速比发生变化

使用ECAT时单2006本身的减速比为36

使用USB2CAN时2006本身的减速比为1



## 修改串口映射

切换USB2CAN与ECAT时dbus与裁判系统映射的串口需要对调

- 使用ECAT时

  ```text
  ACTION=="add",KERNELS=="3-4.2:1.0",SUBSYSTEMS=="usb",MODE:="0777",SYMLINK+="usbDbus"
  ACTION=="add",KERNELS=="3-4.1:1.0",SUBSYSTEMS=="usb",MODE:="0777",SYMLINK+="usbReferee"
  ```

- 使用USB2CAN时

  ```text
  ACTION=="add",KERNELS=="3-4.1:1.0",SUBSYSTEMS=="usb",MODE:="0777",SYMLINK+="usbDbus"
  ACTION=="add",KERNELS=="3-4.2:1.0",SUBSYSTEMS=="usb",MODE:="0777",SYMLINK+="usbReferee"
  ```

  