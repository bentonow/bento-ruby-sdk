require "spec_helper"

module Bento
  class Analytics
    describe Analytics do
      let(:site_id) { "YOUR-SITE_ID" }
      let(:analytics) { Bento::Analytics.new(write_key: site_id) }

      it "#track: track a single event" do
        analytics.track(identity: {email: "user@yourapp.com"}, event: "$action", details: {action_information: "api_test"})
      end
    end
  end
end
