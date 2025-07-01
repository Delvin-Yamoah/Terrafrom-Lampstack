# DB Server
resource "aws_instance" "db" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.db_subnet_id
  vpc_security_group_ids = [var.db_sg_id]
  user_data              = base64encode(file("${path.module}/scripts/db_setup.sh"))

  tags = {
    Name = "${var.project_name}-db-server"
    Tier = "database"
  }
}

# App Server
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.app_subnet_id
  vpc_security_group_ids = [var.app_sg_id]

  user_data = base64encode(templatefile("${path.module}/scripts/app_setup.sh", {
    db_server_ip = aws_instance.db.private_ip
  }))

  tags = {
    Name = "${var.project_name}-app-server"
    Tier = "app"
  }

  depends_on = [aws_instance.db]
}

# Web Server
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.web_subnet_id
  vpc_security_group_ids = [var.web_sg_id]

  user_data = base64encode(templatefile("${path.module}/scripts/web_setup.sh", {
    app_server_ip = aws_instance.app.private_ip
  }))

  tags = {
    Name = "${var.project_name}-web-server"
    Tier = "web"
  }

  depends_on = [aws_instance.app]
}