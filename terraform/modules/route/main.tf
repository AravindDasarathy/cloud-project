resource "google_compute_route" "route" {
  name             = var.name
  dest_range       = var.dest_range
  next_hop_gateway = var.next_hop
  network          = var.vpc_name
}