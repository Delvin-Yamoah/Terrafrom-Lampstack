resource "aws_instance" "db" {
  ami                         = "ami-01f23391a59163da9" # Ubuntu 22.04 in eu-west-1
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = false
  key_name                    = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y mysql-server

              # Configure MySQL to accept remote connections
              sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
              
              systemctl restart mysql
              systemctl enable mysql

              # Set up database and user
              mysql -e "CREATE DATABASE IF NOT EXISTS visits;"
              mysql -e "CREATE USER IF NOT EXISTS 'webuser'@'%' IDENTIFIED BY 'StrongP@ss123';"
              mysql -e "GRANT ALL PRIVILEGES ON visits.* TO 'webuser'@'%';"
              mysql -e "FLUSH PRIVILEGES;"
              EOF

  tags = {
    Name = "db-server"
  }
}
