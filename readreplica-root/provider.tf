
## Use your provider 

terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.13"
  backend "gcs" {
    bucket      = "terraformtf"
    prefix      = "terraform/sql_vpc.tfstate/sql/readreplica"
    credentials = "cred.json"
  }
}

provider "google-beta" {
  project     = var.project_id
  credentials = file("cred.json")
}

provider "google" {
  project     = var.project_id
  credentials = file("cred.json")
}
