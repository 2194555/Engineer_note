# MoveIt学习笔记

## 路径规划

1. 绿色模型是机器当前状态
2. 橙色模型是机器期望状态
3. 分别设定好开始和期望动作后点击plan

## 检查轨迹点

1. 在panels中选择MotionPlanning - Slider
2. 滑动滑块，点击play，检查路径

## 使用笛卡尔路径

- 勾选Use Cartesian Path
- 会尝试从起点到终点最短的路径

## 代码相关

设置moveit类:

`moveit::planning_interface::MoveGroupInterface move_group_interface(PLANNING_GROUP);`

在仿真世界中添加碰撞物体：

`moveit::planning_interface::PlanningSceneInterface planning_scene_interface;`

想要更好的性能可以使用指针：

```
const moveit::core::JointModelGroup* joint_model_group =
    move_group_interface.getCurrentState()->getJointModelGroup(PLANNING_GROUP);
```

## 使用代码规划动作

**代码设置的是末端执行器的位置和姿态**

```
geometry_msgs::Pose target_pose1;
target_pose1.orientation.w = 1.0;
target_pose1.position.x = 0.28;
target_pose1.position.y = -0.2;
target_pose1.position.z = 0.5;
move_group_interface.setPoseTarget(target_pose1);
```

## 疑问

1. visualization部分的作用是什么？
