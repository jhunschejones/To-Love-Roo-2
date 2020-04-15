require 'sinatra/base'

class ApplicationController < Sinatra::Base
  before do
    redirect request.url.sub('http', 'https') if requires_https?
  end

  def authenticated
    if session[:user_id]
      yield
    else
      redirect '/sessions/login'
    end
  end

  private

  def requires_https?
    ENV['RACK_ENV'] == 'production' && request.host != "localhost" && !request.secure?
  end
end
