require 'minitest/autorun'
require File.expand_path('../lib/mini_akka', __dir__)

class RoundRobinResult
  class << self
    attr_accessor :red, :green, :blue
  end
end

class RoundRobin < MiniAkka::RoundRobinActor
  self.nr_of_actors = 2

  def on_receive(message)
    RoundRobinResult.send("#{message}=".to_sym, object_id)
  end
end

Minitest.after_run do
  MiniAkka.system_shutdown
end

class RoundRobinActorTest < Minitest::Test
  def self.round_robin
    @round_robin ||= MiniAkka.system.actor_of(RoundRobin.props, MiniAkka.underscore_name(RoundRobin))
  end

  def round_robin
    self.class.round_robin
  end

  def no_sender
    MiniAkka::ActorRef.no_sender
  end

  def setup
    round_robin.tell('red', no_sender)
    round_robin.tell('green', no_sender)
    round_robin.tell('blue', no_sender)
    sleep 0.05
  end

  def test_on_receive
    assert_instance_of Fixnum, RoundRobinResult.red
    assert_instance_of Fixnum, RoundRobinResult.green
    assert_instance_of Fixnum, RoundRobinResult.blue
  end

  def test_round
    red_actor_id = RoundRobinResult.red
    green_actor_id = RoundRobinResult.green
    blue_actor_id = RoundRobinResult.blue

    assert_equal red_actor_id, blue_actor_id
    assert(green_actor_id != blue_actor_id)
    assert(green_actor_id != red_actor_id)
  end
end

