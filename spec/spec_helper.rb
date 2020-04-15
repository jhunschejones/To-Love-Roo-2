require 'rack/test'
require 'rspec'
require 'database_cleaner/active_record'
require 'rspec-html-matchers'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include RSpecHtmlMatchers

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

def session
  last_request.env['rack.session']
end

def login_user
  User.create(name: "test user", email: ENV["JOSHUA_EMAIL"], password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"])
  post '/sessions/login', {email: ENV["JOSHUA_EMAIL"], password: ENV["DEV_PASSWORD"]}
end

def create_first_note
  User.create(name: "test user", email: ENV["JOSHUA_EMAIL"], password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"])
  User.create(name: "test user", email: ENV["ROO_EMAIL"], password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"])
  Note.create(
    text: "The first note",
    recipient_id: User.where(email: ENV["ROO_EMAIL"]).first.id,
    creator_id: User.where(email: ENV["JOSHUA_EMAIL"]).first.id
  )
end

def create_second_note
  User.create(name: "test user", email: ENV["JOSHUA_EMAIL"], password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"])
  User.create(name: "test user", email: ENV["ROO_EMAIL"], password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"])
  Note.create(
    text: "The second note",
    recipient_id: User.where(email: ENV["ROO_EMAIL"]).first.id,
    creator_id: User.where(email: ENV["JOSHUA_EMAIL"]).first.id
  )
end
