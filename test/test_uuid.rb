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

  def test_comparison
    current_uuid = UUID.new(Time.now)
    future_uuid = UUID.new(Time.now + rand(60))

    assert current_uuid < future_uuid
    assert current_uuid >= current_uuid
    assert future_uuid >= current_uuid
  end
  
  def test_to_time
    ts = Time.new
    uuid = UUID.new(ts)
    assert_equal ts, uuid.to_time
  end
  
  def test_total_usecs
    uuid = UUID.new
    assert_equal uuid.send(:total_usecs), UUID.total_usecs(uuid.bytes)
  end

  def test_no_jitter
    t = Time.now

    assert_not_equal UUID.new(t), UUID.new(t)
    assert_equal UUID.new(t, randomize: false), UUID.new(t, randomize: false)
  end
end
