output "ec2_ip" {
  value = aws_instance.grumlin.public_ip
}

output "neptune_endpoint" {
  value = aws_neptune_cluster.grumlin.endpoint
}
