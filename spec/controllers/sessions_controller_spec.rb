require_relative '../spec_helper'

describe SessionsController do
  let(:test_url) { "http://example.org" }

  it "gets the login page when no user is signed in" do
    get '/sessions/login'
    expect(last_response).to be_ok
  end

  it "redirects home when a user is already signed in" do
    login_user
    get '/sessions/login'
    expect(last_response).to be_redirect
    expect(last_response.location).to eq("#{test_url}/")
  end

  context "when logging in" do
    context "with invalid credentails" do
      before do
        post '/sessions/login', {email: ENV["JOSHUA_EMAIL"], password: "bad password"}
      end

      it "does not log in the user" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects with auth alert" do
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/sessions/login?alert=auth")
      end

      it "displays correct flash alert" do
        follow_redirect!
        expect(last_response.body).to have_tag(:div, class: "notification is-danger", text: "Username or password was incorrect")
      end
    end

    context "with valid credentials" do
      before do
        login_user
      end

      it "logs in the user" do
        expect(session[:user_id]).not_to be_nil
      end

      it "redirects to home page" do
        expect(last_response).to be_redirect
        expect(last_response.location).to eq("#{test_url}/")
      end
    end
  end

  context "when logging out" do
    before do
      login_user
      delete '/sessions/logout'
    end
    it "logs out the user" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to login page" do
      expect(last_response).to be_redirect
      expect(last_response.location).to eq("#{test_url}/sessions/login")
    end
  end
end
