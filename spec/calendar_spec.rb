require 'cucumber/website/calendar'

module Cucumber::Website
  describe Calendar do
    let(:url) { File.expand_path(File.dirname(__FILE__) + '/events/lanyrd.ics') }
    let(:bad_url) { File.expand_path(File.dirname(__FILE__) + '/events/bad.ics') }
    let(:calendar) { Calendar.new(url, logger) }
    let(:logger) { double.as_null_object }

    it "starts out with no events" do
      expect(calendar.events).to be_empty
    end

    it "fetches events from the URL when refreshed" do
      expect(calendar.refresh.events).to_not be_empty
    end

    it "logs when refresh fails to parse the data" do
      bad_calendar = Calendar.new(bad_url, logger)
      expect(logger).to receive(:warn)
      bad_calendar.refresh
      expect(calendar.events).to be_empty
    end
  end
end
