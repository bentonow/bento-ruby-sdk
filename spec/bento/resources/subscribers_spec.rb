require 'spec_helper'

RSpec.describe Bento::Subscribers do
  email = "test@example.com"

  describe '.find' do
    it 'fetches one or many subscribers' do
      expect(described_class.find(email)).to eq('Subscriber')
    end
  end
  
  describe '.import' do
    it 'creates and updates users' do
      expect(described_class.import).to eq('Imported')
    end
  end
  
  describe '.create' do
    it 'creates a new subscriber' do
      expect(described_class.create(email)).to eq('Created subscriber')
    end
  end
end