resource "aws_instance" "web" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t2.micro"
  key_name               = "my-key"
  vpc_security_group_ids = [aws_security_group.mysg.id]

  # Availability Zone should use index for multiple instances
  availability_zone = var.zone1

  tags = {
    Name    = "My-server" # Corrected syntax for dynamic naming
    Project = "Test"
  }

  # provisioner "file" {
#     source      = "web.sh"
#     destination = "/tmp/web.sh"
#   }

#   connection {
#     type        = "ssh"
#     user        = var.webuser
#     private_key = file("my-key")
#     host        = self.public_ip
#   }


#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/web.sh",
#       "sudo /tmp/web.sh"
#     ]
#   }

#   provisioner "local-exec" {
#     command = "echo ${aws_instance.web.private_ip} >>private_ips.txt"
  }

# }

output "WebPublicIP" {
  description = "instance public ip"
  value       = aws_instance.web.public_ip
}

output "WebPrivateIP" {
  description = "instance private ip"
  value       = aws_instance.web.private_ip
}
