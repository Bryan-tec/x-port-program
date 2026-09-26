terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

# Define the provider configuration for Google Cloud
provider "google" {
  project = terraform.var.project_id
  region  = terraform.var.region
}
