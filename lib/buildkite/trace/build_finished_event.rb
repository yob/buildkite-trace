require 'date'
require 'buildkite/trace/span'
require 'digest/crc64'

module Buildkite
  module Trace

    # Value object that wraps raw buildkite webhook data and provides convenience
    # methods for querying it
    class BuildFinishedEvent
      def initialize(data)
        @data = data
      end

      def name
        @data.fetch("event", "")
      end

      def pipeline_name
        @data.fetch("pipeline", {}).fetch("name", "")
      end

      def pipeline_slug
        @data.fetch("pipeline", {}).fetch("slug", "")
      end

      def build_id
        @data.fetch("build", {}).fetch("id", "")
      end

      def build_web_url
        @data.fetch("build", {}).fetch("web_url", "")
      end

      def passed?
        @data.fetch("build", {}).fetch("state", "") == "passed"
      end

      def build_branch
        @data.fetch("build", {}).fetch("branch", "")
      end

      def build_created_at
        value = @data.fetch("build", {}).fetch("created_at", nil)
        value ? DateTime.parse(value).to_time : nil
      end

      def build_started_at
        value = @data.fetch("build", {}).fetch("started_at", nil)
        value ? DateTime.parse(value).to_time : nil
      end

      def build_finished_at
        value = @data.fetch("build", {}).fetch("finished_at", nil)
        value ? DateTime.parse(value).to_time : nil
      end

      def to_span
        Span.new(
          trace_id: Digest::CRC64.checksum(build_id),
          span_id: Digest::CRC64.checksum(build_id) + 1,
          parent_id: nil,
          name: "build",
          resource: pipeline_slug,
          service: "buildkite",
          type: "custom",
          start: build_started_at.to_i * 1_000_000_000,
          duration: duration_in_secs * 1_000_000_000,
          metrics: {_sampling_priority_v1: 2},
          meta: {url: build_web_url, pipeline: pipeline_slug},
        )
      end

      private

      def duration_in_secs
        build_finished_at.to_i - build_started_at.to_i
      end

    end
  end
end
