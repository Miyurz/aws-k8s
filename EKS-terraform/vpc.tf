#Spin up a VPC and related components

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc-1" {
  cidr_block = "${var.cidr_block_vpc}" #"10.0.0.0/16"

  tags = "${
    map(
     "Name", "${var.cluster-name}-vpc",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "subnet-1" {
  count = "${var.subnet_count}"
  availability_zone = "${var.zones[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.vpc-1.id}"

  tags = "${
    map(
     "Name", "${var.cluster-name}-subnet",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "ig-1" {
  vpc_id = "${aws_vpc.vpc-1.id}"

  tags {
    Name = "${var.cluster-name}-internet-gateway"
  }
}

resource "aws_route_table" "rt-1" {
  vpc_id = "${aws_vpc.vpc-1.id}"

  route {
    cidr_block = "${var.cidr_block_route_table}" #0.0.0.0/0
    gateway_id = "${aws_internet_gateway.ig-1.id}"
  }
}

resource "aws_route_table_association" "rta-1" {
  count          = "${var.route_table_count}"
  subnet_id      = "${aws_subnet.subnet-1.*.id[count.index]}"
  route_table_id = "${aws_route_table.rt-1.id}"
}
