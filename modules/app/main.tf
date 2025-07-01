resource "aws_instance" "app" {
  ami                         = "ami-01f23391a59163da9"
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = false
  key_name                    = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y php php-mysql php-fpm mysql-client nginx
              
              # Wait for services to be ready
              sleep 30

              # Configure Nginx
              cat <<NGINX > /etc/nginx/sites-available/default
              server {
                  listen 80;
                  root /var/www/html;
                  index index.php index.html;

                  location / {
                      try_files \$uri \$uri/ /index.php?\$query_string;
                  }

                  location ~ \.php$ {
                      fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
                      fastcgi_index index.php;
                      fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
                      include fastcgi_params;
                  }
              }
              NGINX

              # Create PHP application first
              mkdir -p /var/www/html
              cat <<PHP > /var/www/html/index.php
              <?php
              \$conn = new mysqli("${var.db_host}", "webuser", "StrongP@ss123", "visits");
              if (\$conn->connect_error) die("Connection failed: " . \$conn->connect_error);
              \$conn->query("CREATE TABLE IF NOT EXISTS counter (visits INT)");
              \$res = \$conn->query("SELECT * FROM counter");
              if (\$res->num_rows == 0) {
                \$conn->query("INSERT INTO counter VALUES (1)");
              } else {
                \$row = \$res->fetch_assoc();
                \$count = \$row['visits'] + 1;
                \$conn->query("UPDATE counter SET visits = " . \$count);
              }
              \$res = \$conn->query("SELECT * FROM counter");
              \$row = \$res->fetch_assoc();
              echo "Visit Count: " . \$row['visits'];
              ?>
              PHP

              # Set permissions
              chown -R www-data:www-data /var/www/html
              chmod -R 755 /var/www/html

              # Start services
              systemctl start php8.1-fpm
              systemctl enable php8.1-fpm
              systemctl restart nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "app-server"
  }
}