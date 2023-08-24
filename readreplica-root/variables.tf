/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  type        = string
  description = "The project to run tests against"
  default     = "propane-dogfish-395916"
}

variable "zone" {
  type        = string
  description = "The zone for the master instance, it should be something like: \"us-central-a\", \"us-east-c\"."
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
