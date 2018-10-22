
module "vpc" {
	source = "modules/terraform-aws-vpc"
  name = "${terraform.workspace == "prod" ? var.prod_zone : var.stage_zone }"
  cidr = "${terraform.workspace == "prod" ? var.prod_cidr : var.stage_cidr }"

	# conditional operator cannot be used with list values in, so can't do below
  # azs                 = "${terraform.workspace == "prod" ? "${var.prod_azs}" : "${var.stage_azs}" }"
  # Workaround as per https://github.com/hashicorp/terraform/issues/12453#issuecomment-284273475
	# WIP: https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements
  #      https://github.com/hashicorp/terraform/issues/12453

	azs = ["${split(",", terraform.workspace == "prod" ? join(",", var.prod_azs) : join(",", var.stage_azs))}"]
 

	private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  #database_subnets    = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
  #elasticache_subnets = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]
  #redshift_subnets    = ["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]
  #intra_subnets       = ["10.10.51.0/24", "10.10.52.0/24", "10.10.53.0/24"]

  create_database_subnet_group = false

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_vpn_gateway = true

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  tags = {
    Owner       = "user"
    Environment = "${terraform.workspace == "prod" ? "var.prod_zone" : "var.stage_zone" }"
    #Name        = "${terraform.workspace == "prod" ? format("%s.%s", var.prod_zone, "-env") : format("%s.%s", var.stage_zone,"-env") }"
    Name        = "${terraform.workspace == "prod" ? format("%s", var.prod_zone) : format("%s", var.stage_zone) }"
  }

}
