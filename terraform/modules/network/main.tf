resource "aws_vpc" "infoline_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "infoline-vpc"
  }
}

resource "aws_subnet" "infoline_subnet" {
  vpc_id            = aws_vpc.infoline_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    Name = "infoline-subnet"
  }
}

resource "aws_internet_gateway" "infoline_igw" {
  vpc_id = aws_vpc.infoline_vpc.id

  tags = {
    Name = "infoline-igw"
  }
}

resource "aws_route_table" "infoline_rt" {
  vpc_id = aws_vpc.infoline_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infoline_igw.id
  }

  tags = {
    Name = "infoline-route-table"
  }
}

resource "aws_route_table_association" "infoline_rta" {
  subnet_id      = aws_subnet.infoline_subnet.id
  route_table_id = aws_route_table.infoline_rt.id
}

# Subnet public 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.infoline_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true


  tags = {
    Name                     = "public-subnet-1"
    "kubernetes.io/role/elb" = "1"
  }


}

# Subnet public 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.infoline_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-3b"
  map_public_ip_on_launch = true


  tags = {
    Name                     = "public-subnet-2"
    "kubernetes.io/role/elb" = "1"
  }

}



# Subnet privé 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.infoline_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-3a"


  tags = {
    Name                              = "private-subnet-1"
    "kubernetes.io/role/internal-elb" = "1"
  }

}


# Subnet privé 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.infoline_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-west-3b"


  tags = {
    Name                              = "private-subnet-2"
    "kubernetes.io/role/internal-elb" = "1"
  }

}


resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.infoline_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.infoline_rt.id
}
