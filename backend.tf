terraform {
  backend "s3" {
    bucket = "my-jenkins-terraform-sai-bucket-backend"
    key = "main"
    region = "ap-south-1"
    dynamodb_table = "my-db-1"
  }
}