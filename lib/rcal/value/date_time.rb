require 'rcal/value/parser'
require 'rcal/value/date'
require 'rcal/value/time_of_day'

class Rcal::Value::DateTimeParser < Rcal::Value::Parser
  
  date = Rcal::Value::DateParser::DATE
  time = Rcal::Value::TimeOfDay::TIME
  
  # From {RFC 2445 4.3.5}[link:/files/doc/RFC_2445_rdoc.html]:
  #   date-time  = date "T" time ;As specified in the date and time
  #                              ;value definitions
  # 
  # Matchdata:
  # 0. whole string
  # 1. 4-digit year
  # 2. 2-digit month
  # 3. 2-digit day
  # 4. 2-digit hour
  # 5. 2-digit minute
  # 6. 2-digit second
  # 7. Z (is_utc?)
  DATETIME = Regexp.new("#{date.source}T#{time.source}")
  
  @@value_type = 'DATE-TIME'
  cattr_reader :value_type
  
  # Returns +true+ iff +ical+ is an Ical DATE-TIME.
  def is_parser_for?(ical)
    ical =~ DATETIME.to_whole_line
  end
  
  # Returns a Ruby Time; uses Time.utc if 'Z' is present; otherwise, uses Time.local.
  def parse(ical, context)
    return wrong_parser!(ical, context, "#{ical} is not a DATE-TIME") unless is_parser_for?(ical)
    md = ical.match(DATETIME)
    utc = (md[7] == 'Z')
    begin
      time = md[1,6].map { |s| s.to_i }
      if utc
        Time.utc(*time)
      else
        Time.local(*time)
      end
    rescue ArgumentError
      error!("#{ical} is not a valid DATE-TIME")
    end
  end
  
end