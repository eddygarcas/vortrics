require 'rails_helper'

RSpec.describe "Retrospectives", type: :request do
  describe "GET /retrospectives" do
    it "works! (now write some real specs)" do
      get retrospectives_path
      expect(response).to have_http_status(200)
    end
  end
end
