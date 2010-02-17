require 'test/unit'
require 'simple_uuid'
include SimpleUUID

class UUIDTest < Test::Unit::TestCase
  def test_uuid_sort
    ary = []
    5.times { ary << UUID.new(Time.at(rand(2**31))) }
    assert_equal ary.map { |_| _.seconds }.sort, ary.sort.map { |_| _.seconds }
    assert_not_equal ary.sort, ary.sort_by {|_| _.to_guid }
  end

  def test_uuid_equality
    uuid = UUID.new
    assert_equal uuid, UUID.new(uuid)
    assert_equal uuid, UUID.new(uuid.to_s)
    assert_equal uuid, UUID.new(uuid.to_i)
    assert_equal uuid, UUID.new(uuid.to_guid)
  end

  def test_uuid_error
    assert_raises(TypeError) do
      UUID.new("bogus")
    end
  end

  def test_types_behave_well
    assert !(UUID.new() == false)
  end

  def test_uuid_casting_error
    assert_raises(TypeError) do
      UUID.new({})
    end
  end

  def test_equality
    a = UUID.new
    b = a.dup
    assert_equal a, b
  end
end