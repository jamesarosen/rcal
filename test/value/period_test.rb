require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/period'
require 'parser_test_case'

class PeriodTest < Test::Unit::TestCase
  include ParserTestCase
  include Rcal::Value
  
  def setup
    @parser = Period::Parser.new
  end
  
  def non_periods
    ['foo', '20050101T191900Z/bar', 'baz/20020101T191900Z', 'yoo/P9W', 'hoo/+P1D5H',
      '19750517T193000/20020804T034530']
  end
  
  def periods
    ['19750517T193000Z/20020804T034530Z', '19991231T235500Z/P1DT5H12M',
      '20050101T191900Z/20020101T191900Z', '20020101T191900Z/P9W', '20050101T191900Z/P1DT12H15M']
  end
  
  # Value object
  
  def test_time_time_to_ical
    p = Period::TimeTimePeriod.new(Time.utc(1975, 5, 17, 19, 30), Time.utc(2002, 8, 4, 3, 45, 30))
    assert_equal '19750517T193000Z/20020804T034530Z', p.to_ical
  end
  
  def test_time_duration_to_ical
    p = Period::TimeDurationPeriod.new(Time.utc(1999, 12, 31, 23, 55), Duration.new(nil, 0, 1, 5, 12))
    assert_equal '19991231T235500Z/P1DT5H12M', p.to_ical
  end
  
  # Parser
  
  def test_value_type_is_TIME
    assert_equal 'PERIOD', @parser.value_type
  end
  
  def test_is_not_parser_for_non_periods
    assert_is_wrong_parser_for *non_periods
  end
  
  def test_is_parser_for_periods
    assert_is_parser_for *periods
  end
  
  def test_cannot_parse_non_periods
    with_compliance_level(Rcal::Parser::STRICT) do
      assert_cannot_parse *non_periods
    end
    with_compliance_level(Rcal::Parser::LAX) do
      assert_cannot_parse *non_periods
    end
  end
  
  def test_can_parse_periods
    assert_parses *periods
  end
  
  def test_parses_time_time_period
    p = parse('19750517T193000Z/20020804T034530Z')
    assert p.kind_of?(Period::TimeTimePeriod)
    assert_equal Time.utc(1975, 5, 17, 19, 30), p.start
    assert_equal Time.utc(2002, 8, 4, 3, 45, 30), p.end
  end
  
  def test_parses_time_duration_period
    p = parse('20050101T191900Z/P1DT5H')
    assert p.kind_of?(Period::TimeDurationPeriod)
    assert_equal Time.utc(2005, 1, 1, 19, 19), p.start
    assert_equal 1, p.duration.days
    assert_equal 5, p.duration.hours
  end
  
end