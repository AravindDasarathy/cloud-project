provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "vpc" {
  source   = "./modules/vpc"
  for_each = { for vpc in var.infra_configs.vpcs : vpc.name => vpc }

  name                            = each.value.name
  auto_create_subnetworks         = each.value.auto_create_subnetworks
  routing_mode                    = each.value.routing_mode
  delete_default_routes_on_create = each.value.delete_default_routes_on_create
}


module "subnet" {
  source   = "./modules/subnet"
  for_each = { for subnet in var.infra_configs.subnets : subnet.name => subnet }

  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  vpc_name      = each.value.vpc_name
  purpose       = each.value.purpose == "" ? null : each.value.purpose
  role          = each.value.role == "" ? null : each.value.role

  depends_on = [module.vpc]
}

module "route" {
  source   = "./modules/route"
  for_each = { for route in var.infra_configs.routes : route.name => route }

  name       = each.value.name
  dest_range = each.value.dest_range
  next_hop   = each.value.next_hop
  vpc_name   = each.value.vpc_name

  depends_on = [module.vpc, module.subnet]
}

module "firewall_allow" {
  source   = "./modules/firewall/allow"
  for_each = { for firewall in var.infra_configs.allow_firewalls : firewall.name => firewall }

  name                = each.value.name
  vpc_name            = each.value.vpc_name
  allow_traffic_rules = each.value.allow_traffic_rules
  source_ranges       = each.value.source_ranges
  priority            = each.value.priority
  target_tags         = each.value.target_tags

  depends_on = [module.vpc, module.subnet, module.route]
}

module "firewall_deny" {
  source   = "./modules/firewall/deny"
  for_each = { for firewall in var.infra_configs.deny_firewalls : firewall.name => firewall }

  name          = each.value.name
  vpc_name      = each.value.vpc_name
  protocol      = each.value.protocol
  ports         = each.value.ports
  source_ranges = each.value.source_ranges
  priority      = each.value.priority
  target_tags   = each.value.target_tags

  depends_on = [module.vpc, module.subnet, module.route]
}

locals {
  db_credentials = { for db in var.infra_configs.db_instances : db.regional_compute_instance => {
    db_host     = module.db[db.name].db_host
    db_name     = module.db[db.name].db_name
    db_username = module.db[db.name].db_username
    db_password = module.db[db.name].db_password
  } }

  service_account_emails = { for sa in var.infra_configs.service_accounts : sa.regional_compute_instance => module.service_account[sa.account_id].email }

  health_check_ids = { for hc in var.infra_configs.health_checkers : hc.name => module.health_check[hc.name].id }

  ssl_cert_names = { for ssl_cert in var.infra_configs.ssl_certificates : ssl_cert.name => module.ssl_certificate[ssl_cert.name].name }

  cmek_keys = { for cmek in var.infra_configs.cmek_keys : cmek.name => {
    (cmek.vm_key_name)        = module.cmek[cmek.name].vm_key_id
    (cmek.cloud_sql_key_name) = module.cmek[cmek.name].cloud_sql_key_id
    (cmek.bucket_key_name)    = module.cmek[cmek.name].bucket_key_id
  } }
}

# module "gce" {
#   source   = "./modules/gce"
#   for_each = { for instance in var.infra_configs.compute_instances : instance.name => instance }

#   name                   = each.value.name
#   machine_type           = each.value.machine_type
#   image_id               = each.value.image_id
#   boot_disk_size         = each.value.boot_disk_size
#   boot_disk_type         = each.value.boot_disk_type
#   vpc_name               = each.value.vpc_name
#   subnet_name            = each.value.subnet_name
#   tags                   = each.value.tags
#   db_host                = local.db_credentials[each.value.name].db_host
#   db_name                = local.db_credentials[each.value.name].db_name
#   db_username            = local.db_credentials[each.value.name].db_username
#   db_password            = local.db_credentials[each.value.name].db_password
#   service_account_email  = local.service_account_emails[each.value.name]
#   service_account_scopes = each.value.service_account_scopes
#   project_id             = each.value.project_id
#   pubsub_topic_name      = each.value.pubsub_topic_name

