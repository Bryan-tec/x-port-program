variable "project_id" {
  type        = string
  description = "Your GCP project ID"
}

variable "region" {
  type        = string
  description = "region used to deploy the resources"
  default     = "us-central1"
}

