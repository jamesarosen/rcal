require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/util/to_ical'

class ToIcalTest < Test::Unit::TestCase

  def test_nil_to_ical
    assert_nil nil.to_ical
  end
  
  def test_string_to_ical
    assert_equal 'foo', 'foo'.to_ical
  end
  
  def test_symbol_to_ical
    assert_equal 'bar', :bar.to_ical
  end
  
  def test_numeric_to_ical
    assert_equal '5', 5.to_ical
    assert_equal '6.2', 6.2.to_ical
    assert_equal '-0.45', -0.45.to_ical 
  end
  
  def test_array_to_ical
    assert_equal 'a,b,cc cc,d,101', [:a, 'b', 'cc cc', :d, 101].to_ical
  end
  
  def test_uri_to_ical
    assert_equal 'https://foo.com/bar/baz.html?yoo=yaz', URI.parse('https://foo.com/bar/baz.html?yoo=yaz').to_ical
  end
  
  def test_time_to_ical
    assert_equal '20020506T143030', Time.local(2002, 5, 6, 14, 30, 30).to_ical
    assert_equal '19901214T051500Z', Time.utc(1990, 12, 14, 5, 15).to_ical
  end
  
  def test_date_to_ical
    assert_equal '15850419', Date.civil(1585, 4, 19).to_ical
  end
  
  def test_datetime_to_ical
    assert_equal '21890131T120000', DateTime.civil(2189, 1, 31, 12).to_ical
  end
  
end