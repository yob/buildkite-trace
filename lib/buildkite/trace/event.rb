require 'buildkite/trace/build_finished_event'
require 'buildkite/trace/unknown_event'
require 'json'

module Buildkite
  module Trace
    class Event
      def self.build(string)
        data = JSON.load(string)

        case data.fetch("event", "")
        when "build.finished" then
          BuildFinishedEvent.new(data)
        when "job.finished" then
          JobFinishedEvent.new(data)
        else
          UnknownEvent.new(data)
        end
      rescue JSON::ParserError
        UnknownEvent.new("event" => "error", "message" => "Invalid JSON", "body" => string)
      end
    end
  end
end
