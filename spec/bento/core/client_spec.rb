require 'spec_helper'

RSpec.describe Bento::Client do
  let(:client) { Bento::Client.new }

  describe '#get' do
    it 'sends a GET request with the correct endpoint' do
      conn = double('Faraday connection')
      allow(Faraday).to receive(:new).and_return(conn)
      expect(conn).to receive(:get).with('/test-endpoint')

      client.get('/test-endpoint')
    end
  end

  describe '#post' do
    it 'sends a POST request with the correct endpoint and payload' do
      conn = double('Faraday connection')
      allow(Faraday).to receive(:new).and_return(conn)
      expect(conn).to receive(:post).with('/test-endpoint', { key: 'value' })

      client.post('/test-endpoint', { key: 'value' })
    end
  end

  describe '#authorization' do
    it 'returns the correct authorization header' do
      allow(Bento).to receive(:publishable_key).and_return('publishable_key')
      allow(Bento).to receive(:secret_key).and_return('secret_key')

      expect(client.send(:authorization)).to eq('Basic publishable_key:secret_key')
    end
  end
end