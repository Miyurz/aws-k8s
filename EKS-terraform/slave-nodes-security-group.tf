resource "aws_security_group" "nodes-security-group" {
  name        = "${var.cluster-name}-sg1"
  description = "Security group for all the nodes in the cluster"
  vpc_id      = "${aws_vpc.vpc-1.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "${var.cluster-name}-sg1",
     "kubernetes.io/cluster/${var.cluster-name}", "owned",
    )
  }"
}
