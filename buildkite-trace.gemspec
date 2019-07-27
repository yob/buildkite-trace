Gem::Specification.new do |spec|
  spec.name = "buildkite-trace"
  spec.version = "0.0.1"
  spec.summary = "A mini rack app that converts buildkite webhooks into datadog APM traces"
  spec.description = "A mini rack app that converts buildkite webhooks into datadog APM traces"
  spec.license = "MIT"
  spec.files =  Dir.glob("{images,lib,spec}/**/**/*")
  spec.extra_rdoc_files = %w{README.md MIT-LICENSE }
  spec.authors = ["James Healy"]
  spec.email   = ["james@yob.id.au"]
  spec.homepage = "http://github.com/yob/buildkite-trace"
  spec.required_ruby_version = ">=1.9.3"

  spec.add_development_dependency("rspec", "~> 3.5")
  spec.add_development_dependency("sinatra")
  spec.add_development_dependency("shotgun")
  spec.add_development_dependency("puma")

  spec.add_dependency("digest-crc")
  spec.add_dependency("rack")
end
