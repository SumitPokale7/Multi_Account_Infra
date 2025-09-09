terraform {
  required_version = ">= 1.9.7, < 1.10.0"
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = merge(var.tags, { Name = "${var.name}-subnet-group" })
}

# Aurora Cluster Resources
resource "aws_rds_cluster" "this" {
  count                   = var.create_rds_cluster ? 1 : 0

  cluster_identifier      = var.name
  engine                  = var.engine
  engine_version          = var.engine_version
  master_username         = var.username
  master_password         = var.password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.vpc_security_group_ids
  skip_final_snapshot     = true
  backup_retention_period = 7

  tags = merge(var.tags, { Name = var.name })
}

resource "aws_rds_cluster_instance" "this" {
  count              = var.create_rds_cluster ? var.instance_count : 0

  identifier         = "${var.name}-instance-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.this[0].id
  instance_class     = var.instance_class
  engine             = var.engine
  engine_version     = var.engine_version

  tags = merge(var.tags, {
    Name = "${var.name}-instance-${count.index + 1}"
  })
}

# Standalone RDS Instance Resources
resource "aws_db_instance" "standalone" {
  count = var.create_standalone_instances ? var.instance_count : 0

  identifier             = "${var.name}-standalone-${count.index + 1}"
  allocated_storage      = 20
  storage_type          = "gp2"
  engine                = var.engine == "aurora-mysql" ? "mysql" : var.engine
  engine_version        = var.engine == "aurora-mysql" ? "8.0" : var.engine_version
  instance_class        = var.instance_class
  username              = var.username
  password              = var.password
  db_subnet_group_name  = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  skip_final_snapshot   = true
  backup_retention_period = 7

  tags = merge(var.tags, {
    Name = "${var.name}-standalone-${count.index + 1}"
  })
}
