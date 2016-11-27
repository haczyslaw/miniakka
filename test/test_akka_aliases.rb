require 'minitest/autorun'
require File.expand_path('../lib/mini_akka', __dir__)

class Aliases
  include MiniAkka::AkkaAliases

  def on_receive(msg)
    msg
  end

  def getSender
    :get_sender
  end
end

class AkkaAliasesTest < Minitest::Test
  def test_on_receive
    assert_equal Aliases.new.onReceive(:test), :test
  end

  def test_get_sender
    assert_equal Aliases.new.get_sender, :get_sender 
  end
end

