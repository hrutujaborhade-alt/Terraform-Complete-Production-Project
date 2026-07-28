output "aws_iam_role" {
  value = aws_iam_role.ec2_role
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}