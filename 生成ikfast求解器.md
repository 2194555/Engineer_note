# 给工程生成ikfast插件

> MoveIt提供了一些工具，可以使用OpenRAVE生成的cpp文件为MoveIt生成IKFast运动学插件

用Ubuntu 14.04的docker镜像

```
sudo apt-get install docker.io
sudo service docker start
```

以下命令将确保可以使用用户帐户运行docker（将$user添加到docker组）

```
sudo usermod -a -G docker $USER
```

下载解算库

```
sudo apt-get install ros-noetic-moveit-kinematics
```

------

## 创建IKFast MoveIt插件

在rm_engineer文件夹下生成urdf格式（需删掉已生成的插件）

```
rosrun xacro xacro -o engineer.urdf ../rm_description/urdf/engineer/engineer.urdf.xacro
```

运行auto_create_ikfast_moveit_plugin.sh

```
rosrun moveit_kinematics auto_create_ikfast_moveit_plugin.sh --iktype Transform6D engineer.urdf arm base_link link6
```

上个命令的参数意思

> http://openrave.org/docs/latest_stable/openravepy/ikfast/#ik-types

| 参数            | 意思             |
| --------------- | ---------------- |
| base_link       | 初始关节         |
| link6           | 结束关节         |
| **Transform6D** | 机械臂是六轴串联 |

(这步之后不会生成engineer_moveit_config)

编译

------

修改engineer_arm_config包下的把 kinematics.yaml文件 的 **kinematics_solver:**

```
kinematics_solver: engineer_arm/IKFastKinematicsPlugin
```

TODO:

添加七轴机械臂ikfast插件的生成方法。