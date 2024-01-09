variable "db_private_subnet_group_1" {
  description = "mysql rds private subnet group"
}

variable "db_private_subnet_group_2" {
  description = "mysql rds private subnet group"
}

variable "database_name" {
  description = "mysql database name"
}

variable "database_engine" {
  description = "mysql database engine name"
}

variable "database_engine_version" {
  description = "mysql database engine version"
}

variable "database_instance_class" {
  description = "mysql instance class"
}

variable "database_username" {
  description = "mysql database username"
}

variable "database_password" {
  description = "mysql database password"
}

variable "database_parameter_group_name" {
  description = "mysql database parameter group name"
}

variable "database_allocated_storage" {
  description = "mysql database storage unit size"
}

variable "database_identifier" {
  description = "mysql database identifier"
}

variable "database_storage_type" {
  description = "mysql database storage type"
}

variable "database_security_group_id" {
  description = "mysql database seurity group id"
  type = string
}

variable "database_multi_az" {
  description = "mysql database multi-az configuration"
}

variable "database_option_group_name" {
  description = "mysql database optional group name"
}
