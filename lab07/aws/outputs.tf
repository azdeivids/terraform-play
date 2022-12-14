output "region_1" {
  description = "Name of the first region"
  value = data.aws_region.region_1.name
}

output "region_2" {
  description = "Name of the second region"
  value = data.aws_region.region_2.name
}