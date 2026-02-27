#!/bin/sh
set -e

echo "Waiting for MySQL to be ready..."
until mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" 2>/dev/null; do
  sleep 2
done
echo "MySQL is ready!"

DRUPAL_ROOT=/var/www/html/drupal

# Install Drupal if not already installed
if ! vendor/bin/drush --root=$DRUPAL_ROOT/web status | grep -q "Drupal bootstrap.*Successful"; then
  echo "Installing Drupal..."
  vendor/bin/drush --root=$DRUPAL_ROOT/web site-install standard \
    --db-url="mysql://$DB_USER:$DB_PASSWORD@$DB_HOST/$DB_NAME" \
    --site-name="$DRUPAL_SITE_NAME" \
    --account-name="$DRUPAL_ADMIN_USER" \
    --account-pass="$DRUPAL_ADMIN_PASS" \
    --account-mail="$DRUPAL_ADMIN_EMAIL" \
    --yes
  echo "Drupal installed!"
fi

# Start services via Supervisor
exec /usr/bin/supervisord -c /etc/supervisord.conf
