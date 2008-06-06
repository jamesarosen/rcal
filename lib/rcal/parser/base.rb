require 'rcal/parser'

module Rcal
  module Parser
    
    # The base class for all parsers.
    class Base
      
      attr_accessor :compliance_level
      
      # Creates a new parser with compliance_level +compliance_level+.
      # If +compliance_level+ is nil, uses
      # Rcal::Parser::default_compliance_level[link:/classes/Rcal/Parser.html]
      # @raises ArgumentError if +compliance_level+ is not a valid level.
      def initialize(compliance_level = nil)
        compliance_level ||= Rcal::Parser::default_compliance_level
        raise ArgumentError.new("#{compliance_level} is not a valid level") unless
          [STRICT, LAX].include?(compliance_level)
        @compliance_level = compliance_level
      end
      
    end
    
  end
end