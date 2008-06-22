require 'rcal/value/parser'

=begin
4.3.4 Date

Value Name: DATE

Purpose: This value type is used to identify values that contain a
calendar date.

Formal Definition: The value type is defined by the following
notation:

  date               = date-value

  date-value         = date-fullyear date-month date-mday
  date-fullyear      = 4DIGIT
  date-month         = 2DIGIT        ;01-12
  date-mday          = 2DIGIT        ;01-28, 01-29, 01-30, 01-31
                                     ;based on month/year

Description: If the property permits, multiple "date" values are
specified as a COMMA character (US-ASCII decimal 44) separated list
of values. The format for the value type is expressed as the [ISO 8601]
complete representation, basic format for a calendar date. The
textual format specifies a four-digit year, two-digit month, and
two-digit day of the month. There are no separator characters between
the year, month and day component text.

No additional content value encoding (i.e., BACKSLASH character
encoding) is defined for this value type.

Example: The following represents July 14, 1997:

  19970714
=end
class Rcal::Value::DateParser < Rcal::Value::Parser
  
  day = /(?:0[1-9])|(?:[1-2][0-9])|(?:3[01])/
  month = /(?:0[1-9])|(?:1[0-2])/
  year = /[0-9]{4}/

  # Matchdata:
  # 0. Whole date string
  # 1. Year
  # 2. Month
  # 3. Day
  DATE = Regexp.new("(#{year.source})(#{month.source})(#{day.source})")
  
  # Returns +true+ iff +ical+ is an Ical Date.
  def is_parser_for?(ical)
    ical =~ DATE.to_whole_line
  end
  
  # Returns a Ruby Date.
  def parse(ical, context)
    return wrong_parser!(ical, context, "#{ical} is not a Date") unless is_parser_for?(ical)
    begin
      Date.civil(*ical.match(DATE)[1,3].map { |s| s.to_i })
    rescue ArgumentError
      error!(ical, context, "#{ical} is not a valid Date")
    end
  end
  
  # Returns 'DATE'.
  def value_type
    'DATE'
  end
  
end