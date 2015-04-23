require 'cucumber/website/events'
require 'cucumber/website/calendar'
require 'cucumber/website/page'
require 'cucumber/website/config'

module Cucumber::Website
  describe Events do
    include Config

    it "replaces event url with local page when we have one that matches" do
      ical = File.dirname(__FILE__) + '/events/lanyrd.ics'

      config = load_config('test')
      views_dir = File.dirname(__FILE__) + '/../apps/dynamic/views'
      event_pages = Page.all(config, views_dir).select(&:event?)

      events = Cucumber::Website::Events.new(event_pages, calendars=[Cucumber::Website::FakeCalendar.new(IO.read(ical))])
      cukeup_australia = events.to_a[1]
      expect(cukeup_australia.url.to_s).to eq('https://cukes.info/events/cukeup-australia-2015')
      expect(cukeup_australia.url.class).to eq(Icalendar::Values::Uri)
    end
  end
end
