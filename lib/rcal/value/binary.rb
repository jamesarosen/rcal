require 'rcal/value/parser'

=begin
4.3.1   Binary

Value Name: BINARY

Purpose: This value type is used to identify properties that contain
a character encoding of inline binary data. For example, an inline
attachment of an object code might be included in an iCalendar
object.

Formal Definition: The value type is defined by the following
notation:

  binary     = *(4b-char) [b-end]
  ; A "BASE64" encoded character string, as defined by [RFC 2045].

  b-end      = (2b-char "==") / (3b-char "=")

  b-char = ALPHA / DIGIT / "+" / "/"

Description: Property values with this value type MUST also include
the inline encoding parameter sequence of ";ENCODING=BASE64". That
is, all inline binary data MUST first be character encoded using the
"BASE64" encoding method defined in [RFC 2045]. No additional content
value encoding (i.e., BACKSLASH character encoding) is defined for
this value type.

Example: The following is an abridged example of a "BASE64" encoded
binary value data.

  ATTACH;VALUE=BINARY;ENCODING=BASE64:MIICajCCAdOgAwIBAgICBEUwDQY
   JKoZIhvcNAQEEBQAwdzELMAkGA1UEBhMCVVMxLDAqBgNVBAoTI05ldHNjYXBlI
   ENvbW11bmljYXRpb25zIENvcnBvcmF0aW9uMRwwGgYDVQQLExNJbmZv
     <...remainder of "BASE64" encoded binary data...>
=end
class Rcal::Value::BinaryParser < Rcal::Value::Parser
  
  binary_char = /[a-zA-Z0-9\+\/]/
  binary_end = Regexp.new("(?:#{binary_char.source}{2}==)|(?:#{binary_char.source}{3}=)")
  
  BINARY = Regexp.new("(?:#{binary_char.source}{4})*(?:#{binary_end.source})?")
  
  # Returns +true+ iff +ical+ is Base64-encoded binary data.
  def is_parser_for?(ical)
    ical =~ BINARY.to_whole_line
  end
  
  # Returns +ical+, unchanged.
  def parse(ical, context)
    return wrong_parser!(ical, context, "#{ical} is not Base64-encoded binary data") unless is_parser_for?(ical)
    ical
  end

  # Returns 'BINARY'.
  def value_type
    'BINARY'
  end
  
end