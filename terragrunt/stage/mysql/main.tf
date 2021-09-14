terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "stage/mysql/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}