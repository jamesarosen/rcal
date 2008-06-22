require 'rcal/value/parser'

=begin
4.3.2   Boolean

Value Name: BOOLEAN

Purpose: This value type is used to identify properties that contain
either a "TRUE" or "FALSE" Boolean value.

Formal Definition: The value type is defined by the following
notation:

  boolean    = "TRUE" / "FALSE"

Description: These values are case insensitive text. No additional
content value encoding (i.e., BACKSLASH character encoding) is
defined for this value type.

Example: The following is an example of a hypothetical property that
has a BOOLEAN value type:

  GIBBERISH:TRUE
=end
class Rcal::Value::BooleanParser < Rcal::Value::Parser
  
  BOOLEAN = /TRUE|FALSE/
  
  # Returns +true+ iff +ical+ is "TRUE" or "FALSE".
  def is_parser_for?(ical)
    ical =~ BOOLEAN.to_whole_line
  end
  
  # Returns a Ruby Boolean (+true+ or +false+).
  def parse(ical, context)
    return wrong_parser!(ical, context, "#{ical} is not a Boolean") unless is_parser_for?(ical)
    ical == 'TRUE'
  end
  
  # Returns 'BOOLEAN'.
  def value_type
    'BOOLEAN'
  end
  
end