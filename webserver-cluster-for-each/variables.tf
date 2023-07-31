//variable "module_db_remote_state_bucket" {}
//variable "module_db_remote_state_key" {}
variable "module_server_port" {}
variable "module_elb_name" {}
variable "module_instance_security_group_name" {}
variable "module_elb_security_group_name" {}
variable "custom_tags" {
    description = "Custom tags to set on the Instances in the ASG"
    type = map(string)
    default = {}
}

locals {
    http_port               = 80
    ssh_port                = 22
    elb_http_port           = 80
    any_port                = 0
    any_protocol            = "-1"
    tcp_protocol            = "tcp"
    all_ips                 = ["0.0.0.0/0"]
    elb_protocol            = "http"
    elb_instance_protocol   = "http"
    instance_type           = "t2.medium"
}