require 'json'

describe Buildkite::Trace::BuildFinishedEvent do
  let(:json_path) { File.join(File.dirname(__FILE__), "..", "..", "fixtures", "buildkite_build_finished.json")}
  let(:json) { JSON.load(File.read(json_path)) }
  let(:event) { Buildkite::Trace::BuildFinishedEvent.new(json)}

  describe '.name' do
    it "returns the correct value" do
      expect(event.name).to eq "build.finished"
    end
  end

  describe '.build_id' do
    it "returns the correct value" do
      expect(event.build_id).to eq "83636ec4-0643-4d4b-9576-4b4cc9416dbc"
    end
  end

  describe '.build_branch' do
    it "returns the branch name" do
      expect(event.build_branch).to eq "master"
    end
  end

  describe '.pipeline_name' do
    it "returns the pipeline name" do
      expect(event.pipeline_name).to eq "Bar"
    end
  end

  describe '.pipeline_slug' do
    it "returns the pipeline name" do
      expect(event.pipeline_slug).to eq "bar"
    end
  end

  describe '.build_web_url' do
    it "returns with the build web_url" do
      expect(event.build_web_url).to eq "https://buildkite.com/foo/bar/builds/4472"
    end
  end

  describe '.passed?' do
    it "returns false" do
      expect(event.passed?).to eq false
    end
  end

  describe 'build_created_at' do
    it "returns correct time" do
      expect(event.build_created_at).to eq Time.utc(2018,12,28,13,3,28)
    end
  end

  describe 'build_started_at' do
    it "returns correct time" do
      expect(event.build_started_at).to eq Time.utc(2018,12,28,13,3,32)
    end
  end

  describe 'build_finished_at' do
    it "returns correct time" do
      expect(event.build_finished_at).to eq Time.utc(2018,12,28,13,29,38)
    end
  end

  describe '.to_span' do
    let(:span) { event.to_span }

    it "returns a Span instance with the correct values" do
      expect(span.trace_id).to eq(18259648613135438764)
      expect(span.span_id).to eq(18259648613135438765)
      expect(span.parent_id).to be_nil
      expect(span.name).to eq("build")
      expect(span.resource).to eq("bar")
      expect(span.service).to eq("buildkite")
      expect(span.type).to eq("custom")
      expect(span.start).to eq(1546002212000000000)
      expect(span.duration).to eq(1_566_000_000_000)
      expect(span.metrics).to eq({_sampling_priority_v1: 2})
      expect(span.meta).to eq({:pipeline=>"bar", :url=>"https://buildkite.com/foo/bar/builds/4472"})
    end
  end
end
