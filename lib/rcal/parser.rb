# All parsers inherit from
# Parser::Base[link:/classes/Rcal/Parser/Base.html].
module Rcal::Parser
  
  public

  # Strict parse compliance level
  STRICT = :strict

  # Lax parse compliance level
  LAX = :lax

  private
  
  @@default_compliance_level = STRICT
  
  public
  
  # The default parse compliance level for parsers initialized without one.
  def self.default_compliance_level
    @@default_compliance_level
  end
  
  # Set the default parse compliance level.
  #
  # Raises ArgumentError unless +level+ is one of +[STRICT, LAX]+.
  def self.default_compliance_level=(level)
    raise ArgumentError.new("#{level} is not one of [#{Rcal::Parser::STRICT}, #{Rcal::Parser::LAX}]") unless
      [STRICT, LAX].include?(level)
    @@default_compliance_level = level
  end
  
end