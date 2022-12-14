output "region_1" {
  description = "Name of the first region"
  value       = data.aws_region.region_1.name
}

output "region_2" {
  description = "Name of the second region"
  value       = data.aws_region.region_2.name
}
output "instance_region_1_az" {
  value       = aws_instance.region_1.availability_zone
  description = "The AZ where the instance in the first regiondeployed"
}
output "instance_region_2_az" {
  value       = aws_instance.region_2.availability_zone
  description = "The AZ where the instance in the second regiondeployed"
}