source 'https://rubygems.org'

ruby '2.2.0'
# on heroku: Old: ruby 2.0.0p645 (2015-04-13 revision 50299) [x86_64-linux]
#            New: ruby 2.2.0p0 (2014-12-25 revision 49005) [x86_64-linux]

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

gem 'rails-i18n'

# Use PostGreSQL as the database for Active Record
gem 'pg'
gem 'rails_12factor', group: :production

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem "paperclip", "~> 4.2"

gem "rest-client"

# Amazon webservices S3
# newer version is buggy, see:
# http://ruby.awsblog.com/post/TxFKSK2QJE6RPZ/Upcoming-Stable-Release-of-AWS-SDK-for-Ruby-Version-2
gem 'aws-sdk', '< 2.0'
# Module for the 'fog' gem to support Amazon Web Services:
gem 'fog', require: 'fog/aws'

# TODO: use Refile instead of carrierwave? Refile is a modern file
# upload library for Ruby applications, Refile is an attempt by
# CarrierWave's original author to fix the design mistakes and
# overengineering in CarrierWave.
gem 'carrierwave'

gem "paranoia", "~> 2.0"
gem 'acts_as_votable', '~> 0.10.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'devise', '~> 3.4.1'
gem 'devise-i18n'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'cancancan', '~> 1.10'
# Use Unicorn as the app server
# gem 'unicorn'

gem 'puma' # used by Heroku instead of WebRick as Rails server

gem 'meta-tags'

gem 'default_value_for', '~> 3.0.0'

group :development, :test do
#  gem 'sunspot_rails'
#  gem 'sunspot_solr' # is the pre-packaged development version of Solr

  gem 'rspec-rails',        '~> 3.0',   :require => false
  gem 'factory_girl_rails', '~> 4.5.0', :require => false
  gem 'database_cleaner'
  gem 'faker'
  gem 'cucumber-rails',                 :require => false
  gem 'webrat'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry-rails'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'

#    gem 'debugger'
  gem 'better_errors', '~> 2.1.1'
#    gem 'binding_of_caller'
#    gem 'meta_request'
end

gem 'redcarpet'

# pagination
gem 'kaminari'

# animate.css
gem "animate-rails"

group :test do
  gem 'capybara'
#  gem 'capybara-firebug',   '~> 1.3.0'
#  gem 'selenium-webdriver', '~> 2.32.1'
#   gem 'poltergeist',        '~> 1.3.0'
#
#    gem "spork-rails", "~> 3.2.1"
end

gem 'sitemap_generator'

gem 'friendly_id', '~> 5.1.0'

# changes in Rails 5:
# this is to monitor the file system for changes in dev mode to know
# when the Rails application has to be reloaded during development
# see http://weblog.rubyonrails.org/2015/11/11/snappier-development-mode-in-rails-5/?utm_source=rubyweekly&utm_medium=email
# group :development do
#   gem 'listen', '~> 3.0.4'
# end
