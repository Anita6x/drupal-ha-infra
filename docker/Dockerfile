# ── Stage 1: Build ────────────────────────────
FROM composer:2.7 AS builder

WORKDIR /app

# Download Drupal 10 — ignore platform reqs because
# we install all extensions properly in stage 2
RUN composer create-project drupal/recommended-project:^10 . \
    --no-interaction \
    --no-dev \
    --ignore-platform-reqs

# Install Drush
RUN composer require drush/drush \
    --no-interaction \
    --ignore-platform-reqs


# ── Stage 2: Runtime ──────────────────────────
FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    nginx \
    mysql-client \
    git \
    curl \
    unzip \
    supervisor \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    icu-dev \
    oniguruma-dev \
    && rm -rf /var/cache/apk/*

# Install PHP extensions Drupal needs
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    opcache \
    intl \
    gd \
    zip \
    mbstring

# Copy Drupal files from builder stage
COPY --from=builder /app /var/www/html/drupal

# Copy config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set correct ownership
RUN chown -R www-data:www-data /var/www/html/drupal

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
