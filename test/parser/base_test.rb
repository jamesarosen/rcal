require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/parser/base'

class BaseParserTest < Test::Unit::TestCase
  include Rcal::Parser
  
  class SimpleParser < Rcal::Parser::Base
    def parse(i,p)
      return wrong_parser!(i,p) unless is_parser_for?(p)
      return p.nil? ? error!(i,p) : i
    end
    def is_parser_for?(i)
      i.kind_of?(String)
    end
  end
  
  def test_initialize_with_nil_compliance_level
    assert_equal Rcal::Parser::default_compliance_level, Base.new.compliance_level
  end
  
  def test_initialize_with_valid_compliance_level
    assert_equal LAX, Base.new(LAX).compliance_level
  end
  
  def test_initialize_with_invalid_compliance_level
    assert_raises(ArgumentError) { Base.new('foo') }
  end
  
  def test_parse_not_implemented
    assert_raises(NotImplementedError) { Base.new.parse(nil, nil) }
  end
  
  def test_is_parser_for_not_implemented
    assert_raises(NotImplementedError) { Base.new.is_parser_for?(nil) }
  end
  
  def test_error_raises_error_when_strict
    assert_raises(ParseError) { SimpleParser.new(STRICT).parse('foo', nil) }
  end 
  
  def test_wrong_parser
    assert_raises(ParseError) { SimpleParser.new(STRICT).parse(9, :anything) }
  end
  
  def test_error_returns_nil_when_lax
    assert_nil SimpleParser.new(LAX).parse('foo', nil)
  end
  
end