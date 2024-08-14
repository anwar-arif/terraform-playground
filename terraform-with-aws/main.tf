terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_key_pair" "my-key-pair" {
  key_name = "my-key-pair"
  public_key = file("~/.ssh/my-aws-key.pub")
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my-ubuntu" {
  ami = "ami-003c463c8207b4dfa"
  instance_type = "t2.micro"
  key_name = aws_key_pair.my-key-pair.key_name
  security_groups = [aws_security_group.allow_ssh.name]
  
  user_data = <<-EOF
    export DEBIAN_FRONTEND=noninteractive

    apt-get update
    apt-get install -y --no-install-recommends \
      apt-utils \
      software-properties-common \
      curl \
      wget \
      gnupg \
      lsb-release \
      vim \
      nano \
      less \
      net-tools \
      iputils-ping \
      htop \
      iftop \
      iotop \
      dstat \
      sysstat \
      strace \
      lsof \
      tcpdump \
      traceroute \
      ltrace \
      bpfcc-tools \
      perf-tools-unstable \
      linux-tools-common \
      linux-tools-generic \
      procps \
      util-linux \
      iproute2 \
      psmisc \
      gdb \
      man-db \
      tldr \
      sar \
      cpuinfo \
      meminfo \
      diskstats \
      stat
    unset DEBIAN_FRONTEND
  EOF
  
  tags = {
    Name = "MyUbuntu"
  }
}

output "instance_public_ip" {
  value = aws_instance.my-ubuntu.public_ip
}
