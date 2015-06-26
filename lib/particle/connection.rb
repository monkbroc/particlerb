require 'sawyer'
require 'particle/response/raise_error'

module Particle

  # Network layer for API client
  module Connection

    # Faraday middleware stack
    MIDDLEWARE = Faraday::RackBuilder.new do |builder|
      builder.use Particle::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end

    # Make a HTTP GET request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def get(url, options = {})
      request :get, url, options
    end

    # Make a HTTP POST request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def post(url, options = {})
      request :post, url, options
    end

    # Make a HTTP PUT request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def put(url, options = {})
      request :put, url, options
    end

    # Make a HTTP PATCH request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def patch(url, options = {})
      request :patch, url, options
    end

    # Make a HTTP DELETE request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def delete(url, options = {})
      request :delete, url, options
    end

    # Hypermedia agent for the Particle API
    #
    # @return [Sawyer::Agent]
    def agent
      @agent ||= Sawyer::Agent.new(endpoint, sawyer_options) do |http|
        http.headers[:content_type] = "application/json"
        http.headers[:user_agent] = user_agent
        if @access_token
          http.authorization :Bearer, @access_token
        end
      end
    end

    # Response for last HTTP request
    #
    # @return [Sawyer::Response]
    attr_reader :last_response

    protected

    def endpoint
      api_endpoint
    end

    private

    def reset_agent
      @agent = nil
    end

    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query]   = data.delete(:query) || {}
        options[:headers] = data.delete(:headers) || {}
        if accept = data.delete(:accept)
          options[:headers][:accept] = accept
        end

        username = data.delete(:username)
        password = data.delete(:password)
        if username && password
          options[:headers][:authorization] =
            basic_auth_header(username, password)
        end
      end

      @last_response = response = agent.call(method, URI::Parser.new.escape(path.to_s), data, options)
      response.data
    end

    def sawyer_options
      opts = {
        :links_parser => Sawyer::LinkParsers::Simple.new
      }
      conn_opts = @connection_options.dup
      conn_opts[:builder] = MIDDLEWARE
      conn_opts[:proxy] = @proxy if @proxy
      opts[:faraday] = Faraday.new(conn_opts)

      opts
    end

    # Temporarily set the Authorization to use basic auth
    def basic_auth_header(username, password)
      Faraday::Request.lookup_middleware(:basic_auth).
        header(username, password)
    end
  end
end

