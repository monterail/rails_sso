module RailsSso
  class FetchUser
    def initialize(access_token)
      @access_token = access_token
    end

    def call
      yield(get)
    end

    private

    attr_reader :access_token

    def get
      access_token.get(RailsSso.provider_profile_path).parsed
    end
  end
end
