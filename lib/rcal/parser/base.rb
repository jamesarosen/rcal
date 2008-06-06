require 'rcal/parser'
require 'rcal/parser/parse_error'

# The base class for all parsers.
#
# The following is an example of a parser that uses the private methods
# properly:
#
#   class MyPartParser < Rcal::Parser::Base
#     def parse(ical, parent)
#       return wrong_parser!(ical, parent) unless is_parser_for?(ical)
#       return error!(ical, parent, "MyParts must have at least 4 foos") unless
#         has_enough_foos?(ical, parent)
#       warn!("MyParts should not have bars") if has_bars?(ical, parent)
#       ... do some parsing, returning a part ...
#     end
#
#     def is_parser_for?(ical)
#       ...
#     end
#
#     private
#
#     def has_enough_foos?(ical, parent)
#       ...
#     end
#
#     def has_bars?(ical, parent)
#       ...
#     end
#   end
#
class Rcal::Parser::Base
  include Rcal::Parser
  
  attr_accessor :compliance_level
  
  # Creates a new parser with compliance_level +compliance_level+.
  # If +compliance_level+ is nil, uses
  # Parser::default_compliance_level[link:/classes/Rcal/Parser.html].
  #
  # Raises ArgumentError if +compliance_level+ is not a valid level.
  def initialize(compliance_level = nil)
    compliance_level ||= Rcal::Parser::default_compliance_level
    raise ArgumentError.new("#{compliance_level} is not a valid level") unless
      [STRICT, LAX].include?(compliance_level)
    @compliance_level = compliance_level
  end
  
  # Returns whether +compliance_level+ is strict.
  def strict?
    compliance_level == STRICT
  end
  
  # Returns whether +compliance_level+ is lax.
  def lax?
    !strict
  end
  
  # Parses content +ical+ in the context +parent+.  Depending on the
  # parser, +ical+ must be either a String or an Array of Strings.
  # +parent+ must always be an Part[link:/classes/Rcal/Part.html].
  #
  # Subclasses *MUST* redefine this method; in doing so, they _SHOULD_
  # use <tt>error!(message)</tt> when encountering parsing problems
  # instead of raising a
  # ParseError[link:/classes/Rcal/Parser/ParseError.html] directly.
  #
  # Returns a Part[link:/classes/Rcal/Part.html].
  #
  # Raises a ParseError[link:/classes/Rcal/Parser/ParseError.html]
  # on problems if +compliance_level+ is strict.
  #
  # Returns +nil+ on problems if +compliance_level+ is lax.
  def parse(ical, parent)
    raise NotImplementedError.new('Subclasses MUST redefine parse(ical, parent)')
  end
  
  # Whether or not this parser knows how to parse +ical+.  This method is
  # of particular importance to
  # Parser::Registry[link:/classes/Rcal/Parser/Registry.html].
  #
  # *IMPORTANT*: this does not guarantee that <tt>parse(ical, parent)</tt> is
  # guaranteed to succeed.  That is, the following can happen:
  #
  #   p = MyParser.new
  #   p.is_parser_for?(some_ical_string)
  #     # => true
  #   p.parse(some_ical_string, some_context)
  #     # CRASH!  BAM!  BOOM!  ParseError!
  def is_parser_for?(ical)
    raise NotImplementedError.new('Subclasses MUST redefine is_parser_for?(ical)')
  end
  
  private
  
  # Parsers _SHOULD_ call this private method when parsing +ical+ such that
  # <tt>is_parser_for(ical)</tt> would return false.
  #
  # +ical+ and +parent+ are required; +message+ is optional; if it is +nil+,
  # a default message will be generated.
  def wrong_parser!(ical, parent, message = nil) #:doc:
    message ||= "#{self} is not the right parser for #{ical}"
    error!(ical, parent, message)
  end
  
  # Parsers _SHOULD_ call this private method when they encounter a problem.
  # Generally, <tt>error!</tt> is to be called when the content to be parsed
  # somehow violates a "MUST" or "MUST NOT" clause in the RFC.
  #
  # +ical+ and +parent+ are required.  +message+ is an optional error
  # message; if it is +nil+, a default message will be generated.
  #
  # Raises a ParseError[link:/classes/Rcal/Parser/ParseError.html] if
  # +compliance_level+ is strict; otherwise, logs the error and returns
  # +nil+.
  def error!(ical, parent, message = nil) #:doc:
    if strict?
      raise ParseError.new(ical, parent, message)
    else
      # TODO log
      nil
    end
  end
  
  # Logs a warning.  Generally <tt>warn!</tt> is to be called when the content
  # to be parsed somehow violates a "SHOULD" or "SHOULD NOT" clause in the
  # RFC.
  #
  # Returns +nil+.
  def warn!(message) #:doc:
    # TODO: log
    nil
  end
  
end