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

  # supporting ?query=latest and ?query=random
  get '/notes' do
    authenticated do
      if params["query"] == "latest"
        note = Note.last
      else
        note = Note.order(Arel.sql('RANDOM()')).first
      end

      content_type :json
      {
        id: note.id,
        text: note.text,
        creatorName: User.find(note.creator_id).name,
        recipientName: User.find(note.recipient_id).name,
      }.to_json
    end
  end

  get '/notes/:id/previous' do
    authenticated do
      note = Note.previous(params[:id])

      content_type :json
      if note
        {
          id: note.id,
          text: note.text,
          creatorName: User.find(note.creator_id).name,
          recipientName: User.find(note.recipient_id).name,
        }.to_json
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

      note = Note.create(
        text: request_payload[:text],
        creator_id: session[:user_id],
        recipient_id: User.find(session[:user_id]).other_user.id,
      )

      content_type :json
      {
        id: note.id,
        text: note.text,
        creatorName: User.find(note.creator_id).name,
        recipientName: User.find(note.recipient_id).name,
      }.to_json
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
