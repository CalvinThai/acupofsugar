web: bin/rails server -p $PORT -e $RAILS_ENV
release: bundle exec rails db:migrate
worker: bundle exec sidekiq -C config/sidekiq.yml
