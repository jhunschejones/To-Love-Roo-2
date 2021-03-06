require "newrelic_rpm"
require "sinatra"
require "sinatra/activerecord"
require_relative "./config/environments"
require_relative "./app/models/note"
require_relative "./app/models/user"
require_relative "./app/serializers/note_serializer"
require_relative "./app/controllers/application_controller"
require_relative "./app/controllers/sessions_controller"
require_relative "./app/controllers/notes_controller"

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
