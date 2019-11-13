## Set up k8s cluster by kubeadm in vagrant

Ref: [Multi Node Kubernetes Cluster with Vagrant, VirtualBox and Kubeadm](https://medium.com/@raj10x/multi-node-kubernetes-cluster-with-vagrant-virtualbox-and-kubeadm-9d3eaac28b98)

- vagrant
- kubeadm
  - [install-kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- vitrual box

## Standalone k8s

- deploy docker compose
- deploy k8s
  - You can deploy a docker compose on your local k8s, using [docker stack](https://alanhou.org/docker-kubernetes/).
  - ~~Or using [kompose](https://kompose.io/) to deploy dc, if no docker stack tools~~
  - Or convert dc to k8s config, then deploy them

### k8s resources

Pod:

- 最小部署单元
- 由 1~n 个共享资源(volume,ports)的容器组成, 可以通过 localhost 访问彼此
- 异常终止无法自动恢复

ReplicaSet:

- define pod template
- 副本控制, auto scale to expected replicas
- 滚动升级, 自动调整 Pod 配置和副本数量

Deployment:

- 升级版 RS, has deploy status

Service:

- network management
- load balancing
- expose port

#### Access pod with NodePort service

```
kubectl create -f app-pod.yml,app-service.yml
curl http://localhost:8080?key=a&value=b
kubectl delete -f app-pod.yml,app-service.yml
```

#### Access node service through LoadBalance service, with multi copies pod

```
kubectl create -f redis-svc.yml,redis-deploy.yml,app-deploy.yml,app-svc.yml
curl http://localhost:8080?key=a&value=b
kubectl delete -f redis-svc.yml,redis-deploy.yml,app-deploy.yml,app-svc.yml
```

## Let's GO

- prepare server by vagrant, find more details in `Vagrantfile`
- check docker/kubernetes are ready in servers
  - `vagrant ssh <name>`
- install k8s-dashboard
  - `kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml`
  - ~~start dashoboard and allow request from remote server, `kubectl proxy --address 0.0.0.0 --accept-hosts '.*'`~~
    - dashboard can not published by http, you can modify the service type to NodePort: `kubectl -n kube-system edit service kubernetes-dashboard`
    - use a proxy to redirect your request
    - !!!!! [iptables -A FORWARD -j ACCEPT](https://stackoverflow.com/questions/46667659/kubernetes-cannot-access-nodeport-from-other-machines)
  - create service account `kubectl create serviceaccount dashboard-admin`
  - bind account to cluster admin role `kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin`
  - get access token `kubectl describe secret $(kubectl get secret | grep dashboard-admin | awk '{print $1}')`

## Maintenance
