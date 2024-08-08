sudo chown -R ubuntu:ubuntu /var/www/html/slapp_data

cd /var/www/html/slapp_data

sudo apt install libpq-dev -y

bundle install
