require 'uri'
require 'rcal/value/parser'

class Rcal::Value::UriParser < Rcal::Value::Parser
  
  # Returns whether +ical+ can be parsed as a URI. In strict mode, the
  # resulting URI *cannot* be Generic.  That is, 'some/relative/path.html'
  # and '/some/absolute/path/' are invalid in strict mode.  In lax mode,
  # all URIs are valid.
  def is_parser_for?(ical)
    begin
      u = URI.parse(ical)
      lax? || u.class != URI::Generic
    rescue URI::InvalidURIError
      false
    end
  end
  
  # Returns a +ical+ as a URI if possible.
  def parse(ical, context)
    begin
      u = URI.parse(ical)
      error!(ical, context, "#{ical} is not a valid URI") if u.class == URI::Generic
      u
    rescue URI::InvalidURIError
      error!(ical, context, "#{ical} is not a valid URI")
    end
  end

  # Returns 'URI'.
  def value_type
    'URI'
  end
  
end