module Buildkite
  module Trace
    # A value object to hold the data we will submit to datadog
    class Span
      attr_reader :trace_id, :span_id, :parent_id, :name, :resource
      attr_reader :service, :type, :start, :duration, :metrics, :meta

      def initialize(trace_id:, span_id:, parent_id:, name:, resource:, service:, type:, start:, duration:, metrics:, meta:)
        @trace_id = trace_id
        @span_id = span_id
        @parent_id = parent_id
        @name = name
        @resource = resource
        @service = service
        @type = type
        @start = start
        @duration = duration
        @metrics = metrics
        @meta = meta
      end

      def to_hash
        {
          trace_id: trace_id,
          span_id: span_id,
          parent_id: parent_id,
          name: name,
          resource: resource,
          service: service,
          type: @type,
          start: start,
          duration: duration,
          metrics: metrics,
          meta: meta,
        }
      end
    end

  end
end
