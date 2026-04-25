provider "aws" {
  region = "eu-west-3"
}

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

resource "aws_security_group" "infoline_sg" {
  name        = "infoline-sg"
  description = "Security group for infoline project"
  vpc_id      = aws_vpc.infoline_vpc.id

  # SSH
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Sortie
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "infoline-sg"
  }
}


resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "infoline_eks" {
  name     = "infoline-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id,
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = "infoline-eks-cluster"
  }
}
  
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}


resource "aws_eks_node_group" "infoline_nodes" {
  cluster_name    = aws_eks_cluster.infoline_eks.name
  node_group_name = "infoline-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids = [
  aws_subnet.public_subnet_1.id,
  aws_subnet.public_subnet_2.id
  ]

  scaling_config {
    desired_size = 4
    max_size     = 4
    min_size     = 3
  }


  instance_types = ["t3.micro"]

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry_policy
  ]

  tags = {
    Name = "infoline-node-group"
  }
}

resource "aws_instance" "ansible_server" {
  ami                         = "ami-0d3c032f5934e1b41"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.infoline_sg.id]
  associate_public_ip_address = true
  key_name = "ansible-key"

  tags = {
    Name = "ansible-server"
  }
}

resource "aws_ecr_repository" "backend_repo" {
  name = "backend-node-app"

  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "backend-node-app"
  }
}

resource "aws_ecr_repository" "frontend_repo" {
  name = "frontend-react-app"

  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "frontend-react-app"
  }
}
