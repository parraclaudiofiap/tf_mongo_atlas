 terraform {
  backend "s3" {
    bucket = "fiapterraform"
    key    = "mongodb/terraform.tfstate"
    region = "us-east-1"
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
  public_key  = local.db_secrets.mongodb_atlas_api_pub_key
  private_key = local.db_secrets.mongodb_atlas_api_pri_key
}

provider "aws" {
  region = "us-east-1"
}
