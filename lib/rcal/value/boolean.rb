require 'rcal/value/parser'

class Rcal::Value::BooleanParser < Rcal::Value::Parser
  
  @@value_type = 'BOOLEAN'
  cattr_accessor :value_type
  
  # From {RFC 2445 4.3.2}[link:/files/doc/RFC_2445_rdoc.html]:
  #   boolean    = "TRUE" / "FALSE"
  BOOLEAN = /TRUE|FALSE/
  
  # Returns +true+ iff +ical+ is "TRUE" or "FALSE".
  def is_parser_for?(ical)
    ical =~ BOOLEAN
  end
  
  # Returns a Ruby Boolean (+true+ or +false+).
  def parse(ical, context)
    return wrong_parser!(ical, context, "#{ical} is not a Boolean") unless is_parser_for?(ical)
    ical == 'TRUE'
  end
  
end