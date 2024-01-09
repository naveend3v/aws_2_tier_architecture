# Create IAM Role to access RDS and SSM parameter store
resource "aws_iam_role" "ec2_role" {
  name = "ec2_rds_ssm_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ec2_rds_ssm_role"
  }
}

# IAM Role RDS policy attachment
resource "aws_iam_role_policy_attachment" "rds_policy" {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

# IAM Role SSM policy attachment
resource "aws_iam_role_policy_attachment" "ssm_policy" {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.ec2_role.name
}