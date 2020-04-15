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
        login_user
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
        login_user
        create_first_note
        create_second_note
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
    before do
      create_first_note
    end

    context "when no user is logged in" do
      it "redirects for login" do
        get "notes/#{Note.last.id}/previous"
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login")
      end
    end

    context "when a user is logged in" do
      before do
        login_user
      end

      context "when there is a previous note" do
        before do
          create_second_note
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

  describe "POST /notes" do
    before do
      create_first_note
      create_second_note
    end

    context "when no user is logged in" do
      it "redirects for login" do
        post '/notes', { text: "A new note", recipient_id: User.last.id, creator_id: User.first.id }.to_json
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login")
      end
    end

    context "when a user is logged in" do
      before do
        login_user
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
end
