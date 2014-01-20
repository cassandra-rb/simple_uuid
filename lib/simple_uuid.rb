class Time
  def self.stamp
    Time.now.stamp
  end

  def stamp
    to_i * 1_000_000 + usec
  end
end

module SimpleUUID
  # UUID format version 1, as specified in RFC 4122, with jitter in place of the mac address and sequence counter.
  class UUID
    include Comparable

    class InvalidVersion < StandardError #:nodoc:
    end

    GREGORIAN_EPOCH_OFFSET = 0x01B2_1DD2_1381_4000 # Oct 15, 1582

    VARIANT = 0b1000_0000_0000_0000

    def initialize(bytes = nil, opts = {})
      case bytes
      when self.class # UUID
        @bytes = bytes.to_s
      when String
        case bytes.size
        when 16 # Raw byte array
          @bytes = bytes
        when 36 # Human-readable UUID representation; inverse of #to_guid
          elements = bytes.split("-")
          raise TypeError, "Expected #{bytes.inspect} to cast to a #{self.class} (malformed UUID representation)" if elements.size != 5
          @bytes = [elements.join].pack('H32')
        else
          raise TypeError, "Expected #{bytes.inspect} to cast to a #{self.class} (invalid bytecount)"
        end

      when Integer
        raise TypeError, "Expected #{bytes.inspect} to cast to a #{self.class} (integer out of range)" if bytes < 0 or bytes > 2**128
        @bytes = [
          (bytes >> 96) & 0xFFFF_FFFF,
          (bytes >> 64) & 0xFFFF_FFFF,
          (bytes >> 32) & 0xFFFF_FFFF,
          bytes & 0xFFFF_FFFF
        ].pack("NNNN")

      when NilClass, Time
        time = (bytes || Time).stamp * 10 + GREGORIAN_EPOCH_OFFSET
        # See http://github.com/spectra/ruby-uuid/
        byte_array = [
          time & 0xFFFF_FFFF,
          time >> 32,
          ((time >> 48) & 0x0FFF) | 0x1000,
        ]

        # Top 3 bytes reserved
        if opts[:randomize] == false
          byte_array += if !opts[:salt].nil?
            clock_h, clock_l, node_h, node_l =
              opts[:salt].to_s.unpack("CCnN")

            clock = [
              clock_h | VARIANT,
              clock_l
            ].pack("n").unpack("n").first

            [ clock, node_h, node_l ]
          else
            [ 0 | VARIANT, 0, 0 ]
          end
        else
          byte_array += [
            rand(2**13) | VARIANT,
            rand(2**16),
            rand(2**32)
          ]
        end

        @bytes = byte_array.pack("NnnnnN")
      else
        raise TypeError, "Expected #{bytes.inspect} to cast to a #{self.class} (unknown source class)"
      end
    end

    def to_i
      ints = @bytes.unpack("NNNN")
      (ints[0] << 96) +
      (ints[1] << 64) +
      (ints[2] << 32) +
      ints[3]
    end

    def version
      time_high = @bytes.unpack("NnnQ")[2]
      version = (time_high & 0xF000).to_s(16)[0].chr.to_i
      version > 0 and version < 6 ? version : -1
    end

    def variant
      @bytes.unpack('QnnN')[1] >> 13
    end

    def to_guid
      elements = @bytes.unpack("NnnCCa6")
      node = elements[-1].unpack('C*')
      elements[-1] = '%02x%02x%02x%02x%02x%02x' % node
      "%08x-%04x-%04x-%02x%02x-%s" % elements
    end

    def seconds
      total_usecs / 1_000_000
    end

    def usecs
      total_usecs % 1_000_000
    end

    def <=>(other)
      me = to_s.unpack('Nn2C*')
      him = other.to_s.unpack('Nn2C*')
      # swap most significant time bits to front
      me[0], me[2], him[0], him[2] = me[2], me[0], him[2], him[0]
      me.zip(him) do |m, h|
        comp = m <=> h
        return comp if comp != 0
      end
      return 0
    end

    def inspect(long = false)
      "<UUID##{object_id} time: #{
        to_time.inspect
      }, usecs: #{
        usecs
      } jitter: #{
        @bytes.unpack('QQ')[1]
      }" + (long ? ", version: #{version}, variant: #{variant}, guid: #{to_guid}>" :  ">")
    end

    def to_s
      @bytes
    end
    alias bytes to_s

    def hash
      @bytes.hash
    end

    def eql?(other)
      other.respond_to?(:bytes) && bytes == other.bytes
    end

    # Given raw bytes, return a time object
    def self.to_time(bytes)
      usecs = total_usecs(bytes)
      Time.at(usecs / 1_000_000, usecs % 1_000_000)
    end

    # Return a time object
    def to_time
      Time.at(total_usecs / 1_000_000, total_usecs % 1_000_000)
    end

    # Given raw bytes, return the total_usecs
    def self.total_usecs(bytes)
      elements = bytes.unpack("Nnn")
      (elements[0] + (elements[1] << 32) + ((elements[2] & 0x0FFF) << 48) - GREGORIAN_EPOCH_OFFSET) / 10
    end

    private

    def total_usecs
      @total_usecs ||= self.class.total_usecs(@bytes)
    end
  end
end
