require 'rcal/util/blank'

unless ''.respond_to?(:pad)
  
  class String
    
    # Pads +self+ with +pad_string+ until the result is at least
    # +min_length+ characters.  If +type+ is <tt>:head</tt>, all padding is
    # added to the beginning of +self+; if it is <tt>:tail</tt>, all padding
    # is added to the end of +self+; if it is <tt>:even</tt>, padding is
    # divided between the beginning and end (with beginning receiving the
    # odd one left out, if any).  The default is <tt>:head</tt>.
    #
    # Returns a new, padded String of length at least +min_length+.
    #
    # Raises ArgumentError if +pad_string+ is not a String of length 1.
    # 
    # Raises ArgumentError if +type+ is not one of <tt>[:head, :tail]</tt>.
    def pad(pad_string, min_length, type = :head)
      return self.dup if self.length >= min_length
      pad_string = pad_string.to_s
      raise ArgumentError.new("#{pad_string} is blank") if pad_string.length != 1
      extra = (min_length - self.length)
      case type
      when :head
        (pad_string * extra) + self
      when :tail
        self + (pad_string * extra)
      when :even
        (pad_string * (extra / 2.0).ceil) + self + (pad_string * (extra / 2.0).floor)
      else
        raise ArgumentError.new("#{type} is not one of [:head, :tail]")
      end
    end
    
  end
  
end