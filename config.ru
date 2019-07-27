$LOAD_PATH << "lib"

require 'buildkite-trace'
run Buildkite::Trace::App
