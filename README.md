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

To run the project, navigate to the project root directory `/iac/environment/docker/` and follow the steps below:

1. Run `terraform init` to initialize the project.
2. Run `terraform apply` to apply the changes.

That's it! You have successfully set up and run the project.
