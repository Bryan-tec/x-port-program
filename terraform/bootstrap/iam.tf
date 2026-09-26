locals {
  github_repository_principal = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository_id/1356610612"
  
  terraform_apply_roles = toset([
    "roles/compute.instanceAdmin.v1",
    "roles/compute.networkAdmin",
    "roles/compute.securityAdmin",
    "roles/artifactregistry.admin"
  ])

  ansible_deploy_roles = toset([
    "roles/iap.tunnelResourceAccessor", 
    "roles/compute.osAdminLogin"
  ])
}


# Terraform Plan and Apply SA

resource "google_service_account_iam_member" "github_terraform_plan" {
  service_account_id = google_service_account.terraform_plan.name
  role = "roles/iam.workloadIdentityUser"
  member = local.github_repository_principal
}

resource "google_service_account_iam_member" "github_terraform_apply" {
  service_account_id = google_service_account.terraform_apply.name
  role = "roles/iam.workloadIdentityUser"
  member = local.github_repository_principal
}

resource "google_service_iam_member" "github_ansible_deploy" {
  for_each = local.ansible_deploy_roles
  project = var.project_id
  service_account_id = google_service_account.ansible_deploy.name
  role = each.value
  member = "ServiceAccount:${google_service_account.ansible_deploy.email}"
}

resource "google_project_iam_member" "terraform_plan_viewer" {
  project = var.project_id
  role = "roles/viewer"
  member = "serviceAccount:${google_service_account.terraform_plan.email}"
}

resource "google_project_iam_member" "terraform_apply_roles" {
  for_each = local.terraform_apply_roles
  project = var.project_id
  role = each.value
  member = "serviceAccount:${google_service_account.terraform_apply.email}"
}


# If the VM have a defined default, the other SA needs the role: https://docs.cloud.google.com/compute/docs/oslogin/set-up-oslogin#configure_users
data "google_compute_default_service_account" "default" {
}

resource "google_service_account_iam_member" "ansible_use_vm_service_account" {
  service_account_id = data.google_compute_default_service_account.default.name
  role = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${google_service_account.ansible_deploy.email}"
}