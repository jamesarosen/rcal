require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/float'
require 'parser_test_case'

class FloatTest < Test::Unit::TestCase
  include ParserTestCase
  
  def setup
    @parser = Rcal::Value::FloatParser.new
  end
  
  def test_value_type_is_FLOAT
    assert_equal 'FLOAT', @parser.value_type
  end
  
  def test_is_parser_for_floats
    assert_is_parser_for '16.5', '+2.093', '-1919.4949', '0.1', '5'
  end
  
  def test_is_not_parser_for_non_floats
    assert_is_wrong_parser_for '.3', '-.0001', '345.2f', 'not a float'
  end
  
  def test_parses_floats
    assert_parses '16.5', '+2.093', '-1919.4949', '0.1', '5'
  end
  
  def test_cannot_parse_non_floats
    assert_cannot_parse '.3', '-.0001', '345.2f', 'not a float'
  end
  
end