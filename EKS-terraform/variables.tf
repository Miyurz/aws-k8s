variable "cluster-name" {
  default = "staging"
  type    = "string"
}

variable "k8s-master-version" {
  default = "1.10"
}

variable "zones" {
	type = "list"
  default = ["us-east-1a", "us-east-1c", "us-east-1d"]
}

variable "cidr_block_vpc" {
  default = "10.0.0.0/16"
}

variable "subnet_count" {
  default = 2
}

variable "cidr_block_route_table" {
  default = "0.0.0.0/0"
}

variable "master-iam-role" {
  default = "master-iam-role"
}

variable "route_table_count" {
  default = "2"
}
