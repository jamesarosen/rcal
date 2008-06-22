require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/date_time'
require 'parser_test_case'

class DateTimeTest < Test::Unit::TestCase
  include ParserTestCase
  
  def setup
    @parser = Rcal::Value::DateTimeParser.new
  end
  
  def test_value_type_is_DATE_TIME
    assert_equal 'DATE-TIME', @parser.value_type
  end
  
  def test_is_not_parser_for_non_date_times
    assert_is_wrong_parser_for 'foo', '2001', '200101', '20010203', '20010203T', '20010203T04', '20010203T0405', '20010203040506'
  end
  
  def test_is_parser_for_date_times
    assert_is_parser_for '20010203T040506', '19541209T145500Z'
  end
  
  def test_cannot_parse_non_date_times
    non_date_times = 'foo', '2001', '200101', '20010203', '20010203T', '20010203T04', '20010203T0405', '20010203040506'
    with_compliance_level(Rcal::Parser::STRICT) do
      assert_cannot_parse *non_date_times
    end
    with_compliance_level(Rcal::Parser::LAX) do
      assert_cannot_parse *non_date_times
    end
  end
  
  def test_parses_date_times
    assert_parses '20010203T040506', '19541209T145500Z'
  end
  
  def test_parses_date_times_to_ruby_time_objects
    ['20010203T040506', '19541209T145500Z'].each do |dt|
      assert parse(dt).kind_of?(Time)
    end
  end
  
  def test_parses_date_times_to_correct_time
    assert_equal '2001-02-03 04:05:06', parse('20010203T040506').strftime('%Y-%m-%d %H:%M:%S')
    assert_equal '1954-12-09 14:55:00', parse('19541209T145500Z').strftime('%Y-%m-%d %H:%M:%S')
  end
  
  def test_parses_no_z_to_local
    assert !parse('20010203T040506').utc?
  end
  
  def test_parses_z_to_utc
    assert parse('19541209T145500Z').utc?
  end
  
end