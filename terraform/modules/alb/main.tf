# ── APPLICATION LOAD BALANCER ─────────────────
# The public-facing entry point for all web traffic.
# Lives in the public subnet and has a stable DNS name
# that never changes even if EC2 is replaced.
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = [var.public_subnet_id, var.public_subnet_b_id]

  # Prevents accidental deletion of the load balancer
  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
}


# ── TARGET GROUP ──────────────────────────────
# A target group is the list of servers the ALB
# sends traffic to. Right now it's just our one EC2.
# Later you could add more EC2 instances here.
resource "aws_lb_target_group" "drupal" {
  name     = "${var.project_name}-${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  # Health check — ALB pings this path every 30 seconds.
  # If EC2 stops responding, ALB stops sending traffic to it.
  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200,302"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-tg"
  }
}


# ── REGISTER EC2 WITH TARGET GROUP ───────────
# This tells the target group which specific EC2
# instance to send traffic to.
resource "aws_lb_target_group_attachment" "drupal" {
  target_group_arn = aws_lb_target_group.drupal.arn
  target_id        = var.ec2_instance_id
  port             = 80
}


# ── HTTP LISTENER ─────────────────────────────
# The listener watches for incoming traffic on port 80
# and forwards it to our target group (EC2).
# Think of it as the receptionist that directs visitors.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.drupal.arn
  }
}
