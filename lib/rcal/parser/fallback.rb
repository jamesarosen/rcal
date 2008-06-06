require 'rcal/parser/base'

# A fallback parser to be used at the end of a
# Registry[link:/classes/Rcal/Parser/Registry.html].
class Rcal::Parser::Fallback < Rcal::Parser::Base
  
  # Returns +true+ if +compliance_level+ is lax; +false+ otherwise.
  def is_parser_for?(ical)
    lax?
  end
  
  # Returns <tt>parse_helper(ical, parent)</tt> if +compliance_level+ is lax.
  #
  # Raises ParseError if +compliance_level+ is strict.
  def parse(ical, parent)
    if lax?
      warn!("Using fallback parser for #{ical} in context #{parent}")
      parse_helper(ical, parent)
    else
      wrong_parser!(ical, parent, "Fallback Parsers cannot parse in Strict mode")
    end
  end
  
  private
  
  # Returns +ical+.
  #
  # Subclasses _SHOULD_ redefine this method and return some sort of fallback
  # version of +ical+ in context +parent+.
  #
  # Subclasses <em>SHOULD NOT</em> call <tt>error!</tt> from this method, nor
  # should they raise a ParseError.
  def parse_helper(ical, parent) #:doc:
    ical
  end
  
end