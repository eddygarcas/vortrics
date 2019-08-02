require 'rails_helper'

RSpec.describe "postits/edit", type: :view do
  before(:each) do
    @postit = assign(:postit, FactoryBot.create(:postit))
  end

  it "renders the edit postit form" do
    render

    assert_select "form[action=?][method=?]", postit_path(@postit), "post" do

      assert_select "input[name=?]", "postit[text]"

      assert_select "input[name=?]", "postit[position]"

      assert_select "input[name=?]", "postit[dots]"

      assert_select "input[name=?]", "postit[comments]"

      assert_select "input[name=?]", "postit[retrospective]"
    end
  end
end
