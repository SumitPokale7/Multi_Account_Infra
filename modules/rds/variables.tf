variable "cluster_identifier" {
  description = "Identifier for the RDS cluster"
  type        = string
}

variable "engine" {
  description = "Database engine (e.g. aurora-mysql, aurora-postgresql)"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "database_name" {
  description = "Initial database name"
  type        = string
}

variable "master_username" {
  description = "Master username for the DB cluster"
  type        = string
}

variable "master_password" {
  description = "Master password for the DB cluster"
  type        = string
  sensitive   = true
}

variable "db_subnet_ids" {
  description = "List of DB subnet IDs for the subnet group"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the cluster"
  type        = list(string)
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "instance_count" {
  description = "Number of cluster instances to create"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "Instance class for each cluster instance (e.g. db.r6g.large)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}
