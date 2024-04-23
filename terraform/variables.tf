variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "infra_configs" {
  description = "Configuration for VPCs, subnets, and routes."
  default = {
    vpcs            = []
    subnets         = []
    routes          = []
    allow_firewalls = []
    deny_firewalls  = []
    # compute_instances = []
    regional_compute_instances = []
    health_checkers            = []
    instance_group_managers    = []
    auto_scalers               = []
    private_services           = []
    service_identities         = []
    crypto_iam_bindings        = []
    db_instances               = []
    dns_records                = []
    service_accounts           = []
    iam_bindings               = []
    pubsub_topics              = []
    vpc_connectors             = []
    functions                  = []
    addresses                  = []
    backend_services           = []
    url_maps                   = []
    target_http_proxies        = []
    forwarding_rules           = []
    ssl_certificates           = []
    cmek_keys                  = []
    buckets                    = []
  }
  type = object({
    vpcs = list(object({
      name                            = string
      auto_create_subnetworks         = bool
      routing_mode                    = string
      delete_default_routes_on_create = bool
    }))
    subnets = list(object({
      name          = string
      ip_cidr_range = string
      region        = string
      vpc_name      = string
      purpose       = string
      role          = string
    }))
    routes = list(object({
      name       = string
      dest_range = string
      next_hop   = string
      vpc_name   = string
    }))
    allow_firewalls = list(object({
      name     = string
      vpc_name = string
      allow_traffic_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
      source_ranges = list(string)
      priority      = number
      target_tags   = list(string)
    }))
    deny_firewalls = list(object({
      name          = string
      vpc_name      = string
      protocol      = string
      ports         = list(number)
      source_ranges = list(string)
      priority      = number
      target_tags   = list(string)
    }))
    # compute_instances = list(object({
    #   name                   = string
    #   machine_type           = string
    #   image_id               = string
    #   boot_disk_size         = number
    #   boot_disk_type         = string
    #   vpc_name               = string
    #   subnet_name            = string
    #   tags                   = list(string)
    #   service_account_scopes = list(string)
    #   project_id             = string
    #   pubsub_topic_name      = string
    # }))
    regional_compute_instances = list(object({
      name                   = string
      machine_type           = string
      image_id               = string
      boot_disk_size         = number
      boot_disk_type         = string
      vpc_name               = string
      subnet_name            = string
      tags                   = list(string)
      service_account_scopes = list(string)
      project_id             = string
      pubsub_topic_name      = string
      key_ring_name          = string
      vm_key_name            = string
    }))
    health_checkers = list(object({
      name                = string
      check_interval_sec  = number
      timeout_sec         = number
      healthy_threshold   = number
      unhealthy_threshold = number
      request_path        = string
      port_specification  = string
      port                = number
      # proxy_header        = string
    }))
    instance_group_managers = list(object({
      name                   = string
      base_name              = string
      target_size            = number
      port_name              = string
      port_number            = number
      initial_delay_sec      = number
      instance_template_name = string
      health_checker_name    = string
    }))
    auto_scalers = list(object({
      name                   = string
      target_cpu_utilization = number
      cooldown_period        = number
      min_replicas           = number
      max_replicas           = number
      instance_group_manager = string
    }))
    private_services = list(object({
      name          = string
      purpose       = string
      address_type  = string
      prefix_length = number
      network       = string
      service       = string
      vpc_name      = string
    }))
    service_identities = list(object({
      name    = string
      service = string
    }))
    crypto_iam_bindings = list(object({
      key_ring_name   = string
      crypto_key_name = string
      roles           = list(string)
      members         = list(string)
    }))
    db_instances = list(object({
      name                      = string
      region                    = string
      database_version          = string
      tier                      = string
      ipv4_enabled              = bool
      private_network           = string
      db_name                   = string
      db_username               = string
      regional_compute_instance = string
      key_ring_name             = string
      cloud_sql_key_name        = string
    }))
    dns_records = list(object({
      name         = string
      type         = string
      ttl          = number
      managed_zone = string
      # regional_compute_instance = string
      load_balancer_address = string
    }))
    service_accounts = list(object({
      account_id                   = string
      display_name                 = string
      project_id                   = string
      create_ignore_already_exists = bool
      regional_compute_instance    = string
    }))
    iam_bindings = list(object({
      project_id = string
      roles      = list(string)
      members    = list(string)
    }))
    pubsub_topics = list(object({
      name                       = string
      message_retention_duration = string
      project_id                 = string
    }))
    vpc_connectors = list(object({
      name          = string
      vpc_name      = string
      ip_cidr_range = string
      region        = string
      machine_type  = string
      min_instances = number
      max_instances = number
    }))
    functions = list(object({
      name                           = string
      location                       = string
      runtime                        = string
      entry_point                    = string
      source_bucket                  = string
      source_bucket_object           = string
      max_instance_count             = number
      min_instance_count             = number
      available_memory               = string
      timeout_seconds                = number
      ingress_settings               = string
      all_traffic_on_latest_revision = bool
      vpc_connector                  = string
      vpc_connector_egress_settings  = string
      trigger_region                 = string
      event_type                     = string
      pubsub_topic                   = string
      retry_policy                   = string
      regional_compute_instance      = string
      mailgun_api_key                = string
      mailgun_domain                 = string
      mailgun_from_email             = string
      webapp_domain                  = string
    }))
    addresses = list(object({
      name = string
      # tier = string
    }))
    backend_services = list(object({
      name                   = string
      load_balancing_scheme  = string
      health_checkers        = list(string)
      protocol               = string
      session_affinity       = string
      timeout_sec            = number
      instance_group_manager = string
      balancing_mode         = string
      capacity_scaler        = number
      max_utilization        = number
    }))
    url_maps = list(object({
      name            = string
      default_service = string
    }))
    target_http_proxies = list(object({
      name             = string
      url_map          = string
      ssl_certificates = list(string)
    }))
    forwarding_rules = list(object({
      name                  = string
      ip_protocol           = string
      load_balancing_scheme = string
      port_range            = string
      target_http_proxy     = string
      # vpc_name              = string
      address = string
      # network_tier          = string
    }))
    ssl_certificates = list(object({
      name    = string
      domains = list(string)
    }))
    cmek_keys = list(object({
      name               = string
      region             = string
      vm_key_name        = string
      cloud_sql_key_name = string
      bucket_key_name    = string
      rotation_period    = string
    }))
    buckets = list(object({
      bucket_name     = string
      region          = string
      force_destroy   = bool
      object_name     = string
      object_source   = string
      content_type    = string
      cmek_key_name   = string
      bucket_key_name = string
    }))
  })
}