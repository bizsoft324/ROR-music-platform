require 'rails_helper'
RSpec.describe Badge, type: :model do
  describe 'Associations' do
    it { should belong_to(:badge_duty) }
  end
end
