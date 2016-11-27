require 'minitest/autorun'
require File.expand_path('../lib/mini_akka', __dir__)

Creator = Class.new(MiniAkka::Creator)

class CreatorTest < Minitest::Test
  def test_create
    creator = Creator.new(Time, 2016, 1, 1)
    assert_equal Creator.included_modules.first, Java::AkkaJapi::Creator
    assert_equal creator.create, Time.new(2016, 1, 1)
  end

  def test_double_create
    creator = Creator.new(Time, 2016, 1, 1)
    time1 = creator.create
    time2 = creator.create
    assert(time1.object_id != time2.object_id)
  end
end

