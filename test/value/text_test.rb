require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/text'
require 'parser_test_case'

class TextTest < Test::Unit::TestCase
  include ParserTestCase
  
  def setup
    @parser = Rcal::Value::Text::Parser.new
  end
  
  def test_value_type_is_TEXT
    assert_equal 'TEXT', @parser.value_type
  end
  
  def test_is_parser_for_text_with_safe_chars
    assert_is_parser_for 'blah blah blah', 'I am a dolphin.', "you've", 'gulp-worthy'
  end
  
  def test_is_parser_for_text_with_colons
    assert_is_parser_for 'blah: foobar'
  end
  
  def test_is_parser_for_text_with_double_quotes
    assert_is_parser_for 'a double quote looks like "', 'John said "GULP!"', '"This whole thing is a quote"'
  end
  
  def test_is_parser_for_text_with_escaped_chars
    assert_is_parser_for 'commas (\\,) semicolons (\\;) and backslashes (\\\\) need escaping.  So\\ndo\\Nnewlines.'
  end
  
  def test_is_not_parser_for_non_text_if_strict
    with_compliance_level(Rcal::Parser::STRICT) do
      assert_is_wrong_parser_for 'an, unencoded; \\ string'
    end
  end
  
  def test_is_parser_for_non_text_if_lax
    with_compliance_level(Rcal::Parser::LAX) do
      assert_is_parser_for 'an, unencoded; \\ string'
    end
  end
  
  def test_parses_simple_text
    assert_parses 'blah blah blah', 'I am a dolphin.', "you've", 'gulp-worthy', 'blah: foobar', 'a double quote looks like "', 'John said "GULP!"', '"This whole thing is a quote"'
  end
  
  def test_unescapes_escaped_chars
    {
      'A comma: \\,'      => 'A comma: ,',
      'A semicolon: \\;'  => 'A semicolon: ;',
      'A backslash: \\\\' => 'A backslash: \\',
      'A\\nnewline'       => "A\nnewline",
      'Another\\Nnewline' => "Another\nnewline",
    }.each do |k,v|
      assert_equal v, parse(k).to_s
    end
  end

  def test_can_parse_unescaped_chars_that_need_escaping_in_lax_mode
    with_compliance_level(Rcal::Parser::LAX) do
      assert_equal 'an, unencoded; \\ string', parse('an, unencoded; \\ string').to_s
    end
  end
  
  def test_cannot_parse_unescaped_chars_that_need_escaping_in_strict_mode
    with_compliance_level(Rcal::Parser::STRICT) do
      assert_cannot_parse 'unencoded, comma', 'unencoded; semicolon', 'unencoded\\ backslash'
    end
  end
  
end