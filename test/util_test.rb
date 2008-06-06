require File.join(File.dirname(__FILE__), 'test_helper')
require 'rcal/util'

class UtilTest < Test::Unit::TestCase
  
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
  
  def test_hash_from_empty_array
    assert_equal({}, [].extract_options!)
  end
  
  def test_hash_from_array_with_no_hash
    assert_equal({}, [1, 2, 3, 4].extract_options!)
  end
  
  def test_hash_from_array_with_hash_in_middle
    assert_equal({}, [1, {:foo => 'bar'}, 3, 4].extract_options!)
  end
  
  def test_hash_from_array_with_hash_at_end
    assert_equal({:baz => 'yoo', 4 => 12}, [1, 2, 3, {:baz => 'yoo', 4 => 12}].extract_options!)
  end
  
  def test_pluralize_singular
    assert_equal 'boats', 'boat'.pluralize
  end
  
  def test_pluralize_plural
    assert_equal 'drinks', 'drinks'.pluralize
  end
  
  def test_singularize_singular
    assert_equal 'noun', 'noun'.singularize
  end
  
  def test_singularize_plural
    assert_equal 'noun', 'nouns'.singularize
  end
  
end