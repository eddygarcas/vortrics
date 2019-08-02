require 'rails_helper'

RSpec.describe "postits/show", type: :view do
  login_user
  before(:each) do
    @postit = assign(:postit, FactoryBot.create(:postit))
  end


  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(//)
  end
end
