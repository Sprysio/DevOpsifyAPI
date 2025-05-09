# SimpleAPI DevOps Project

This project demonstrates a complete DevOps workflow for deploying a Go-based application (`simpleapi`) with a PostgreSQL database. It involves infrastructure provisioning, configuration management, containerization, and orchestration using modern tools like Terraform, Ansible, Docker, Kubernetes, and ArgoCD.

## Overview

### Infrastructure
- **Two Virtual Machines (VMs)** are provisioned using **Terraform**:
  - **PostgreSQL VM**: Hosts the PostgreSQL database.
  - **SimpleAPI VM**: Hosts the `simpleapi` application and Kubernetes cluster.

### Configuration Management
- **Ansible** is used to configure the VMs:
  - The PostgreSQL VM is set up with the database and preloaded with initial data.
  - The SimpleAPI VM is configured with Kubernetes (K3s), ArgoCD, and networking for app deployment.

### Application
- The `simpleapi` application is a Go-based REST API that connects to the PostgreSQL database to fetch and serve data.
- The application is **Dockerized** for portability and ease of deployment.

### Orchestration
- **Kubernetes (K3s)** is used to deploy the `simpleapi` application.
- **ArgoCD** handles continuous delivery:
  - The application is described in a Git repository using Kustomize.
  - ArgoCD syncs the deployment automatically from Git.
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
     - Kubernetes (K3s) Cluster on the application VM.

3. **Application Deployment**:
   - The `simpleapi` application is built and containerized using the provided `Dockerfile`.
   - Kubernetes manifests in the `apiserver/` directory are synced to the cluster by ArgoCD.

4. **Continuous Integration**:
   - GitHub Actions workflows in `.github/workflows` automate:
     - Building and pushing Docker images.
     - Running unit tests for the application.

## Directory Structure

- `apiserver/`: Kubernetes manifests for deploying the `simpleapi` application.
- `infrastructure/`: Terraform and Ansible configurations for provisioning and configuring the VMs.
- `sql/`: SQL scripts for initializing and populating the PostgreSQL database also config files for postgreSQL.
- `.github/workflows/`: CI/CD pipelines for Docker image building and testing.
- `main.go`: Source code for the `simpleapi` application.
- `Dockerfile`: Instructions for containerizing the `simpleapi` application.

## Prerequisites

To run this project, you need the following tools installed on your local machine:

- **Terraform**: For provisioning the virtual machines.
- **Ansible**: For configuring the VMs and setting up the environment.
- **Virtualization** (e.g., libvirt): Used by Terraform to create VMs.

## How to Run

1. **Provision Infrastructure**:
```bash
   cd infrastructure/postgres-server
   terraform init
   terraform apply
```
After it finishes:
  
  ```bash
   cd infrastructure/k3s-server
   terraform init
   terraform apply
```
2. **Configure VMs**:

VMs are configured automatically during provisioning using Ansible playbooks.

3. **Access the Application**:

After deployment is complete, the API is available at:
```
http://apiserver.192.168.122.100.nip.io/brainrot
```

4. **Access ArgoCD Dashboard**

Add the following entry to your `/etc/hosts` file to resolve the domain locally:

```
192.168.122.100 argocd.local
```

You can access the ArgoCD web UI at:

```
http://argocd.local
```

Use admin as the username and retrieve the initial password.  To retrieve the initial password, run the provided script on the `k3s_app` VM: 

```
ubuntu@ubuntu:~$ cd argocd/
ubuntu@ubuntu:~/argocd$ chmod +x passwordCheck.sh 
ubuntu@ubuntu:~/argocd$ ./passwordCheck.sh 
```

## Features
- Automated infrastructure provisioning with Terraform.
- Configuration management with Ansible.
- Containerized Go application with Docker.
- Kubernetes-based deployment with K3s.
- GitOps workflow with ArgoCD.
- CI/CD pipelines for automated testing and deployment.

## License
This project is licensed under the MIT License.