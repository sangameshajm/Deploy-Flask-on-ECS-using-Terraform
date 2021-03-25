resource "aws_lb" "ecs_load_balancer" {
    name                = "assignment-load-balancer"
    load_balancer_type  = "application"
    internal            = false
    security_groups     = [aws_security_group.ecs_assignment.id]
    subnets             = [aws_subnet.public_subnet_a_assignment.id, aws_subnet.public_subnet_b_assignment.id]
}

resource "aws_lb_target_group" "ecs_target_group" {
    name                = "ecs-target-group"
    port                = "80"
    protocol            = "HTTP"
    target_type         = "instance"
    vpc_id              = aws_vpc.vpc_assignment.id

    health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}

resource "aws_lb_listener" "alb_listener" {
    load_balancer_arn = aws_lb.ecs_load_balancer.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_lb_target_group.ecs_target_group.arn
        type             = "forward"
    }
}