resource "google_service_account" "terraform_plan" {
  account_id   = "xport-iac-planner"
  display_name = "Xport IaC Planner"
  description  = "Service account used by GitHub to run Terraform plan"
}

resource "google_service_account" "terraform_apply" {
  account_id   = "xport-iac-deployer"
  display_name = "Xport IaC Deployer"
  description  = "Service account used by GitHub to run Terraform apply"
}

resource "google_service_account" "ansible_deploy" {
  account_id   = "xport-ansible-deployer"
  display_name = "Xport Ansible Deployer"
  description  = "Service account used by GitHub Actions to deploy Ansible on the VM"
}