FROM isaacyung/rails:6.0.0.beta3

# Project Config
RUN mkdir /gobbler
WORKDIR /gobbler
COPY Gemfile /gobbler/Gemfile
COPY Gemfile.lock /gobbler/Gemfile.lock

RUN bundle install

COPY . /gobbler

RUN [ -f package-lock.json ] && rm package-lock.json || echo "package-lock.json not created"

RUN rm -rf gobbler/public/assets

RUN yarn install --check-files
RUN bundle exec rails webpacker:install

EXPOSE 3000

# Start the main process.
ENTRYPOINT ["rails", "server", "-e", "$RAILS_ENV", "-b", "0.0.0.0"]
