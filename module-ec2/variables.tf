# variable "env" {}
# variable "component_name" {}
# variable "instance_type" {}
# variable "app_port" {}
# variable "zone_id" {}
# variable "domain_name" {}
# # tool_name = each.key
# # sg_port = each.value["port"]
# # volume_size = each.value["volume_size"]
#
#
# variable "ami" {}
variable "tool_name" {}
variable "sg_port" {
  default = {
    http = 80
    http = 8200
  }
}
variable "volume_size" {}
variable "instance_type" {}
variable "zone_id" {}
variable "domain_name" {}
variable "policy_list" {}