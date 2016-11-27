module MiniAkka
  class SimpleActor < UntypedActor
    include AkkaAliases

    def self.props(*params)
      Props.create(java_class, Creator.new(self, *params))
    end
  end
end
