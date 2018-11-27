#!/bin/bash
#mastodon-update-script 
#wrote by nesosuke

### 
### Run on only your responsibilitity. 
###

### Conf values 
. ~/access_token


### Def. func toot ###
function toot () { curl -X POST -d "access_token=$ACCESS_TOKEN&status=$1" -Ss https://$DOMAIN/api/v1/statuses ; }

### Update pkg(s) 
toot ":neso: < update script is starting... at $(date)"
cd ~/live 
sudo apt update -y 
sudo apt upgrade -y 
cd ~/.rbenv/plugins/ruby-build && git pull && cd -
gem install bundler 
bundle install 
yarn install 

# (?) only need to v2.5.0 (c.f. https://github.com/tootsuite/mastodon/releases/tag/v2.5.0)
#SKIP_POST_DEPLOYMENT_MIGRATIONS=true RAILS_ENV=production bundle exec rails db:migrate

# Migrate  
RAILS_ENV=production bundle exec rails assets:clobber 
toot ":neso: < migration starting at $(date)"
RAILS_ENV=production bundle exec rails db:migrate 


### Precompile
toot ":neso: < precompiling started at $(date)" 
RAILS_ENV=production bundle exec rails assets:precompile 
toot ":neso: < precompiling finished at $(date)" 


### Restart mastodon-*.service ###
sudo systemctl restart mastodon-*.service nginx
sleep 5 && toot ":neso: < services restarting..." 

#v2.5.0に伴い追加 20180903
#toot ":neso: < migration starting at $(date)"
#RAILS_ENV=production bundle exec rails db:migrate
#toot ":neso: < migration finished at $(date)"

### Toot the end of script ###
toot ":neso: < The update script is ending at $(date)"


# EOF
