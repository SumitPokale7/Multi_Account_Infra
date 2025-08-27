resource "aws_db_subnet_group" "this" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.db_subnet_ids
  tags       = merge(var.tags, { Name = "${var.cluster_identifier}-subnet-group" })
}

resource "aws_rds_cluster" "this" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = var.master_password

  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  backup_retention_period = var.backup_retention_period
  tags                    = merge(var.tags, { Name = var.cluster_identifier })
}

resource "aws_rds_cluster_instance" "this" {
  count              = var.instance_count
  identifier         = "${var.cluster_identifier}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = var.engine
  engine_version     = var.engine_version
  tags               = merge(var.tags, { Name = "${var.cluster_identifier}-instance-${count.index}" })
}
