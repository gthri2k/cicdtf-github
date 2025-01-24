#ec2

resource "aws_instance" "servernew-gaya" {
  ami = "ami-05576a079321f21f8"
  instance_type = "t2.micro"
  subnet_id = var.sn
  security_groups = [var.sg]

  tags = {
    Name = "myserver-gaya"
  }
}
