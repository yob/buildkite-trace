require 'json'

describe Buildkite::Trace::Event do
  let(:json) { JSON.dump(data) }
  let(:event) { Buildkite::Trace::Event.build(json)}

  context "with a build finished event" do
    let(:data) { { "event" => "build.finished"} }

    it "returns the correct object" do
      expect(event).to be_a(Buildkite::Trace::BuildFinishedEvent)
    end
  end

  context "with a job finished event" do
    let(:data) { { "event" => "job.finished"} }

    it "returns the correct object" do
      expect(event).to be_a(Buildkite::Trace::JobFinishedEvent)
    end
  end

  context "with another event" do
    let(:data) { { "event" => "foo"} }

    it "returns the correct object" do
      expect(event).to be_a(Buildkite::Trace::UnknownEvent)
    end
  end

end
