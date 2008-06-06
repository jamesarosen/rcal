require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'parser_test_case'
require 'rcal/parser/registry'

class ParserRegistryTest < Test::Unit::TestCase
  include ParserTestCase
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
    @parser = Registry.new
    @parser.parsers << IsClassParser.new(String) << IsClassParser.new(Symbol) << IsClassParser.new(Numeric)
  end
  
  def test_is_parser_for_if_finds_parser_for
    assert_is_parser_for 'foobar', :foobar, 9
  end
  
  def test_is_not_parser_for_if_does_not_find_parser_for
    assert_is_wrong_parser_for Object.new, /some_regexp/, Time.now
  end
  
  def test_parses_if_finds_parser_for
    assert_equal 'String: foobar', parse('foobar')
    assert_equal 'Symbol: foobar', parse(:foobar)
    assert_equal 'Numeric: 19', parse(19)
  end
  
  def test_cannot_parse_if_no_parser_for
    assert_cannot_parse Object.new
  end
  
  def test_returns_first_value
    parser.parsers.unshift IsClassParser.new(Object)
    assert_equal 'Object: foobar', parse('foobar')
  end
  
end