class ApplicationController < Sinatra::Base
  before do
    redirect request.url.sub('http', 'https') if requires_https?
  end

  def authenticate
    @current_user = User.find_by(id: session[:user_id])
    redirect '/sessions/login' unless @current_user
  end

  private

  def requires_https?
    ENV['RACK_ENV'] == 'production' && request.host != "localhost" && !request.secure?
  end
end
