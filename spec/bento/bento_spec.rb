require 'spec_helper'
require 'bento-sdk'

describe Bento do
  it "has a version number" do
    expect(Bento::VERSION).not_to be nil
  end

  describe 'configures Bento using configure block ' do
    before do
      Bento.configure do |config|
        config.site_uuid = 'site_uuid'
        config.publishable_key = 'publishable_key'
        config.secret_key = 'secret_key'
      end
    end

    it 'sets the site_uuid' do
      expect(Bento.config.site_uuid).to eq('site_uuid')
    end

    it 'sets the publishable_key' do
      expect(Bento.config.publishable_key).to eq('publishable_key')
    end

    it 'sets the secret_key' do
      expect(Bento.config.secret_key).to eq('secret_key')
    end
  end

  describe 'environment variable configuration' do
    before do
      ENV['BENTO_SITE_UUID'] = 'site_uuid'
      ENV['BENTO_PUBLISHABLE_KEY'] = 'publishable_key'
      ENV['BENTO_SECRET_KEY'] = 'secret_key'
    end

    it 'sets the site_uuid from ENV' do
      expect(Bento.config.site_uuid).to eq('site_uuid')
    end

    it 'sets the publishable_key from ENV' do
      expect(Bento.config.publishable_key).to eq('publishable_key')
    end

    it 'sets the secret_key from ENV' do
      expect(Bento.config.secret_key).to eq('secret_key')
    end
  end  
end