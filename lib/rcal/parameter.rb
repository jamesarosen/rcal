require 'rcal'
require 'rcal/parser/registry'

# Module containing all of the Ical parameter types (TZID, PARTSTAT,
# DELEGATED-TO, etc.). See
# {RFC 2445 Section 4.2}[link:/files/doc/RFC_2445_rdoc.html].
module Rcal::Parameter

  # Returns a {Parser Registry}[link:/classes/Rcal/Parser/Registry.html]
  # capable of parsing all the canonical parameter types.
  def self.parser(compliance_level)
    Rcal::Parser::Registry.new(compliance_level)
  end

end