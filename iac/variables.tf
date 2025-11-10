variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "AWS key pair name for SSH access"
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
  default     = "f3a-pattern-aerobatics-rc.club"
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
  default     = "Z00071653MWP8XE0V1MUU"
}

variable "create_dns_record" {
  description = "Whether to create DNS record for microservice subdomain (micro.domain.com)"
  type        = bool
  default     = false
}

variable "create_api_dns_record" {
  description = "Whether to create DNS record for API subdomain (api.domain.com)"
  type        = bool
  default     = false
}
