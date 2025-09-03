variable "name" {
    type = string
}

variable "vpc" {
  type = object({
    prod = object({
      cidr       = string
      single_nat = bool
      enable_nat = bool
      number_azs = number
    })

    dev = object({
      cidr       = string
      single_nat = bool
      enable_nat = bool
      number_azs = number
    })
  })

  default = {
    prod = {
      cidr       = "10.100.0.0/16"
      single_nat = false
      enable_nat = true
      number_azs = 3
    }

    dev = {
      cidr       = "10.101.0.0/16"
      single_nat = false
      enable_nat = false
      number_azs = 2
    }
  }
}