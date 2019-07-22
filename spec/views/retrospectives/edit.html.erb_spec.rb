require 'rails_helper'

RSpec.describe "retrospectives/edit", type: :view do
  before(:each) do
    @retrospective = assign(:retrospective, Retrospective.create!(
      :name => "MyString",
      :position => 1,
      :team => nil
    ))
  end

  it "renders the edit retrospective form" do
    render

    assert_select "form[action=?][method=?]", retrospective_path(@retrospective), "post" do

      assert_select "input[name=?]", "retrospective[name]"

      assert_select "input[name=?]", "retrospective[position]"

      assert_select "input[name=?]", "retrospective[team_id]"
    end
  end
end
