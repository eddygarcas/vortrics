source 'https://rubygems.org'
ruby "2.6.3"
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

source "https://gems.kiso.io/" do
  gem "dresssed-ives", "~> 1.0.67"
end
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
gem "rack", ">= 2.0.7"
gem "loofah", ">= 2.2.3"
gem "rubyzip", ">= 1.3.0"
gem "ffi", ">= 1.11.3"

# Use Puma as the app server
gem "puma", ">= 4.3.3"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '>= 5.0.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', github: 'rails/jbuilder', branch: 'master'

# Use ActiveModel has_secure_password
gem 'will_paginate', '~> 3.1.0'
gem 'bootstrap-datepicker-rails', :require => 'bootstrap-datepicker-rails',:git => 'https://github.com/Nerian/bootstrap-datepicker-rails.git'
gem "sweet-alert", git: "https://github.com/frank184/sweet-alert-rails"
gem "sweet-alert-confirm", git: "https://github.com/humancopy/sweet-alert-rails-confirm"
gem 'acts_as_list'

gem 'jira-ruby', '1.7.0', :require => 'jira-ruby'

gem "devise", ">= 4.7.1"
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection', '~> 0.1'

gem 'jquery-rails', '~> 4.3.1'
gem 'jquery-ui-rails','~> 6.0.1'
gem 'rails-ujs'

gem 'resque'
gem 'business_time'

gem 'webpacker', '~> 4.x'

gem 'montecasting', '>= 0.6.5'


group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'test-unit'
  gem 'mocha'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '4.0.0.beta2'
  gem 'rails-controller-testing'
  gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
  gem 'shoulda-matchers', '~> 3.0', require: false
  gem 'database_cleaner', '~> 1.5'
  gem 'webmock'
  gem 'vcr'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'awesome_print'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  # Use Redis adapter to run Action Cable in production
  gem 'redis', '~> 4.1.3'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
