variable "project_id" {
  type        = string
  description = "Your GCP project ID"
}

variable "region" {
  type        = string
  description = "region used to deploy the resources"
  default     = "us-central1"
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
