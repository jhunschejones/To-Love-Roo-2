class NotesController < ApplicationController
  set :views, File.expand_path('../../views/notes', __FILE__)

  before do
    authenticate
  end

  # Get the home page
  get '/' do
    @current_user = User.find(session[:user_id])
    @other_user = @current_user.other_user
    erb :home
  end

  # Get all notes as JSON
  get '/notes' do
    content_type :json
    if params["query"] == "latest"
      NoteSerializer.new(Note.last).as_json
    elsif params["query"] == "random"
      NoteSerializer.new(Note.random).as_json
    else
      Note.all.map { |note| NoteSerializer.new(note).serializable_hash }.to_json
    end
  end

  # Get the note before a specific note ID
  get '/notes/:id/previous' do
    note = Note.previous(params[:id])

    content_type :json
    if note
      NoteSerializer.new(note).as_json
    else
      { error: { message: "There are no more notes." } }.to_json
    end
  end

  # Get the edit notes page
  get '/notes/:id/edit' do
    @current_user = User.find(session[:user_id])
    @note = Note.find(params[:id])
    return redirect '/' unless @note.creator_id.to_s == @current_user.id.to_s
    erb :edit
  rescue ActiveRecord::RecordNotFound
    redirect '/'
  end

  # Create a new note
  post '/notes' do
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

  # Update a note
  post '/notes/:id' do
    @note = Note.find(params[:id])
    @current_user = User.find(session[:user_id])
    halt 401 if @note.creator_id.to_s != @current_user.id.to_s
    halt 400 if params[:text].length == 0

    @note.update!(text: params[:text])
    redirect '/'
  rescue ActiveRecord::RecordNotFound
    redirect '/'
  end

  # Catch requests that do not match any routes but don't accidentally
  # catch requests for static assets
  get /(?!.*(.js|.css)).*/ do
    redirect '/'
  end
end
