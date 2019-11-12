## Set up k8s cluster by kubeadm in vagrant

Ref: [Multi Node Kubernetes Cluster with Vagrant, VirtualBox and Kubeadm](https://medium.com/@raj10x/multi-node-kubernetes-cluster-with-vagrant-virtualbox-and-kubeadm-9d3eaac28b98)

- vagrant 
- kubeadm
  - [install-kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- vitrual box

### Standalone k8s
- deploy docker compose
- deploy k8s
  - You can deploy a docker compose on your local k8s, using [docker stack](https://alanhou.org/docker-kubernetes/).
  - Or using [kompose](https://kompose.io/) to deploy dc, if no docker stack tools
  - Or convert dc to k8s config, then deploy them: ``

### Let's GO

- prepare server by vagrant
  - check ip
  - install required env
- 