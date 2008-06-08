require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/integer'
require 'parser_test_case'

class IntegerTest < Test::Unit::TestCase
  include ParserTestCase
  
  def setup
    @parser = Rcal::Value::IntegerParser.new
  end
  
  def test_value_type_is_INTEGER
    assert_equal 'INTEGER', @parser.value_type
  end
  
  def test_is_parser_for_integers
    assert_is_parser_for '1', '+43', '-1919191', '0'
  end
  
  def test_is_not_parser_for_non_integers
    assert_is_wrong_parser_for '0.0', '.3', '-.', '345i', 'not an integer'
  end
  
  def test_parses_integers
    assert_parses '1', '+43', '-1919191', '0'
  end
  
  def test_cannot_parse_non_integers
    assert_cannot_parse '0.0', '.3', '-.', '345i', 'not an integer'
  end
  
  def test_parses_value_correctly
    assert_equal 0, parse('0')
    assert_equal 1234, parse('1234')
    assert_equal -5678, parse('-5678')
    assert_equal 91011, parse('+91011')
  end
  
end