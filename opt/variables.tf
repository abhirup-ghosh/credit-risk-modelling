variable "key_pair_name" {
  description = "The EC2 Key Pair to associate with the EC2 Instance for SSH access."
  type = string
  default = "credit-risk-modelling-key"
}
variable "docker_registry" {
  description = "Docker registry (AWS server that stores docker images). The registry should contain the `credit-risk-modelling` image"
  type = string
}
