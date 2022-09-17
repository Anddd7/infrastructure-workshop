- https://registry.terraform.io/providers/hashicorp/google/latest/docs
- a cloud guru limit: us, europe, australia-southeast

### login

```zsh
gcloud auth login --no-launch-browser
gcloud config set project playground-s-11-9b98f7af 
```

### create storage bucket (backend of terraform)

```zsh
gcloud alpha storage buckets create gs://tf-state_anddd7_github_com --location=AUSTRALIA-SOUTHEAST1
```

### get credentials for terraform

```zsh
gcloud auth application-default login
```
