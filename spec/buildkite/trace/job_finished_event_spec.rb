require 'json'

describe Buildkite::Trace::JobFinishedEvent do
  let(:json_path) { File.join(File.dirname(__FILE__), "..", "..", "fixtures", "buildkite_job_finished.json")}
  let(:json) { JSON.load(File.read(json_path)) }
  let(:event) { Buildkite::Trace::JobFinishedEvent.new(json)}

  describe '.name' do
    it "returns the correct value" do
      expect(event.name).to eq "job.finished"
    end
  end

  describe '.job_id' do
    it "returns the job id" do
      expect(event.job_id).to eq "db30e1c2-7200-49db-b3f3-85edcbedec6e"
    end
  end

  describe '.job_name' do
    it "returns the job name" do
      expect(event.job_name).to eq ":rspec: Run Spec Group 1"
    end
  end

  describe '.job_slug' do
    it "returns the job slug" do
      expect(event.job_slug).to eq "rspec-run-spec-group-1"
    end
  end

  describe '.job_state' do
    it "returns the job state" do
      expect(event.job_state).to eq "passed"
    end
  end

  describe '.job_web_url' do
    it "returns the job URL" do
      expect(event.job_web_url).to eq "https://buildkite.com/foo/bar/builds/4474#db30e1c2-7200-49db-b3f3-85edcbedec6e"
    end
  end

  describe '.job_started_at' do
    it "returns the correct time" do
      expect(event.job_started_at).to eq Time.utc(2018,12,28,13,23,43)
    end
  end

  describe '.job_finished_at' do
    it "returns the correct time" do
      expect(event.job_finished_at).to eq Time.utc(2018,12,28,13,26,11)
    end
  end

  describe '.agent_name' do
    it "returns the agent name" do
      expect(event.agent_name).to eq "build-robot-himem-5cd88946-g74t6-1"
    end
  end

  describe '.agent_hostname' do
    it "returns the agent hostname" do
      expect(event.agent_hostname).to eq "build-robot-himem-5cd88946-g74t6"
    end
  end

  describe '.build_id' do
    it "returns the build id" do
      expect(event.build_id).to eq "464b5536-643c-4d70-bdaf-cb50660099f5"
    end
  end

  describe '.build_branch' do
    it "returns the build branch name" do
      expect(event.build_branch).to eq "master"
    end
  end

  describe '.pipeline_name' do
    it "returns the pipeline name" do
      expect(event.pipeline_name).to eq "Bar"
    end
  end

  describe '.pipeline_slug' do
    it "returns the pipeline slug" do
      expect(event.pipeline_slug).to eq "bar"
    end
  end

  describe '.to_span' do
    let(:span) { event.to_span }

    it "returns a Span instance with the correct values" do
      expect(span.trace_id).to eq(16600268248679578299)
      expect(span.span_id).to eq(3724764218537855423)
      expect(span.parent_id).to eq(16600268248679578300)
      expect(span.name).to eq("build.job")
      expect(span.resource).to eq(":rspec: Run Spec Group 1")
      expect(span.service).to eq("buildkite")
      expect(span.type).to eq("custom")
      expect(span.start).to eq(1546003423000000000)
      expect(span.duration).to eq(148_000_000_000)
      expect(span.metrics).to eq({_sampling_priority_v1: 2})
      expect(span.meta).to eq({:pipeline=>"bar", :url=>"https://buildkite.com/foo/bar/builds/4474#db30e1c2-7200-49db-b3f3-85edcbedec6e"})
    end
  end
end
