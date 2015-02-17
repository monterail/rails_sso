module RailsSso
  class FetchUser
    def initialize(access_token)
      @access_token = access_token
    end

    def call
      access_token.get(RailsSso.provider_profile_path).parsed
    end

    private

    attr_reader :access_token
  end
end
