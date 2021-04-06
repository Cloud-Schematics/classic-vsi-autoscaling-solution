variable "iaas_classic_username" {
  description = "Classic IaaS username."
  type        = string
  default     = ""
}

variable "iaas_classic_api_key" {
  description = "Classic IaaS API Key."
  type        = string
  default     = ""
}

variable "ssh_key" {
  description = "SSH key to add to instance."
  type        = string
  default     = ""
}

variable "datacenter" {
  description = "Default datacenter for LBaaS and web instances."
  type        = string
  default     = ""
}

variable "lbaas_name" {
  description = "lbaas isnatnce name"
  type = string
  default = ""
}

variable "instance_count" {
  description = "Number of instances"
  type = number
  default = 3
}


