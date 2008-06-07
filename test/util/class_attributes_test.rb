require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/util/class_attributes'

class ClassAttributesTest < Test::Unit::TestCase
  
  def setup
    @klass = Class.new do
      class <<self
        public :class_variable_get, :class_variable_set
      end
    end
    @klass.class_variable_set(:@@foo, 'foo')
  end
  
  def test_cattr_reader_defines_class_reader
    @klass.cattr_reader :bar
    assert @klass.respond_to?(:bar)
  end
  
  def test_cattr_reader_defines_instance_reader
    @klass.cattr_reader :bar
    assert @klass.new.respond_to?(:bar)
  end
  
  def test_cattr_reader_sets_class_variable_to_nil_if_not_defined
    @klass.cattr_reader :bar
    assert_nil @klass.class_variable_get(:@@bar)
  end
  
  def test_cattr_reader_does_not_overwrite_existing_class_variable
    @klass.cattr_reader :foo
    assert_equal 'foo', @klass.class_variable_get(:@@foo)
  end
  
  def test_class_reader_returns_class_variable
    @klass.cattr_reader :foo
    assert_equal 'foo', @klass.foo
  end
  
  def test_cattr_writer_defines_class_writer
    @klass.cattr_writer :bar
    assert @klass.respond_to?(:bar=)
  end
  
  def test_cattr_writer_defines_instance_writer
    @klass.cattr_writer :bar
    assert @klass.new.respond_to?(:bar=)
  end
  
  def test_cattr_writer_does_not_define_instance_writer_if_instnace_writer_false
    @klass.cattr_writer :bar, :instance_writer => false
    assert !@klass.new.respond_to?(:bar=)
  end
  
  def test_cattr_writer_sets_class_variable_to_nil_if_not_defined
    @klass.cattr_writer :bar
    assert_nil @klass.class_variable_get(:@@bar)
  end
  
  def test_cattr_writer_does_not_overwrite_existing_class_variable
    @klass.cattr_writer :foo
    assert_equal 'foo', @klass.class_variable_get(:@@foo)
  end
  
  def test_class_writer_sets_class_variable
    @klass.cattr_writer :foo
    @klass.foo = 'baz'
    assert_equal 'baz', @klass.class_variable_get(:@@foo)
  end
  
end