require 'rails_helper'

RSpec.describe "comments/index", type: :view do
  login_user
  before(:each) do
    assign(:comments, [
      FactoryBot.create(:comment),
      FactoryBot.create(:comment)
    ])
  end

  it "renders a list of comments" do
    render
  end
end
