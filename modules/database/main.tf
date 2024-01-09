# RDS Mysql database subnet group
resource "aws_db_subnet_group" "db_private_subnet_group" {
  name       = "db_private_subnet_group"
  subnet_ids = [var.db_private_subnet_group_1, var.db_private_subnet_group_2]

  tags = {
    Name = "db_private_subnet_group"
  }
}

# Create RDS Mysql database
resource "aws_db_instance" "mysql_db" {
  db_name              = var.database_name
  parameter_group_name = var.database_parameter_group_name
  option_group_name = var.database_option_group_name
  engine                 = var.database_engine
  engine_version         = var.database_engine_version
  instance_class         = var.database_instance_class
  multi_az               = var.database_multi_az
  identifier             = var.database_identifier
  username               = var.database_username
  password               = var.database_password
  storage_type           = var.database_storage_type
  allocated_storage      = var.database_allocated_storage
  vpc_security_group_ids = [var.database_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.db_private_subnet_group.name
  skip_final_snapshot    = true

  depends_on = [ aws_db_subnet_group.db_private_subnet_group ]
}
