# Use Ruby 3.4.5 as base image
FROM ruby:3.4.5-slim

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    curl \
    git \
    nodejs \
    npm \
    sqlite3 \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Yarn
RUN npm install -g yarn

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY tmp/development_apps/rails_80/Gemfile tmp/development_apps/rails_80/Gemfile.lock ./

# Install Ruby dependencies
RUN bundle config --global frozen 1 && \
    bundle config --global without 'development test' && \
    bundle install

# Copy package.json and yarn.lock
COPY tmp/development_apps/rails_80/package.json tmp/development_apps/rails_80/yarn.lock ./

# Install Node.js dependencies
RUN yarn install --frozen-lockfile

# Copy the entire application
COPY tmp/development_apps/rails_80/ .

# Copy ActiveAdmin gem files
COPY . /activeadmin
RUN bundle config --local local.activeadmin /activeadmin

# Precompile assets
RUN bundle exec rails assets:precompile

# Create a non-root user
RUN groupadd -r rails && useradd -r -g rails rails
RUN chown -R rails:rails /app
USER rails

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/admin || exit 1

# Start the application
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