#   # added google_function dependency as creating google_function resource creates a subscriber for the pubsub topic
#   # it is good to have subscriber available before gce instance is created
#   depends_on = [module.vpc, module.subnet, module.route, module.firewall_allow, module.firewall_deny, module.iam_binding, module.function]
# }

module "regional_compute_instances" {
  source   = "./modules/gce/regional"
  for_each = { for instance in var.infra_configs.regional_compute_instances : instance.name => instance }

  name                   = each.value.name
  machine_type           = each.value.machine_type
  image_id               = each.value.image_id
  boot_disk_size         = each.value.boot_disk_size
  boot_disk_type         = each.value.boot_disk_type
  vpc_name               = each.value.vpc_name
  subnet_name            = each.value.subnet_name
  db_host                = local.db_credentials[each.value.name].db_host
  db_name                = local.db_credentials[each.value.name].db_name
  db_username            = local.db_credentials[each.value.name].db_username
  db_password            = local.db_credentials[each.value.name].db_password
  project_id             = each.value.project_id
  pubsub_topic_name      = each.value.pubsub_topic_name
  service_account_email  = local.service_account_emails[each.value.name]
  service_account_scopes = each.value.service_account_scopes
  tags                   = each.value.tags
  kms_key                = local.cmek_keys[each.value.key_ring_name][each.value.vm_key_name]

  # added google_function dependency as creating google_function resource creates a subscriber for the pubsub topic
  # it is good to have subscriber available before gce instance is created

  depends_on = [module.vpc, module.subnet, module.route, module.firewall_allow, module.firewall_deny, module.iam_binding, module.function, module.cmek]
}

module "health_check" {
  source   = "./modules/health_check"
  for_each = { for hc in var.infra_configs.health_checkers : hc.name => hc }

  name                = each.value.name
  check_interval_sec  = each.value.check_interval_sec
  timeout_sec         = each.value.timeout_sec
  healthy_threshold   = each.value.healthy_threshold
  unhealthy_threshold = each.value.unhealthy_threshold
  request_path        = each.value.request_path
  port_specification  = each.value.port_specification
  port                = each.value.port
  # proxy_header        = each.value.proxy_header
}

module "instance_group_manager" {
  source   = "./modules/gce/regional/instance_group_manager"
  for_each = { for igm in var.infra_configs.instance_group_managers : igm.name => igm }

  name              = each.value.name
  base_name         = each.value.base_name
  target_size       = each.value.target_size
  port_name         = each.value.port_name
  port_number       = each.value.port_number
  instance_template = module.regional_compute_instances[each.value.instance_template_name].id
  health_check      = module.health_check[each.value.health_checker_name].id
  initial_delay_sec = each.value.initial_delay_sec

  depends_on = [module.regional_compute_instances, module.health_check]
}

module "auto_scaler" {
  source   = "./modules/auto_scaler"
  for_each = { for as in var.infra_configs.auto_scalers : as.name => as }

  name                   = each.value.name
  target_instance_group  = module.instance_group_manager[each.value.instance_group_manager].id
  min_replicas           = each.value.min_replicas
  max_replicas           = each.value.max_replicas
  cooldown_period        = each.value.cooldown_period
  target_cpu_utilization = each.value.target_cpu_utilization

  depends_on = [module.instance_group_manager]
}

module "dns_record" {
  source       = "./modules/dns_record"
  for_each     = { for record in var.infra_configs.dns_records : record.name => record }
  name         = each.value.name
  type         = each.value.type
  ttl          = each.value.ttl
  managed_zone = each.value.managed_zone
  rrdatas      = [module.compute_address[each.value.load_balancer_address].ip]
  # rrdatas      = [module.address[each.value.regional_compute_instance].address]

  depends_on = [module.compute_address, module.forwarding_rule, module.url_map, module.backend_service, module.target_http_proxy]
}

module "service_account" {
  source                       = "./modules/service_account"
  for_each                     = { for sa in var.infra_configs.service_accounts : sa.account_id => sa }
  account_id                   = each.key
  display_name                 = each.value.display_name
  project_id                   = each.value.project_id
  create_ignore_already_exists = each.value.create_ignore_already_exists
}

