require 'rails_helper'

RSpec.describe "retrospectives/new", type: :view do
  before(:each) do
    assign(:retrospective, Retrospective.new(
      :name => "MyString",
      :position => 1,
      :team => nil
    ))
  end

  it "renders new retrospective form" do
    render

    assert_select "form[action=?][method=?]", retrospectives_path, "post" do

      assert_select "input[name=?]", "retrospective[name]"

      assert_select "input[name=?]", "retrospective[position]"

      assert_select "input[name=?]", "retrospective[team_id]"
    end
  end
end
