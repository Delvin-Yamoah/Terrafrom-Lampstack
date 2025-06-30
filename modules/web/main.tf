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
              apt install -y apache2 php libapache2-mod-php php-mysql

              # Create a simple PHP page that connects to database
              cat <<PHP > /var/www/html/index.php
              <?php
              \$servername = "${var.db_host}";
              \$username = "admin";
              \$password = "password123";
              \$dbname = "lampdb";

              try {
                  \$pdo = new PDO("mysql:host=\$servername;dbname=\$dbname", \$username, \$password);
                  \$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                  echo "<h1>LAMP Stack - 2 Tier Architecture</h1>";
                  echo "<p>Database connection: <strong>Successful</strong></p>";
                  echo "<p>Connected to: " . \$servername . "</p>";
              } catch(PDOException \$e) {
                  echo "<h1>LAMP Stack - 2 Tier Architecture</h1>";
                  echo "<p>Database connection: <strong>Failed</strong></p>";
                  echo "<p>Error: " . \$e->getMessage() . "</p>";
              }
              ?>
              PHP

              # Remove default index.html
              rm -f /var/www/html/index.html
              
              systemctl restart apache2
              systemctl enable apache2
              EOF

  tags = {
    Name = "web-server"
  }
}
