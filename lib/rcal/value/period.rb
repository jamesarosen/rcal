require 'rcal/value/date_time'
require 'rcal/value/duration'

=begin
4.3.9 Period of Time

Value Name: PERIOD

Purpose: This value type is used to identify values that contain a
precise period of time.

Formal Definition: The data type is defined by the following
notation:

  period     = period-explicit / period-start

  period-explicit = date-time "/" date-time
  ; [ISO 8601] complete representation basic format for a period of
  ; time consisting of a start and end. The start MUST be before the
  ; end.

  period-start = date-time "/" dur-value
  ; [ISO 8601] complete representation basic format for a period of
  ; time consisting of a start and positive duration of time.

Description: If the property permits, multiple "period" values are
specified by a COMMA character (US-ASCII decimal 44) separated list
of values. There are two forms of a period of time. First, a period
of time is identified by its start and its end. This format is
expressed as the [ISO 8601] complete representation, basic format for
"DATE-TIME" start of the period, followed by a SOLIDUS character
(US-ASCII decimal 47), followed by the "DATE-TIME" of the end of the
period. The start of the period MUST be before the end of the period.
Second, a period of time can also be defined by a start and a
positive duration of time. The format is expressed as the [ISO 8601]
complete representation, basic format for the "DATE-TIME" start of
the period, followed by a SOLIDUS character (US-ASCII decimal 47),
followed by the [ISO 8601] basic format for "DURATION" of the period.

Example: The period starting at 18:00:00 UTC, on January 1, 1997 and
ending at 07:00:00 UTC on January 2, 1997 would be:

  19970101T180000Z/19970102T070000Z

The period start at 18:00:00 on January 1, 1997 and lasting 5 hours
and 30 minutes would be:

  19970101T180000Z/PT5H30M

No additional content value encoding (i.e., BACKSLASH character
encoding) is defined for this value type.
=end
class Rcal::Value::Period
  include Rcal::Value
  
  # Matchdata:
  # 1. Whole Priod string
  # 2. Start DateTime
  # 3. End DateTime or Duration
  #
  # *IMPORTANT* this regular expression will match things that are not
  # valid PERIODs, since it only breaks the expression into its component
  # parts and doesn't actually check the components.  Use
  # {parser}[link:/classes/Rcal/Value/Period/Parser.html].is_parser_for?
  # to check whether a String is a valid ICAL PERIOD.
  PERIOD = /(.*)\/(.*)/
  
  # The start time, as a Time.
  attr_reader :start
  
  def initialize(start)
    validate_date_time(start)
    @start = start
  end
  
  # Returns this Period as a Range(Time..Time)
  def to_range
    Range.new(self.start, self.end)
  end
  
  def validate_date_time(t)
    raise ArgumentError.new("#{t} is not a time") unless t.kind_of?(Time)
    raise ArgumentError.new("#{t} is not in UTC") unless t.utc?
  end
  private :validate_date_time
  
  class TimeTimePeriod < Period
    
    attr_reader :end
    
    def initialize(start, stop)
      super(start)
      validate_date_time(stop)
      @end = stop
    end
    
    def to_ical
      start.to_ical + '/' + self.end.to_ical
    end
    
  end
  
  class TimeDurationPeriod < Period
    
    attr_reader :duration
    
    def initialize(start, duration)
      super(start)
      raise ArugmentError.new("#{duration} is not a Duration") unless duration.kind_of?(Duration)
      raise ArgumentError.new('duration cannot be negative') if duration.negative?
      @duration = duration
    end
    
    def end
      duration.from(start)
    end
    
    def to_ical
      start.to_ical + '/' + duration.to_ical
    end
    
  end
  
  class Parser < Rcal::Value::Parser
    
    def initialize(compliance_level = nil)
      super(compliance_level)
      @date_time_parser = Rcal::Value::DateTimeParser.new(compliance_level)
      @duration_parser = Rcal::Value::Duration::Parser.new(compliance_level)
    end
      
    # Returns +true+ iff +ical+ is an Ical DURATION.
    def is_parser_for?(ical)
      begin
        parse_helper!(ical)
        true
      rescue
        false
      end
    end
  
    # Returns a Ruby Date.
    def parse(ical, context)
      begin
        parse_helper!(ical)
      rescue Exception => e
        error!(ical, context, e.to_s)
      end
    end
    
    # Returns 'PERIOD'.
    def value_type
      'PERIOD'
    end
    
    private
    
    # Raises errors unless +ical+ is a PERIOD
    def parse_helper!(ical)
      md = ical.match(PERIOD.to_whole_line)
      raise ArgumentError.new("#{ical} is not a PERIOD") unless md
      
      start_time = md[1]
      if @date_time_parser.is_parser_for?(start_time)
        start_time = @date_time_parser.parse(start_time, nil)
      else
        raise ArgumentError.new("#{start_time} is not a PERIOD start time")
      end
      
      end_time_or_duration = md[2]
      if @date_time_parser.is_parser_for?(end_time_or_duration)
        end_time = @date_time_parser.parse(end_time_or_duration, nil)
        return TimeTimePeriod.new(start_time, end_time)
      elsif @duration_parser.is_parser_for?(end_time_or_duration)
        duration = @duration_parser.parse(end_time_or_duration, nil)
        return TimeDurationPeriod.new(start_time, duration)
      else
        raise ArgumentError.new("#{end_time_or_duration} is not a PERIOD end time or duration")
      end
    end
    
  end
  
end