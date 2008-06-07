require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/util/blank'

class BlankTest < Test::Unit::TestCase
  
  def test_object_not_blank
    assert !Object.new.blank?
  end
  
  def test_symbols_not_blank
    assert !:foo.blank?
  end
  
  def test_numerics_not_blank
    assert !7.blank?
  end
  
  def test_empty_string_blank
    assert ''.blank?
  end
  
  def test_non_empty_string_not_blank
    assert !'foo'.blank?
  end
  
  def test_nil_blank
    assert nil.blank?
  end
  
end