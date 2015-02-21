module RailsSso
  class ResponseError < RuntimeError
    attr_reader :code

    def initialize(code)
      @code = code
      super
    end
  end
end
