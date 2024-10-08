# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.1
FROM ruby:$RUBY_VERSION-alpine AS base

# Install essential runtime packages for Ruby and Rails app
RUN apk add --no-cache \
    vips \
    tzdata \
    bash \
    gcompat \
    nodejs \
    postgresql-client \
    libpq

# Set working directory
WORKDIR /rails

# Set production environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    SECRET_KEY_BASE_DUMMY=1

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems and precompile assets
RUN apk add --no-cache --virtual .build-deps \
    build-base \
    git \
    postgresql-dev \
    vips-dev

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3 

# Clean up build artifacts
RUN set -x && \
    rm -rf /usr/local/bundle/cache/*.gem || true && \
    find /usr/local/bundle/gems/ -name "*.c" -delete || true && \
    find /usr/local/bundle/gems/ -name "*.o" -delete || true

# Copy application code
COPY . .

# Precompile bootsnap and assets
RUN bundle exec bootsnap precompile --gemfile && \
    bundle exec rails assets:precompile

# Remove build dependencies
RUN apk del .build-deps

# Final stage
FROM base

# Copy built gems and application code from the build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Set ownership and permissions
RUN adduser -h /rails -s /bin/sh -D rails && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Expose the port and start the server
EXPOSE 3000
CMD ["sh", "-c", "bin/rails db:prepare && bin/rails server -b 0.0.0.0"]