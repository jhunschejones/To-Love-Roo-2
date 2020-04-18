require "sinatra"
require "sinatra/activerecord"
require_relative "./config/environments"
Dir["#{File.dirname(__FILE__)}/app/**/*.rb"].each { |f| require_relative(f) }

use SessionsController
use NotesController

configure do
  enable :sessions
  set :session_secret, ENV["KEY_SECRET"]
end

configure :development do
  enable :logging
end

configure :production do
  set :host, "to-love-roo-2.herokuapp.com"
  set :force_ssl, true
end
