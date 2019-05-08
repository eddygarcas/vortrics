require 'rails_helper'

RSpec.describe "comments/show", type: :view do
  login_user
  before(:each) do
    @comment = assign(:comment, FactoryBot.create(:comment))
    @advice = assign(:advice, FactoryBot.create(:advice))
  end

  it "renders attributes in <p>" do
    render
  end
end
