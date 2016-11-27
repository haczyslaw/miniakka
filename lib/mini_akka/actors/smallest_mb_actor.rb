module MiniAkka
  class SmallestMailboxActor < ActorWithBalancer
    def self.props(*params)
      SmallestMailboxPool.new(nr_of_actors).props(
        Props.create(java_class, Creator.new(self, *params)))
    end
  end
end
