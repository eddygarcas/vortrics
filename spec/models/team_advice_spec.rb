require 'rails_helper'

RSpec.describe TeamAdvice, type: :model do
  describe '#belongs_to' do
    it { should belong_to :team}
    it { should belong_to :advice}
    end
end
