resource "aws_instance" "web" {
  ami                         = "ami-01f23391a59163da9" # Ubuntu 22.04 (eu-west-1)
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2

              # Enable required modules
              a2enmod proxy
              a2enmod proxy_http

              # Pure proxy configuration - no PHP
              cat <<APACHE > /etc/apache2/sites-available/000-default.conf
              <VirtualHost *:80>
                  ProxyPass / http://${var.app_host}/
                  ProxyPassReverse / http://${var.app_host}/
                  ProxyPreserveHost On
              </VirtualHost>
              APACHE

              # Remove any existing PHP files
              rm -rf /var/www/html/*
              
              systemctl restart apache2
              systemctl enable apache2
              EOF

  tags = {
    Name = "web-server"
  }
}
