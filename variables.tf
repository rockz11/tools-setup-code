variable "tools" {
  default = {

    vault = {
      port          = 8200
      volume_size   = 20
      instance_type = "t3.small"
      policy_list = []
    }


    github-runner = {
      port = 80 # Just a dummy port , it wont open any port.
      volume_size   = 20
      instance_type = "t3.small"
      policy_list = ["*"]
    }
    elasticsearch = {
      port = {
        elasticsearch = 9200
        nginx         = 80
        logstash      = 5044
      }
      volume_size   = 50
      instance_type = "r6idn.large"
      policy_list = []
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