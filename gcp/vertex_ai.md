# Objectives

- Train a TensorFlow model locally in a hosted Vertex Notebook.
- Create a managed Tabular dataset artifact for experiment tracking.
- Containerize your training code with Cloud Build and push it to Google Cloud Artifact Registry.
- Run a Vertex AI custom training job with your custom model container.
- Use Vertex TensorBoard to visualize model performance.
- Deploy your trained model to a Vertex Online Prediction Endpoint for serving predictions.
- Request an online prediction and explanation and see the response.

# Run

## Enable Google Cloud services

1. In Cloud Shell, use gcloud to enable the services used in the lab.

```bash
gcloud services enable \
  compute.googleapis.com \
  iam.googleapis.com \
  iamcredentials.googleapis.com \
  monitoring.googleapis.com \
  logging.googleapis.com \
  notebooks.googleapis.com \
  aiplatform.googleapis.com \
  bigquery.googleapis.com \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com \
  container.googleapis.com
```

## Create Vertex AI custom service account for Vertex Tensorboard integration

1. Create custom service account

```bash
SERVICE_ACCOUNT_ID=vertex-custom-training-sa
gcloud iam service-accounts create $SERVICE_ACCOUNT_ID  \
    --description="A custom service account for Vertex custom training with Tensorboard" \
    --display-name="Vertex AI Custom Training"
```

2. Grant it access to GCS for writing and retrieving Tensorboard logs

```bash
PROJECT_ID=$(gcloud config get-value core/project)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/storage.admin"
```

3. Grant it access to your BigQuery data source to read data into your TensorFlow model

```bash
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/bigquery.admin"
```

4. Grant it access to Vertex AI for running model training, deployment, and explanation jobs.

```bash
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com \
    --role="roles/aiplatform.user"
```
