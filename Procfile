web: bin/rails server -p $PORT -e $RAILS_ENV
release: bundle exec rails db:migrate
release: rake assets:clobber
release: bundle exec rake assets:precompile
worker: bundle exec sidekiq -C config/sidekiq.yml