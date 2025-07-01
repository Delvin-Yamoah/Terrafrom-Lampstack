output "web_server_url" {
  description = "URL to access the visit counter application"
  value       = "http://${module.compute.web_public_ip}"
}

output "web_server_public_ip" {
  description = "Public IP of web server"
  value       = module.compute.web_public_ip
}

output "app_server_private_ip" {
  description = "Private IP of app server"
  value       = module.compute.app_private_ip
}

output "db_server_private_ip" {
  description = "Private IP of database server"
  value       = module.compute.db_private_ip
}