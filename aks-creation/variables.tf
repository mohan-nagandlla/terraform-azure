# resource group name for aks cluster deployment 
variable "rsg_name" {
    type = string
    default = "aksrsg"
}

variable "location" {
    type = string
    default = "eastus"
  
}

# inputs for keyvalut 

variable "key_vault_name" {
    type = string
    default = "AKSdata"
  
}
variable "key_vault_rsg_name" {
    type = string
    default = "Global"
  
}

variable "ssh_key" {
    type = string
    default = "terraformspaksSSHkey"
  
}

variable "client_name" {
    type = string
    default = "terraformspaksAppID"
  
}

variable "client_secret" {
    type = string
    default = "terraformspaksPassword"
  
}
# variable for network security group

variable "nsg" {
    type = string
    default = "aksnsg"
  
}

# variables for AKS
variable "aks_name" {
    type = string
    default = "akscluster"
  
}

variable "ssh_public_key" {
     default = "~/.ssh/id_rsa.pub"
  
}
variable "dnsPrefix" {
    type = string
    default = "k8s"
  
}

variable "node_count" {
    type = number
    default = 1
}

variable "vm_size" {
    type = string
    default = "Standard_D2_v2"
  
}
variable "max_nodes" {
    type = number
    default = 4  
}

variable "min_nodes" {
    type = number
    default = 1
  
}

# acr details
variable "acr_name" {
  type = string
  default = "ACRMohanGlobal"
}