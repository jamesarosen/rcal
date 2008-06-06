require 'rcal/parser/base'

# A parser comprised of an ordered list of other parsers.
class Rcal::Parser::Registry < Rcal::Parser::Base
  include Rcal::Parser
  
  attr_reader :parsers
  
  def initialize(compliance_level = nil)
    super(compliance_level)
    @parsers = []
  end
  
  # Passes +ical+ and +parent+ to the first
  # Parser[link:/classes/Rcal/Parser/Base.html], p in +parsers+ such that
  # <tt>p.is_parser_for?(ical)</tt> returns +true+.
  #
  # Returns the value returned by the first suitable parser, or +nil+ if
  # no such parser exists and +compliance_level+ is lax.
  #
  # Raises ParseError if a suitable parser exists and that parser does.
  #
  # Raises ParseError if no suitable parser is found and +compliance_level+
  # is strict.
  def parse(ical, parent)
    if p = @parsers.find { |p| p.is_parser_for?(ical) }
      p.parse(ical, parent)
    else
      wrong_parser!(ical, parent, "No parser registered to parse #{ical}")
    end
  end
  
  # Returns true iff any registered parser does.
  def is_parser_for?(ical)
    @parsers.any? { |p| p.is_parser_for?(ical) }
  end
  
end