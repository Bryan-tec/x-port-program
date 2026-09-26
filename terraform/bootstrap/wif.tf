resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "xport-wif-pool"
  display_name              = "X-Port GitHub Actions"
  description               = "Workload Identity Pool for X-Port GitHub Actions"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id = google_iam_workload_identity_pool.github.workload_identity_pool_id

  workload_identity_pool_provider_id = "xport-github"
  display_name                       = "X-Port GitHub Provider"

  attribute_mapping = {
    "google.subject"                = "assertion.sub"
    "attribute.repository"          = "assertion.repository"
    "attribute.repository_id"       = "assertion.repository_id"
    "attribute.repository_owner_id" = "assertion.repository_owner_id"
    "attribute.ref"                 = "assertion.ref"
  }

  attribute_condition = <<EOT
assertion.repository_id == "1356610612" &&
assertion.repository_owner_id == "139839762"
EOT

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com/"
  }
}