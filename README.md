# X-Port Program

X-Port is a small Flask application used to practice a complete infrastructure and deployment workflow with **Python, Docker, Terraform, Ansible, Google Cloud and GitHub Actions**.

The application listens on port **5500** and is currently deployable to a Google Compute Engine VM as a Docker container.

## Current architecture

```text
                         GitHub
                            │
                            ▼
                     Source repository
                            │
               ┌────────────┴────────────┐
               │                         │
               ▼                         ▼
          Docker image               Terraform
               │                         │
               ▼                         ▼
           Docker Hub              Google Cloud
                                         │
                              ┌──────────┼──────────┐
                              ▼          ▼          ▼
                             VPC       Firewall   Compute VM
                                                    │
                                                    ▼
                                                 Ansible
                                                    │
                                                    ▼
                                                  Docker
                                                    │
                                                    ▼
                                                X-Port App
                                                    │
                                                    ▼
                                         http://<VM-IP>:5500
```

### Google Cloud infrastructure

Terraform currently manages the application infrastructure in GCP:

- **Compute Engine:** one Debian 12 `e2-micro` VM.
- **Boot disk:** 10 GB `pd-standard`.
- **Region:** `us-central1`.
- **Zone:** `us-central1-a`.
- **VPC:** custom `xport-network-main`.
- **Subnet:** `10.0.1.0/24`.
- **Firewall:** TCP `5500` for the application and restricted TCP `22` for SSH.
- **Terraform state:** remote GCS backend.
- **Container image:** Docker Hub is the current deployment source.

The Terraform configuration still contains the previous Artifact Registry resource and related variables/output. That resource is planned for removal now that Docker Hub is the selected container registry.

## Configuration management

Ansible connects to the Compute Engine VM over SSH and is responsible for preparing the host and running the application container.

Current responsibilities include:

- Updating the VM packages.
- Installing Docker.
- Validating the Docker installation.
- Pulling the application image from Docker Hub.
- Running the container on port `5500`.

The Ansible inventory must contain a valid VM public IP, SSH user and private-key path for the environment where it is executed.

## Run locally

### Requirements

- Python 3.14+
- Docker
- Git

Clone the repository:

```bash
git clone https://github.com/Bryan-tec/x-port-program.git
cd x-port-program
```

Run directly with Python:

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python app.py
```

Open:

```text
http://localhost:5500
```

Or run it with Docker:

```bash
docker build -t xport-app .
docker run -p 5500:5500 xport-app
```

## Tests

The application uses `pytest` and `pytest-cov`:

```bash
python -m pytest -v tests/
python -m pytest --cov=app tests/
```

## Deploy the infrastructure

Additional requirements:

- Google Cloud CLI
- Terraform
- Ansible
- Access to a GCP project

Terraform variables specific to an environment are kept outside Git in:

```text
terraform/terraform.tfvars
```

The repository contains an example file showing the expected values.

Before using Terraform, authenticate to Google Cloud with Application Default Credentials:

```bash
gcloud auth application-default login
```

From `terraform/`:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

The configured GCS backend must exist and be accessible by the account running Terraform.

Useful outputs:

```bash
terraform output vm_instance_name
terraform output vm_public_ip
```

## Configure and deploy with Ansible

After the VM exists, update `ansible/inventory.ini` with the correct VM IP, SSH user and key path.

Validate connectivity:

```bash
ansible xport -i ansible/inventory.ini -m ping
```

Run the playbook:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

When deployment succeeds, the application is available at:

```text
http://<VM_PUBLIC_IP>:5500
```

## Project structure

```text
x-port-program/
├── .github/
│   └── workflows/
├── ansible/
│   ├── inventory.ini
│   └── playbook.yml
├── terraform/
│   ├── backend.tf
│   ├── compute.tf
│   ├── main.tf
│   ├── network.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars.example.txt
│   └── variables.tf
├── templates/
│   └── index.html
├── tests/
│   └── test_app.py
├── app.py
├── Dockerfile
├── requirements.txt
└── README.md
```

## Current project status

| Component | Status |
| --- | --- |
| Flask application | ✅ Working |
| Automated tests and coverage | ✅ Working |
| Docker image | ✅ Working |
| Docker Hub deployment | ✅ Working |
| Terraform infrastructure | ✅ Working |
| GCS remote state | ✅ Working |
| Compute Engine deployment | ✅ Working |
| Ansible connectivity | ✅ Working |
| Application reachable on VM port 5500 | ✅ Working |
| Remove Artifact Registry from Terraform | 🔄 Pending |
| Workload Identity Federation | 🔄 Pending |
| GitHub Actions CI/CD | 🔄 Pending |

## Next stage

The next phase is to remove the unused Artifact Registry configuration, configure **Workload Identity Federation** for GitHub Actions, and restore the CI/CD workflow so application builds, infrastructure validation and deployment can be automated without storing long-lived GCP credentials in GitHub.
