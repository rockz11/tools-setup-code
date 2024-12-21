terraform {
  backend "s3" {
    bucket = "terraform143"
    key    = "vault-secrets/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "vault" {
  address = "http://vault-internal.devops11.online:8200"
  token = var.vault_token
  skip_tls_verify = true
}

variable "vault_token" {}

resource "vault_mount" "roboshop-dev" {
  path = "roboshop-dev"
  type = "kv"
  options = { version= "2" }
  description = "Roboshop Dev Secrets"
}

resource "vault_generic_secret" "frontend" {
  path = "${vault_mount.roboshop-dev.path}/frontend"

  data_json = <<EOT
{
  "catalogue_url":    "http://catalogue-dev.devops11.online:8080/",
  "cart_url":   "http://cart-dev.devops11.online:8080/",
  "user_url":   "http://user-dev.devops11.online:8080/",
  "shipping_url":   "http://shipping-dev.devops11.online:8080/",
  "payment_url":   "http://payment-dev.devops11.online:8080/"
}
EOT
}

Environment=MONGO=true
Environment=MONGO_URL="mongodb://mongodb-{{ env }}.devops11.online:27017/catalogue"


resource "vault_generic_secret" "catalogue" {
path = "${vault_mount.roboshop-dev.path}/catalogue"

data_json = <<EOT
{
  MONGO: "true"
  "MONGO_URL" : "mongodb://mongodb-dev.devops11.online:27017/catalogue"
}
EOT
}