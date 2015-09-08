require 'json'

module RailsSso
  class FetchUser
    def initialize(client)
      @client = client
    end

    def call
      response = client.get(RailsSso.config.provider_profile_path)

      case response.status
      when 200
        begin
          JSON.parse(response.body)
        rescue
          response.body
        end
      when 401
        raise ResponseError.new(:unauthenticated)
      else
        raise ResponseError.new(:unknown)
      end
    end

    private

    attr_reader :client
  end
end
