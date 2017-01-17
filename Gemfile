source 'https://rubygems.org'
source 'https://rails-assets.org'


# Using ruby version
#ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.5'

# Use postgresql as the database for Active Record
# gem 'pg'

# Use mysql as the database for Active Record
gem 'mysql2'

# Bootstrap sass rails
gem "bootstrap-sass"

# Use SCSS for stylesheets
gem 'sass-rails'

# add browser vendor prefixes automatically
gem 'autoprefixer-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# ActiveRecord callbacks and Observers Alternative
gem 'wisper', '~>1.2.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Use jquery UI as the JavaScript library
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Jquery-Turbolins restore ready events when Turbolinks triggers the the page:load event. It may restore functionality of some libraries.
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Rails-Admin to admin administration
gem 'rails_admin'

# Devise to users authentication features
gem 'devise', "3.0.2"

# Omniauth connection
gem 'omniauth'

# Omniauth connection with twitter
gem 'omniauth-twitter'

# Twitter Bootstrap
#gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git', :branch => 'bootstrap3'

# Twitter Bootstrap Glyphicons
#gem 'bootstrap-glyphicons'

# This Rails gem helps creating forms for models with nested has_many associations. It uses jQuery to dynamically add and remove nested associations.
gem 'nested_form_fields'

# With ActsAsTaggableOn, you can tag a single model on several contexts, such as skills, interests, and awards. It also provides other advanced functionality.
gem "acts-as-taggable-on", "~> 3.0.1"

# Grape is a REST-like API micro-framework for Ruby. It's designed to run on Rack or complement existing web application frameworks such as Rails and Sinatra by providing a simple DSL to easily develop RESTful APIs
gem 'grape'


# Entities - a simple Facade to use with your models and API - extracted from Grape.
gem 'grape-entity'

# Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible.
gem 'rack-cors', :require => 'rack/cors'

# Atach files solution
gem 'carrierwave'

# Image processing for carrierwave
gem 'mini_magick'

# The Ruby cloud services library
gem 'fog'
gem 'unf'

# App Analitics
gem 'newrelic_rpm'

# Internationalization
gem 'rails-i18n', '~> 4.0.0' # For 4.0.x
# Ruby server library for the Pusher API http://pusher.com
gem 'pusher'

# Voting System
gem 'thumbs_up'

#A Ruby client that tries to match Redis' API one-to-one, while still providing an idiomatic interface.
gem 'redis', '~> 3.0.7'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  # Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema.
  gem 'annotate'

  gem 'rspec-rails', '2.13.1'

  # Format tables in Rails console
  gem 'hirb'

  # The Bullet gem is designed to help you increase your application’s performance by reducing the number of queries it makes.
  gem 'bullet'

  # Localtunnel lets you expose a local web server to the public Internet.
  # gem 'localtunnel'

  # Every Rails page has footnotes that gives information about your application and links back to your editor
  #gem 'rails-footnotes', git: 'git@github.com:tommireinikainen/rails-footnotes.git' # This repo has a fix for annoying logs [hash#diff deprecation warnings]
  #gem 'rails-footnotes', git: 'git://github.com/tommireinikainen/rails-footnotes.git' # This repo has a fix for annoying logs [hash#diff deprecation warnings]

  # Debugging tool


  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'

  gem 'capistrano-nginx-unicorn'

  gem "better_errors"
  gem "binding_of_caller"

end

group :development, :test do
  #Guard monitors changes in the filesystem so that, for example, when we change the static_pages_spec.rb file only those tests get run.
  gem 'guard-rspec', '2.5.0'
  gem 'byebug'
  # Spork loads the environment once, and then maintains a pool of processes for running future tests. Spork is particularly useful when combined with Guard
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.3.6'
end

group :test do
  gem 'cucumber-rails', :require => false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'

  gem 'selenium-webdriver', '2.35.1'
  gem 'capybara', '2.1.0'


  ##Needed to run Guard Properly
  #
  # Uncomment this line on OS X.
  # gem 'growl', '1.0.3'
  #
  # Uncomment these lines on Linux.
  gem 'libnotify', '0.8.0'
  #
  # Uncomment these lines on Windows.
  # gem 'rb-notifu', '0.0.4'
  # gem 'win32console', '1.3.2'
  # gem 'wdm', '0.1.0'
end

gem 'rails_12factor', group: :production

gem 'unicorn'

gem 'aasm'

gem 'geocoder'

gem 'localized_country_select', '>= 0.9.9'

gem "hashie-forbidden_attributes"
# gem "hashie_rails" # Added in order to avoid strong parameters security at model layer #[DEPRECATION] This gem has been renamed to hashie-forbidden_attributes

gem 'redis-objects'

gem 'fb_graph'

gem 'grape-rails-routes'
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
