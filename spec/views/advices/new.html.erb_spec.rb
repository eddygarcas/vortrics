require 'rails_helper'

RSpec.describe "advices/new", type: :view do
  before(:each) do
    assign(:advice, Advice.new())
  end

  it "renders new advice form" do
    render

    assert_select "form[action=?][method=?]", advices_path, "post" do
    end
  end
end
