source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.0'
gem 'bootstrap', '~> 4.0.0.beta'
gem 'bootstrap4-kaminari-views'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.3'
gem 'dotenv-rails'
gem 'draper', '~> 3.0', '>= 3.0.1'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'kaminari'
gem 'omniauth-google-oauth2', '~> 0.5.2'
gem 'page_number'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'pundit', '~> 1.1'
gem 'rails', '~> 5.1.3'
gem 'rails-patterns'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'responders', '~> 2.0'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'kaminari-rspec'
  gem 'pry-rails', '~> 0.3.6'
  gem 'rubocop', '~> 0.49.1', require: false
  gem 'rubocop', '~> 0.49.1', require: false
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'pundit-matchers', '~> 1.3.1'
  gem 'rspec-rails', '~> 3.6'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'vcr', '~> 3.0', '>= 3.0.3'
  gem 'webmock', '~> 3.0', '>= 3.0.1'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
