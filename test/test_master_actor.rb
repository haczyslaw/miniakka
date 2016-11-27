require 'minitest/autorun'
require 'set'
require File.expand_path('../lib/mini_akka', __dir__)

class SmallestMailboxResult
  class << self
    attr_accessor :red, :green, :blue, :in_progress

    def all
      @results
    end

    def add_result(result)
      @results ||= Set.new
      @results << result
    end
  end
end

class Actor < MiniAkka::SmallestMailboxActor
  Response = Struct.new(:body)

  def on_receive(message)
    SmallestMailboxResult.send("#{message}=".to_sym, message)
    get_sender.tell(Response.new(message), get_self)
  end
end

class Master < MiniAkka::MasterActor
  attr_reader :counter

  def on_receive(message)
    if message.is_a? MiniAkka::Msg
      # send messsage from master to one of actors ( SmallestMailbox instance )
      actor_router.tell(message.body, get_self)
    elsif message.is_a? Actor::Response
      inc_counter
      SmallestMailboxResult.add_result(message.body)
      SmallestMailboxResult.in_progress = false if (counter % 3 == 0)
    end
  end

  def inc_counter
    @counter ||= 0
    @counter += 1
  end
end

Minitest.after_run do
  MiniAkka.system_shutdown
end

class MasterActorTest < Minitest::Test
  def self.master
    @master ||= MiniAkka.system.actor_of(Master.props(Actor), MiniAkka.underscore_name(Master))
  end

  def master
    self.class.master
  end

  def no_sender
    MiniAkka::ActorRef.no_sender
  end

  def wait
    while SmallestMailboxResult.in_progress
      sleep 0.05
    end
  end

  def setup
    SmallestMailboxResult.in_progress = true
    master.tell(MiniAkka::Msg.new('red'), no_sender)
    master.tell(MiniAkka::Msg.new('green'), no_sender)
    master.tell(MiniAkka::Msg.new('blue'), no_sender)
    wait
  end

  def test_on_receive
    assert_equal SmallestMailboxResult.red, 'red'
    assert_equal SmallestMailboxResult.green, 'green'
    assert_equal SmallestMailboxResult.blue, 'blue'
  end

  def test_on_receive_from_smallest_mailbox
    assert_equal SmallestMailboxResult.all, Set.new(['blue', 'green', 'red'])
  end
end

