## public/private subnets architecture

- Create VPC
- Create subnets
  - naming convention: public/private + az + id
  - default is private
  - 'public subnet' = private + auto-assign public ip
- Create Instance
  - bastion in public subnet
    - 因为没有internet gateway, AWS不会允许任何流量出入VPC, 所以连接会失败
  - private instance in private subnet
    - 可以使用同一个key
    - ```
      ssh-add -K bastion.pem
      # 连接bastion
      ssh -A ec2-user@52.87.105.11
      # 连接private instance
      ssh -A ec2-user@10.0.0.108
      ```
- Create Internet Gateway
    - 1:1 attach to VPC
- 'Config' Route Tables to route bastion's in/out access
  - Add new route table
    - 一般会保留主route, 创建custom route table进行定制
  - Add route
    - 0.0.0.0/0 = ipv4所有地址 ; ::/0 = ipv6所有地址
    - 按精确程度匹配, 范围越小越优先
  - Attach public subnet
    - 应该只有public subnet有能力通过route table连接internet gateway
    - 此时连接bastion成功, 并具有外网连接, try `ping 1.1.1.1`
- Connect private instance from bastion instance
  - 因为在同一个VPC内, private instance可通过route table连接
  - 但是private instance是没有外网权限, 他所属的route table只能导流内部
- Create NAT for private instance
  - Create NAT in public subnet
    - 有公共IP
    - 保证NAT能够通过Internet Gateway出去
  - Add new route table -> add route to NAT -> attach private subnet
    - 所有从private访问外界的流量都会通过NAT流出
  - 连接private instance via bastion, try `ping 1.1.1.1`
    - private instance -> NAT -> Internet Gateway
    - 外界看到的host ip其实是NAT的IP, 所以只允许从instance发起的连接流量, 而不能反向访问 (单向)
- Network ACL
  - 默认所有流量都可以通过subnet
  - 可修改控制到某一个subnet的流量