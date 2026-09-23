variable "project_id" {
<<<<<<< HEAD
  type = string
  description = "test-project"
=======
  type        = string
  description = "Project ID where the resources will be deployed"
>>>>>>> a41de46 (Adding terraform configuration)
}
  
variable "region" {
  type        = string
  description = "region used to deploy the resources"
  default     = "us-central1"
}

variable "repository_name" {
  type        = string
  description = "Artifact Registry repository name"
  default     = "xport-images"
}

variable "zone" {
  type        = string
  description = "zone used to deploy the resources"
  default     = "us-central1-a"
}

variable "machine_type" {
  type        = string
  description = "Machine type for the VM instance"
  default     = "e2-micro"
}
