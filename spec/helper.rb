require 'particle'
require 'rspec'
require 'webmock/rspec'

# Configure VCR web request replays
require 'vcr'

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("<PARTICLE_ACCESS_TOKEN>") do
    test_particle_access_token
  end

  c.default_cassette_options = {
    :serialize_with             => :json,
    :record                     => ENV['TRAVIS'] ? :none : :once
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def test_particle_access_token
  ENV.fetch 'TEST_PARTICLE_ACCES_TOKEN', 'XYZ'
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def json_response(file)
  {
    :body => fixture(file),
    :headers => {
      :content_type => 'application/json; charset=utf-8'
    }
  }
end

