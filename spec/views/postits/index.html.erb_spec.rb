require 'rails_helper'

RSpec.describe "postits/index", type: :view do
  before(:each) do
    assign(:postits, [
      Postit.create!(
        :text => "Text",
        :position => 2,
        :dots => 3,
        :comments => 4,
        :Retrospective => nil
      ),
      Postit.create!(
        :text => "Text",
        :position => 2,
        :dots => 3,
        :comments => 4,
        :Retrospective => nil
      )
    ])
  end

  it "renders a list of postits" do
    render
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
