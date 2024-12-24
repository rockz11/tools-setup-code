terraform {
  backend "s3" {
    bucket = "terraform143"
    key = "tools/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "vault" {
  address         = "http://vault-internal.devops11.online:8200"
  token           = var.vault_token
  skip_tls_verify = true
}