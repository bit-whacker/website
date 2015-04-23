require 'open-uri'
require 'icalendar'

module Cucumber
  module Website
    class Calendar
      def initialize(url, logger)
        @url, @logger = url, logger
        @calendars = []
      end

      def events
        @calendars.map(&:events).flatten
      end

      def refresh
        @logger.debug "Fetching events from #{@url}"
        @calendars = Icalendar::Parser.new(open(@url), true).parse
        @logger.debug "Fetched #{events.length} events from #{@url}"
        self
      rescue => exception
        @logger.warn exception.to_s
      end
    end

    # Stub used for specs and scenarios
    class FakeCalendar
      def initialize(data)
        @data = data
      end

      def events
        calendars = Icalendar::Parser.new(@data, true).parse
        calendars.map(&:events).flatten
      end
    end
  end
end
