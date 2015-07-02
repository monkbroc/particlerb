require 'particle'
require 'rspec'
require 'webmock/rspec'
require 'uri'

WebMock.disable_net_connect!

# Configure VCR web request replays
# Hint: use this on an example to force re-recording a VCR casette
# it "work", :vcr => { record: :all }
require 'vcr'

RSpec.configure do |config|
  config.before(:each) do |example|
    if example.metadata[:vcr]
      Particle.reset!
      Particle.configure do |config|
        config.access_token = test_particle_access_token
      end
    end
  end
end

def test_particle_username
  ENV.fetch('TEST_PARTICLE_USERNAME', 'tester@example.com')
end

def test_particle_password
  ENV.fetch('TEST_PARTICLE_PASSWORD', 'password')
end

def test_particle_access_token
  ENV.fetch('TEST_PARTICLE_ACCESS_TOKEN', '9' * 40)
end

def dev_id
  test_particle_device_ids[0]
end

def test_particle_device_ids
  ENV.fetch('TEST_PARTICLE_DEVICE_IDS', 'a' * 24).split(",")
end

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("__PARTICLE_USERNAME__") do
    test_particle_username
  end
  # Also filter the url-encoded username
  c.filter_sensitive_data("__PARTICLE_USERNAME_URL_ENCODED__") do
    URI.encode_www_form_component test_particle_username
  end
  c.filter_sensitive_data("__PARTICLE_PASSWORD__") do
    test_particle_password
  end
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
  File.join(fixture_path, file)
end

def wait_for_end_of_flash
  # Sleep for 60 seconds to give time for the flash to finish and device
  # to go back online
  sleep(60) if VCR.current_cassette.recording?
end
