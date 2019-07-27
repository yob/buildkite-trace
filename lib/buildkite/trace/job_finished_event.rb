require 'date'
require 'buildkite/trace/span'
require 'digest/crc64'

module Buildkite
  module Trace
    # Value object that wraps raw buildkite webhook data and provides convenience
    # methods for querying it
    class JobFinishedEvent
      def initialize(data)
        @data = data
      end

      def name
        @data.fetch("event", "")
      end

      def job_id
        @data.fetch("job", {}).fetch("id","")
      end

      def job_name
        @data.fetch("job", {}).fetch("name","")
      end

      def job_slug
        slugorize(job_name)
      end

      def job_state
        @data.fetch("job", {}).fetch("state","")
      end

      def job_web_url
        @data.fetch("job", {}).fetch("web_url","")
      end

      def job_started_at
        value = @data.fetch("job", {}).fetch("started_at", nil)
        value ? DateTime.parse(value).to_time : nil
      end

      def job_finished_at
        value = @data.fetch("job", {}).fetch("finished_at", nil)
        value ? DateTime.parse(value).to_time : nil
      end

      def agent_name
        @data.fetch("job", {}).fetch("agent",{}).fetch("name","")
      end

      def agent_hostname
        @data.fetch("job", {}).fetch("agent",{}).fetch("hostname","")
      end

      def build_id
        @data.fetch("build", {}).fetch("id","")
      end

      def build_branch
        @data.fetch("build", {}).fetch("branch","")
      end

      def pipeline_name
        @data.fetch("pipeline", {}).fetch("name", "")
      end

      def pipeline_slug
        @data.fetch("pipeline", {}).fetch("slug", "")
      end

      def to_span
        Span.new(
          trace_id: Digest::CRC64.checksum(build_id),
          span_id: Digest::CRC64.checksum(job_id),
          parent_id: Digest::CRC64.checksum(build_id) + 1,
          name: "build.job",
          resource: job_name,
          service: "buildkite",
          type: "custom",
          start: job_started_at.to_i * 1_000_000_000,
          duration: duration_in_secs * 1_000_000_000,
          metrics: {_sampling_priority_v1: 2},
          meta: {url: job_web_url, pipeline: pipeline_slug},
        )
      end

      private

      def duration_in_secs
        job_finished_at.to_i - job_started_at.to_i
      end

      def slugorize(input)
        result = input.to_s.downcase
        result.gsub!(/['|’]/, '')           # Remove apostrophes
        result.gsub!('&', 'and')            # Replace & with 'and'
        result.gsub!(/[^a-z0-9\-]/, '-')    # Get rid of anything we don't like
        result.gsub!(/-+/, '-')             # collapse dashes
        result.gsub!(/-$/, '')              # trim dashes
        result.gsub!(/^-/, '')              # trim dashes
        result
      end
    end
  end
end
