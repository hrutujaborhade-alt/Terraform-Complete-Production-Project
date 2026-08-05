resource "aws_alb" "alb" {
  internal           = false
  load_balancer_type = "application"


  security_groups = [var.alb_security_group_id]
  subnets         = var.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-alb"
    }
  )
}

resource "aws_alb_target_group" "alb_tg" {

  port     = 80
  protocol = "HTTP"

  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    path     = "/"

    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3

    interval = 30
    timeout  = 5
    matcher  = 200
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-alb-tg"
    }
  )
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn

  port     = 80
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg.arn
  }
}