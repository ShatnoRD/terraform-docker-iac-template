## Terraform docker iac template
This repository utilizes the [`ShatnoRD/container/docker`](https://registry.terraform.io/modules/ShatnoRD/container/docker/latest) Terraform module to manage Docker containers on a remote host, demonstrated by the provided NGINX example. It includes a GitHub Actions-based deployment pipeline and [MegaLinter](https://nvuillam.github.io/mega-linter/) configurations for formatting Terraform code with `terraform-fmt`, ensuring CI/CD and code quality assurance.

## Quickstart Guide

To get started with this project, follow the steps below.

### Prerequisites

Before running the project, make sure you have the following:

- SSH Key: You need an SSH key pair (public and private keys). If you don't have one, follow the instructions in the SSH Key Generation section.

### SSH Key Generation

To generate a new SSH key pair, open your terminal and run the following command:

```bash
ssh-keygen -f ~/.ssh/terraform
```

To place the SSH keys on the remote machine, use the following command:

```bash
ssh-copy-id -i ~/.ssh/terraform.pub -p 22 user@host
```

By default, the `var.ssh_key_file` variable is set to `~/.ssh/terraform` in the configuration. This means that if no specific value is provided for `ssh_key_file`, Terraform will automatically use `~/.ssh/terraform` as the path to the SSH key for authentication.

### Configuration

Make sure to update the following configuration files:

#### `provider.system`

```hcl
provider "system" {
    ssh {
        host        = var.host_ip_address
        port        = var.ssh_port
        user        = var.ssh_user
        private_key = file(var.ssh_key_file)
    }
}
```

#### `provider.docker`

```hcl
provider "docker" {
    host     = "ssh://${var.ssh_user}@${var.host_ip_address}:${var.ssh_port}"
    ssh_opts = [
        "-o", "StrictHostKeyChecking=no",
        "-o", "UserKnownHostsFile=/dev/null",
        "-i", "${var.ssh_key_file}"
    ]
}
```

### Running the Project

If deploying with GitHub Actions from a PR, ensure the following secrets are populated in your GitHub repository:

- `terraform_secrets`: `${{ secrets.TERRAFORM_SECRETS_DOCKER_CICD }}`
- `terraform_ssh_key`: `${{ secrets.TERRAFORM_SSH_KEY }}`

#### Github Actions Deployment:

1. Encode the `terraform.tfvars` file:
    ```bash
    cat terraform.tfvars | base64 -w 0
    ```
2. Verify the encoded string:
    ```bash
    echo "ENCODED_STRING" | base64 -d
    ```
3. Navigate to `Settings` > `Secrets and variables` > `Actions` and add a new repository secret named `TERRAFORM_SECRETS_DOCKER_CICD` with the encoded string for value

If you are using a remote backend like the provided S3 example, also populate these secrets for the self-hosted S3 alternative Minio:

- `minio_endpoint`: `${{ secrets.TERRAFORM_BACKEND_MINIO_ENDPOINT }}`
- `minio_access_key`: `${{ secrets.TERRAFORM_BACKEND_MINIO_ACCESS_KEY }}`
- `minio_secret_key`: `${{ secrets.TERRAFORM_BACKEND_MINIO_SECRET_KEY }}`

#### Manual Deployment:

To manually deploy, with  local terraform statefile, navigate to the project root directory `/iac/environment/docker/nginx-app` and follow these steps:
1. Comment out the backend.tf file contents
2. Run `terraform init` to initialize the project.
3. Run `terraform apply` to apply the changes.

That's it! You have successfully set up and run the project.