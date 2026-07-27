variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_rate_limit" {
  description = "Enable WAF rate limiting"
  type        = bool
  default     = true
}

variable "rate_limit" {
  description = "Requests allowed from a single IP in a 5 minute period"
  type        = number
  default     = 2000
}

variable "ip_allow_list" {
  description = "List of IPv4 CIDRs that should always be allowed"
  type        = list(string)
  default     = []
}

variable "ip_block_list" {
  description = "List of IPv4 CIDRs that should always be blocked"
  type        = list(string)
  default     = []
}
