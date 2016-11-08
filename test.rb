$:.unshift File.expand_path('../lib', __FILE__)

require 'particlerb'
# Local
#Particle.access_token = '76421d3a9621f914bd1f7a23d343ca21a6a534f8'
#Particle.api_endpoint = 'http://localhost:9090'
# Staging
Particle.access_token = '76421d3a9621f914bd1f7a23d343ca21a6a534f8'
Particle.api_endpoint = 'https://api.staging.particle.io'
begin
  device = Particle.provision_device product_id: 31
  puts device.id
rescue Particle::Error => e
  $stderr.puts "Error: #{e.short_message}"
end
