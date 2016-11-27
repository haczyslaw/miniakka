module MiniAkka
  class Creator
    include Java::akka.japi.Creator

    def initialize(klass, *params)
      @klass = klass
      @params = params
    end

    def create
      @klass.new(*@params)
    end
  end
end
