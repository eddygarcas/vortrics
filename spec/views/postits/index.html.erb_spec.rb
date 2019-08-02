require 'rails_helper'

RSpec.describe "postits/index", type: :view do
  before(:each) do
    assign(:postits, [
        FactoryBot.create(:postit),
        FactoryBot.create(:postit)
    ])
  end


  it "renders a list of postits" do
    render

  end
end
