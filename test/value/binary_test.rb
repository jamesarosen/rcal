require File.join(File.dirname(__FILE__), '..', 'test_helper')
require 'rcal/value/binary'
require 'parser_test_case'

class BinaryTest < Test::Unit::TestCase
  include ParserTestCase
  
  BASE_64_VALUES = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a + ["+", "/"]
  
  # +length+ values from the set a-zA-Z0-9+/
  def base_64_data(length)
    result = ''
    length.times { result << "#{BASE_64_VALUES[rand(BASE_64_VALUES.length)]}" }
    result
  end
  
  def setup
    @parser = Rcal::Value::BinaryParser.new
    @strings_0_mod_4 = [base_64_data(4), base_64_data(9*4), base_64_data(14*4)]
    @strings_1_mod_4 = [base_64_data(4 + 1), base_64_data(9*4 + 1), base_64_data(14*4 + 1)]
    @strings_2_mod_4 = [base_64_data(4 + 2), base_64_data(9*4 + 2), base_64_data(14*4 + 2)]
    @strings_3_mod_4 = [base_64_data(4 + 3), base_64_data(9*4 + 3), base_64_data(14*4 + 3)]
    @invalid_chars = [base_64_data(7) + '$', base_64_data(10) + '$' + base_64_data(10) + '%' + base_64_data(4)]
  end
  
  def test_value_type_is_BINARY
    assert_equal 'BINARY', @parser.value_type
  end

  def test_is_parser_for_strings_length_0_mod_4
    assert_is_parser_for *@strings_0_mod_4
  end
  
  def test_is_not_parser_for_strings_length_1_mod_4
    assert_is_wrong_parser_for *@strings_1_mod_4
  end
  
  def test_is_not_parser_for_strings_length_2_mod_4
    assert_is_wrong_parser_for *@strings_2_mod_4
  end
  
  def test_is_parser_for_strings_length_2_mod_4_padded_properly
    assert_is_parser_for *(@strings_2_mod_4.map { |s| s + '==' })
  end
  
  def test_is_not_parser_for_strings_length_3_mod_4
    assert_is_wrong_parser_for *@strings_3_mod_4
  end
  
  def test_is_parser_for_strings_length_3_mod_4_padded_properly
    assert_is_parser_for *(@strings_3_mod_4.map { |s| s + '=' })
  end
  
  def test_is_not_parser_for_strings_with_invalid_chars
    assert_is_wrong_parser_for *@invalid_chars
  end
  
  
  
  def test_parses_strings_length_0_mod_4
    assert_parses *@strings_0_mod_4
  end
  
  def test_cannot_parse_strings_length_1_mod_4
    assert_cannot_parse *@strings_1_mod_4
  end
  
  def test_cannot_parse_strings_length_2_mod_4
    assert_cannot_parse *@strings_2_mod_4
  end
  
  def test_parses_strings_length_2_mod_4_padded_properly
    assert_parses *(@strings_2_mod_4.map { |s| s + '==' })
  end
  
  def test_cannot_parse_strings_length_3_mod_4
    assert_cannot_parse *@strings_3_mod_4
  end
  
  def test_parses_strings_length_3_mod_4_padded_properly
    assert_parses *(@strings_3_mod_4.map { |s| s + '=' })
  end
  
  def test_cannot_parse_strings_with_invalid_chars
    assert_cannot_parse *@invalid_chars
  end
  
  
  
  
  def test_returns_original_string
    valid_strings = @strings_0_mod_4 +
      (@strings_2_mod_4.map { |s| s + '==' }) +
      (@strings_3_mod_4.map { |s| s + '=' })
    
    valid_strings.each do |s|
      assert_equal s, parse(s)
    end
  end
  
end