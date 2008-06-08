require 'rcal/value/parser'

class Rcal::Value::BinaryParser < Rcal::Value::Parser
  
  binary_char = /[a-zA-Z0-9\+\/]/
  binary_end = Regexp.new("(?:#{binary_char.source}{2}==)|(?:#{binary_char.source}{3}=)")
  
  # From {RFC 2445 4.3.1}[link:/files/doc/RFC_2445_rdoc.html]:
  #   binary     = *(4b-char) [b-end]
  #   ; A "BASE64" encoded character string, as defined by [RFC 2045].
  #
  #   b-end      = (2b-char "==") / (3b-char "=")
  #
  #   b-char = ALPHA / DIGIT / "+" / "/"
  BINARY = Regexp.new("(?:#{binary_char.source}{4})*(?:#{binary_end.source})?")
  
  @@value_type = 'BINARY'
  cattr_reader :value_type
  
  # Returns +true+ iff +ical+ is Base64-encoded binary data.
  def is_parser_for?(ical)
    ical =~ BINARY.to_whole_line
  end
  
  # Returns +ical+, unchanged.
  def parse(ical, context)
    return wrong_parser!(ical, context, "#{ical} is not Base64-encoded binary data") unless is_parser_for?(ical)
    ical
  end
  
end