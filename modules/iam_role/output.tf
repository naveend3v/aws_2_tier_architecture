output "ec2_instance_profile_name" {
  description = "aws"
  value = aws_iam_instance_profile.instance_profile.name
}
output "ec2_instance_profile_arn" {
  description = "aws"
  value = aws_iam_instance_profile.instance_profile.arn
}