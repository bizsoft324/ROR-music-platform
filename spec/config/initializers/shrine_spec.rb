require 'spec_helper'

RSpec.describe Shrine do
  context 'all environments' do
    it 'allows a max file size of 10 megabytes' do
      expect(Shrine::MAX_FILESIZE).to eq(10.megabytes)
    end

    it 'it registers :cache storage' do
      expect(Shrine.storages).to include(:cache)
    end

    it 'registers :store storage' do
      expect(Shrine.storages).to include(:store)
    end
  end

  context 'when local' do
  end
end
