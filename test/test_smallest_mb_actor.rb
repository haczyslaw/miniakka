require 'minitest/autorun'
require File.expand_path('../lib/mini_akka', __dir__)

class SmallestMailboxResult
  class << self
    attr_accessor :red, :green, :blue
  end
end

class SmallestMailbox < MiniAkka::SmallestMailboxActor
  self.nr_of_actors = 2

  def on_receive(message)
    SmallestMailboxResult.send("#{message}=".to_sym, message)
  end
end

Minitest.after_run do
  MiniAkka.system_shutdown
end

class SmallestMailboxActorTest < Minitest::Test
  def self.smallest_mailbox
    @smallest_mailbox ||= MiniAkka.system.actor_of(SmallestMailbox.props, MiniAkka.underscore_name(SmallestMailbox))
  end

  def smallest_mailbox
    self.class.smallest_mailbox
  end

  def no_sender
    MiniAkka::ActorRef.no_sender
  end

  def setup
    smallest_mailbox.tell('red', no_sender)
    smallest_mailbox.tell('green', no_sender)
    smallest_mailbox.tell('blue', no_sender)
    sleep 0.05
  end

  def test_on_receive
    assert_equal SmallestMailboxResult.red, 'red'
    assert_equal SmallestMailboxResult.green, 'green'
    assert_equal SmallestMailboxResult.blue, 'blue'
  end
end

