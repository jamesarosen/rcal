module Rcal
  
  module Parser
  
    private
    @@default_compliance_level = STRICT
    
    public
    
    # Strict parse compliance level
    STRICT = :strict
    
    # Lax parse compliance level
    LAX = :lax
    
    # The default parse compliance level for parsers initialized without one.
    def self.default_compliance_level
      @@default_compliance_level
    end
    
    # Set the default parse compliance level.
    def self.default_compliance_level=(level)
      raise ArgumentError.new("#{level} is not one of [#{Rcal::Parser::STRICT}, #{Rcal::Parser::LAX}]") unless
        [STRICT, LAX].include?(level)
      @@default_compliance_level = level
    end
    
  end
  
end