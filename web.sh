#!/bin/bash
# apt update
# apt install wget unzip apache2 -y
# systemctl start apache2
# systemctl enable apache2
# wget https://www.tooplate.com/zip-templates/2117_infinite_loop.zip
# unzip -o 2117_infinite_loop.zip
# cp -r 2117_infinite_loop/* /var/www/html/
# systemctl restart apache2

 # Terraform Provisioning Script for EC2 Instance Setup

provisioner "remote-exec" {
  # SSH Connection Settings
  connection {
    type        = "ssh"
    private_key = file(var.ssh_key_path) # Replace with variable for flexibility
    user        = var.ec2_user          # Parameterized user
    host        = self.public_ip
  }

  inline = [
    # Update and Install Required Packages
    "sudo apt update -y && sudo apt upgrade -y",
    "sudo apt install unzip curl -y",

    # Install AWS CLI
    "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
    "unzip awscliv2.zip && sudo ./aws/install",

    # Install Docker
    "sudo apt-get install -y ca-certificates curl",
    "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
    "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
    "sudo apt-get update -y && sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
    "sudo usermod -aG docker ${var.ec2_user}",
    "docker --version",

    # Run SonarQube as a Docker Container
    "docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community",

    # Install Trivy
    "wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null",
    "echo \"deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main\" | sudo tee -a /etc/apt/sources.list.d/trivy.list",
    "sudo apt-get update -y && sudo apt-get install trivy -y",

    # Install Java 17
    "sudo apt install openjdk-17-jdk -y",
    "java -version",

    # Install Jenkins
    "wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
    "echo \"deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/\" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
    "sudo apt-get update -y && sudo apt-get install jenkins -y",
    "sudo systemctl start jenkins && sudo systemctl enable jenkins",

    # Output Jenkins and SonarQube Access Information
    "ip=$(curl -s ifconfig.me)",
    "echo 'Jenkins: http://'$ip':8080 (Initial Password: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword))'",
    "echo 'SonarQube: http://'$ip':9000 (Default Username/Password: admin/admin)'"
  ]
}

# Output EC2 Instance Information
output "ssh_access" {
  value = "ssh -i ${var.ssh_key_path} ${var.ec2_user}@${aws_instance.my-ec2.public_ip}"
}

output "public_ip" {
  value = aws_instance.my-ec2.public_ip
}
