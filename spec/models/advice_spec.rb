require 'rails_helper'

RSpec.describe Advice, type: :model do

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
