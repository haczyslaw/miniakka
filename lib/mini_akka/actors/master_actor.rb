module MiniAkka
  class MasterActor < SimpleActor
    attr_reader :actor_router

    def initialize(actor_class)
      super()
      @actor_router = self.get_context.actor_of(actor_class.props, MiniAkka.underscore_name(actor_class))
    end
  end
end
