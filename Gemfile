# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.4"

gem "falcon"
gem "grumlin"

gem "bootsnap", require: false

group :test do
  gem "async-rspec"
  gem "simplecov", require: false
end

group :development, :test do
  gem "dead_end"
  gem "debug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
end

group :development do
  gem "overcommit", require: false
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "solargraph", require: false
end
