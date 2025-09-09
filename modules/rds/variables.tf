variable "create_rds_cluster" {
  description = "Whether to create RDS cluster"
  type        = bool
  default     = true
}

variable "create_standalone_instances" {
  description = "Whether to create standalone RDS instances"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name for the RDS cluster and related resources"
  type        = string
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "aurora-mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "5.7.mysql_aurora.2.11.0"
}

variable "username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "instance_count" {
  description = "Number of instances in the cluster"
  type        = number
  default     = 1
}

variable "instance_class" {
  description = "Instance class for RDS instances"
  type        = string
  default     = "db.t3.small"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
