require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'highline'

# Run all tests using recorded HTTP responses
task :test => :spec
task :default => :spec

namespace :spec do
  desc "Run all tests against the real API, re-recording all HTTP responses"
  task :rerecord => ["clean:vcr", :wait_online, :online, :wait_offline, :offline, :spec]

  desc "Wait for the device to be online"
  task :wait_online do
    HighLine.new.ask "<%= color('Is the device online?', LIGHT_GREEN) %> "
  end

  desc "Run tests where device has to be online"
  RSpec::Core::RakeTask.new(:online) do |t|
    t.rspec_opts = "--tag ~offline"
  end

  desc "Wait for the device to be offline"
  task :wait_offline do
    HighLine.new.ask "<%= color('Is the device offline?', LIGHT_YELLOW) %> "
  end

  desc "Run tests where device has to be offline"
  RSpec::Core::RakeTask.new(:offline) do |t|
    t.rspec_opts = "--tag offline"
  end

end

task :clean => %w(clean:vcr)
namespace :clean do
  desc "Clean HTTP responses recorded by VCR"
  task :vcr do
    FileUtils.rm_rf 'spec/cassettes'
  end
end
