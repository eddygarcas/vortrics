require 'rails_helper'

RSpec.describe Action, type: :model do
  describe '#belongs_to' do
    it { should belong_to :issue}
    it { should belong_to :advice}
  end
end
