module RailsSso
  class FetchUser
    def initialize(access_token, storage)
      @access_token, @storage = access_token, storage
    end

    def get_and_cache
      updater(get).call
    end

    private

    attr_reader :access_token, :storage

    def get(tries = 1)
      access_token.get(RailsSso.provider_profile_path).parsed
    rescue ::OAuth2::Error => e
      if tries > 0
        refresh_token!

        get(0)
      else
        raise e
      end
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

    def refresh_token!
      @access_token = access_token.refresh!

      storage[:access_token] = access_token.token
      storage[:refresh_token] = access_token.refresh_token
    end
  end
end
