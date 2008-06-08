require 'rcal/value/parser'
require 'date'

# Value class representing a time of day.
class Rcal::Value::TimeOfDay

  second = /(?:[0-5][0-9])|(?:60)/
  minute = /[0-5][0-9]/
  hour = /(?:0[1-9])|(?:1[0-9])|(?:2[0-3])/

  # From {RFC 2445 4.3.12}[link:/files/doc/RFC_2445_rdoc.html]:
  #   time               = time-hour time-minute time-second [time-utc]
  #
  #   time-hour          = 2DIGIT        ;00-23
  #   time-minute        = 2DIGIT        ;00-59
  #   time-second        = 2DIGIT        ;00-60
  #   ;The "60" value is used to account for "leap" seconds.
  #
  #   time-utc   = "Z"
  #
  # Matchdata:
  # 0. Whole time string
  # 1. Hour
  # 2. Minute
  # 3. Second
  # 4. Z (is_utc?)
  TIME = Regexp.new("(#{hour.source})(#{minute.source})(#{second.source})(Z)?")
  
  # The +hour+, +minute+, and +second+ of the day, as Integers.
  attr_reader :hour, :min, :sec
  
  # Create a new TimeOfDay.  The result is a UTC time unless +utc+ is false.
  # By default, +utc+ is true.
  # 
  # +hour+, +min+, and +sec+ must each respond to +to_i+.
  #
  # Raises ArgumentError if +hour+:+min+:+sec+ is not a valid time.
  def initialize(hour, min, sec, utc = true)
    @hour, @min, @sec, @utc = hour.to_i, min.to_i, sec.to_i, !!utc
    validate!
  end
  
  def utc?
    @utc
  end
  
  # Returns a new Time representing this TimeOfDay on +date+.
  # Uses <tt>Time.utc</tt> if <tt>utc?</tt>; otherwise, uses
  # <tt>Time.local</tt>.
  #
  # Raises ArgumentError if +date+ is not a Date or if the resulting Time
  # is not a valid Time (for example, if <tt>self.sec</tt> is 60,
  # representing a leap second, but +date+ has no leap second).
  def on(date)
    raise ArgumentError.new("#{date} is not a Date") unless date.kind_of?(Date)
    begin
      args = [date.year, date.month, date.day, hour, min, sec]
      if utc?
        Time.utc *args
      else
        Time.local *args
      end
    rescue
      raise ArgumentError.new("#{self} is not a valid time on #{date}")
    end
  end
  
  def validate!
    raise ArgumentError.new('Hour must be between 1 and 23') unless (1..23).include?(hour)
    raise ArgumentError.new('Minute must be between 0 and 59') unless (0..59).include?(min)
    raise ArgumentError.new('Second must be between 0 and 60') unless (0..60).include?(sec)
  end

  private :validate!
  
  def to_ical
    [hour, min, sec].map { |c| c.to_s.pad('0', 2) }.join + (utc? ? 'Z' : '')
  end
    
  
  # Parser for TimeOfDays.
  class Parser < Rcal::Value::Parser
    include Rcal::Value
  
    # Returns +true+ iff +ical+ is an Ical Time.
    def is_parser_for?(ical)
      ical =~ TIME.to_whole_line
    end
  
    # Returns a Ruby Date.
    def parse(ical, context)
      return wrong_parser!(ical, context, "#{ical} is not a Time") unless is_parser_for?(ical)
      md = ical.match(TIME)
      begin
        h, m, s = *md[1,3]
        TimeOfDay.new(h, m, s, md[4] == 'Z')
      rescue ArgumentError
        error!("#{ical} is not a valid Time")
      end
    end
    
    # Returns 'TIME'.
    def value_type
      'TIME'
    end
    
  end
end