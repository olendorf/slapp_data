sudo chown -R ubuntu:ubuntu /var/www/html/slapp_data

sudo apt -y install nodejs npm libreadline-dev zlib1g-dev
sudo npm install -g n

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# sudo apt-get -y install rbenv ruby-build

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

ruby -v


cd /var/www/html/slapp_data

bundle install
