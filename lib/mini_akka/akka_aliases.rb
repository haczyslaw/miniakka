module MiniAkka
  module AkkaAliases
    def onReceive(msg)
      on_receive(msg)
    end

    def get_sender
      getSender()
    end
  end
end
