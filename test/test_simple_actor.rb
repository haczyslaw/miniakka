require 'minitest/autorun'
require File.expand_path('../lib/mini_akka', __dir__)

class SimpleActorResult
  class << self
    attr_accessor :green
  end
end

class Simple < MiniAkka::SimpleActor
  def on_receive(message)
    SimpleActorResult.green = message
  end
end

Minitest.after_run do
  MiniAkka.system_shutdown
end

class SimpleActorTest < Minitest::Test
  def self.simple
    @simple ||= MiniAkka.system.actor_of(Simple.props, MiniAkka.underscore_name(Simple))
  end

  def simple
    self.class.simple
  end

  def no_sender
    MiniAkka::ActorRef.no_sender
  end

  def setup
    simple.tell('green', no_sender)
    sleep 0.02
  end

  def test_on_receive
    assert_equal SimpleActorResult.green, 'green'
  end
end

