require 'particle'
require 'rspec'
require 'webmock/rspec'

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

def test_particle_access_token
  ENV.fetch('TEST_PARTICLE_ACCESS_TOKEN', 'x' * 40)
end

def test_particle_user_id
  ENV.fetch('TEST_PARTICLE_USER_ID', 'y' * 24)
end

def test_particle_device_ids
  ENV.fetch('TEST_PARTICLE_DEVICE_IDS', 'z' * 24).split(",")
end

def test_particle_webhook_ids
  ENV.fetch('TEST_PARTICLE_WEBHOOK_IDS', 'w' * 24).split(",")
end

def test_particle_webhook_password
  ENV.fetch('TEST_PARTICLE_WEBHOOK_PASSWORD', 'v' * 24)
end

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.filter_sensitive_data("__PARTICLE_ACCESS_TOKEN__") do
    test_particle_access_token
  end
  c.filter_sensitive_data("__PARTICLE_USER_ID__") do
    test_particle_user_id
  end
  test_particle_device_ids.each_with_index do |device_id, index|
    c.filter_sensitive_data("__PARTICLE_DEVICE_ID_#{index}__") { device_id }
  end
  test_particle_webhook_ids.each_with_index do |webhook_id, index|
    c.filter_sensitive_data("__PARTICLE_WEBHOOK_ID_#{index}__") { webhook_id }
  end
  c.filter_sensitive_data("__PARTICLE_WEBHOOK_PASSWORD__") do
    test_particle_webhook_password
  end

  c.default_cassette_options = {
    :serialize_with             => :json,
    :record                     => ENV['TRAVIS'] ? :none : :once
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

