web: bin/rails server -p $PORT -e $RAILS_ENV
release: bundle exec rails db:migrate
release: bundle exec rails db:reset
worker: bundle exec sidekiq -C config/sidekiq.yml
