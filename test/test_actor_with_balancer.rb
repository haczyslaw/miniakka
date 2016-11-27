require 'minitest/autorun'
require File.expand_path('../lib/mini_akka', __dir__)

class WithBalancer17 < MiniAkka::ActorWithBalancer
  self.nr_of_actors = 17
end

WithBalancer20 = Class.new(MiniAkka::ActorWithBalancer)

class WithBalancerTest < Minitest::Test
  def test_nr_of_actors
    assert_equal WithBalancer17.nr_of_actors, 17
  end

  def test_default_nr_of_actors
    assert_equal WithBalancer20.nr_of_actors, 20
  end
end

