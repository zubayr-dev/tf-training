resource "aws_instance" "test-tf-ec2" {
   ami = "ami-087a0156cb826e921"
   instance_type = "t2.micro"
   key_name = "tf-ec2-test-kp"
   security_groups = [
      aws_security_group.allow_tls.id
   ]
   availability_zone = aws_subnet.test-tf-subnet-az1.availability_zone
   subnet_id = aws_subnet.test-tf-subnet-az1.id
   
   tags = aws_vpc.test-tf-vpc.tags

   count = 2
}

