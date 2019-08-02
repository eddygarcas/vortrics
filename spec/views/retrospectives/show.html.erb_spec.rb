require 'rails_helper'

RSpec.describe "retrospectives/show", type: :view do
  before(:each) do
    @retrospective = assign(:retrospective, FactoryBot.create(:retrospective))
  end
  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
