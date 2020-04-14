require 'sinatra/base'

class SessionsController < Sinatra::Base
  set :views, File.expand_path('../../views/sessions', __FILE__)

  get '/sessions/login' do
    if session[:user_id]
      redirect '/'
    else
      erb :login
    end
  end

  post '/sessions/login' do
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      session.clear
      session[:user_id] = user.id.to_s
      redirect '/'
    else
      @error = 'Username or password was incorrect'
      erb :login
    end
  end

  delete '/sessions/logout' do
    session.clear
    redirect '/sessions/login'
  end
end
