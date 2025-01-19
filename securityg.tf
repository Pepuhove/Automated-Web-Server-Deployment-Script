resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "My Security Group"

  tags = {
    Name = "mysg"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.mysg.id
  cidr_blocks       = ["0.0.0.0/0"] # Fixed the extra space in CIDR block
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  security_group_id = aws_security_group.mysg.id
  cidr_blocks       = ["0.0.0.0/0"] # Changed from `cidr_ipv6` to `cidr_blocks` for IPv4
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_all_outbound_ipv4" {
  type              = "egress"
  security_group_id = aws_security_group.mysg.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # All traffic
}

resource "aws_security_group_rule" "allow_all_outbound_ipv6" {
  type              = "egress"
  security_group_id = aws_security_group.mysg.id
  ipv6_cidr_blocks  = ["::/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # All traffic
}
