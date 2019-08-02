require 'rails_helper'

RSpec.describe "Postits", type: :request do
  before do
    sign_in FactoryBot.create(:user)
    FactoryBot.create(:team)
  end
  describe "GET /postits" do
    it "works! (now write some real specs)" do
      get postits_path
      expect(response).to have_http_status(200)
    end
  end
end
