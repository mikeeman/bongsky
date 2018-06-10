#load env vars
. ./../deploy.sh
#kill old instance
read -r processid < ./tmp/pids/server.pid
kill $processid
#compile
bundle install
#run migrations
rake db:migrate
#precompile assets
rake assets:precompile RAILS_ENV=production
#start server as a service running in background
rails server -b 0.0.0.0 -p 3000 -e production -d
