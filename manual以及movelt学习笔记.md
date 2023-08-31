# MANUAL

## 功能

为了实现键鼠和遥控器的操控

## 代码结构

本质上为先定义各个按键的组合名字
设置dbus回调函数，后更新数据的类成员
设置sendcommand的类成员函数
后定义各个按键所能实现的功能，每个功能本质上是给相应数据赋值
每个功能对应一个sendcommand
后发送出去

# Movelt

参考教程https://ros-planning.github.io/moveit_tutorials/doc/quickstart_in_rviz/quickstart_in_rviz_tutorial.html

## 初步了解

帮助进行运动学分析解算的一个ros包

Movelt 由**TRACLab，IKFast**进行逆运动学解算
KDL正运动学解算

路径规划：OMPL、CHOMP、SBPL、、、
碰撞检测：FCL、PCD

## 配置环境

具体教程https://ros-planning.github.io/moveit_tutorials/doc/getting_started/getting_started.html
配置movelt环境途中用到了一个不同于catkin名为wstool的编译工具(不确定)
__注意：配置实例环境时候不要随意使用

```shell
echo 'source ~/ws_moveit/devel/setup.bash' >> ~/.bashrc
```

会导致rm_ws又要手动配置，开启示例时候应该手动配置环境变量__

## 打开实例

在开始学习之前，先打开官方提供的实例

```shell
mon launch panda_moveit_config demo.launch rviz_tutorial:=true
```

## RViz中的交互

不知道为何我没法让其碰撞变红
超出了工作空间也并没有发生啥
利用下方的joint选项卡可以只控制单个关节 “null space exploration” 的调节可以让爪子保持不动只动关节

<table><tr><td bgcolor=DarkSeaGreen>本质的运动计划便是确定一个起点和终点，然后过程确保机械臂不会碰到他自己，勾选show tail选项可以看到运动轨迹</td></tr></table>

### 各种可视化

打开Trajectory Slider可以查看各个时间点机械臂的状态
使用笛卡尔路径，再点击plan可以实现笛卡尔运动让爪子进行线性运动

## Movelt C++的接口学习

### 运行代码

第一个shell

```
mon launch panda_moveit_config demo.launch
```

第二个shell

```
mon launch moveit_tutorials move_group_interface_tutorial.launch
```

### 代码理解

#### 类的理解

*JointModelGroup*用于储存各个计划组和关节模型组

```c++
static const std::string PLANNING_GROUP = "panda_arm";
```

*MoveGroupInterface*为了方便改变计划组的名字而设置

```c++
moveit::planning_interface::MoveGroupInterface move_group_interface(PLANNING_GROUP);
```

*PlanningSceneInterface*用于添加或者删除碰撞箱和障碍物

```c++
moveit::planning_interface::PlanningSceneInterface planning_scene_interface;
```

*Raw pointers*用于指向计划组来提升性能

```c++
const moveit::core::JointModelGroup* joint_model_group =
    move_group_interface.getCurrentState()->getJointModelGroup(PLANNING_GROUP);
```
