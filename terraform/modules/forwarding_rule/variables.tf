variable "name" {
  description = "Name of the forwarding rule"
  type        = string
}

variable "ip_protocol" {
  description = "The IP protocol to use for this forwarding rule. The valid values are TCP, UDP, ESP, AH, SCTP or ICMP."
  type        = string
}

variable "load_balancing_scheme" {
  description = "This signifies what the Forwarding Rule will be used for. The value of INTERNAL is used for Internal TCP/UDP Load Balancing."
  type        = string
}

variable "port_range" {
  description = "The range of ports that the forwarding rule should match."
  type        = string
}

variable "target_http_proxy" {
  description = "The URL of the target HTTP proxy to receive the matched traffic."
  type        = string
}

# variable "vpc_name" {
#   description = "The VPC network to which this forwarding rule is attached."
#   type        = string
# }

variable "address" {
  description = "The external IP address that this forwarding rule will serve."
  type        = string
}

# variable "network_tier" {
#   description = "This signifies the networking tier used for configuring this load balancer."
#   type        = string
# }