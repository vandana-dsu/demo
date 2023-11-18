# EC2 instance variables
variable "ami" {
  description = "Amazon Machine Image (AMI) ID for the EC2 instance"
  default     = "ami-0fc5d935ebf8bc3bc"  # Replace with your desired AMI ID
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.micro"  # Replace with your desired instance type
}

variable "git_repo" {
  description = "Git repository URL containing Dockerfiles and docker-compose.yml"
  default     = "https://github.com/vandana-dsu/demo.git"  # Replace with your Git repository URL
}

# EC2 instance resource
resource "aws_instance" "example_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  region        = "us-east-1"

  # Other instance configuration options can be added here

  tags = {
    Name = "ExampleInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y git docker
              sudo systemctl start docker
              sudo systemctl enable docker
              git clone ${var.git_repo} /tmp/repo
              cd /tmp/repo
              docker-compose up -d
              EOF

  # Security group for allowing HTTP, SSH, and Docker traffic
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}

# Security group resource
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for the EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
