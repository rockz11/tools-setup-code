terraform {
  backend "s3" {
    bucket = "terraform143"
    key = "tools/terraform.tfstate"
    region = "us-east-1"
  }
}