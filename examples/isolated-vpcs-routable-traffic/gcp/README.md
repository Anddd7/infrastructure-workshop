- gcp terraform: https://registry.terraform.io/providers/hashicorp/google/latest/docs
- a cloud guru limit: us, europe, australia-southeast
- youtube
    - how peering works: https://www.youtube.com/watch?v=ZGUwEuubBwU
    - how to use nat: https://www.youtube.com/watch?v=Y47yGMY2-UU
- nat in vpc peering mode: https://themirgleich.medium.com/how-to-use-cloud-nat-with-vpc-peering-5a3874315502
- nat
  vm: https://cloud.google.com/architecture/deploying-nat-gateways-in-a-hub-and-spoke-architecture-using-vpc-network-peering-and-routing
    - !! 但是，由于 NAT 配置未导入对等互连网络，因此该使用场景不支持 Cloud NAT。
    - > VPC 网络对等互连交互
    - > Cloud NAT 网关与单个地区和单个 VPC 网络中的子网 IP 地址范围相关联。即使对等互连网络中的虚拟机与网关位于同一地区，在一个 VPC 网络中创建的 Cloud NAT 网关也无法向使用 VPC
      网络对等互连连接的其他 VPC 网络中的虚拟机提供 NAT。

### login

```zsh
gcloud auth login
gcloud config set project playground-s-11-9b98f7af 
```

### get credentials for terraform

```zsh
gcloud auth application-default login
terragrunt init
```

### clear up

```zsh
terragrunt destroy

gcloud alpha storage rm --recursive gs://tf-state_gcp_anddd7_github_com/
gcloud alpha storage delete gs://tf-state_gcp_anddd7_github_com/
```
