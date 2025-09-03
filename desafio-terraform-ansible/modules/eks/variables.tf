variable "name" {
  type = string
}

variable "eks_version" {
  type = string
  default = "1.33"
}

variable "eks_public_endpoint" {
    type = bool
    default = false
}

variable "network" {
  type = object({
    vpc_id = string
    cluster_subnet_ids = list(string)
    nodes_subnet_ids = list(string)
  })
}