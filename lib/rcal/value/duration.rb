require 'rcal/value/parser'

# Value class representing a duration.
class Rcal::Value::Duration

  # From {RFC 2445 4.3.6}[link:/files/doc/RFC_2445_rdoc.html]:
  #   dur-value  = (["+"] / "-") "P" (dur-date / dur-time / dur-week)
  #   
  #   dur-date   = dur-day [dur-time]
  #   dur-time   = "T" (dur-hour / dur-minute / dur-second)
  #   dur-week   = 1*DIGIT "W"
  #   dur-hour   = 1*DIGIT "H" [dur-minute]
  #   dur-minute = 1*DIGIT "M" [dur-second]
  #   dur-second = 1*DIGIT "S"
  #   dur-day    = 1*DIGIT "D"
  # 
  # Matchdata:
  # 0. Whole duration string
  # 1. Sign ('+', '-' or +nil+)
  # 2. Weeks
  # 3. Days
  # 4. Hours
  # 5. Minutes
  # 6. Seconds
  #
  # *IMPORTANT* this regexp will match values that are technically invalid
  # Ical.  For example, the string 'P8W4M' is not valid Ical, but will be
  # parsed successfully to matchdata 
  # <tt>['P8W4M', nil, 8, nil, nil, 4, nil]</tt>.
  DURATION = /([\+-])?P(?:([0-9]+)W)?(?:([0-9]+)D)?(?:T(?:([0-9]+)H)?(?:([0-9]+)M)?(?:([0-9]+)S)?)?/
  
  # The weeks, days, hours, minutes, and seconds, as Integers.
  attr_reader :weeks, :days, :hours, :minutes, :seconds
  
  # The sign; one of <tt>['+', '-', '', nil]</tt>, where anything but '-'
  # indicates '+'.  See also +positive?+.
  attr_reader :sign
  
  # Create a new duration.
  # +sign+ defaults to +''+ (equivalent in value to '+'); all of the time
  # unit values default to 0.
  #
  # Raises ArgumentError if +sign+ is not a valid sign (one of <tt>['+',
  # '-', '']).
  #
  # Raises ArgumentError if +weeks+ is nonzero and any of the other units is
  # nonzero.
  #
  # Raises ArgumnetError if all time units are zero.
  #
  # Raises NoMethodError unless all the time units respond to +to_i+.
  def initialize(sign = nil, weeks = 0, days = 0, hours = 0, minutes = 0, seconds = 0)
    @sign = sign || ''
    @weeks, @days, @hours, @minutes, @seconds = weeks.to_i, days.to_i, hours.to_i, minutes.to_i, seconds.to_i
    validate!
  end
  
  def validate!
    raise ArgumentError.new("#{sign} must be '+', '-', '', or nil") unless
      ['+', '-', '', nil].include?(sign)
    raise ArgumentError.new("Durations cannot have weeks and other units") if
      weeks > 0 && [days, hours, minutes, seconds].any? { |u| u > 0 }
    raise ArgumentError.new("Durations must have at least one of [weeks, days, hours, minutes, seconds]") if
      [weeks, days, hours, minutes, seconds].all? { |u| u == 0 }
  end
  
  def positive?
    sign != '-'
  end
  
  # Returns a new Time that is this duration away from +time+.  Converts
  # the duration to a number of seconds.  (This is fine, since Durations
  # cannot include Months or Years, and so months having different numbers
  # of days will not cause discrepencies.)
  #
  # Raises ArgumentError if +time+ is not a Time.
  def from(time)
    raise ArgumentError.new("#{time} is not a Time") unless time.kind_of?(Time)
    time + in_seconds
  end
  
  # Returns this duration as an Integer number of seconds.
  def in_seconds
    multiplier = positive? ? 1 : -1
    multiplier * (((((weeks * 7) + days) * 24 + hours) * 60 + minutes) * 60 + seconds)
  end
  
  alias_method :to_i, :in_seconds
  
  def to_ical
    result = "#{sign}P"
    result << "#{weeks}W" if weeks > 0
    result << "#{days}D" if days > 0
    result << 'T' if [hours, minutes, seconds].any? { |u| u > 0 }
    result << "#{hours}H" if hours > 0
    result << "#{minutes}M" if (minutes > 0) || (hours > 0 && seconds > 0)
    result << "#{seconds}S" if seconds > 0
    return result
  end
  
  private :validate!
    
  
  # Parser for Durations.
  class Parser < Rcal::Value::Parser
    include Rcal::Value
  
    # Returns +true+ iff +ical+ is an Ical DURATION.
    def is_parser_for?(ical)
      ical =~ DURATION.to_whole_line
    end
  
    # Returns a Ruby Date.
    def parse(ical, context)
      return wrong_parser!(ical, context, "#{ical} is not a DURATION") unless is_parser_for?(ical)
      begin
        Duration.new(*ical.match(DURATION)[1,6])
      rescue ArgumentError
        error!(ical, context, "#{ical} is not a valid DURATION")
      end
    end
    
    # Returns 'DURATION'.
    def value_type
      'DURATION'
    end
    
  end
end