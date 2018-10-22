resource "aws_security_group" "master-security-group" {
  name        = "Master security group"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.vpc-1.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Master security group"
  }
}
