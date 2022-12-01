
resource "aws_neptune_cluster" "grumlin" {
  cluster_identifier                   = "grumlin"
  engine                               = "neptune"
  engine_version                       = "1.2.0.2"
  neptune_cluster_parameter_group_name = "default.neptune1.2"
  skip_final_snapshot                  = true

  vpc_security_group_ids    = [aws_security_group.grumlin.id]
  neptune_subnet_group_name = aws_neptune_subnet_group.grumlin.name

  serverless_v2_scaling_configuration {}
}

resource "aws_neptune_cluster_instance" "grumlin" {
  cluster_identifier = aws_neptune_cluster.grumlin.cluster_identifier
  instance_class     = "db.serverless"

  neptune_parameter_group_name = "default.neptune1.2"

  neptune_subnet_group_name = aws_neptune_subnet_group.grumlin.name
}
