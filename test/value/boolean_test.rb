require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/boolean'
require 'parser_test_case'

class BooleanTest < Test::Unit::TestCase
  include ParserTestCase
  
  def setup
    @parser = Rcal::Value::BooleanParser.new
  end
  
  def test_value_type_is_BOOLEAN
    assert_equal 'BOOLEAN', @parser.value_type
  end
  
  def test_is_parser_for_uppercase_boolean_values
    assert_is_parser_for 'TRUE', 'FALSE'
  end
  
  def test_is_not_parser_for_lowercase_boolean_values
    assert_is_wrong_parser_for 'true', 'false'
  end
  
  def test_parses_uppercase_boolean_values
    assert_parses 'TRUE', 'FALSE'
  end
  
  def test_parses_to_ruby_booleans
    assert_equal true, parse('TRUE')
    assert_equal false, parse('FALSE')
  end
  
  def test_cannot_parse_strings_with_invalid_chars
    invalid_booleans = 'true', 'false', 't', 'f'
    with_compliance_level(Rcal::Parser::STRICT) do
      assert_cannot_parse *invalid_booleans
    end
    with_compliance_level(Rcal::Parser::LAX) do
      assert_cannot_parse *invalid_booleans
    end
  end
  
end