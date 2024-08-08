sudo chown -R ubuntu:ubuntu /var/www/html/slapp_data

cd /var/www/html/slapp_data

sudo apt install libpq-dev -y
sudo apt update
sudo apt install -y git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev -y libffi-dev libgdbm-dev
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

rbenv install 3.2.2
rbenv global 3.2.2
echo "gem: --no-document" > ~/.gemrc

# sudo gem install bundler

ruby -v

bundle install
