class SessionsController < ApplicationController
  set :views, File.expand_path('../../views/sessions', __FILE__)

  ALERTS = { 'auth' => 'Username or password was incorrect' }

  # Get the login page
  get '/sessions/login' do
    if User.find_by(id: session[:user_id]).present?
      redirect '/'
    else
      @flash = { alert: ALERTS[params[:alert]] }
      erb :login
    end
  end

  # Post a login request
  post '/sessions/login' do
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      session.clear
      session[:user_id] = user.id.to_s
      redirect '/'
    else
      redirect '/sessions/login?alert=auth'
    end
  end

  # Log out
  delete '/sessions/logout' do
    session.clear
    redirect '/sessions/login'
  end
end