module "iam_binding" {
  source     = "./modules/iam_binding"
  for_each   = { for iam in var.infra_configs.iam_bindings : iam.members[0] => iam }
  project_id = each.value.project_id
  roles      = each.value.roles
  members = [for member in each.value.members :
    length(regexall("@", member)) > 0 ?
  member : "serviceAccount:${module.service_account[member].email}"]
  depends_on = [module.service_account]
}

module "private_service" {
  source   = "./modules/private_service"
  for_each = { for service in var.infra_configs.private_services : service.name => service }
  providers = {
    google-beta = google-beta
  }

  project       = var.project
  region        = var.region
  name          = each.value.name
  purpose       = each.value.purpose
  address_type  = each.value.address_type
  prefix_length = each.value.prefix_length
  network       = module.vpc[each.value.vpc_name].id
  service       = each.value.service

  depends_on = [module.vpc]
}

module "service_identity" {
  source   = "./modules/service_identity"
  for_each = { for si in var.infra_configs.service_identities : si.name => si }

  providers = {
    google-beta = google-beta
  }

  service = each.value.service

  depends_on = [module.iam_binding]
}

data "google_storage_project_service_account" "gcs_account" {
}
module "crypto_iam_binding" {
  source   = "./modules/cmek/iam_binding"
  for_each = { for iam in var.infra_configs.crypto_iam_bindings : iam.members[0] => iam }

  providers = {
    google-beta = google-beta
  }

  crypto_key_id = local.cmek_keys[each.value.key_ring_name][each.value.crypto_key_name]
  roles         = each.value.roles
  members = [for member in each.value.members : member == "webapp-bucket"
    ? "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
  : "serviceAccount:${module.service_identity[member].email}"]

  depends_on = [module.service_identity, module.cmek]
}

module "db" {
  source   = "./modules/db"
  for_each = { for db in var.infra_configs.db_instances : db.name => db }
  providers = {
    google-beta = google-beta
  }

  name                           = each.value.name
  region                         = each.value.region
  database_version               = each.value.database_version
  tier                           = each.value.tier
  ipv4_enabled                   = each.value.ipv4_enabled
  private_network                = each.value.private_network
  db_name                        = each.value.db_name
  db_username                    = each.value.db_username
  regional_compute_instance_name = each.value.regional_compute_instance
  encryption_key                 = local.cmek_keys[each.value.key_ring_name][each.value.cloud_sql_key_name]

  depends_on = [module.private_service, module.iam_binding, module.crypto_iam_binding]
}

module "pubsub_topic" {
  source   = "./modules/pubsub/topic"
  for_each = { for topic in var.infra_configs.pubsub_topics : topic.name => topic }

  name                       = each.value.name
  message_retention_duration = each.value.message_retention_duration
  project                    = each.value.project_id
}

module "vpc_connector" {
  source   = "./modules/vpc_connector"
  for_each = { for connector in var.infra_configs.vpc_connectors : connector.name => connector }

  name          = each.value.name
  vpc_name      = each.value.vpc_name
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  machine_type  = each.value.machine_type
  min_instances = each.value.min_instances
  max_instances = each.value.max_instances

  depends_on = [module.vpc]
}

module "function" {
  source   = "./modules/function"
  for_each = { for func in var.infra_configs.functions : func.name => func }

  name        = each.value.name
  location    = each.value.location
  runtime     = each.value.runtime
  entry_point = each.value.entry_point
  environment_variables = {
    MAILGUN_API_KEY    = each.value.mailgun_api_key
    MAILGUN_DOMAIN     = each.value.mailgun_domain
    POSTGRES_HOST      = local.db_credentials[each.value.regional_compute_instance].db_host
    POSTGRES_DB_NAME   = local.db_credentials[each.value.regional_compute_instance].db_name
    POSTGRES_USER      = local.db_credentials[each.value.regional_compute_instance].db_username
    POSTGRES_PASSWORD  = local.db_credentials[each.value.regional_compute_instance].db_password
    MAILGUN_FROM_EMAIL = each.value.mailgun_from_email
    WEBAPP_DOMAIN      = each.value.webapp_domain
  }
  source_bucket                  = each.value.source_bucket
  source_bucket_object           = each.value.source_bucket_object
  max_instance_count             = each.value.max_instance_count
  min_instance_count             = each.value.min_instance_count
  available_memory               = each.value.available_memory
  timeout_seconds                = each.value.timeout_seconds
  ingress_settings               = each.value.ingress_settings
  all_traffic_on_latest_revision = each.value.all_traffic_on_latest_revision
  vpc_connector                  = each.value.vpc_connector
  vpc_connector_egress_settings  = each.value.vpc_connector_egress_settings
  trigger_region                 = each.value.trigger_region
  event_type                     = each.value.event_type
  pubsub_topic                   = module.pubsub_topic[each.value.pubsub_topic].topic_id
  retry_policy                   = each.value.retry_policy

