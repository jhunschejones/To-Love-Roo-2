require 'sinatra/base'

class NotesController < Sinatra::Base
  set :views, File.expand_path('../../views/', __FILE__)

  get '/' do
    authenticated do
      @current_user = User.find(session[:user_id])
      @other_user = @current_user.other_user
      erb :home
    end
  end

  get '/notes' do
    authenticated do
      content_type :json
      if params["query"] == "latest"
        NoteSerializer.new(Note.last).as_json
      elsif params["query"] == "random"
        NoteSerializer.new(Note.random).as_json
      else
        Note.all.map { |note| NoteSerializer.new(note).serializable_hash }.to_json
      end
    end
  end

  get '/notes/:id/previous' do
    authenticated do
      note = Note.previous(params[:id])

      content_type :json
      if note
        NoteSerializer.new(note).as_json
      else
        { error: { message: "There are no more notes." } }.to_json
      end
    end
  end

  post "/notes" do
    authenticated do
      request.body.rewind
      request_payload = JSON.parse(request.body.read, symbolize_names: true)
      halt 400 if request_payload[:text].length == 0

      content_type :json
      NoteSerializer.new(
        Note.create(
          text: request_payload[:text],
          creator_id: session[:user_id],
          recipient_id: User.find(session[:user_id]).other_user.id,
        )
      ).as_json
    end
  end

  def authenticated
    if session[:user_id]
      yield
    else
      redirect '/sessions/login'
    end
  end
end
