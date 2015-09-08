require 'faraday'

module RailsSso
  class TokenMock
    attr_reader :connection

    delegate :get, :post, :put, :patch, :delete, to: :connection

    def initialize(*)
      @connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.delete(RailsSso.config.provider_sign_out_path) { |env| [200, {}, ''] }
        end
      end
    end
  end
end
