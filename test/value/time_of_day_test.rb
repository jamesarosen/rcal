require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/time_of_day'
require 'parser_test_case'

class TimeOfDayTest < Test::Unit::TestCase
  include ParserTestCase
  include Rcal::Value
  
  def setup
    @parser = TimeOfDay::Parser.new
  end
  
  # Value object
  
  def test_cannot_create_with_invalid_time
    assert_raises(ArgumentError) { TimeOfDay.new(-1, 0, 0) }
    assert_raises(ArgumentError) { TimeOfDay.new(24, 0, 0) }
    
    assert_raises(ArgumentError) { TimeOfDay.new(4, -1, 0) }
    assert_raises(ArgumentError) { TimeOfDay.new(7, 60, 0) }
    
    assert_raises(ArgumentError) { TimeOfDay.new(10, 30, -1) }
    assert_raises(ArgumentError) { TimeOfDay.new(13, 45, 61) }
  end
  
  def test_to_ical
    assert_equal '010203', TimeOfDay.new(1, 2, 3, false).to_ical
    assert_equal '040506Z', TimeOfDay.new(4, 5, 6, true).to_ical
    assert_equal '110640', TimeOfDay.new(11, 6, 40, false).to_ical
  end
  
  def test_on_non_day_raises_error
    assert_raises(ArgumentError) { TimeOfDay.new(5, 6, 7).on('foo') }
    assert_raises(ArgumentError) { TimeOfDay.new(5, 6, 7).on(Time.now) }
  end

  def test_on_date_returns_time
    assert TimeOfDay.new(15, 16, 17).on(Date.civil(2006)).kind_of?(Time)
  end
  
  def test_on_date_preserves_utc
    assert  TimeOfDay.new(10, 11, 12, true ).on(Date.civil(1995)).utc?
    assert !TimeOfDay.new(10, 11, 12, false).on(Date.civil(2002)).utc?
  end
  
  def test_on_date_returns_correct_time
    assert_equal '2001-02-03 04:05:06', TimeOfDay.new(4, 5, 6).on(Date.civil(2001, 2, 3)).strftime('%Y-%m-%d %H:%M:%S')
  end
  
  
  # Parser
  
  def test_value_type_is_TIME
    assert_equal 'TIME', @parser.value_type
  end
  
  def test_is_not_parser_for_non_times_of_day
    assert_is_wrong_parser_for 'foo', '14', '1456', 'T195445'
  end
  
  def test_is_parser_for_times_of_day
    assert_is_parser_for '010203', '224530Z'
  end
  
  def test_cannot_parse_non_times_of_day
    non_times_of_day = 'foo', '14', '1456', 'T195445'
    with_compliance_level(Rcal::Parser::STRICT) do
      assert_cannot_parse *non_times_of_day
    end
    with_compliance_level(Rcal::Parser::LAX) do
      assert_cannot_parse *non_times_of_day
    end
  end
  
  def test_parses_times_of_day
    assert_parses '010203', '224530Z'
  end
  
end