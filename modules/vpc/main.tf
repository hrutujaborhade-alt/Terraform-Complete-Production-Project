resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  enable_dns_support = true

  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-vpc"
    }
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidrs[count.index]
  count      = length(var.public_subnet_cidrs)

  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-subnet-az${count.index + 1}"
      Tier = "Public"
    }
  )
}

resource "aws_subnet" "private_app" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_app_subnet_cidrs[count.index]
  count      = length(var.private_app_subnet_cidrs)

  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-app-subnet-az${count.index + 1}"
      Tier = "Private-App"
    }
  )
}

resource "aws_subnet" "private_db" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_db_subnet_cidrs[count.index]
  count      = length(var.private_db_subnet_cidrs)

  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-db-subnet-az${count.index + 1}"
      Tier = "Private-DB"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-igw"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id

  count     = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
}

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-eip-nat"
    }
  )
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-nat-az1"
    }
  )

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-rt"
    }
  )
}

resource "aws_route_table_association" "private-app" {
  route_table_id = aws_route_table.private.id

  count     = length(aws_subnet.private_app)
  subnet_id = aws_subnet.private_app[count.index].id
}

resource "aws_route_table_association" "private-db" {
  route_table_id = aws_route_table.private.id

  count     = length(aws_subnet.private_db)
  subnet_id = aws_subnet.private_db[count.index].id
}