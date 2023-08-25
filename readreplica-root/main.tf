#  If you are using a different repository for 'rr', 
#  you can comment it out data terraform_remote_state and replace  with from your 
#  master instance's state file, such as the bucket name and prefix.

# If you are using the same module as your master instance, 
# there's no need to comment it out. Simply configure the master instance name.

# Use your tfvars

# data "terraform_remote_state" "read_replica" {
#   backend   = "gcs"
#   workspace = terraform.workspace
#   config = {
#     bucket      = "terraformtf"
#     prefix      = "terraform/sql_vpc.tfstate/sql/"
#     credentials = "cred.json"
#   }
# }


## example 
module "cloudsql_mssql_replicas_test" {
  source = "../../child-module/replica-for-postgres"
  project_id               = var.project_id
  name                     = "assql-enterprise"
  zone                     = var.zone
  tier                     = var.tier
  master_instance_name     = module.<master_module_name>.name
  # master_instance_name     = data.terraform_remote_state.read_replica.outputs.name
  database_version         = var.database_version
  read_replicas            = var.read_replica
  read_replica_name_suffix = var.read_replica_name_suffix
}
