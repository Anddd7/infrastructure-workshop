- https://registry.terraform.io/providers/hashicorp/google/latest/docs
- a cloud guru limit: us, europe, australia-southeast
- youtube
  - how peering works: https://www.youtube.com/watch?v=ZGUwEuubBwU
  - how to use nat: https://www.youtube.com/watch?v=Y47yGMY2-UU


### login

```zsh
gcloud auth login
gcloud config set project playground-s-11-9b98f7af 
```

### create storage bucket (backend of terraform)

```zsh
gcloud alpha storage buckets create gs://tf-state_gcp_anddd7_github_com --location=AUSTRALIA-SOUTHEAST1
```

### get credentials for terraform

```zsh
gcloud auth application-default login
terraform init -reconfigure
```








----



### clear up

```zsh
terraform destroy

gcloud alpha storage rm --recursive gs://tf-state_gcp_anddd7_github_com/
gcloud alpha storage delete gs://tf-state_gcp_anddd7_github_com/
```
