output "terraform_plan_service_account" {
  value = google_service_account.terraform_plan.email
}

output "terraform_apply_service_account" {
  value = google_service_account.terraform_apply.email
}

output "workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.github.name
}

output "workload_identity_pool" {
  value = google_iam_workload_identity_pool.github.name
}

output "ansible_deploy_service_account" {
  value = google_service_account.ansible_deploy.email
}