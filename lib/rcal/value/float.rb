require 'rcal/value/parser'

=begin
4.3.7   Float

Value Name: FLOAT

Purpose: This value type is used to identify properties that contain
a real number value.

Formal Definition: The value type is defined by the following
notation:

  float      = (["+"] / "-") 1*DIGIT ["." 1*DIGIT]

Description: If the property permits, multiple "float" values are
specified by a COMMA character (US-ASCII decimal 44) separated list
of values.

No additional content value encoding (i.e., BACKSLASH character
encoding) is defined for this value type.

Example:

  1000000.0000001
  1.333
  -3.14
=end
class Rcal::Value::FloatParser < Rcal::Value::Parser
  
  FLOAT = /[\+-]?[0-9]+(?:\.[0-9]+)?/
  
  def is_parser_for?(ical)
    ical =~ FLOAT.to_whole_line
  end
  
  # Returns a Ruby Float.
  def parse(ical, context)
    return wrong_parser!(ical, context, "#{ical} is not a float") unless is_parser_for?(ical)
    ical.to_f
  end
  
  # Returns 'FLOAT'.
  def value_type
    'FLOAT'
  end
  
end