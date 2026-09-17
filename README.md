# X-Port Program

Simple web application built with **Python, Flask, Docker, GitHub Actions, Terraform and Ansible**.

The purpose of this project is to build a small web application while implementing a complete CI/CD workflow, from testing the source code to deploying the application in Google Cloud.

---

## Architecture

```text
Developer
   │
   ▼
GitHub
   │
   ▼
GitHub Actions
   │
   ├── Python Tests
   ├── Code Coverage
   └── Docker Build
          │
          ▼
     Container Registry
          │
          ▼
      Google Cloud
          │
          ├── Terraform
          │     └── Infrastructure
          │
          └── Ansible
                └── VM Configuration
                       │
                       ▼
                  Docker Container
                       │
                       ▼
                   Flask App
```

---

# Requirements

To run the application locally, install the following:

* Python 3.14+
* Git
* Docker (optional, if running the application as a container)
* WSL Ubuntu (recommended when working from Windows)

For the Google Cloud deployment, the following tools will also be required:

* Google Cloud CLI (`gcloud`)
* Terraform
* Ansible

---

# 1. Clone the repository

Clone the repository:

```bash
git clone https://github.com/Bryan-tec/x-port-program.git
```

Enter the project directory:

```bash
cd x-port-program
```

---

# 2. Create the Python virtual environment

Create a virtual environment:

```bash
python3 -m venv venv
```

Activate it:

```bash
source venv/bin/activate
```

After activation, the terminal should display something similar to:

```text
(venv)
```

Verify Python:

```bash
python --version
```

Verify pip:

```bash
pip --version
```

---

# 3. Install dependencies

Install the dependencies defined in `requirements.txt`:

```bash
pip install -r requirements.txt
```

---

# 4. Run the Flask application

Start the application:

```bash
python app.py
```

The application runs on port `5500`.

Open a browser and navigate to:

```text
http://localhost:5500
```

You should see the X-Port application.

---

# 5. Run the tests

The project uses `pytest` for automated testing.

Run the tests with:

```bash
python -m pytest -v tests/
```

Example output:

```text
collected 1 item

tests/test_app.py::test_home_page PASSED

1 passed
```

Every new feature should include the corresponding tests.

---

# 6. Code coverage

Code coverage can be executed using `pytest-cov`.

Install it if it is not already included in `requirements.txt`:

```bash
pip install pytest-cov
```

Run:

```bash
python -m pytest --cov=. tests/
```

For an HTML report:

```bash
python -m pytest --cov=. --cov-report=html tests/
```

The report will be generated under:

```text
htmlcov/
```

---

# 7. Run the application with Docker

Build the Docker image:

```bash
docker build -t xport-app .
```

Run the container:

```bash
docker run -p 5500:5500 xport-app
```

Open:

```text
http://localhost:5500
```

To see the running containers:

```bash
docker ps
```

To stop the container:

```bash
docker stop <container_id>
```

---

# 8. Docker Hub

The application image can be published to Docker Hub.

Repository:

```text
mrasaltanas/xport-images
```

Example:

```bash
docker tag xport-app mrasaltanas/xport-images:v1
```

Push the image:

```bash
docker push mrasaltanas/xport-images:v1
```

The `latest` tag can also be used:

```bash
docker tag xport-app mrasaltanas/xport-images:latest
docker push mrasaltanas/xport-images:latest
```

The GitHub Actions pipeline is responsible for automatically building and publishing container images.

---

# 9. GitHub Actions

The CI pipeline is located at:

```text
.github/workflows/ci.yml
```

The pipeline currently performs several stages:

```text
Git Push
   │
   ▼
GitHub Actions
   │
   ▼
Install Python
   │
   ▼
Install dependencies
   │
   ▼
Run pytest
   │
   ▼
Docker Build
   │
   ▼
Docker Registry
```

The tests are executed automatically when the configured GitHub Actions workflow is triggered.

---

# 10. Terraform

