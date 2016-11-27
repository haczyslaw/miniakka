module MiniAkka
  class ActorWithBalancer < UntypedActor
    include AkkaAliases

    class << self
      attr_writer :nr_of_actors

      def nr_of_actors
        defined?(@nr_of_actors) ? @nr_of_actors : DEFAULT_NR_OF_ACTORS
      end
    end
  end
end
