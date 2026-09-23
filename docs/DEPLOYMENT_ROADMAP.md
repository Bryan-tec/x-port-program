# X-Port Deployment Roadmap

This roadmap tracks the remaining work required to move X-Port from manually provisioned infrastructure to a repeatable CI/CD deployment on Google Cloud.

## Current baseline

Already completed or validated:

- Flask application and tests
- Docker image build
- Terraform infrastructure creation
- Compute Engine VM
- Custom VPC and subnet
- Firewall rules for port 5500 and restricted SSH
- Artifact Registry repository
- Remote Terraform state in GCS
- Terraform plan/apply validated locally
- SSH access to the VM
- Ansible connectivity test returns SUCCESS / pong

---

## Phase 1 — Configure the VM with Ansible

Issue: #3 — Configure VM with Ansible

Goal: make base VM configuration repeatable.

Work:

- Validate inventory and SSH connectivity
- Update apt cache
- Install Docker
- Enable and start Docker
- Add the Ansible user to the docker group when appropriate
- Add a Docker validation task
- Re-run the playbook to confirm idempotency

Exit criteria:

- Ansible ping succeeds
- Playbook ends with failed=0 and unreachable=0
- Docker is installed and running
- Second playbook run does not perform unnecessary changes

---

## Phase 2 — Publish the application image

Issue: #9 — Publish xport-app image to Google Artifact Registry

Goal: prove the image publishing flow manually before automating it.

Work:

- Authenticate local Docker with Artifact Registry
- Build xport-app
- Tag the image using the Artifact Registry URL
- Push a versioned image
- Confirm the image exists in GCP
- Define the project's tagging convention

Suggested tagging strategy:

- Versioned/deployment tag for traceability
- latest only as a convenience tag for development

Exit criteria:

- Image is visible in Artifact Registry
- Image can be pulled successfully from an authenticated environment

---

## Phase 3 — Give the VM least-privilege registry access

Issue: #10 — Configure VM identity and Artifact Registry read access

Goal: allow the VM to pull images without service-account JSON keys.

Work:

- Review the service account currently attached to the VM
- Create a dedicated VM service account if appropriate
- Manage identity/IAM through Terraform
- Grant Artifact Registry read access only
- Re-run terraform plan before any IAM apply
- Validate registry authentication from the VM

Exit criteria:

- VM identity is explicit
- No long-lived JSON key is used
- VM can pull xport-app from Artifact Registry

---

## Phase 4 — Deploy the application with Ansible

Issue: #11 — Deploy xport container on the VM with Ansible

Goal: make application deployment repeatable.

Work:

- Authenticate Docker to Artifact Registry using the VM identity
- Pull the selected xport-app image tag
- Stop/remove an outdated container when required
- Run the application container on port 5500
- Add an appropriate restart policy
- Validate the app from inside the VM
- Re-run the playbook safely

Exit criteria:

- Container is running
- Port 5500 is published
- curl http://localhost:5500 succeeds on the VM
- Re-running Ansible does not break the deployment

---

## Phase 5 — Validate the complete deployment

Issue: #12 — Validate end-to-end deployment and application availability

Goal: prove that infrastructure, container runtime and application all work together.

Work:

- Run terraform plan and confirm no unexpected drift
- Confirm VM status
- Confirm Docker container status
- Test the app from inside the VM
- Test the app externally using the VM public IP
- Review firewall rules
- Record deployment issues and resolutions in GitHub

Exit criteria:

- Internal HTTP request succeeds
- External http://<VM_PUBLIC_IP>:5500 succeeds
- Terraform shows no unexpected changes
- Deployment problems and fixes are documented

---

## Phase 6 — Configure GitHub-to-GCP authentication

Issue: #13 — Configure Workload Identity Federation for GitHub Actions

Goal: let GitHub Actions authenticate to GCP without service-account keys.

Work:

- Create/select CI/CD service account
- Create Workload Identity Pool
- Create GitHub OIDC provider
- Restrict trust to Bryan-tec/x-port-program
- Grant least-privilege roles
- Configure GitHub Actions authentication
- Validate with a non-destructive GCP/Terraform operation

Exit criteria:

- GitHub Actions authenticates through WIF
- No service-account JSON key is stored in GitHub
- Trust is restricted to this repository

---

## Phase 7 — Restore and finalize CI/CD

Issue: #7 — Restore and clean GitHub Actions CI/CD pipeline

Goal: turn the validated manual workflow into automation.

Work:

- Restore .github/workflows/ci.yml
- Remove troubleshooting-only commands
- Run Python tests and coverage
- Build and smoke-test Docker image
- Run Terraform fmt/init/validate/plan
- Authenticate to GCP through WIF
- Push image to Artifact Registry
- Add deployment stages only after manual deployment is proven
- Keep the scorecard/job summary

Important:

The repository currently contains .github/workflows/ci.txt. GitHub Actions requires .yml or .yaml.

Exit criteria:

- CI runs on relevant repository changes
- Validation jobs pass
- GCP authentication uses WIF
- Docker image is published automatically
- Deployment jobs have clear dependencies
- Job summary clearly reports PASS/FAIL status

---

## Phase 8 — Cost guardrails and repository hygiene

Issue: #14 — Add GCP Free Tier cost guardrails and repository cleanup

Goal: reduce accidental cost and prevent generated/sensitive files from entering Git.

Work:

- Configure a GCP budget and billing alerts
- Reconfirm e2-micro and intended disk sizing
- Define Artifact Registry cleanup/retention
- Review public IP usage
- Verify tfstate/tfvars/credentials remain outside Git
- Remove generated Terraform plan artifacts if tracked
- Review terraform/tfile
- Update README to match the real repository
- Confirm no private SSH key is committed

Exit criteria:

- Budget/alerts exist
- Repository contains no generated plans, state, secrets or private keys
- README reflects the current architecture
- Artifact Registry storage growth is controlled

---

## Recommended execution order

1. #3 Configure VM with Ansible
2. #9 Publish xport-app image to Artifact Registry
3. #10 Configure VM identity / registry read access
4. #11 Deploy container with Ansible
5. #12 Validate end-to-end deployment
6. #13 Configure Workload Identity Federation
7. #7 Restore/finalize GitHub Actions CI/CD
8. #14 Cost guardrails and repository cleanup

## Working method

For each issue:

1. Create a feature branch from main
2. Work only on the issue scope
3. Test locally
4. Commit with a descriptive message
5. Open a pull request referencing the issue
6. Record relevant errors/fixes in the issue or PR
7. Merge only after the acceptance criteria are satisfied
8. Close the issue

Suggested branch naming:

- feature/issue-3-ansible-vm
- feature/issue-9-artifact-registry-push
- feature/issue-10-vm-registry-access
- feature/issue-11-ansible-deploy
- feature/issue-12-e2e-validation
- feature/issue-13-wif
- feature/issue-7-cicd
- chore/issue-14-cost-cleanup

## Definition of done for the project

The project can be considered complete when:

- Terraform can recreate the infrastructure
- Terraform state is stored securely in GCS
- Ansible can configure a fresh VM
- Artifact Registry stores versioned xport-app images
- VM pulls images without long-lived credentials
- xport-app is reachable externally
- GitHub Actions authenticates through WIF
- CI validates code, Docker and Terraform
- CD publishes and deploys the selected image
- The repository contains no secrets, tfstate or generated plan artifacts
- GCP cost guardrails are enabled
