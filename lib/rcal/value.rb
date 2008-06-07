require 'rcal'
require 'rcal/parser/registry'

# Module containing all of the Ical value types (BINARY, TIME,
# DURATION, etc.). 
# {RFC 2445 Section 4.3}[link:/files/doc/RFC_2445_rdoc.html].
module Rcal::Value
  
  # Returns a {Parser Registry}[link:/classes/Rcal/Parser/Registry.html]
  # capable of parsing all the canonical value types.
  def self.parser(compliance_level)
    Rcal::Parser::Registry.new(compliance_level)
  end
  
  # Returns a Parser[link:/classes/Rcal/Parser/Base.html] capable
  # of parsing Strings of type +value_type+.
  #
  # Raises ArgumentError if +value_type+ is not a known value type.
  def self.parser_for(value_type, compliance_level)
    raise ArgumentError.new("#{value_type} is not a known value type")
  end
  
end