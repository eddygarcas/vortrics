require 'rails_helper'

RSpec.describe Advice, type: :model do

  describe '#validate instance of' do
    t = Advice.reflect_on_association(:team_advices)

    it "should have many team advices" do
      expect(t.macro).to eq(:has_many)
    end
    it "should validate presence of advice type" do
      ad_type = Advice.new
      expect(ad_type.advice_type).to be_falsey
    end
    it "should validate presence of subject" do
      ad_type = Advice.new
      expect(ad_type.subject).to be_falsey
    end
    it "should validate presence of description" do
      ad_type = Advice.new
      expect(ad_type.description).to be_falsey
    end
  end

  describe '#have_many' do
    it { should have_many :team_advices}
    it { should have_many :actions}
    it { should have_many :teams}
    it { should have_many :issues}
  end

  describe '#team_advices' do
    it { should validate_presence_of(:team_advices) }
  end
end
