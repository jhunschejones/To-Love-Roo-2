class ApplicationController < Sinatra::Base
  before do
    redirect request.url.sub('http', 'https') if requires_https?
  end

  def authenticate
    redirect '/sessions/login' unless session[:user_id]
  end

  private

  def requires_https?
    ENV['RACK_ENV'] == 'production' && request.host != "localhost" && !request.secure?
  end
end
