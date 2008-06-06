require File.join(File.dirname(__FILE__), 'test_helper')
require 'rcal/util'

class UtilTest < Test::Unit::TestCase
  
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
  
end