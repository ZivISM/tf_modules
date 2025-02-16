output "name_servers" {
  description = "The name servers for the Route53 zone"
  value       = aws_route53_zone.main.name_servers
}

output "name_server_1" {
  description = "Name server 1"
  value       = aws_route53_zone.main.name_servers[0]
}

output "name_server_2" {
  description = "Name server 2" 
  value       = aws_route53_zone.main.name_servers[1]
}

output "name_server_3" {
  description = "Name server 3"
  value       = aws_route53_zone.main.name_servers[2]
}

output "name_server_4" {
  description = "Name server 4"
  value       = aws_route53_zone.main.name_servers[3]
}
