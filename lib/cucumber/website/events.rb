module Cucumber
  module Website
    class Events
      include Enumerable

      def initialize(event_pages, calendars)
        @event_pages, @calendars = event_pages, calendars
      end

      def each(&block)
        @calendars.each do |calendar|
          calendar.events.each do |event|
            matching_event_page = @event_pages.find do |event_page|
              result = event_page.ical_url == event.url.to_s
            end

            if matching_event_page
              event.url = Icalendar::Values::Uri.new(matching_event_page.url)
              matching_event_page.title = event.summary
            end
            block.call(event)
          end
        end
      end

      def start
        @calendars.each do |calendar|
          Thread.new do
            loop do
              calendar.refresh
              sleep 60 # 1 minute
            end
          end
        end
      end
    end
  end
end
