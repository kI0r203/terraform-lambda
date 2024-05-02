terraform {
  backend "s3" {
    bucket = "deploy-upb-bucket"
    key = "terraform/lambda.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state"
  }
}