require "spec_helper"

module Bento
  class Analytics
    describe Analytics do
      let(:site_id) { "YOUR-SITE_ID" }
      let(:analytics) { Bento::Analytics.new(write_key: site_id) }

      it "#track: track a single event" do
        analytics.track(identity: {email: "user@yourapp.com"}, event: "$action", details: {action_information: "api_test"})
      end

      it '#track: should show error' do
      	expect { analytics.track(:user_id => 'user') }.to raise_error(ArgumentError)
      end

      it 'errors without a user_id' do
        expect { analytics.track(:event => 'Event') }.to raise_error(ArgumentError)
      end

      it 'errors if properties is not a hash' do
        expect {
          analytics.track({
            :user_id => 'user',
            :event => 'Event',
            :properties => [1, 2, 3]
          })
        }.to raise_error(ArgumentError)
      end
    end
  end
end
