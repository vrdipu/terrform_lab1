terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "k8s_node" {
  ami                    = "ami-0cf2b4e024cdb6960" # Replace with a valid AMI ID for your region
  instance_type          = "t2.micro"
  key_name               = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get upgrade -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
              chmod +x ./kind
              sudo mv ./kind /usr/local/bin/kind
              kind create cluster --name test
              EOF

  tags = {
    Name = "k8s-node"
  }
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.k8s_node.id
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.k8s_node.public_ip
}
