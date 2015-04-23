module Cucumber
  module Website
    class Events
      include Enumerable

      def initialize(event_pages, calendars)
        @calendars = calendars
      end

      def each(&block)
        @calendars.each do |calendar|
          calendar.events.each &block
        end
      end
    end
  end
end
