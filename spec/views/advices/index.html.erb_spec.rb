require 'rails_helper'

RSpec.describe "advices/index", type: :view do
  before(:each) do
    assign(:advices, [
        FactoryBot.create(:advice),
        FactoryBot.create(:advice)
    ])
  end

  it "renders a list of advices" do
    render
  end
end
