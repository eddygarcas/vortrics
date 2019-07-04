require 'rails_helper'

RSpec.describe "advices/index", type: :view do
  let(:team) { FactoryBot.create(:team)}
  let(:advices) { [
      FactoryBot.create(:advice),
      FactoryBot.create(:advice)
  ] }
  before(:each) do
    team.advices << advices
  end

  it "renders a list of advices" do
    @advice = Advice.new
    @team = team
    render
  end
end
