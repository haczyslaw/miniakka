require 'java'

require File.expand_path('jar/scala-library-2.11.8.jar', __dir__)
require File.expand_path('jar/config-1.3.0.jar', __dir__)
require File.expand_path('jar/akka-actor_2.11-2.4.14.jar', __dir__)

module MiniAkka
  java_import 'akka.actor.UntypedActor'
  java_import 'akka.actor.ActorRef'
  java_import 'akka.actor.ActorSystem'
  java_import 'akka.routing.RoundRobinPool'
  java_import 'akka.routing.SmallestMailboxPool'
  java_import 'akka.actor.Props'

  DEFAULT_NR_OF_ACTORS = 20
  Msg = Struct.new(:body)

  module_function

  def default_system_name=(value)
    @default_system_name = value
  end

  def default_system_name
    defined?(@default_system_name) ? @default_system_name : "DefaultSystem"
  end

  def system
    @system ||= ActorSystem.create(default_system_name)
  end

  def system_shutdown
    system.shutdown
  end

  def underscore_name(klass)
    name = klass.to_s
    name[0].downcase + name[1..-1].gsub(/[A-Z]/) { |letter| '_'+letter.downcase }
  end
end

require File.expand_path('mini_akka/creator', __dir__)
require File.expand_path('mini_akka/akka_aliases', __dir__)
require File.expand_path('mini_akka/actors/actor_with_balancer', __dir__)
require File.expand_path('mini_akka/actors/simple_actor', __dir__)
require File.expand_path('mini_akka/actors/round_robin_actor', __dir__)
require File.expand_path('mini_akka/actors/smallest_mb_actor', __dir__)
require File.expand_path('mini_akka/actors/master_actor', __dir__)
