require 'rcal/value/parser'

class Rcal::Value::FloatParser < Rcal::Value::Parser
  
  # From {RFC 2445 Section 4.3.7}[link:/files/doc/RFC_2445_rdoc.html]:
  #   float      = (["+"] / "-") 1*DIGIT ["." 1*DIGIT]
  FLOAT = /[\+-]?[0-9]+(?:\.[0-9]+)?/
  
  @@value_type = 'FLOAT'
  cattr_reader :value_type
  
  def is_parser_for?(ical)
    ical =~ FLOAT.to_whole_line
  end
  
  # Returns a Ruby Float.
  def parse(ical, context)
    return wrong_parser!(ical, context, "#{ical} is not a float") unless is_parser_for?(ical)
    ical.to_f
  end
  
end