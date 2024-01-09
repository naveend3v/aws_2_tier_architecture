# Create the Networking module for VPC and Subnets
module "networking" {
  source                = "./modules/networking"
  my_vpc_cidr           = "10.0.0.0/16"
  vpc_tag               = "my_vpc"
  az_1                  = "us-east-1a"
  az_2                  = "us-east-1b"
  public_subnet_1_cidr  = "10.0.1.0/24"
  public_subnet_2_cidr  = "10.0.2.0/24"
  private_subnet_1_cidr = "10.0.3.0/24"
  private_subnet_2_cidr = "10.0.4.0/24"
  ec2_security_group_id = module.networking.ec2_sg_id
}

# Create the IAM module for EC2 instance profile
module "iam_role" {
  source = "./modules/iam_role"
}

# Create the SSM parameter store to store database password
module "ssm_parameter_store" {
  source         = "./modules/ssm_parameter_store"
  mysql_db_pwd   = var.mysql_db_password
  aws_secret_key = var.secret_key
}

# Create the Databse module for RDS Mysql database
module "database" {
  source                        = "./modules/database"
  db_private_subnet_group_1     = module.networking.private_subnet_1
  db_private_subnet_group_2     = module.networking.private_subnet_2
  database_name                 = "test"
  database_parameter_group_name = "default.mysql8.0"
  database_option_group_name    = "default:mysql-8-0"
  database_engine               = "mysql"
  database_engine_version       = "8.0.35"
  database_instance_class       = "db.t2.micro"
  database_multi_az             = true
  database_identifier           = "test"
  database_username             = "admin"
  database_storage_type         = "gp2"
  database_allocated_storage    = 10
  database_password             = module.ssm_parameter_store.db_password
  database_security_group_id    = module.networking.rds_ec2_sg_id
}

# Create the EC2 Auto Scaling module for Ec2 instance using launch template
module "ec2_auto_scaling" {
  source               = "./modules/ec2_auto_scaling"
  ec2_instance_profile = module.iam_role.ec2_instance_profile_name
  ec2_security_group   = module.networking.ec2_sg_id
  ec2_instance_ami     = "ami-0c7217cdde317cfec"
  ec2_instance_type    = "t2.micro"
  asg_name             = "my_asg"
  asg_subnet_1         = module.networking.public_subnet_1
  asg_subnet_2         = module.networking.public_subnet_2
  alb_target_group_arn = module.load_balancer.alb_tg_arn
  asg_min_size         = 2
  asg_max_size         = 4
  asg_desired_capacity = 2                 # desired capacity should not be less than ASG minimum size
  depends_on           = [module.database] # Create AWS RDS MySQL DB instance before python MySQL application deploying in Ec2 instance
}

# Create the Load balancer module for Application load balancer
module "load_balancer" {
  source                = "./modules/load_balancer"
  alb_subnet_1          = module.networking.public_subnet_1
  alb_subnet_2          = module.networking.public_subnet_2
  alb_name              = "myALB"
  alb_target_group_name = "myALBTargetGroup"
  alb_vpc_id            = module.networking.vpc_id
}

