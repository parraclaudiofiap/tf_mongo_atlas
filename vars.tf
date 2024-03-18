variable "aws_region_default" {
  default = "us-east-1"
}
 
data "aws_secretsmanager_secret" "by_arn" {
  arn = "arn:aws:secretsmanager:us-east-1:341161836869:secret:mongodb_configuration-hR2FqN"
}
 
data "aws_secretsmanager_secret_version" "db_secrets" {
  secret_id = data.aws_secretsmanager_secret.by_arn.id
}
 
locals {
  db_secrets = jsondecode(data.aws_secretsmanager_secret_version.db_secrets.secret_string)
}