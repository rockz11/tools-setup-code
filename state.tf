terraform {
  backend "s3" {
    bucket = "terraform11"
    key = "tools/terraform.tfstate"
    region = "us-east-1"
  }
}