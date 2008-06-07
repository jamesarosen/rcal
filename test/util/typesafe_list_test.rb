require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/util/typesafe_list'

class TypesafeListTest < Test::Unit::TestCase
  include Rcal::Util
  
  attr_reader :symbols, :strings
  
  def setup
    @symbols = TypesafeList.new(Symbol) << :foo << :bar
    @strings = TypesafeList.new(String) << 'foo' << 'bar'
  end
  
  # <<
  
  def test_can_add_right_type
    symbols << :baz
    assert_equal 3, symbols.length
    assert_equal :baz, symbols.last
  end
  
  def test_cannot_add_wrong_type
    assert_raises(TypeError) { symbols << 'foo' }
  end
  
  # +
  
  def test_concatenate_with_typesafe_list_of_same_type
    other = TypesafeList.new(Symbol) << :baz << :yoo
    sum = symbols + other
    assert sum.kind_of?(TypesafeList)
    assert_equal [:foo, :bar, :baz, :yoo], sum.to_a
  end
  
  def test_concatenate_with_typesafe_list_of_different_type
    sum = symbols + strings
    assert !sum.kind_of?(TypesafeList)
    assert_equal [:foo, :bar, 'foo', 'bar'], sum
  end
  
  def test_concatenate_with_array
    sum =  symbols + [2, /regexp/]
    assert !sum.kind_of?(TypesafeList)
    assert_equal [:foo, :bar, 2, /regexp/], sum
  end
  
  # ==
  
  def test_not_equal_to_regular_array_with_same_elements
    assert !([:foo, :bar].==(symbols))
    assert !(symbols.==([:foo, :bar]))
  end
  
  def test_equal_op_to_typesafe_array_of_same_class_with_same_elements
    other = TypesafeList.new(Symbol) << :foo << :bar
    assert other.==(symbols)
    assert symbols.==(other)
  end
  
  # push
  
  def test_can_push_right_type
    symbols.push(:baz, :yoo, :hoo)
    assert_equal [:foo, :bar, :baz, :yoo, :hoo], symbols.to_a
  end
  
  def test_cannot_push_wrong_type
    assert_raises(TypeError) { symbols.push('baz', :yoo) }
  end
  
  # unshift
  
  def test_can_unshift_right_type
    symbols.unshift :bar, :baz
    assert_equal [:bar, :baz, :foo, :bar], symbols.to_a
  end
  
  def test_cannot_unshift_wrong_type
    assert_raises(TypeError) { symbols.unshift(:bar, 'baz') }
  end
  
  # clear
  
  def test_clear
    symbols.clear
    assert_equal [], symbols.to_a
  end

  # to_a

  def test_to_a_returns_regular_array
    assert symbols.to_a.kind_of?(Array)
  end

  def test_to_a_returns_defensive_copy
    original_size = symbols.size
    symbols.to_a << 'gulp!'
    assert_equal original_size, symbols.size
  end
  
  # Enumerable
  
  def test_enumerable
    assert_equal strings.to_a, symbols.map { |sym| sym.to_s }
  end
  
end