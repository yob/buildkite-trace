require 'json'

describe Buildkite::Trace::Client do

  describe ".submit_trace" do
    context "with valid trace data" do
      it "submits the trace data to the datadog agent"
      it "returns true"
    end
    context "with invalid trace data" do
      it "returns false"
    end
  end

end
