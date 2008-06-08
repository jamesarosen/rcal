require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/uri'
require 'parser_test_case'

class UriTest < Test::Unit::TestCase
  include ParserTestCase
  
  def setup
    @parser = Rcal::Value::UriParser.new
  end
  
  def test_value_type_is_URI
    assert_equal 'URI', @parser.value_type
  end
  
  def test_is_parser_for_uris
    assert_is_parser_for 'http://example.com', 'ftp:/gulp.com/wee.txt', 'MAILTO:joan@example.com'
  end
  
  def test_is_not_parser_for_non_uris
    assert_is_wrong_parser_for "URIs can't have spaces", Time.now, /some regexp/
  end

  def test_is_parser_for_generic_uris_in_lax_mode
    with_compliance_level(Rcal::Parser::LAX) do
      assert_is_parser_for 'foo', '/bar', '/baz.html'
    end
  end
  
  def test_is_not_parser_for_generic_uris_in_strict_mode
    with_compliance_level(Rcal::Parser::STRICT) do
      assert_is_wrong_parser_for 'foo', '/bar', '/baz.html'
    end
  end
  
  def test_parses_uris
    assert_parses 'http://example.com', 'ftp:/gulp.com/wee.txt', 'MAILTO:joan@example.com'
  end
  
  def test_cannot_parse_non_uris
    assert_cannot_parse "URIs can't have spaces", Time.now, /some regexp/
  end

  def test_parses_generic_uris_in_lax_mode
    with_compliance_level(Rcal::Parser::LAX) do
      ['foo', '/bar', '/baz.html'].each do |s|
        assert_nothing_raised { parse(s) }
      end
    end
  end
  
  def test_cannot_parse_generic_uris_in_strict_mode
    with_compliance_level(Rcal::Parser::STRICT) do
      ['foo', '/bar', '/baz.html'].each do |s|
        assert_raises(ParseError) { parse(s) }
      end
    end
  end
  
end