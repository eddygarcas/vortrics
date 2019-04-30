require 'rails_helper'

RSpec.describe "advices/edit", type: :view do
  before(:each) do
    @advice = assign(:advice, FactoryBot.create(:advice))
  end

  it "renders the edit advice form" do
    render

    assert_select "form[action=?][method=?]", advice_path(@advice), "post" do
    end
  end
end
