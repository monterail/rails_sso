require 'faraday'
require 'faraday-http-cache'

module RailsSso
  class Client
    def self.build(url, &block)
      adapter = Faraday.new(url, &block)
      new(adapter)
    end

    def self.build_real(url)
      build(url) do |conn|
        if RailsSso.use_cache
          conn.use :http_cache,
            store: Rails.cache,
            logger: Rails.logger,
            serializer: Marshal,
            shared_cache: false
        end

        conn.adapter Faraday.default_adapter
      end
    end

    def self.build_fake(url)
      build(url) do |conn|
        conn.adapter :test do |stub|
          RailsSso.profile_mocks.each do |token, profile|
            headers = {
              "Content-Type" => "application/json",
              "Authorization" => "Bearer #{token}"
            }

            stub.get(RailsSso.provider_profile_path, headers) do |env|
              if profile.nil?
                [401, { "Content-Type" => "application/json" }, ""]
              else
                [200, { "Content-Type" => "application/json" }, profile.to_json]
              end
            end
          end
        end
      end
    end

    def initialize(adapter)
      @connection = adapter
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
        req.headers["Authorization"] = "Bearer #{token}"
        req.headers["Content-Type"] = "application/json"

        req.url(url)
        req.body = params.to_json
      end
    end
  end
end
