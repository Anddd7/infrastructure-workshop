- [AWS Certified Solution Architect Associate (SAA-C01)](#aws-certified-solution-architect-associate-saa-c01)
  - [What's this](#whats-this)
  - [How to start](#how-to-start)
    - [Create AWS Account](#create-aws-account)
- [AWS and SA Fundamentals](#aws-and-sa-fundamentals)
  - [Architecture 101](#architecture-101)
    - [Access Management](#access-management)
    - [Shared Reponsibility Model](#shared-reponsibility-model)
    - [Services models](#services-models)
    - [High Availability vs Fault Tolerance](#high-availability-vs-fault-tolerance)
    - [RPO vs RTO：灾备指标](#rpo-vs-rto%e7%81%be%e5%a4%87%e6%8c%87%e6%a0%87)
    - [Scaling](#scaling)
    - [Tiered Application Design](#tiered-application-design)
    - [Encryption](#encryption)
    - [Architecture Odds and Ends（核心原则）](#architecture-odds-and-ends%e6%a0%b8%e5%bf%83%e5%8e%9f%e5%88%99)
    - [AWS Accounts](#aws-accounts)
    - [AWS Physical and Networking Layer](#aws-physical-and-networking-layer)
    - [(TODO) Well-Architected Framework](#todo-well-architected-framework)
    - [Elasticity](#elasticity)
  - [AWS Product Fundamentals](#aws-product-fundamentals)
    - [S3 = simple storage service](#s3--simple-storage-service)
    - [CloudFormation](#cloudformation)
- [Identity and Access Control](#identity-and-access-control)
  - [IAM (Identity and Access Management)](#iam-identity-and-access-management)
    - [IAM Essentials](#iam-essentials)
      - [Amazon Resource Name (ARN)](#amazon-resource-name-arn)
    - [IAM Policies](#iam-policies)
    - [IAM Users](#iam-users)
    - [IAM Groups](#iam-groups)
      - [identity-based vs resource-based policy](#identity-based-vs-resource-based-policy)
    - [IAM Access Keys](#iam-access-keys)
    - [IAM Roles](#iam-roles)
  - [Multi-Account Management and Organizations](#multi-account-management-and-organizations)
    - [AWS Organizations](#aws-organizations)
    - [Role Switching Between Accounts](#role-switching-between-accounts)
- [Compute](#compute)
  - [Server-Based Compute (EC2) Fundamentals](#server-based-compute-ec2-fundamentals)
    - [EC2 Architecture](#ec2-architecture)
      - [EC2 is IaaS](#ec2-is-iaas)
      - [EC2 basic](#ec2-basic)
    - [Instance Types and Sizes](#instance-types-and-sizes)
  - [Server-Based Compute (EC2) Intermediate](#server-based-compute-ec2-intermediate)
  - [Server-Based Compute (EC2) Advanced](#server-based-compute-ec2-advanced)
  - [Serverless Compute (Lambda)](#serverless-compute-lambda)
  - [Container-Based Compute and Microservices](#container-based-compute-and-microservices)
- [Networking](#networking)
  - [Networking Fundamentals](#networking-fundamentals)
  - [Virtual Private Cloud (VPC)](#virtual-private-cloud-vpc)
  - [Advanced VPC](#advanced-vpc)
  - [Global DNS (Route 53) Fundamentals](#global-dns-route-53-fundamentals)
  - [Global DNS (Route 53) Advanced](#global-dns-route-53-advanced)
- [Storage and Content Delivery](#storage-and-content-delivery)
  - [S3 Architecture and Features](#s3-architecture-and-features)
  - [S3 Performance and Resilience](#s3-performance-and-resilience)
  - [CloudFront](#cloudfront)
  - [CloudFront](#cloudfront-1)
- [Databases](#databases)
  - [Database Fundamentals](#database-fundamentals)
  - [SQL — RDS](#sql--rds)
  - [SQL — Aurora](#sql--aurora)
  - [NoSQL](#nosql)
  - [In-Memory Caching](#in-memory-caching)
- [Hybrid and Scaling](#hybrid-and-scaling)
  - [Load Balancing and Auto Scaling](#load-balancing-and-auto-scaling)
  - [VPN and Direct Connect](#vpn-and-direct-connect)
  - [Snowball](#snowball)
  - [Data and DB Migration](#data-and-db-migration)
  - [Identity Federation and SSO](#identity-federation-and-sso)
- [Application, Analytics, and Operations](#application-analytics-and-operations)
  - [Application Integration](#application-integration)
  - [Analytics](#analytics)
  - [Logging and Monitoring](#logging-and-monitoring)
  - [Operations](#operations)
  - [Deployment](#deployment)
- [Conclusion](#conclusion)

# AWS Certified Solution Architect Associate (SAA-C01)

## What's this

- What's AWS

> Amazon Web Services

- What's AWS Certified

![](./images/aws-certification.png)

- What's AWS Certified Solution Architect

> AWS Solutions Architect – Associate SAA-C01 exam is the latest AWS exam and would replace the old CSA-Associate exam.
>
> It basically validates the ability to effectively demonstrate knowledge of how to architect and deploy secure and robust applications on AWS technologies

> - Define a solution using architectural design principles based on customer requirements
> - Provide implementation guidance based on best practices to the organization throughout the life cycle of the project.

![img](./images/good-sa.png)

## How to start

### Create AWS Account

- Credit Card
- Set billing alert: billing dashboard - preference
  - Will send email with invoice
  - Get cost summary from Cost Explorer
- Set billing alarm: CloudWatch
- Set MFA code

# AWS and SA Fundamentals

## Architecture 101

### Access Management

![img](./images/access-keywords.png)

- Principal vs Identity

  - principal 是发起 request 的人
  - identity 是**定义好的** **需要身份验证的** **具有某些访问权限的** 身份

- Authentication（身份验证） vs Authorization（授权）
  - authentication 判断身份, who are you
  - authorization 检查权利, what you can do

**Key: Authorization controls access within a system, while authentication is the validation of a principal against an identity.**

Desc: The key point is that authorization controls where one can go within a system and authentication controls who can get into a system.

### Shared Reponsibility Model

- AWS：[Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/)

  - **AWS responsibility “Security of the Cloud”**

    > 负责基础设施（云基础设施，比如物理机、网络、存储的可靠性）

  - **Customer responsibility “Security in the Cloud”**

    > 取决于用户使用的服务, e.g
    >
    > EC2 - IAAS：用户需要管理 OS 系统，保证访问 remote os 的安全性和应用运行时的稳定性
    >
    > S3 - SAAS：用户需要管理自己的数据，但不需要考虑 S3 的部署和稳定性

![img](https://d1.awsstatic.com/security-center/Shared_Responsibility_Model_V2.59d1eccec334b366627e9295b304202faf7b899b.jpg)

- Azure: [Shared responsibility in the cloud](https://docs.microsoft.com/en-us/azure/security/fundamentals/shared-responsibility)

![](https://docs.microsoft.com/en-us/azure/security/fundamentals/media/shared-responsibility/shared-responsibility.png)

### Services models

![img](./images/resources-stack.png)

- SAAS
  - pay for the service
  - e.g amazon, office, gmail
  - focus on Data, just manage your data(email)
- PAAS
  - focus on Application and Data
- FAAS
  - like PAAS, but not 'full' application
- IAAS
  - pay for Infrastructure
  - e.g EC2
  - focus on items above the OS, don't need to build the data center or set the network

### High Availability vs Fault Tolerance

![img](./images/ha-vs-ft.png)

[容错、高可用、灾备](http://www.ruanyifeng.com/blog/2019/11/fault-tolerance.html)

- Fault Tolerance：operate through a failure with no customer impact
  - 发生故障时，系统的运行水平可能有所下降，但是依然**可用**，不会**完全**失败
  - e.g 飞机发动机, 4 个引擎坏了 1 个还能够继续飞行
- High Available：recover quickly
  - 一旦中断能够**快速恢复**
  - e.g 汽车备胎，更换过后就可以继续运行
- Disaster Recovery
  - 发生故障时，保留核心的业务数据，在新的基础设施上进行恢复
  - e.g 飞机失事时，飞行员可以通过弹射装置弹出

### RPO vs RTO：灾备指标

![img](./images/rps-rto.png)

RPO（Recovery Point Objective，复原点目标）

- 最后备份点与异常事件的时间差
- RPO 越小丢失的数据越少
- RPO 越小花费越高，备份越频繁
- 数据完整性

RTO（Recovery Time Objective，复原时间目标）

- 企业可容许服务中断的时间长度：服务恢复与异常事件的时间差
- 数据恢复能力

### Scaling

![img](./images/vertical-scaling.png)
![img](./images/horizontal-scaling.png)

Vertical

- add additional resources: CPU, memory of existing machine
  - 性能瓶颈
  - 价格曲线升高: 1 台 1T 的电脑 > 10 台 100G 的

Horizontal

- add additional machine
  - central data
  - 负载
  - 性价比更高, 但需要处理更多的问题

### Tiered Application Design

![img](./images/tiered-design.png)

= Layered Application Design

**monolithic（单体） vs isolated components**

### Encryption

![](./images/encryption.png)

- at rest：本地
- at transit：传输过程中

* symmetrical 对称加密
* asymmetrical 非对称加密
  - public_key 只能用来加密; 加密后的信息只能用 private_key 解密

### Architecture Odds and Ends（核心原则）

- Cost efficient and effective
  - 钱要用到刀刃上，要高效且省钱
- Secure: 抵御攻击的能力
- Application session state
  - 即用户状态
  - 无状态应用优先: 无需处理用户状态，在 scale 和 recover 的时候有巨大优势
- Undifferentiated heavy lifting
  - 和业务需求无关的 应用/系统/平台
  - e.g 搭建博客网站, -> 需要 DataCenter
  - 将业务无关的繁重的操作交给 vendor, 只关注业务

### AWS Accounts

by default:
1 account - 1 root user account -> authentication
1 account - all authorizations in this account
multiple accounts - same billing config

![img](./images/account-authentication.png)
![img](./images/account-authorization.png)
![img](./images/account-billing.png)

### [AWS Physical and Networking Layer](https://www.infrastructure.aws)

- region
  - 基于 地域 和 法律 划分的区域
  - 不是所有 region 都具有 full set of AWS
  - 区域之间采用 Internet 互联
  - 区域之间的数据复制必须是用户主动触发和执行
- available zone
  - AZ 相互物理隔离
  - 可用区之间采用高速低延迟专线直连
  - AWS 可以跨多个可用区复制数据以增强弹性
  - 一个 AZ 有多个 DataCenter
    - 数据中心之间采用 N+1 形式进行灾备
    - 数据中心采用自由网络设备和网络协议
- [local zone](https://aws.amazon.com/cn/about-aws/whats-new/2019/12/introducing-aws-local-zone-in-los-angeles-ca/?nc1=h_ls)
  - 新的 AZ 的扩展, 更近更快的部分服务, e.g EC2 VPC ELB ...
- points of presence
  - = edge location and regional edge cache server
  - -> CloudFront and Route 53, as CDN and DNS
  - low latency connectivity

![img](./images/az.png)
![img](./images/global-Infrastructure.png)

### (TODO) [Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

- Framework
- Operational Excellence
- Security
- Reliability
- Performance Efficiency
- Cost Optimization

### Elasticity

- vertical
  - 预测 demond, 再扩展 capacity
  - demond 和 capacity 不是完全匹配的, 会出现不足和浪费的情况

![img](./images/elasticity-vertical.png)

- horizontal
  - 使用小机器 + 频繁的调整, 能够比较好的贴合 demond

![img](./images/elasticity-horizontal.png)

- elastic = horizontal + automation
  - 真实的需求情况是上下波动的
  - achieve Performance Efficiency & Cost Optimization

![img](./images/elasticity-elastic.png)

## AWS Product Fundamentals

### S3 = simple storage service

- global
  - but the created bucket should belong to a region
  - duplicated in multiple AZs
- store the object
  - 以 key-value(name-data) 的方式存储
  - folder 不是 folder, 也是一个文件

![img](./images/s3.png)
![img](./images/exam-facts-s3.png)

### CloudFormation

- stack: container of aws resources
  - logical in template -> physical in aws

![img](./images/cloudformation.png)
![img](./images/exam-facts-cloudformation.png)

# Identity and Access Control

## IAM (Identity and Access Management)

### IAM Essentials

**account root user**

- always full access
- initial set up for IAM users
  - password policy, security token service(sts)
- recommend: should not use account root user do any thing except the initial account set up

**'identity' type**

- IAM User
  - login with username and password or access key
  - e.g a person, an application
- IAM Group
  - cannot loggin
  - group x n : n x users
  - e.g a department, a system
- IAM Role
  - cannot loggin
  - can be temporarily taken
  - e.g a job, a duty-hat
- IAM Policy
  - can assigned to group, user or role
  - define what can/cannot do
- IAM Credential
  - username password
  - access key (for command line)
  - short term username/password or access key (for role)

You cannot access any resources until given the permission policy

![img](./images/iam.png)

#### Amazon Resource Name (ARN)

an unique identifier for all aws resources

![img](./images/arn.png)

### IAM Policies

![img](./images/iam-policy.png)
[policy sample](./content-aws-csa2019/lesson_files/02_identity_access_control/iam_policies_and_users/policy.json)

> sid: statement id, unique id
> effect: allow or deny
> action: actions which defined by aws and what you want to put in this policy
> resource: arn or target resources

use managed policy controll the base, customize with inline policy

![img](./images/iam-policy-exam.png)

> 只要有一个 显式的 deny(from user/role/group)就会禁止访问, 即 explicit deny > allow > implicit deny

### IAM Users

![img](./images/iam-user.png)

![img](./images/iam-user-exam.png)

permission boundry: beyond permission policy

> 一个用户(默认)最大可添加的 managed policy 是 10 个, inline 最大 2048 个字符
> 建议使用 group 对 policy 进行组合, 然后拆分再赋权给 user

### IAM Groups

> Note that a group is not truly an "identity" in IAM because it cannot be identified as a Principal in a permission policy. It is simply a way to attach policies to multiple users at one time.
> policy 并不是作用在 group 上的, 只是通过 group 赋权给 user; group 也无法参与 resource-policy 的设置

![img](./images/iam-group.png)

![img](./images/iam-group-exam.png)

#### [identity-based vs resource-based policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_identity-vs-resource.html)

- **Identity-based policies** are attached to an IAM user, group, or role. These policies let you specify what that identity can do (its permissions).
- **Resource-based policies** are attached to a resource. you can specify who has access to the resource and what actions they can perform on it.

![img](https://docs.aws.amazon.com/IAM/latest/UserGuide/images/Types_of_Permissions.diagram.png)

### IAM Access Keys

Access keys consist of access key IDs and secret access keys. Access keys are the long-term credentials used to authenticate to AWS for anything but the console UI.

- you can have 2 access key
- secret acess key can only be obtained once at generated
- recommend: rotate access key regularly

![img](./images/iam-accesskey.png)

### IAM Roles

![img](./images/iam-role.png)

![img](./images/iam-role-exam.png)

- trust policy: 定义谁能使用这个角色
- permission policy: 定义这个角色能使用哪些资源

> 创建角色; 指定 trust policy 和 permission policy;
> assume role: STS 会 validate 是否可以应用此角色;
> 生成一个 time-limited 的 access keys; 通过这组 keys 可以使用 permission policy 定义的资源;

```
aws sts assume-role
```

> 用于 multiple-account/organization aws management
> e.g A 公司的员工可以通过 B 公司的 Role, 访问 B 公司的资源

## Multi-Account Management and Organizations

### AWS Organizations

Manage multiple accounts

- consolidate bill

  > aws account 默认是 standard account
  > 由 aws account 创建的 organization 中, 会升级为 master account
  > member account 的账单会提交给 master 统一管理

- all features mode

  > can limit usage of organization unit or member account using service control policies
  > master account only used to manage service control policies and pay the bill

![img](./images/organization-billing-1.png)

![img](./images/organization-billing-2.png)

### Role Switching Between Accounts

![img](./images/switch-role.png)

# Compute

## Server-Based Compute (EC2) Fundamentals

### EC2 Architecture

#### EC2 is IaaS

- Monolithic applications
- Consistent, long-running compute scenarios
- Applications that require full OS/runtime installations
- Services, endpoints, and/or applications that require high availability

![img](./images/ec2.png)

#### EC2 basic

- EC2 Host: 实际运行的物理主机
- EC2 Instance: 划分给用户使用的虚拟主机
  > “An important difference between a Dedicated Host and a Dedicated Instance is that a Dedicated Host gives you additional visibility and control over how instances are placed on a physical server, and you can consistently deploy your instances to the same physical server over time.”
- [Instance Store Volume](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html): 在物理机所管理的存储空间上临时划分给 Instance 的空间
- Amazon Machine Image(AMI): 虚拟机镜像
- Elastic Block Store(EBS): 可挂载的 block-storage
  - [vs Instance Store](https://medium.com/awesome-cloud/aws-difference-between-ebs-and-instance-store-f030c4407387): **if an instance is stopped or terminated, any data on instance store volumes is lost.**

![img](https://miro.medium.com/max/4640/1*qsp2AVDuy9-UC3eykIWM_w.png)

- [Elastic Network Interface(ENI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide//using-eni.html): 类似虚拟网卡, 主要包含 IP 相关的信息
  - 由 Security Group 管理 IP 的访问域
- CloudWatch: AWS 监控中心

[EC2 Instance Lifecycle](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-lifecycle.html)
![img](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/images/instance_lifecycle.png)

### [Instance Types and Sizes](https://aws.amazon.com/ec2/instance-types/)

[T3 vs M5](https://www.apptio.com/emerge/ec2-m5-vs-t3/)

> Burstable Performance Instances

> T2 或 T3 有一个 CPU Baseline, 即 24 小时内 CPU 的使用率未超过基线, 则按一般价格收费; 超过了即按 On-Demand 收费;
> 1 credit = 1 vCPU * 100% * 1 min = 2 vCPUs * 50% * 1 min
> 低于baseline的运行会累积credit, 超过时会先抵扣

![img](./images/ec2-size.png)

---

Continue...

---

## Server-Based Compute (EC2) Intermediate

## Server-Based Compute (EC2) Advanced

## Serverless Compute (Lambda)

## Container-Based Compute and Microservices

# Networking

## Networking Fundamentals

## Virtual Private Cloud (VPC)

## Advanced VPC

## Global DNS (Route 53) Fundamentals

## Global DNS (Route 53) Advanced

# Storage and Content Delivery

## S3 Architecture and Features

## S3 Performance and Resilience

## CloudFront

## CloudFront

# Databases

## Database Fundamentals

## SQL — RDS

## SQL — Aurora

## NoSQL

## In-Memory Caching

# Hybrid and Scaling

## Load Balancing and Auto Scaling

## VPN and Direct Connect

## Snowball

## Data and DB Migration

## Identity Federation and SSO

# Application, Analytics, and Operations

## Application Integration

## Analytics

## Logging and Monitoring

## Operations

## Deployment

# Conclusion
