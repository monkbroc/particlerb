require 'faraday'
require 'faraday_middleware'
require 'particle/response/raise_error'
require 'particle/response/parse_json_symbols'

module Particle

  # Network layer for API client
  module Connection

    # Faraday middleware stack
    MIDDLEWARE = Faraday::RackBuilder.new do |builder|
      builder.use Particle::Response::RaiseError
      # For file upload
      builder.request :multipart

      builder.request :json
      builder.use Particle::Response::ParseJsonSymbols, :content_type => /\bjson$/
      builder.adapter Faraday.default_adapter
    end

    # Make a HTTP GET request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Hash] JSON response as a hash
    def get(url, options = {})
      request :get, url, options
    end

    # Make a HTTP POST request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Hash] JSON response as a hash
    def post(url, options = {})
      request :post, url, options
    end

    # Make a HTTP PUT request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Hash] JSON response as a hash
    def put(url, options = {})
      request :put, url, options
    end

    # Make a HTTP PATCH request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Hash] JSON response as a hash
    def patch(url, options = {})
      request :patch, url, options
    end

    # Make a HTTP DELETE request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Hash] JSON response as a hash
    def delete(url, options = {})
      request :delete, url, options
    end

    # HTTP connection for the Particle API
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(conn_opts) do |http|
        http.url_prefix = endpoint
        if @access_token
          http.authorization :Bearer, @access_token
        end
      end
    end

    # Response for last HTTP request
    #
    # @return [Faraday::Response]
    attr_reader :last_response

    protected

    def endpoint
      api_endpoint
    end

    private

    def reset_connection
      @connection = nil
    end

    def request(method, path, data, options = {})
      prepare_request_options(data, options)
      @last_response = response = connection.send(method, URI::Parser.new.escape(path.to_s)) do |req|
        if data && method != :get
          req.body = data
        end
        if params = options[:query]
          req.params.update params
        end
        if headers = options[:headers]
          req.headers.update headers
        end
      end
      response.body
    end

    def prepare_request_options(data, options)
      if data.is_a?(Hash)
        options[:query]   ||= data.delete(:query) || {}
        options[:headers] ||= data.delete(:headers) || {}
        if accept = data.delete(:accept)
          options[:headers][:accept] = accept
        end
      end

      username = options.delete(:username)
      password = options.delete(:password)
      if username && password
        options[:headers] ||= {}
        options[:headers][:authorization] =
          basic_auth_header(username, password)
      end
    end

    def conn_opts
      conn_opts = @connection_options.dup
      conn_opts[:builder] = MIDDLEWARE
      conn_opts
    end

    # Temporarily set the Authorization to use basic auth
    def basic_auth_header(username, password)
      Faraday::Request.lookup_middleware(:basic_auth).
        header(username, password)
    end
  end
end

