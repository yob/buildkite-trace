module Buildkite
  module Trace
    class UnknownEvent
      def initialize(data)
        @data = data
      end

      def name
        @data.fetch("event", "")
      end

      def to_span
        nil
      end

    end
  end
end
