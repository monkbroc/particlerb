require 'particle'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!

# Configure VCR web request replays
require 'vcr'

def test_particle_access_token
  ENV.fetch('TEST_PARTICLE_ACCESS_TOKEN', 'x' * 40)
end

def test_particle_device_ids
  ENV.fetch('TEST_PARTICLE_DEVICE_IDS', '').split(",")
end

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("__PARTICLE_ACCESS_TOKEN__") do
    test_particle_access_token
  end
  test_particle_device_ids.each_with_index do |device_id, index|
    c.filter_sensitive_data("__PARTICLE_DEVICE_ID_#{index}__") { device_id }
  end

  c.default_cassette_options = {
    :serialize_with             => :json,
    :record                     => ENV['TRAVIS'] ? :none : :once
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
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

def particle_url(url)
  return url if url =~ /^http/

  url = File.join(Particle.api_endpoint, url)
  uri = Addressable::URI.parse(url)
  uri.path.gsub!("v3//", "v3/")

  uri.to_s
end
