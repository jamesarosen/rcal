require 'date'
require 'uri/generic'

class NilClass
  # Returns +nil+.
  def to_ical; self; end
end

class String
  # Returns +self+.
  def to_ical; self; end
end

class Symbol
  # Alias for +to_s+.
  def to_ical; to_s; end
end

class Numeric
  # Alias for +to_s+.
  def to_ical; to_s; end
end

class Array
  # From RFC 2445:
  #    Values in a list of values MUST be separated by a COMMA
  #    character (US-ASCII decimal 44)."
  #
  # Returns <tt>map{|x| x.to_ical}.join ','</tt>.
  def to_ical
    map{|x| x.to_ical}.join ','
  end
end

class URI::Generic
  # Alias for +to_s+.
  def to_ical; to_s; end
end

class DateTime
  # Returns <tt>strftime('%Y%m%dT%H%M%S')</tt>
  def to_ical
    strftime('%Y%m%dT%H%M%S')
  end
end

class Date
  # Returns <tt>strftime('%Y%m%d')</tt>
  def to_ical
    strftime('%Y%m%d')
  end
end

class Time
  # Returns <tt>strftime('%Y%m%dT%H%M%S')</tt>, with 'Z' appended if
  # <tt>utc?</tt> returns true.
  def to_ical
    result = strftime('%Y%m%dT%H%M%S')
    result << 'Z' if utc?
    result
  end
end