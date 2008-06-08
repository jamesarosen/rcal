require 'rcal/value/parser'

class Rcal::Value::IntegerParser < Rcal::Value::Parser
  
  # From {RFC 2445 Section 4.3.8}[link:/files/doc/RFC_2445_rdoc.html]:
  #   integer    = (["+"] / "-") 1*DIGIT
  INTEGER = /[\+-]?[0-9]+/
  
  def is_parser_for?(ical)
    ical =~ INTEGER.to_whole_line
  end
  
  # Returns a Ruby Float.
  def parse(ical, context)
    return wrong_parser!(ical, context, "#{ical} is not an integer") unless is_parser_for?(ical)
    ical.to_i
  end
  
  # Returns 'INTEGER'.
  def value_type
    'INTEGER'
  end
  
end