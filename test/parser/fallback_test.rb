require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'parser_test_case'
require 'rcal/parser/fallback'

class FallbackParserTest < Test::Unit::TestCase
  include ParserTestCase
  include Rcal::Parser
  
  def setup
    @parser = Fallback.new
  end
  
  def test_is_parser_for_anything_if_lax
    with_compliance_level(LAX) do
      assert_is_parser_for nil, Object.new, 'foobar', :foobar, 19, Time.now, /some_regexp/
    end
  end
  
  def test_is_parser_for_nothing_if_strict
    with_compliance_level(STRICT) do
      assert_is_wrong_parser_for nil, Object.new, 'foobar', :foobar, 19, Time.now, /some_regexp/
    end
  end
  
end