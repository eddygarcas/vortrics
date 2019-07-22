require 'rails_helper'

RSpec.describe "postits/new", type: :view do
  before(:each) do
    assign(:postit, Postit.new(
      :text => "MyString",
      :position => 1,
      :dots => 1,
      :comments => 1,
      :Retrospective => nil
    ))
  end

  it "renders new postit form" do
    render

    assert_select "form[action=?][method=?]", postits_path, "post" do

      assert_select "input[name=?]", "postit[text]"

      assert_select "input[name=?]", "postit[position]"

      assert_select "input[name=?]", "postit[dots]"

      assert_select "input[name=?]", "postit[comments]"

      assert_select "input[name=?]", "postit[Retrospective_id]"
    end
  end
end
