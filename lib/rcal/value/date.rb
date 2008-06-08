require 'rcal/value/parser'

class Rcal::Value::DateParser < Rcal::Value::Parser
  
  day = /(?:0[1-9])|(?:[1-2][0-9])|(?:3[01])/
  month = /(?:0[1-9])|(?:1[0-2])/
  year = /[0-9]{4}/

  # From {RFC 2445 4.3.4}[link:/files/doc/RFC_2445_rdoc.html]:
  #   date               = date-value
  #
  #   date-value         = date-fullyear date-month date-mday
  #   date-fullyear      = 4DIGIT
  #   date-month         = 2DIGIT        ;01-12
  #   date-mday          = 2DIGIT        ;01-28, 01-29, 01-30, 01-31
  #                                      ;based on month/year
  #
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