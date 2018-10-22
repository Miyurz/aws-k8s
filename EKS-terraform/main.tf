
#https://github.com/hashicorp/terraform/issues/13022
terraform {
  required_version = "= 0.11.7"
	backend "s3" {
  }
}

provider "aws" {
  region     = "us-east-1"
}

/*
provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
  version = "~> 1.0"
}
*/

