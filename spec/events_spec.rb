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
      events.sync

      cukeup_australia = events.to_a[1]
      expect(cukeup_australia.url.to_s).to eq('https://cukes.info/events/cukeup-australia-2015')
      expect(cukeup_australia.url.class).to eq(Icalendar::Values::Uri)
    end

    it "replaces page attributes with attributes from event" do
      ical = File.dirname(__FILE__) + '/events/lanyrd.ics'

      config = load_config('test')
      views_dir = File.dirname(__FILE__) + '/../apps/dynamic/views'
      event_pages = Page.all(config, views_dir).select(&:event?)

      events = Cucumber::Website::Events.new(event_pages, calendars=[Cucumber::Website::FakeCalendar.new(IO.read(ical))])
      events.sync

      cukeup_australia_page = event_pages.find {|page| page.title == 'CukeUp Australia'}
      expect(cukeup_australia_page).to_not be_nil
      expect(cukeup_australia_page.dtstart.strftime('%Y%m%d')).to eq('20151203')
      expect(cukeup_australia_page.dtend.strftime('%Y%m%d')).to eq('20151204')
    end

    it "updates after the ical feed changes" do
      ical = File.dirname(__FILE__) + '/events/lanyrd.ics'

      config = load_config('test')
      views_dir = File.dirname(__FILE__) + '/../apps/dynamic/views'
      event_pages = Page.all(config, views_dir).select(&:event?)

      calendars = [Cucumber::Website::FakeCalendar.new(IO.read(ical))]
      events = Cucumber::Website::Events.new(event_pages, calendars)
      events.sync

      calendars[0] = Cucumber::Website::FakeCalendar.new(IO.read(ical).gsub(/CukeUp Australia/m, 'CukeUp Australia Updated'))
      events.sync

      cukeup_australia_page = event_pages.find {|page| page.title == 'CukeUp Australia Updated'}
      expect(cukeup_australia_page).to_not be_nil
    end

  end
end
