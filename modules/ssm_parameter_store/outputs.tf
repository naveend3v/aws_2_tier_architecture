output "db_password" {
  description = "MySQL Database Password"
  value = aws_ssm_parameter.mysql_db_password.value
}