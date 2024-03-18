 terraform {
  backend "s3" {
    bucket = "fiapterraform"
    key    = "mongodb/terraform.tfstate"
    region = var.aws_default_region
  }
}

terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
  }
 }

provider "mongodbatlas" {
  public_key  = local.db_creds.mongodb_atlas_api_pub_key
  private_key = local.db_creds.mongodb_atlas_api_pri_key
}

provider "aws" {
  region = var.aws_default_region
}
