variable "cluster_role_name" {
    default     = "eks-cluster-role"
}

variable "node_role_name" {
    default     = "eks-node-role"
}

variable "cluster_name" {
    default = "test123454321"
    type    = string
}

variable "cluster_version" {
    default = "1.27"
    type    = string
}

variable "node-group-name" {
    default = "nodes"
}

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
  type        = any
  default     = {}
}

variable "addons" {
  type = list(object({
    name    = string
    //version = string
  }))

  default = [
    {
      name    = "kube-proxy"
      //version = "v1.27.1-eksbuild.1"
      //conflicts = "NONE"
    },
    {
      name    = "vpc-cni"
      //version = "v1.12.6-eksbuild.2"
      //conflicts = "NONE"
    },
    {
      name    = "coredns"
      //version = "v1.10.1-eksbuild.1"
      //conflicts = "PRESERVE"
    }
  ]
}