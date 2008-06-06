require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/parser/registry'

class ParserRegistryTest < Test::Unit::TestCase
  include Rcal::Parser
  
  class IsClassParser < Rcal::Parser::Base
    def initialize(klass, compliance_level = nil)
      super(compliance_level)
      @klass = klass
    end
    def parse(i,p)
      return wrong_parser!(i,p) unless is_parser_for?(i)
      return "#{@klass}: #{i}"
    end
    def is_parser_for?(i)
      i.kind_of?(@klass)
    end
  end
  
  def setup
    @object_parser = IsClassParser.new(Object)
    @string_parser = IsClassParser.new(String)
    @symbol_parser = IsClassParser.new(Symbol)
    @number_parser = IsClassParser.new(Numeric)
    
    @registry = Registry.new(STRICT)
    @registry.parsers << @string_parser << @symbol_parser << @number_parser
  end
  
  def test_is_parser_for_if_finds_parser_for
    assert @registry.is_parser_for?('foobar')
    assert @registry.is_parser_for?(:foobar)
    assert @registry.is_parser_for?(9)
  end
  
  def test_is_not_parser_for_if_does_not_find_parser_for
    assert !@registry.is_parser_for?(Object.new)
  end
  
  def test_parses_if_finds_parser_for
    assert_equal 'String: foobar', @registry.parse('foobar', nil)
    assert_equal 'Symbol: foobar', @registry.parse(:foobar, nil)
    assert_equal 'Numeric: 19', @registry.parse(19, nil)
  end
  
  def test_raises_error_if_no_parser_for_and_strict
    assert_raises(ParseError) { @registry.parse(Object.new, nil) }
  end
  
  def test_returns_nil_if_no_parser_for_and_lax
    @registry.compliance_level = LAX
    assert_nil @registry.parse(Object.new, nil)
  end
  
  def test_returns_first_value
    @registry.parsers.unshift @object_parser
    assert_equal 'Object: foobar', @registry.parse('foobar', nil)
  end
  
end