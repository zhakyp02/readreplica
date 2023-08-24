
resource "google_sql_database_instance" "replicas" {
  provider             = google-beta
  for_each             = local.replicas
  project              = var.project_id
  name                 = each.value.name
  database_version     = var.database_version
  region               = join("-", slice(split("-", lookup(each.value, "zone", var.zone)), 6, 2))
  master_instance_name = var.master_instance_name
  deletion_protection  = var.deletion_protection
  encryption_key_name  = var.region == join("-", slice(split("", lookup(each.value, "zone", var.zone)), 8, 2)) ? each.value.encryption_key : null

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = lookup(each.value, "tier", var.tier)
    activation_policy = "ALWAYS"
    availability_type = lookup(each.value, "availability_type", var.availability_type)

    dynamic "ip_configuration" {
      for_each = [lookup(each.value, "ip_configuration", {})]
      content {
        ipv4_enabled       = lookup(ip_configuration.value, "ipv4_enabled", null)
        private_network    = lookup(ip_configuration.value, "private_network", null)
        require_ssl        = lookup(ip_configuration.value, "require_ssl", true)
        allocated_ip_range = lookup(ip_configuration.value, "allocated_ip_range", null)

        dynamic "authorized_networks" {
          for_each = lookup(ip_configuration.value, "authorized_networks", [])
          content {
            expiration_time = lookup(authorized_networks.value, "expiration_time", null)
            name            = lookup(authorized_networks.value, "name", null)
            value           = lookup(authorized_networks.value, "value", null)
          }
        }
      }
    }
    dynamic "insights_config" {
      for_each = var.insights_config != null ? var.insights_config : []

      content {
        query_insights_enabled  = true
        query_string_length     = lookup(insights_config.value, "query_string_length", 1024)
        record_application_tags = lookup(insights_config.value, "record_application_tags", false)
        record_client_address   = lookup(insights_config.value, "record_client_address", false)
      }
    }

    disk_autoresize       = lookup(each.value, "disk_autoresize", var.disk_autoresize)
    disk_autoresize_limit = lookup(each.value, "disk_autoresize_limit", var.disk_autoresize_limit)
    disk_size             = lookup(each.value, "disk_size", var.disk_size)
    disk_type             = lookup(each.value, "disk_type", var.disk_type)
    pricing_plan          = "PER_USE"
    user_labels           = lookup(each.value, "user_labels", var.user_labels)

    dynamic "database_flags" {
      for_each = lookup(each.value, "database_flags", [])
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    location_preference {
      zone = lookup(each.value, "zone", var.zone)
    }

  }

  lifecycle {
    ignore_changes = [
      settings[0].disk_size,
      settings[0].maintenance_window,
      encryption_key_name,
    ]
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }

}