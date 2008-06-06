require File.join(File.dirname(__FILE__), 'test_helper')
require 'rcal/parser'

class ParserTest < Test::Unit::TestCase
  include Rcal::Parser
  
  def test_default_default_compliance_level_is_strict
    assert_equal STRICT, Rcal::Parser::default_compliance_level
  end
  
  def test_set_default_compliance_level_to_valid_value
    Rcal::Parser::default_compliance_level = LAX
    assert_equal LAX, Rcal::Parser::default_compliance_level
  end
  
  def test_set_default_compliance_level_to_invalid_value
    assert_raises(ArgumentError) do
      Rcal::Parser::default_compliance_level = 'foo'
    end
  end
  
end