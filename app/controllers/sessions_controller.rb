class SessionsController < ApplicationController
  set :views, File.expand_path('../../views/sessions', __FILE__)

  ALERTS = { 'auth' => 'Username or password was incorrect' }

  get '/sessions/login' do
    if session[:user_id]
      redirect '/'
    else
      @flash = { alert: ALERTS[params[:alert]] }
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
      redirect '/sessions/login?alert=auth'
    end
  end

  delete '/sessions/logout' do
    session.clear
    redirect '/sessions/login'
  end
end
