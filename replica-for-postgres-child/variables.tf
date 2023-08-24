variable "project_id" {
  type        = string
  description = "Project ID of the GCP project"
}

variable "master_instance_name" {
  description = "will on root"

}

variable "region" {
  type        = string
  description = "Region of the GCP project"
  default = "us-central1"
}



variable "database_version" {
  description = "The database version to use"
  type        = string
}

variable "tier" {
  description = "The tier for the master instance."
  type        = string
}

variable "read_replica" {
  description = "List of read replicas to create"
  type = list(object({
    name            = string
    tier            = string
    zone            = string
    disk_type       = string
    disk_autoresize = bool
    boot_disk_size  = string
    user_labels     = map(string)
    database_flags = list(object({
      name  = string
      value = string
    }))
    ip_configuration = object({
      authorized_networks = list(map(string))
      ipv4_enabled        = bool
      private_network     = string
      require_ssl         = bool
    })
  }))
  default = [{
    name            = "repl"
    tier            = "db-custom-1-3840"
    zone            = "us-central1-c"
    disk_type       = "PD_SSD"
    disk_autoresize = true
    boot_disk_size  = "10"
    user_labels = {
      label_key = "label_value"
    }
    database_flags = [
      {
        name  = "autovacuum"
        value = "off"
      }
    ]
    ip_configuration = {
      authorized_networks = []
      ipv4_enabled        = true
      private_network     = null
      require_ssl         = true
    }
  }]
}


variable "read_replica_name_suffix" {
  description = "The optional suffix to add to the read instance name"
  type        = string
  default     = "-replica"
}


variable "ip_configuration" {
  description = "The ip configuration for the master instances."
  type = object({
    authorized_networks = list(map(string))
    ipv4_enabled        = bool
    private_network     = bool
    require_ssl         = bool
    allocated_ip_range  = string
  })
  default = {
    authorized_networks = []
    ipv4_enabled        = true
    private_network     = false
    require_ssl         = true
    allocated_ip_range  = null
  }
}


variable "user_labels" {
  description = "The key/value labels for the master instances."
  type = object({
    tla                       = string
    ci                        = string
    environment               = string
    portfolio_manager         = string
    new_cost_center           = string
    pending_deletion          = string
    resource_last_update_date = string
    opt_in_handler            = string
    opt_out_handler           = string
    resource_location         = string
    workload_type             = string
  })
  validation {
    condition     = length(var.user_labels) != 0
    error_message = "Must specify label values"
  }
  default = {
    tla                       = "sample_tla"
    ci                        = "sample_ci"
    environment               = "sample_environment"
    portfolio_manager         = "sample_manager"
    new_cost_center           = "sample_cost_center"
    pending_deletion          = "sample_pending"
    resource_last_update_date = "sample_update_date"
    opt_in_handler            = "sample_opt_in"
    opt_out_handler           = "sample_opt_out"
    resource_location         = "sample_location"
    workload_type             = "sample_workload"
  }
}


variable "zone" {
  type        = string
  description = "The zone for the master instance, it should be something like: \"us-central-a\", \"us-east-c\"."
}

variable "availability_type" {
  description = "The availability type for the master instance. This is only used to set up high availability for the PostgreSQL Instance."
  type        = string
  default     = "REGIONAL"
}


variable "create_timeout" {
  description = "The optional timeout that is applied to limit long database creates."
  type        = string
  default     = "30"
}

variable "database_flags" {
  description = "The database flags for the master instance. See more details [here](https://cloud.google.com/sql/docs/postgres/flags)"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "update_timeout" {
  description = "The optional timout that is applied to limit long database updates."
  type        = string
  default     = "20m"
}

variable "delete_timeout" {
  description = "The optional timeout that is applied to limit long database deletes."
  type        = string
  default     = "20"
}

variable "deletion_protection" {
  description = "Used to block Terraform from deleting a SQL Instance."
  type        = bool
  default     = false
}

variable "disk_autoresize" {
  description = "Configuration to increase storage size."
  type        = bool
  default     = true
}

variable "disk_size" {
  description = "The disk size for the master instance."
  default     = 10
}

variable "disk_type" {
  description = "The disk type for the master instance."
  type        = string
  default     = "PD SSD"
}

variable "encryption_key_name" {
  description = "The full path to the encryption key used for the CMEK disk encryption"
  type        = string
  default     = ""
}


variable "insights_config" {
  description = "The insights_config settings for the database."
  type = object({
    query_string_length     = number
    record_application_tags = bool
    record_client_address   = bool
  })
  default = {
    query_string_length     = 0
    record_application_tags = false
    record_client_address   = false
  }
}

variable "disk_autoresize_limit" {
  description = "The maximum size to which storage can be auto increased."
  type        = number
  default     = 0
}
