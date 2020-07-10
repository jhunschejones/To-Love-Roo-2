require_relative '../spec_helper'

describe NotesController do
  let(:test_url) { "http://example.org" }

  describe "GET /" do
    context "when no user is logged in" do
      it "redirects for login" do
        get '/'
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login")
      end
    end

    context "when a user is logged in" do
      before do
        login_user_joshua
      end

      it "loads the notes page" do
        get '/'
        expect(last_response).to be_ok
      end
    end
  end

  describe "GET /notes" do
    context "when no user is logged in" do
      it "redirects for login" do
        get '/notes'
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login")
      end
    end

    context "when a user is logged in" do
      before do
        login_user_joshua
        create_two_notes
      end

      context "with no params" do
        before do
          get '/notes'
        end

        it "returns json" do
          expect(last_response.headers.first).to eq(["Content-Type", "application/json"])
        end

        it "returns a list of all notes" do
          expect(JSON.parse(last_response.body).size).to eq(2)
        end
      end

      context "with ?query=latest" do
        before do
          get '/notes?query=latest'
        end

        it "returns json" do
          expect(last_response.headers.first).to eq(["Content-Type", "application/json"])
        end

        it "gets the latest note" do
          expect(JSON.parse(last_response.body)["text"]).to eq("The second note")
        end
      end

      context "with ?query=random" do
        before do
          get '/notes?query=random'
        end

        it "returns json" do
          expect(last_response.headers.first).to eq(["Content-Type", "application/json"])
        end

        it "gets a random note" do
          expect(JSON.parse(last_response.body)["text"]).to eq("The first note").or eq("The second note")
        end
      end
    end
  end

  describe "GET /notes/:id/previous" do
    context "when no user is logged in" do
      before do
        create_one_note
      end

      it "redirects for login" do
        get "notes/#{Note.last.id}/previous"
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login")
      end
    end

    context "when admin is logged in" do
      before do
        login_user_joshua
      end

      context "when there is a previous note" do
        before do
          create_two_notes
          get "notes/#{Note.last.id}/previous"
        end

        it "returns json" do
          expect(last_response.headers.first).to eq(["Content-Type", "application/json"])
        end

        it "returns the previous note" do
          expect(JSON.parse(last_response.body)["id"]).to eq(Note.first.id)
        end
      end

      context "when there is no previous note" do
        before do
          create_one_note
          get "notes/#{Note.first.id}/previous"
        end

        it "returns json" do
          expect(last_response.headers.first).to eq(["Content-Type", "application/json"])
        end

        it "returns an error message" do
          expect(JSON.parse(last_response.body)["error"]["message"]).to eq("There are no more notes.")
        end
      end
    end
  end

  describe "GET /notes/:id/next" do
    context "when no user is logged in" do
      before do
        create_one_note
      end

      it "redirects for login" do
        get "notes/#{Note.first.id}/next"
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login")
      end
    end

    context "when admin is logged in" do
      before do
        login_user_joshua
      end

      context "when there is a next note" do
        before do
          create_two_notes
          get "notes/#{Note.first.id}/next"
        end

        it "returns json" do
          expect(last_response.headers.first).to eq(["Content-Type", "application/json"])
        end

        it "returns the previous note" do
          expect(JSON.parse(last_response.body)["id"]).to eq(Note.all[1].id)
        end
      end

      context "when there is no next note" do
        before do
          create_one_note
          get "notes/#{Note.last.id}/next"
        end

        it "returns json" do
          expect(last_response.headers.first).to eq(["Content-Type", "application/json"])
        end

        it "returns an error message" do
          expect(JSON.parse(last_response.body)["error"]["message"]).to eq("There are no more notes.")
        end
      end
    end
  end

  describe "GET /notes/:id/edit" do
    before do
      create_two_notes
    end

    context "when no user is logged in" do
      it "redirects for login" do
        get "/notes/#{Note.last.id}/edit"
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login")
      end
    end

    context "when user is logged in" do
      before do
        login_user_roo
      end

      it "redirects to home page" do
        get "/notes/#{Note.last.id}/edit"
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/")
      end
    end

    context "when admin user is logged in" do
      before do
        login_user_joshua
      end

      it "loads the edit page for the note" do
        get "/notes/#{Note.last.id}/edit"
        expect(last_response).to be_ok
      end

      it "redirects to home page if note does not exist" do
        get "/notes/#{Note.last.id + 1}/edit"
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/")
      end
    end
  end

  describe "POST /notes" do
    before do
      create_two_users
    end

    context "when no user is logged in" do
      it "redirects for login" do
        post '/notes', { text: "A new note", recipient_id: User.last.id, creator_id: User.first.id }.to_json
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login")
      end
    end

    context "when user is logged in" do
      before do
        login_user_roo
      end

      it "returns 401" do
        post '/notes', { text: "A new note", recipient_id: User.last.id, creator_id: User.first.id }.to_json
        expect(last_response.status).to eq(401)
      end
    end

    context "when admin user is logged in" do
      before do
        login_user_joshua
      end

      it "creates a note" do
        origional_note_count = Note.count
        post '/notes', { text: "A new note", recipient_id: User.last.id, creator_id: User.first.id }.to_json
        expect(Note.count).to eq(origional_note_count + 1)
      end

      it "returns json" do
        post '/notes', { text: "A new note", recipient_id: User.last.id, creator_id: User.first.id }.to_json
        expect(last_response.headers.first).to eq(["Content-Type", "application/json"])
      end

      it "returns the new note" do
        post '/notes', { text: "A new note", recipient_id: User.last.id, creator_id: User.first.id }.to_json
        expect(JSON.parse(last_response.body)["text"]).to eq("The first note").or eq("A new note")
      end
    end
  end

  describe "POST /notes/:id" do
    before do
      create_two_notes
    end

    context "when no user is logged in" do
      it "redirects for login" do
        post "/notes/#{Note.last.id}", { text: "An updated note" }.to_json
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login")
      end
    end

    context "when user is logged in" do
      before do
        login_user_roo
      end

      it "returns 401" do
        post "/notes/#{Note.last.id}", { text: "An updated note" }
        expect(last_response.status).to eq(401)
      end
    end

    context "when admin user is logged in" do
      before do
        login_user_joshua
      end

      it "returns 400 on empty note text" do
        starting_note_text = Note.last.text
        post "/notes/#{Note.last.id}", { text: "" }
        expect(Note.last.text).to eq(starting_note_text)
        expect(last_response.status).to eq(400)
      end

      it "updates the note with note text" do
        post "/notes/#{Note.last.id}", { text: "An updated note" }
        expect(Note.last.text).to eq("An updated note")
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/")
      end

      it "redirects to home page if note does not exist" do
        post "/notes/#{Note.last.id + 1}", { text: "An updated note" }
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/")
      end
    end
  end

  describe "catch all route" do
    context "when no user is logged in" do
      it "redirects for login" do
        get "/surprise/monsters"
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login")
      end
    end

    context "when a user is logged in" do
      before do
        login_user_joshua
      end

      it "redirects to home page for non-matching route" do
        get "/surprise/monsters"
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/")
      end
    end
  end
end
