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
  # Parser[link:/classes/Rcal/Parser/Base], p in +parsers+ such that
  # <tt>p.is_parser_for?(ical)</tt> returns +true+.
  #
  # Returns the value returned by the first such parser.
  #
  # Raises ParseError if the found parser does.
  #
  # Raises ParseError if no appropriate parser is found and strict?.
  #
  # Returns +nil+ if no appropriate parser is found and lax?.
  def parse(ical, parent)
    if p = @parsers.find { |p| p.is_parser_for?(ical) }
      p.parse(ical, parent)
    else
      error!(ical, parent, "No parser registered to parse #{ical}")
    end
  end
  
  # Returns true iff any registered parser does.
  def is_parser_for?(ical)
    @parsers.any? { |p| p.is_parser_for?(ical) }
  end
  
end