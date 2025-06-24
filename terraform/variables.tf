variable "aws_region" {
  default = "us-east-1"
}

variable "backend_image_uri" {
  type = string
  description = "ECR URI for backend"
}

variable "frontend_image_uri" {
  type        = string
  description = "ECR URI for frontend"
}
