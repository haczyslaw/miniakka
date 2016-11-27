module MiniAkka
  class ActorWithBalancer < UntypedActor
    def self.set_no_actor(number)
      @no_actor = number
    end

    def self.no_actor
      @no_actor || DEFAULT_NO_ACTOR
    end
  end
end
