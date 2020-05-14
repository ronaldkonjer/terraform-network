/*
 * network gateways
 */

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.name
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = element(var.nat_eip_ids, 0)
  subnet_id     = element(aws_subnet.public.*.id, 0)
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = var.name
  }
}

