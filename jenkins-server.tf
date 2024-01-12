data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_name]      
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jenkins-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = var.key_pair 
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_default_security_group.sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  user_data                   = file("install_jenkins.sh")
  tags = {
    Name = "${var.env_prefix}-jenkins-server"
  }
}

resource "aws_eip_association" "jenkins_eip_assoc" {
  instance_id   = aws_instance.jenkins-server.id
  allocation_id = aws_eip.jenkins_eip.id
}

resource "aws_eip" "jenkins_eip" {
  
}

