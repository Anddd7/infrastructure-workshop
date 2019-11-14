# RDS Guide

## What - 什么是RDS

- RDS简介，数据库服务，支持的数据库引擎，主机的性能



## Why - 为什么使用RDS

- RDS和EC2自建数据库的区别
- RDS的优势，性能、可扩展、备份、高可用、安全性
- AWS技术栈



## How - 如何使用RDS

- 准备阶段（Session），Ref [设置RDS](https://docs.aws.amazon.com/zh_cn/AmazonRDS/latest/UserGuide/CHAP_SettingUp.html)
  - 确定Region，创建VPC、子网（公有、私有）、安全组
  - 为什么需要这些
    - Region区域：减小网络延迟
    - AZ可用域：物理隔离、安全保障
    - 默认VPC、自定义VPC、无VPC
    - 安全组管理、网络访问管理
- 开始创建（Workshop） [MySQL](https://docs.aws.amazon.com/zh_cn/AmazonRDS/latest/UserGuide/CHAP_GettingStarted.CreatingConnecting.MySQL.html)
  - 选择数据库，引擎、许可模式、数据库实例（机器）、存储空间、主用户名密码
    - 各选项的解释
    - 主用户如何变更？
  - 高级配置，关联VPC、子网、安全组，设置可公开性、端口、IAM验证
    - 设置安全组的访问规则（in bound）
- 查看RDS控制台，连接RDS数据库（Workshop）

### 练习

创建RDS，成功访问并插入一条记录



- 在VPC内部使用RDS（Workshop），[创建 Web 服务器和 Amazon RDS 数据库](https://docs.aws.amazon.com/zh_cn/AmazonRDS/latest/UserGuide/TUT_WebAppWithRDS.html)
  - 创建包含公有子网和私有子网的 VPC
  - 创建RDS到私有子网
  - 创建EC2到公有子网，并安装Web服务
  - 创建安全组，修改策略

### 练习

能够访问Web应用，并能正常存取数据

外部访问不了RDS



- 安全管理（workshop）
  - 安全组、公开性
  - [IAM管理](https://docs.aws.amazon.com/zh_cn/AmazonRDS/latest/UserGuide/UsingWithRDS.IAM.html)，账户安全、角色权限动态、临时身份
  - 数据加密，加密RDS资源（密钥管理）、SSL
  - 数据库主账户权限，[MySQL权限管理](https://www.jianshu.com/p/2269ee2a44b9)
    - vault
- [最佳安全实践](https://docs.aws.amazon.com/zh_cn/AmazonRDS/latest/UserGuide/CHAP_BestPractices.Security.html)

### 

使用SSL，创建安全组，限制网络访问（only allow yourself），创建数据库用户，使用新的用户连接



## 删除RDS

RDS控制台->删除

快照



## CloudFormation