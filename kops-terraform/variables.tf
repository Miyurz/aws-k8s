variable "helm_bucket" {
	type = "string"
}
	
variable "helm_bucket_replication" { 
	type = "string"
}

variable "prod_zone" {
	description = "Prod VPC"
	type = "string"
	default = "ProdVPC"
}

variable "stage_zone" {
  description = "Stage VPC"
	type = "string"
	default = "StageVPC"
}

variable "stage_cidr" {
  description = "CIDR for the staging VPC"
	type = "string"
	default = "10.10.0.0/16"
}

variable "prod_cidr" {
  description = "CIDR for the prod VPC"
	type = "string"
	default = "10.9.0.0/16"
}

variable "prod_azs" {
  description = "AZs for prod VPC"
	type = "list"
	default = ["us-west-1a", "us-west-1b", "us-west-1c"]
}

variable "stage_azs" {
  description = "AZs for stage VPC"
	type = "list"
	default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "domain" {
  description = "Domain name"
	default = "test.com"
}

