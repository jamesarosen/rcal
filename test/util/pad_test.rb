require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/util/pad'

class PadTest < Test::Unit::TestCase
  
  def test_error_if_pad_string_blank
    assert_raises(ArgumentError) { 'foo'.pad(nil, 4) }
    assert_raises(ArgumentError) { 'foo'.pad('', 4) }
  end
  
  def tets_error_if_pad_string_more_than_one_char
    assert_raises(ArgumentError) { 'foo'.pad('..', 4) }
  end
  
  def test_error_if_type_invalid
    assert_raises(ArgumentError) { 'foo'.pad('.', 4, :wrong_type) }
  end
  
  def test_no_padding_if_long_enough
    assert_equal 'foo', 'foo'.pad('.', 0)
    assert_equal 'foo', 'foo'.pad('.', 1)
    assert_equal 'foo', 'foo'.pad('.', 2)
    assert_equal 'foo', 'foo'.pad('.', 3)
  end
  
  def test_pad_single_char_on_head
    assert_equal '....foo', 'foo'.pad('.', 7, :head)
  end
  
  def test_pad_single_char_on_tail
    assert_equal 'foo....', 'foo'.pad('.', 7, :tail)
  end
  
  def test_pad_head_is_default
    assert_equal '.foo', 'foo'.pad('.', 4)
  end
  
end