require 'rcal'
require 'rcal/parser/registry'

# Module containing all of the Ical property types (UID, DTSTAMP, PRIORITY,
# etc.). See
# {RFC 2445 Sections 4.5 and 4.6}[link:/files/doc/RFC_2445_rdoc.html].
module Rcal::Property

  # Returns a {Parser Registry}[link:/classes/Rcal/Parser/Registry.html]
  # capable of parsing all the canonical property types.
  def self.parser(compliance_level)
    Rcal::Parser::Registry.new(compliance_level)
  end

end