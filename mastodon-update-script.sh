#!/bin/bash
#mastodon-update-script 
#wrote by nesosuke

### 
### Run on only your responsibilitity. 
###

### Conf values 
SKIP_POST_DEPLOYMENT_MIGRATIONS=true

### Update pkg(s) 
sudo apt update -y 
sudo apt upgrade -y 
cd ~/.rbenv/plugins/ruby-build && git pull && cd -
cd ~/live && git pull &
gem update --system
gem install bundler 
bundle install 
yarn install 

### Migrate  
RAILS_ENV=production ~/live/bin/tootctl cache clear
RAILS_ENV=production bundle exec rails assets:clobber 
RAILS_ENV=production bundle exec rails db:migrate 

sudo systemctl restart mastodon-*.service 

### Precompile
RAILS_ENV=production bundle exec rails assets:precompile 
RAILS_ENV=production bundle exec rails db:migrate  

### Restart mastodon-*.service ###
sudo systemctl restart mastodon-*.service nginx

### Clear cache 
RAILS_ENV=production bin/tootctl cache clear


# EOF
