# Create Systems Manager - Parameter Store for RDS MySQL DB password
resource "aws_ssm_parameter" "mysql_db_password" {
  name        = "mysql_psw"
  description = "AWS RDS mysql database password"
  tier        = "Standard"
  data_type   = "text"
  type        = "SecureString"
  value       = var.mysql_db_pwd
}

# Create Systems Manager - Parameter Store for AWS Secret Key
resource "aws_ssm_parameter" "my_aws_secret_key" {
  name        = "my_secret_key"
  description = "aws secret key"
  tier        = "Standard"
  data_type   = "text"
  type        = "SecureString"
  value       = var.aws_secret_key
}
