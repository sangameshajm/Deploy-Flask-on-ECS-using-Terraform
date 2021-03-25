provider "aws" {
    region = var.aws_region
}

resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = var.ami_id
    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
    security_groups      = [aws_security_group.ecs_assignment.id]
    instance_type        = var.instance_type
    user_data            = <<EOF
                            #!/bin/bash
                            sudo echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
                            EOF

    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "assignment_asg" {
    name                      = "assignment_asg"
    vpc_zone_identifier       = [aws_subnet.public_subnet_a_assignment.id,aws_subnet.public_subnet_b_assignment.id]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name
    target_group_arns         = [aws_lb_target_group.ecs_target_group.arn]
    desired_capacity          = 2
    min_size                  = 1
    max_size                  = 2
    health_check_grace_period = 300
    health_check_type         = "ELB"
}

resource "aws_ecr_repository" "ecr_assignment" {
    name  = "ecr_assignment"
}

resource "aws_ecs_cluster" "ecs_cluster_assignment" {
    name  = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "assignment"
  container_definitions = data.template_file.task_definition_template.rendered
}

resource "aws_ecs_service" "service_assignment" {
  name            = "service_assignment"
  cluster         = aws_ecs_cluster.ecs_cluster_assignment.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
}