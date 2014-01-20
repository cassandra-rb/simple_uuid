require 'test/unit'
require 'digest/md5'
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

  def test_equality_with_encoding
    return unless "".respond_to? :force_encoding

    utf8_uuid_bytes = "\xFD\x17\x1F\xA6=O\x11\xE2\x92\x13pV\x81\xBB\x05\x87".force_encoding("UTF-8")
    binary_uuid_bytes = "\xFD\x17\x1F\xA6=O\x11\xE2\x92\x13pV\x81\xBB\x05\x87".force_encoding("ASCII-8BIT")

    assert_equal UUID.new(utf8_uuid_bytes), UUID.new(binary_uuid_bytes)
  end

  def test_salt
    tnow = Time.now
    salt =  Digest::MD5.new.update("some salt")
    tthen = Time.now

    uuid1 = UUID.new(tnow, :randomize => false, :salt => salt.digest)
    uuid2 = UUID.new(tthen, :randomize => false, :salt => salt.digest)

    assert_equal uuid1.to_time, tnow
    assert_equal uuid2.to_time, tthen
    assert_equal uuid1.bytes[8..-1], uuid2.bytes[8..-1]
    assert uuid2 > uuid1
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

  def test_identical_times
    t = Time.now
    u1 = UUID.new(t)
    u2 = UUID.new(t)

    assert_not_equal u1, u2
    assert_equal u1, UUID.new(u1) # sanity
    assert_not_equal 0, u1 <=> u2
    assert_equal u1.to_time, u2.to_time

    if u1.to_s[-8, 8] > u2.to_s[-8, 8]
      assert u1 > u2
    else
      assert u2 > u1
    end
  end

  def test_dont_crash_on_frozen_bytes
    uuid = UUID.new
    hash = {
      uuid.to_s => Time.now
    }
    # collect freezes the key values as you iterate
    objectified = hash.collect {|k,v| UUID.new(k) }
    assert_equal uuid, objectified[0]
  end
end