Terraform is used to manage the Google Cloud infrastructure as code.

Terraform configuration is located in:

```text
terraform/
```

Current structure:

```text
terraform/
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── artifact_registry.tf
├── iam.tf
└── outputs.tf
```

Initialize Terraform:

```bash
cd terraform
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Create an execution plan:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

> Do not run `terraform apply` unless you have reviewed the output of `terraform plan`.

---

# 11. Google Cloud

The application will eventually be deployed to Google Cloud.

The planned infrastructure includes:

```text
Google Cloud
│
├── Artifact Registry
│   └── xport-images
│
├── IAM
│
├── Workload Identity Federation
│
├── VPC Network
│
├── Firewall
│
└── Compute Engine VM
```

The Docker image will be stored in Google Artifact Registry using a format similar to:

```text
REGION-docker.pkg.dev/PROJECT_ID/xport-images/xport-app:TAG
```

Example:

```text
us-central1-docker.pkg.dev/my-project/xport-images/xport-app:v1
```

---

# 12. Ansible

Ansible will be used to configure the Google Cloud VM after Terraform creates the infrastructure.

The planned responsibilities are:

```text
Terraform
   │
   ▼
Create VM
   │
   ▼
Ansible
   │
   ├── Configure operating system
   ├── Install Docker
   ├── Configure required services
   ├── Authenticate with Artifact Registry
   ├── Pull application image
   └── Start application container
```

Ansible configuration will be located in:

```text
ansible/
```

---

# 13. Project structure

Current project structure:

```text
x-port-program/
│
├── .github/
│   └── workflows/
│       └── ci.yml
│
├── templates/
│   └── index.html
│
├── tests/
│   └── test_app.py
│
├── terraform/
│   ├── providers.tf
│   ├── variables.tf
│   ├── terraform.tfvars
│   ├── artifact_registry.tf
│   ├── iam.tf
│   └── outputs.tf
│
├── ansible/
│   └── ...
│
├── app.py
├── requirements.txt
├── Dockerfile
├── .dockerignore
├── .gitignore
└── README.md
```

---

# 14. Local development workflow

For normal development:

```bash
# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run tests
python -m pytest -v tests/

# Start application
python app.py
```

Then open:

```text
http://localhost:5500
```

---

# 15. Deployment workflow

The final deployment workflow is planned as:

```text
                  Developer
                      │
                      ▼
                  Git Push
                      │
                      ▼
              GitHub Repository
                      │
                      ▼
              GitHub Actions
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
       Pytest                Docker Build
          │                       │
          ▼                       ▼
        PASS                 Docker Image
                                  │
                                  ▼
                         Artifact Registry
                                  │
                                  ▼
                             Terraform
                                  │
                                  ▼
                          Google Cloud VM
                                  │
                                  ▼
                              Ansible
                                  │
                                  ▼
                           Docker Container
                                  │
                                  ▼
                            Flask Application
                                  │
                                  ▼
                          http://<VM-IP>:5500
```

---

# Status

| Component                    | Status         |
| ---------------------------- | -------------- |
| Flask application            | ✅ Completed    |
| HTML template                | ✅ Completed    |
| Python tests                 | ✅ Completed    |
| GitHub Actions CI            | ✅ Completed    |
| Docker image                 | ✅ Completed    |
| Docker Hub                   | ✅ Completed    |
| Code coverage                | ✅ Completed    |
| Terraform                    | 🔄 In progress |
| Artifact Registry            | 🔄 In progress |
| Workload Identity Federation | 🔄 In progress |
| Compute Engine               | 🔄 In progress |
| Ansible                      | 🔄 In progress |
| Automated deployment         | 🔄 In progress |

---

## Goal

The final goal of this project is to have a reproducible CI/CD pipeline where a change pushed to GitHub can be tested, containerized, stored in Google Artifact Registry, and deployed automatically to infrastructure managed by Terraform and configured with Ansible.
