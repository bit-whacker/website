module Cucumber
  module Website
    class Events
      include Enumerable

      def initialize(event_pages, calendars)
        @event_pages, @calendars = event_pages, calendars
      end

      def each(&block)
        events.each &block
      end

      # Updates iCal event urls with url to page
      # Updates event page attributes (title, location etc) with data from iCal event
      def sync
        @events = nil
        each do |event|
          matching_event_page = @event_pages.find do |event_page|
            event_page.ical_url == event.url.to_s
          end

          if matching_event_page
            event.url = Icalendar::Values::Uri.new(matching_event_page.url)

            matching_event_page.title   = event.summary
            # Dates are broken on Lanyrd: https://twitter.com/aslak_hellesoy/status/591272555035684864
            # Start dates is right, end date is wrong (!?!)
            # matching_event_page.dtstart = event.dtstart
            # matching_event_page.dtend   = event.dtend
          end
        end
      end

      def start
        @calendars.each do |calendar|
          Thread.new do
            loop do
              calendar.refresh
              sync
              sleep 1 # 1 minute
            end
          end
        end
      end

    private

      def events
        @events ||= @calendars.map(&:events).flatten
      end
    end
  end
end
