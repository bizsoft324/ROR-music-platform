require 'rails_helper'

RSpec.describe Track::Charted, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:track) }
  end
end
