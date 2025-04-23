# SimpleAPI DevOps Project

This project demonstrates a complete DevOps workflow for deploying a Go-based application (`simpleapi`) with a PostgreSQL database. It involves infrastructure provisioning, configuration management, containerization, and orchestration using modern tools like Terraform, Ansible, Docker, and Kubernetes.

## Overview

### Infrastructure
- **Two Virtual Machines (VMs)** are provisioned using **Terraform**:
  - **PostgreSQL VM**: Hosts the PostgreSQL database.
  - **SimpleAPI VM**: Hosts the `simpleapi` application and Kubernetes cluster.

### Configuration Management
- **Ansible** is used to configure the VMs:
  - The PostgreSQL VM is set up with the database and preloaded with initial data.
  - The SimpleAPI VM is configured with Kubernetes (K3s) and prepared for application deployment.

### Application
- The `simpleapi` application is a Go-based REST API that connects to the PostgreSQL database to fetch and serve data.
- The application is **Dockerized** for portability and ease of deployment.

### Orchestration
- **Kubernetes** (via K3s) is used to deploy the `simpleapi` application on the SimpleAPI VM.
- The deployment includes:
  - A Kubernetes Deployment for the application.
  - A Service for internal communication.
  - An Ingress for external access.

## Workflow

1. **Provisioning**:
   - Terraform scripts in `infrastructure/postgres-server` and `infrastructure/k3s-server` create the VMs and configure their resources (CPU, memory, disk, etc.).

2. **Configuration**:
   - Ansible playbooks in `infrastructure/ansible` install and configure:
     - PostgreSQL on the database VM.
     - Kubernetes (K3s) on the application VM.

3. **Application Deployment**:
   - The `simpleapi` application is built and containerized using the provided `Dockerfile`.
   - Kubernetes manifests in `apiserver` deploy the application to the Kubernetes cluster.

4. **Continuous Integration**:
   - GitHub Actions workflows in `.github/workflows` automate:
     - Building and pushing Docker images.
     - Running unit tests for the application.

## Directory Structure

- `apiserver/`: Kubernetes manifests for deploying the `simpleapi` application.
- `infrastructure/`: Terraform and Ansible configurations for provisioning and configuring the VMs.
- `sql/`: SQL scripts for initializing and populating the PostgreSQL database.
- `.github/workflows/`: CI/CD pipelines for Docker image building and testing.
- `main.go`: Source code for the `simpleapi` application.
- `Dockerfile`: Instructions for containerizing the `simpleapi` application.

## Prerequisites

- Terraform (>= 1.9.8)
- Ansible
- Docker
- Kubernetes (K3s)
- Go (>= 1.24)

## How to Run

1. **Provision Infrastructure**:
   ```bash
   cd infrastructure/postgres-server
   terraform init
   terraform apply

   cd ../k3s-server
   terraform init
   terraform apply
   ```

2. **Configure VMs:

- VMs are gonna get configured by Ansible Playbook.

3. Access the Application:

In Terraform output after creating VM for simpleapi its gonna return an IP, and app can be accessed by URL:
```
http://IP.nip.io
```

## Features
- Automated infrastructure provisioning with Terraform.
- Configuration management with Ansible.
- Containerized Go application with Docker.
- Kubernetes-based orchestration for scalability and reliability.
- CI/CD pipelines for automated testing and deployment.

## License
This project is licensed under the MIT License.