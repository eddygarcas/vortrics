require 'rails_helper'

RSpec.describe "retrospectives/index", type: :view do
  before(:each) do
    assign(:retrospectives, [
      Retrospective.create!(
        :name => "Name",
        :position => 2,
        :team => nil
      ),
      Retrospective.create!(
        :name => "Name",
        :position => 2,
        :team => nil
      )
    ])
  end

  it "renders a list of retrospectives" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
