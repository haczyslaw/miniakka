module MiniAkka
  class RoundRobinActor < ActorWithBalancer
    def self.props(*params)
      RoundRobinPool.new(nr_of_actors).props(
        Props.create(java_class, Creator.new(self, *params)))
    end
  end
end
