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
