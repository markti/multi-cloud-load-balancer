#!/bin/bash

set -e

echo "Rendering HTML with COLOR='$CUSTOM_COLOR' and MESSAGE='$CUSTOM_MESSAGE'"

sed -e "s|{{COLOR}}|${CUSTOM_COLOR}|" \
    -e "s|{{MESSAGE}}|${CUSTOM_MESSAGE}|" \
    /tmp/index.html.tpl > /var/www/html/index.nginx-debian.html

# Ensure correct permissions
chown www-data:www-data /var/www/html/index.nginx-debian.html
chmod 644 /var/www/html/index.nginx-debian.html