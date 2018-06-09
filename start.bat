call bundle exec bundle install
call bundle exec rake assets:precompile RAILS_ENV=production
call bundle exec rails server -b 0.0.0.0 -p 3000 -e production