resource "service_account" "terraform_plan" {
  account_id   = "xport-iac-planner"
  display_name = "Xport IaC Planner"
  description  = "Service account used by Github to run Terraform plan"
}

resource "service_account" "terraform_apply" {
  account_id   = "xport-iac-deployer"
  display_name = "Xport IaC Deployer"
  description  = "Service Account used by Github to run Terraform Apply"
}

resource "service_account" "ansible-deploy" {
  account_id   = "xport-ansible-deployer"
  display_name = "Xport Ansible Deployer"
  description  = "Service Account used by GitHub to deploy Ansible on the VMs"
}