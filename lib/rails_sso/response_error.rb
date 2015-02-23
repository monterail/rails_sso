module RailsSso
  class ResponseError < StandardError
    attr_reader :code

    def initialize(code)
      @code = code

      super(I18n.t("rails_sso.errors.#{code}"))
    end
  end
end
