resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    ManagedBy   = "terraform"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    ManagedBy   = "terraform"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone_id = "euw2-az1"

  tags = {
    ManagedBy   = "terraform"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone_id = "euw2-az1"

  tags = {
    ManagedBy   = "terraform"
  }
}

resource "aws_eip" "nat_1" {
  vpc   = true
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = "${aws_eip.nat_1.id}"
  subnet_id     = "${aws_subnet.public_1.id}"

  tags = {
    ManagedBy   = "terraform"
  }
}

resource "aws_route_table" "public_1" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    ManagedBy   = "terraform"
  }
}

resource "aws_route" "public_igw" {
  route_table_id         = "${aws_route_table.public_1.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public_1.id}"
  route_table_id = "${aws_route_table.public_1.id}"
}

resource "aws_route_table" "private_1" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    ManagedBy   = "terraform"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = "${aws_route_table.private_1.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat_gateway_1.id}"
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.private_1.id}"
  route_table_id = "${aws_route_table.private_1.id}"
}
