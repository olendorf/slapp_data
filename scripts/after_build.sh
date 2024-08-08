sudo chown -R ubuntu:ubuntu /var/www/html/slapp_data

cd /var/www/html/slapp_data

sudo apt install libpq-dev -y

rbenv global 3.2.2

# sudo gem install bundler

ruby -v

bundle install
