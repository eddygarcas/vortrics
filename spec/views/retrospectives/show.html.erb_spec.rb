require 'rails_helper'

RSpec.describe "retrospectives/show", type: :view do
  before(:each) do
    @retrospective = assign(:retrospective, Retrospective.create!(
      :name => "Name",
      :position => 2,
      :team => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
