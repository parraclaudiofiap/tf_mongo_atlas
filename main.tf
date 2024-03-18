resource "mongodbatlas_project" "mongodb_project" {
  name   = "atlasProjectName"
  org_id = local.db_secrets.mongodb_atlas_org_id
}

resource "mongodbatlas_cluster" "mongodb_cluster" {
  project_id                   = mongodbatlas_project.mongodb_project.id
  name                         = "cluster_techchallenge"
  provider_name                = "TENANT"
  backing_provider_name        = "AWS"
  provider_region_name         = "US_EAST_1"
  provider_instance_size_name  = "M0"
  mongo_db_major_version       = "7.0"
  auto_scaling_disk_gb_enabled = "false"
}

resource "mongodbatlas_database_user" "mongodb_user" {
  username           = local.db_secrets.mongodb_atlas_database_username
  password           = local.db_secrets.mongodb_atlas_database_user_password
  project_id         = mongodbatlas_project.mongodb_project.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}

resource "mongodbatlas_project_ip_access_list" "mongodb_ip_list" {
  project_id = mongodbatlas_project.mongodb_project.id
  ip_address = local.db_secrets.mongodb_atlas_accesslistip
}

data "aws_secretsmanager_secret" "secret_cs" {
   arn = "arn:aws:secretsmanager:us-east-1:341161836869:secret:mongodb_connectionstring-ilunHM"
}

resource "aws_secretsmanager_secret_version" "secret_cs_current" {
  secret_id = data.aws_secretsmanager_secret.secret_cs.id
  secret_string = replace(mongodbatlas_cluster.mongodb_cluster.connection_strings[0].standard_srv, "/([\\w+]*).{3}(.*)/", "$1://${mongodbatlas_database_user.mongodb_user.username}:${mongodbatlas_database_user.mongodb_user.password}@$2")
}
