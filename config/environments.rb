require 'sinatra/activerecord'

configure :production, :development do
  set :database_file, 'config/database.yml'
end
