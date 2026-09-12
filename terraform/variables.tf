variable "project_id" {
  type = string
}

variable "region" {
  type        = string
  description = "us-central1"
}

variable "repository_name" {
  type        = string
  description = "Artifact Registry repository name"
  default     = "xport-images"
}

variable "zone" {
  type        = string
  description = "us-central1-a"
  default     = "us-central1-a"
}
