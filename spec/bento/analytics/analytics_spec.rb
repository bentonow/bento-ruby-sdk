require "spec_helper"

module Bento
  class Analytics
    describe Analytics do
      let(:site_id) { "YOUR-SITE_ID" }
      let(:analytics) { Bento::Analytics.new(write_key: site_id) }
      let(:queue) { analytics.instance_variable_get :@queue }

      it "#track: track a single event" do
        analytics.track(
        	identity: {email: "user@yourapp.com"}, 
        	event: "$action", 
        	details: {action_information: "api_test"}
       	)
      end

      it "#track: update a users custom field" do
      	analytics.track(
      		identity: {email: "user@yourapp.com"}, 
      		event: '$update_details', 
      		custom_fields: {favourite_meal: "bento box"}
      	)
      end

      it "#track: tag a visitor" do
      	analytics.track(
      		identity: {email: "user@yourapp.com"}, 
      		event: '$tag', 
      		details: {tag: "customer"}
      	)
      end

      it '#track: track a unique event and add LTV' do
      	analytics.track(
      		identity: {email: "user@yourapp.com"}, 
      		event: '$payment', 
      		details: {value: {amount: 1234, currency: "USD"},
      		unique: {key: "unique-identifier"}}
      	)
      end

      it '#track: track a pageview server-side' do
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
