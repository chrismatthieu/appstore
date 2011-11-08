source 'http://rubygems.org'

gem 'rails', '3.1.1'

gem 'omniauth', '~> 0.3.2'
gem 'twitter'

gem "will_paginate"
gem 'gravatar_image_tag', '1.0.0.pre2'
gem 'bcrypt-ruby'
gem 'rest-client'
gem 'json'

gem 'on_the_spot_in_tree', :git=>'https://github.com/ciscoriordan/on_the_spot_in_tree'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

group :deployment do
	gem 'mysql2'
end 

group :production do
	gem 'pg'
end 


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.1"
  gem 'coffee-rails', "~> 3.1.1"
  gem 'uglifier'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