  depends_on = [module.vpc_connector, module.pubsub_topic, module.bucket]
}

module "compute_address" {
  source   = "./modules/address"
  for_each = { for address in var.infra_configs.addresses : address.name => address }

  name = each.value.name
  # tier = each.value.tier
}

module "backend_service" {
  source   = "./modules/backend_service"
  for_each = { for backend_service in var.infra_configs.backend_services : backend_service.name => backend_service }

  name                  = each.value.name
  load_balancing_scheme = each.value.load_balancing_scheme
  health_checkers       = [for hc in each.value.health_checkers : local.health_check_ids[hc]]
  protocol              = each.value.protocol
  session_affinity      = each.value.session_affinity
  timeout_sec           = each.value.timeout_sec
  instance_group        = module.instance_group_manager[each.value.instance_group_manager].instance_group
  balancing_mode        = each.value.balancing_mode
  capacity_scaler       = each.value.capacity_scaler
  max_utilization       = each.value.max_utilization

  depends_on = [module.instance_group_manager, module.health_check]
}

module "url_map" {
  source   = "./modules/url_map"
  for_each = { for url_map in var.infra_configs.url_maps : url_map.name => url_map }

  name            = each.value.name
  default_service = module.backend_service[each.value.default_service].id

  depends_on = [module.backend_service]
}

module "target_http_proxy" {
  source   = "./modules/target_http_proxy"
  for_each = { for target_http_proxy in var.infra_configs.target_http_proxies : target_http_proxy.name => target_http_proxy }

  providers = {
    google-beta = google-beta
  }

  name                  = each.value.name
  url_map               = module.url_map[each.value.url_map].id
  ssl_certificate_names = [for ssl_cert in each.value.ssl_certificates : local.ssl_cert_names[ssl_cert]]

  depends_on = [module.url_map, module.ssl_certificate]
}

module "forwarding_rule" {
  source   = "./modules/forwarding_rule"
  for_each = { for forwarding_rule in var.infra_configs.forwarding_rules : forwarding_rule.name => forwarding_rule }

  name                  = each.value.name
  ip_protocol           = each.value.ip_protocol
  load_balancing_scheme = each.value.load_balancing_scheme
  port_range            = each.value.port_range
  target_http_proxy     = module.target_http_proxy[each.value.target_http_proxy].id
  # vpc_name              = each.value.vpc_name
  address = module.compute_address[each.value.address].id
  # network_tier          = each.value.network_tier

  depends_on = [module.subnet]
}

module "ssl_certificate" {
  source   = "./modules/ssl_certificate"
  for_each = { for ssl_certificate in var.infra_configs.ssl_certificates : ssl_certificate.name => ssl_certificate }

  providers = {
    google-beta = google-beta
  }

  name    = each.value.name
  domains = each.value.domains
}

module "cmek" {
  source   = "./modules/cmek"
  for_each = { for cmek in var.infra_configs.cmek_keys : cmek.name => cmek }

  name               = each.value.name
  region             = each.value.region
  vm_key_name        = each.value.vm_key_name
  cloud_sql_key_name = each.value.cloud_sql_key_name
  bucket_key_name    = each.value.bucket_key_name
  rotation_period    = each.value.rotation_period
}

module "bucket" {
  source   = "./modules/bucket"
  for_each = { for bucket in var.infra_configs.buckets : bucket.bucket_name => bucket }

  bucket_name    = each.value.bucket_name
  region         = each.value.region
  force_destroy  = each.value.force_destroy
  object_name    = each.value.object_name
  object_source  = each.value.object_source
  content_type   = each.value.content_type
  encryption_key = local.cmek_keys[each.value.cmek_key_name][each.value.bucket_key_name]

  depends_on = [module.crypto_iam_binding]
}