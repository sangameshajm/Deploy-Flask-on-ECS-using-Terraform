output "ecr_repository_assignment_endpoint" {
    value = aws_ecr_repository.ecr_assignment.repository_url
}

output "alb_dns_name" {
  value       = aws_lb.ecs_load_balancer.dns_name
  description = "The domain name of the load balancer"
}