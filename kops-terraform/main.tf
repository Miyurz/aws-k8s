// https://github.com/hashicorp/terraform/issues/13022

terraform {
	# Get version from 
  required_version = ">= 0.11.7"
	backend "s3" {
  }
}

provider "aws" {
	# Get version from here https://releases.hashicorp.com/terraform-provider-aws/
  version = ">= 1.36.0"
	region = "us-east-1"
}

provider "aws" {
  alias  = "bucket"
  region = "us-east-2"
}

/*provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
  version = "~> 1.0"
}*/
