require 'sinatra/base'
require 'buildkite/trace/event'
require 'buildkite/trace/client'

module Buildkite
  module Trace
    class App < Sinatra::Application
      get '/' do
        'Buildkite Trace Server'
      end

      post '/events' do
        request.body.rewind
        data = request.body.read
        event = Buildkite::Trace::Event.build(data)
        span = event.to_span
        if span
          puts span.to_hash.inspect
          trace_client = Buildkite::Trace::Client.new(datadog_hostname)
          trace_client.submit_trace([span.to_hash])
        end
      end

      private

      def datadog_hostname
        ENV.fetch("DATADOG_AGENT_HOST_IP", "127.0.0.1")
      end
    end
  end
end
