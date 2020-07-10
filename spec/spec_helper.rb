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

def login_user_joshua
  User.create_with(name: "test user", password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"]).find_or_create_by(email: ENV["JOSHUA_EMAIL"])
  post '/sessions/login', {email: ENV["JOSHUA_EMAIL"], password: ENV["DEV_PASSWORD"]}
end

def login_user_roo
  User.create_with(name: "test user", password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"]).find_or_create_by(email: ENV["ROO_EMAIL"])
  post '/sessions/login', {email: ENV["ROO_EMAIL"], password: ENV["DEV_PASSWORD"]}
end

def create_one_note
  joshua = User.create_with(name: "test user", password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"]).find_or_create_by(email: ENV["JOSHUA_EMAIL"])
  roo = User.create_with(name: "test user", password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"]).find_or_create_by(email: ENV["ROO_EMAIL"])
  Note.create(
    text: "The first note",
    recipient_id: joshua.id,
    creator_id: roo.id
  )
end

def create_two_notes
  joshua = User.create_with(name: "test user", password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"]).find_or_create_by(email: ENV["JOSHUA_EMAIL"])
  roo = User.create_with(name: "test user", password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"]).find_or_create_by(email: ENV["ROO_EMAIL"])
  Note.create(
    text: "The first note",
    recipient_id: roo.id,
    creator_id: joshua.id
  )
  Note.create(
    text: "The second note",
    recipient_id: roo.id,
    creator_id: joshua.id
  )
end

def create_two_users
  User.create_with(name: "test user", password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"]).find_or_create_by(email: ENV["JOSHUA_EMAIL"])
  User.create_with(name: "test user", password: ENV["DEV_PASSWORD"], password_confirmation: ENV["DEV_PASSWORD"]).find_or_create_by(email: ENV["ROO_EMAIL"])
end
