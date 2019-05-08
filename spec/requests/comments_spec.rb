require 'rails_helper'

RSpec.describe "Comments", type: :request do
  before do
    sign_in FactoryBot.create(:user)

  end
  describe "GET /comments" do
    it "works! (now write some real specs)" do
      get comments_path(:json)
      expect(response).to have_http_status(200)
    end
  end
end
