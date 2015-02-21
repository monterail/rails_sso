require 'faraday'
require 'faraday-http-cache'

module RailsSso
  class Client
    def initialize(url, &block)
      @connection = Faraday.new(url, &block)
    end

    def token!(token)
      @token = token

      self
    end

    def get(url, params = {})
      request(:get, url, params)
    end

    def post(url, params = {})
      request(:post, url, params)
    end

    def put(url, params = {})
      request(:put, url, params)
    end

    def delete(url, params = {})
      request(:delete, url, params)
    end

    def patch(url, params = {})
      request(:patch, url, params)
    end

    private

    attr_reader :connection, :token

    def request(verb, url, params = {})
      connection.send(verb) do |req|
        req.headers['Authorization'] = "Bearer #{token}"
        req.headers['Content-Type'] = 'application/json'

        req.url(url)
        req.body = params.to_json
      end
    end
  end
end
