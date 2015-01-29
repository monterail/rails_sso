module RailsSso
  class UpdateUser
    def initialize(data, options = {})
      @id, @data = data['id'], data.except('id')
      @fields, @repository = options.values_at(:fields, :repository)
    end

    def call
      if user = repository.find_by_sso_id(id)
        repository.update(user, params)
        user
      else
        repository.create_with_sso_id(id, params)
      end
    end

    private

    attr_reader :id, :data, :repository

    def fields
      @fields.map(&:to_s)
    end

    def params
      data.slice(*fields)
    end
  end
end
