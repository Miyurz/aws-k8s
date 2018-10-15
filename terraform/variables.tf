
variable "cidr_stage" {
  description = "CIDR for the staging VPC"
	type = "string"
	default = "10.0.0.0/16"
}

variable "redis_subnet_cidr_block" {
  default = "10.0.2.0/24"
}

variable "db_subnet_1_cidr_block" {
  default = "10.0.7.0/24"
}

variable "db_subnet_2_cidr_block" {
  default = "10.0.8.0/24"
}

variable "prod_vpc_id" {
  description = "VPC ID available to peer with"
	type = "string"
	default = "vpc-bda0a4c5"
}

variable "name_short" {
  description = "Short name"
}

/*
FYI, we are using interpolations to not spin a DB instance/cluster in prod since we already have one there spun
w/o terraform. So we just have to peer it with k8s cluster
*/
variable "db_count" {
	description = "Database instances count in prod."
}

variable "termination_protection" {
  description = "Disable API termination of resources that support it"
}
/*
variable "cloudflare_email" {
  description = "Cloudflare email address for API token"
}

variable "cloudflare_token" {
  description = "Cloudflare API token. It's in 1password"
}

variable "cloudflare_origin_cert" {
  description = "Cloudflare origin certificate file path"
}

variable "cloudflare_origin_key" {
  description = "Cloudflare origin certificate key path"
}
*/
variable "env_prefix" {
  description = "Short form => prod,stg ?"
}

variable "env" {
  description = "What environment? stg,prod,dev ?"
}

variable "domain" {
  description = "Domain name"
}

variable "description" {
  description = "Network description"
}

variable "network_id" {
  description = "Network ID for CIDR math"
}

variable "tg_instance_port" {
  description = "Port the application listens on"
}

variable "cache_node_type" {
  description = "Elasticache redis node type"
}

variable "cache_node_param_group" {
  description = "Elasticache redis parameter group"
}

variable "manager_node_type" {
  description = "EC2 instance type (HVM)"
}

variable "manager_drive_size" {
  description = "Root volume disk size in GB"
}

variable "db_engine" {
  description = "Aurora engine"
}

variable "db_port" {
  description = "Database port"
}

variable "db_name" {
  description = "Main database name"
}

variable "db_master_username" {
  description = "Admin user name"
}

variable "db_master_password" {
  description = "Admin password"
}

variable "db_retention_period" {
  description = "How many days database backups should be retained"
}

variable "db_backup_window" {
  description = "What time of day to perform backup and maintenance"
}

variable "db_num_instances" {
  description = "How many aurora nodes to run"
}

variable "db_node_type" {
  description = "https://goo.gl/GmUY2c"
}

variable "db_skip_final_snapshot" {
    description = "Allow deletion of cluster without final snapshot"
}

variable "apply_immediately" {
  description = "Apply database changes immediately"
}
