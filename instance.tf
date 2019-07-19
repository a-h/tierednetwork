data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

resource "aws_instance" "ssh" {
  ami                    = "${data.aws_ami.amazon_linux.id}"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.public_1.id}"
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  key_name               = "welL_test"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World"
              EOF

  tags = {
    Name = "ssh"
  }
}
