require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/date'
require 'parser_test_case'
require 'date'

class DateTest < Test::Unit::TestCase
  include ParserTestCase
  
  def setup
    @parser = Rcal::Value::DateParser.new
  end
  
  def test_value_type_is_DATE
    assert_equal 'DATE', @parser.value_type
  end
  
  def test_is_parser_for_dates
    assert_is_parser_for '20020719', '19991231'
  end
  
  def test_is_not_parser_for_non_ical_dates
    assert_is_wrong_parser_for '2005', '1565012', 'December 3, 2000'
  end
  
  def test_error_parsing_invalid_date
    assert_cannot_parse '20000631', '20070431', '20050229'
  end
  
  def test_parses_dates
    assert_parses '19120224', '17130808', '23000101'
  end
  
  def test_parses_to_ruby_dates
    ['19120224', '17130808', '23000101'].each do |d|
      assert parse(d).kind_of?(Date)
    end
  end
  
  def test_parses_to_correct_date
    assert_equal '1854-09-10', parse('18540910').strftime('%Y-%m-%d')
  end
  
end