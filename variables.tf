variable "tools" {
  default = {

    vault = {
      port        = 8200
      volume_size = 20
      instance_type = "t3.small"
    }
  }
}

variable "zone_id" {
  default = "Z00196431INWTJ0O5YT57"
}

variable "domain_name" {
  default = "devops11.online"
}

variable "instance_type" {
  default = "t3.small"
}