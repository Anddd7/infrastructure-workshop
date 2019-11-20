## Set up k8s cluster

Prepare server

- docker
- kubectl
- kubeadm (master)
- helm (master)
- jenkins (cluster)
  - [jenkins on k8s](https://github.com/helm/charts/tree/master/stable/jenkins)

### Coding

### Source Code Version Management

Git(Github): trunk-based

### CI

Jenkins

- build pipeline
  - [setup pipeline](https://akomljen.com/set-up-a-jenkins-ci-cd-pipeline-with-kubernetes/)
  - pipeline as code: Jenkinsfile
  - [build image](https://jenkins.io/doc/book/pipeline/docker/)
- define envs in pod template
- credentials management
- hook or cron scan

### CD

Jenkins

- deploy into kubectl

### Monitor

prometheus
grafana
elk
