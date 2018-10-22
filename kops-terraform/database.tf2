/*
 * DB security group
 * TODO: Do not allow entire cluster, reference API sg when its done
 */
resource "aws_security_group" "db" {
  name        = "db.${var.env}.${var.domain}"
	description = "DATA STORE: Security group for postgres DB"
	vpc_id      = "${var.env == "staging" ? aws_vpc.vpc-1.id : var.prod_vpc_id}"

  ingress {
    from_port        = "${var.db_port}"
    to_port          = "${var.db_port}"
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags {
    Name = "db.${var.env}.${var.domain}"
    _network = "${var.env}"
    _zone = "${var.env}.${var.domain}"
  }
}

/*
 * Subnet group for RDS
 */

resource "aws_db_subnet_group" "db" {
  name       = "db.${var.env}.${var.domain}"
  subnet_ids = ["${aws_subnet.db-1.id}","${aws_subnet.db-2.id}"]

  tags {
    Name = "db.${var.env}.${var.domain}"
  }
}

/*
 * RDS Cluster
 */
resource "aws_rds_cluster" "db" {
  cluster_identifier      = "org-${var.env}"
  db_subnet_group_name    = "db.${var.env}.${var.domain}"
  engine                  = "${var.db_engine}"
  database_name           = "${var.db_name}"
  master_username         = "${var.db_master_username}"
  master_password         = "${var.db_master_password}"
  backup_retention_period = "${var.db_retention_period}"
  preferred_backup_window = "${var.db_backup_window}"
  port                    = "${var.db_port}"
  vpc_security_group_ids  = ["${aws_security_group.db.id}"]
  skip_final_snapshot     = "${var.db_skip_final_snapshot}"

  depends_on = [
    "aws_db_subnet_group.db"
  ]
}

/*
 * RDS Instance for cluster
 */
resource "aws_rds_cluster_instance" "db_instances" {
  #count                = "${var.db_num_instances}"
	count                = "${var.db_count}"
  engine               = "${var.db_engine}"
  publicly_accessible  = false
  apply_immediately    = "${var.apply_immediately}" // Do not wait for maintenance window on change
  identifier           = "aurora-cluster-postgresql-instance-${count.index}"
  cluster_identifier   = "${aws_rds_cluster.db.id}"
  instance_class       = "${var.db_node_type}"
  db_subnet_group_name = "db.${var.env}.${var.domain}"

  depends_on = [
    "aws_db_subnet_group.db"
  ]
}

/*

 * Conveinence DNS record for the private network
 * eg: db.stage.org.com
*/
/*
resource "aws_route53_record" "db" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "db.${var.env}.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_rds_cluster.db.endpoint}"]
}*/
