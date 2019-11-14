# Why k8s

# Standalone

Upgrade your docker for mac, enable kubernetes

# Cluster on vagrant

ref [Set up cluster on vagrant](./README.md)

# Pipline

倒推

- 通过 yml config 部署到 k8s 集群
  - 单集群多环境: 通过 label 分隔环境, service selector 暴露不同服务
    - https://blog.csdn.net/yyoc97/article/details/102512711
    - https://www.cnblogs.com/kevingrace/p/10961264.html
  - 多集群多环境: [Multiple environments (Staging, QA, production, etc) with Kubernetes](https://stackoverflow.com/questions/43212836/multiple-environments-staging-qa-production-etc-with-kubernetes)
  - EKS: https://eksworkshop.com/introduction/
- E2E/API test
- docker image (image本身没有环境分别, 对外访问统一用服务名称代替 `https://<downstream>:<port>`)
- source code
  - download, build, package
