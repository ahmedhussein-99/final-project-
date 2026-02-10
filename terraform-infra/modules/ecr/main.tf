# modules/ecr/main.tf
resource "aws_ecr_repository" "backend" {
  name                 = "myapp-backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration { scan_on_push = true } # DevSecOps: Auto scan
}

resource "aws_ecr_repository" "frontend" {
  name                 = "myapp-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration { scan_on_push = true }
}