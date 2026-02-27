# ── IAM ROLE FOR EC2 ──────────────────────────
# This gives the EC2 instance permission to talk
# to other AWS services like CloudWatch for logs.
# Think of it as an ID badge for the server.
resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-role"
  }
}

# Attach CloudWatch policy so EC2 can send logs
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Attach SSM policy so you can connect via AWS
# Session Manager without needing SSH at all
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile wraps the IAM role so EC2 can use it
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2.name
}


# ── EC2 INSTANCE ──────────────────────────────
# The actual server that runs Drupal.
# t2.micro = free tier eligible.
# Ubuntu 22.04 LTS is our operating system.
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  # Root disk — 8GB is enough for Drupal + free tier allows up to 30GB
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  # User data runs automatically when the server first boots.
  # It installs Nginx, PHP, and sets up the environment.
  # Think of it as a startup script.
  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Update system packages
    apt-get update -y
    apt-get upgrade -y

    # Install Nginx web server
    apt-get install -y nginx

    # Install PHP 8.2 and extensions needed by Drupal
    apt-get install -y software-properties-common
    add-apt-repository -y ppa:ondrej/php
    apt-get update -y
    apt-get install -y \
      php8.2 \
      php8.2-fpm \
      php8.2-mysql \
      php8.2-curl \
      php8.2-gd \
      php8.2-mbstring \
      php8.2-xml \
      php8.2-zip \
      php8.2-intl \
      php8.2-opcache

    # Install Composer (PHP package manager — needed for Drupal)
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer

    # Install useful tools
    apt-get install -y git curl unzip mysql-client

    # Store database connection details as environment variables
    # Ansible will use these in Step 6 to configure Drupal
    cat > /etc/drupal-env <<ENVFILE
    DB_HOST=${var.db_endpoint}
    DB_NAME=${var.db_name}
    DB_USER=${var.db_username}
    DB_PASS=${var.db_password}
    ENVFILE

    # Create web root directory for Drupal
    mkdir -p /var/www/html/drupal

    # Set correct ownership
    chown -R www-data:www-data /var/www/html

    # Start and enable Nginx
    systemctl start nginx
    systemctl enable nginx

    # Start and enable PHP-FPM
    systemctl start php8.2-fpm
    systemctl enable php8.2-fpm

    # Simple health check page so the Load Balancer
    # can verify the server is running
    echo "<?php echo 'Drupal server is running!'; ?>" \
      > /var/www/html/index.php

    echo "Bootstrap complete!" >> /var/log/user-data.log
  EOF

  tags = {
    Name = "${var.project_name}-${var.environment}-app-server"
  }
}
