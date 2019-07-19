require 'rails_helper'

RSpec.describe "cards/index", type: :view do
  before(:each) do
    assign(:cards, [
        FactoryBot.create(:card),
        FactoryBot.create(:card)
    ])
  end

  it "renders a list of cards" do
    render
  end
end
