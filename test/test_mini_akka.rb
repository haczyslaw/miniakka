require 'minitest/autorun'
require File.expand_path('../lib/mini_akka', __dir__)

VeryLongClassName = Class.new

class MiniAkkaTest < Minitest::Test
  def test_set_default_system
    assert_equal MiniAkka.default_system_name, 'DefaultSystem'

    MiniAkka.default_system_name = 'DefaultSystemName'

    assert_equal MiniAkka.default_system_name, 'DefaultSystemName'
  end

  def test_underscore_name
    assert_equal MiniAkka.underscore_name(VeryLongClassName), 'very_long_class_name'
  end

  def test_default_nr_of_actors
    assert_equal MiniAkka::DEFAULT_NR_OF_ACTORS, 20
  end
end

