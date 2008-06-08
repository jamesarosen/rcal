require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/duration'
require 'parser_test_case'

class DurationTest < Test::Unit::TestCase
  include ParserTestCase
  include Rcal::Value
  
  def setup
    @parser = Duration::Parser.new
  end
  
  # Value object
  
  def test_create_with_invalid_sign_raises_error
    assert_raises(ArgumentError) { Duration.new('foo', 5 )}
  end

  def test_create_with_invalid_time_object_raises_error
    assert_raises(NoMethodError) { Duration.new('-', /a regexp/)}
  end
  
  def test_create_with_weeks_and_other_units_raises_error
    assert_raises(ArgumentError) { Duration.new('+', 1, 2) }
    assert_raises(ArgumentError) { Duration.new('+', 1, nil, 2) }
    assert_raises(ArgumentError) { Duration.new('+', 1, nil, nil, 2) }
    assert_raises(ArgumentError) { Duration.new('+', 1, nil, nil, nil, 2) }
  end
  
  def test_create_with_no_nonzero_time_units_raises_error
    assert_raises(ArgumentError) { Duration.new }
    assert_raises(ArgumentError) { Duration.new('+', 0, 0) }
  end
  
  def test_positive?
    assert  Duration.new(nil, 7).positive?
    assert  Duration.new('', 7).positive?
    assert  Duration.new('+', 7).positive?
    assert !Duration.new('-', 7).positive?
  end
  
  def test_to_ical
    assert_equal 'P1W', Duration.new(nil, 1).to_ical
    assert_equal 'P2D', Duration.new('', 0, 2).to_ical
    assert_equal '+P3DT4H', Duration.new('+', 0, 3, 4).to_ical
    assert_equal '-PT5H6M7S', Duration.new('-', 0, 0, 5, 6, 7).to_ical
    assert_equal 'PT8S', Duration.new('', 0, 0, 0, 0, 8).to_ical
    assert_equal '-PT9H0M10S', Duration.new('-', 0, 0, 9, 0, 10).to_ical
  end
  
  def test_in_seconds
    assert_equal 60*60*24*7, Duration.new(nil, 1).in_seconds
    assert_equal 60*60*24*2, Duration.new('+', 0, 2).in_seconds
    assert_equal -60*60*7, Duration.new('-', 0, 0, 7).in_seconds
    assert_equal 60*42, Duration.new(nil, 0, 0, 0, 42).in_seconds
    assert_equal -19, Duration.new('-', 0, 0, 0, 0, 19).in_seconds
  end
  
  def test_from_non_time_raises_error
    assert_raises(ArgumentError) { Duration.new(nil, 45).from('not a Time') }
  end
  
  def test_from_time
    t = Time.now
    pos_d = Duration.new(nil, 0, 12, 17, 9)
    neg_d = Duration.new('-', 0, 12, 17, 9)
    assert_in_delta pos_d.in_seconds, pos_d.from(t) - t, 0.1
    assert pos_d.from(t) > t
    assert neg_d.from(t) < t
  end
  
  
  # Parser
  
  def test_is_not_parser_for_non_durations
    assert_is_wrong_parser_for 'foo', '-9W', 'P9', '+P1D5H'
  end
  
  def test_is_parser_for_durations
    assert_is_parser_for 'P9W', '-P3D', '+P1DT4H', 'PT18M'
  end
  
  def test_cannot_parse_non_durations
    assert_cannot_parse 'foo', '-9W', 'P9', 'P1D5H'
  end
  
  def test_cannot_parse_invalid_duration
    assert_cannot_parse '+P9W3D'
  end
  
  def test_parses_durations
    assert_parses 'P9W', '-P3D', '+P1DT4H', 'PT18M'
  end
  
  def test_parses_sign
    assert  parse('P9W').positive?
    assert !parse('-P3D').positive?
    assert  parse('+P1DT4H').positive?
    assert  parse('PT18M').positive?
  end
  
  def test_parses_value
    assert_equal 9, parse('P9W').weeks
    assert_equal 3, parse('-P3D').days
    assert_equal 1, parse('+P1DT4H').days
    assert_equal 4, parse('+P1DT4H').hours
    assert_equal 18, parse('PT18M').minutes
  end
  
end