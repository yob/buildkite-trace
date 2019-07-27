require 'net/http'

module Buildkite
  module Trace
    class Client
      def initialize(hostname)
        @uri = URI("http://#{hostname}:8126/v0.3/traces")
      end

      def submit_trace(array_of_spans)
        array_of_traces = [array_of_spans]
        http = Net::HTTP.new(@uri.host, 8126)
        response = http.start do |http|
          request = Net::HTTP::Put.new(@uri.request_uri, { 'Content-Type' => 'application/json'})
          request.body = JSON.dump(array_of_traces)
          http.request(request)
        end
        response.code.to_i == 200
      end
    end
  end
end
