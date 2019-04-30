require 'rails_helper'

RSpec.describe "advices/show", type: :view do
  before(:each) do
    @advice = assign(:advice, FactoryBot.create(:advice))
  end

  it "renders attributes in <p>" do
    render
  end
end
