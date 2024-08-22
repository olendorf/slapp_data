sudo chown -R ubuntu:ubuntu /var/www/html/slapp_data

if command_exists rbenv
then
    echo 'rbenv found, no action needed'
else
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
    echo 'eval "$(rbenv init -)"' >> ~/.profile
    source /home/ubuntu/.profile
fi

rbenv install 3.2.2
rbenv global 3.2.2
echo "gem: --no-document" > ~/.gemrc

# sudo gem install bundler




cd /var/www/html/slapp_data

bundle install

rails db:migrate RAILS_ENV=sl_development

