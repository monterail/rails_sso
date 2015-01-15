module RailsSso
  class FetchUser
    def initialize(access_token)
      @access_token = access_token
    end

    def get_and_cache
      updater(get).call
    end

    private

    attr_reader :access_token

    def get
      access_token.get(RailsSso.provider_profile_path).parsed
    end

    def updater(data)
      RailsSso::UpdateUser.new(data, updater_options)
    end

    def updater_options
      {
        fields: RailsSso.user_fields,
        repository: RailsSso.user_repository.new
      }
    end
  end
end
