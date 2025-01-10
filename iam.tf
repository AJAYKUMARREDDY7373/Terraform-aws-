terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  access_key = "var.access_key"
  secret_key = "var.secret_key"
  region     = "us-east-1"
}
resource "aws_s3_bucket" "example" {
  bucket = "recall-terraform-bucket"
   
}


# Create IAM user
resource "aws_iam_user" "s3_user" {
  name = "s3_user"
}

# Attach an inline policy to the IAM user
resource "aws_iam_user_policy" "s3_access_policy" {
  name   = "S3AccessPolicy"
  user   = aws_iam_user.s3_user.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::recall-terraform-bucket",
          "arn:aws:s3:::recall-terraform-bucket/*"
        ]
      }
    ]
  })
}

# Output the IAM user details
output "iam_user_name" {
  value = aws_iam_user.s3_user.name
}
